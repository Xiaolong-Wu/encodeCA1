# step 5 - translate .npy for accuracy and to .txt

# in this script, analysis the accuracy of .npy and translate the .npy file into .txt format

import h5py
import numpy
import random
import matplotlib.pyplot
from deepposekit import DataGenerator, VideoReader
from deepposekit.io import merge_new_images
from deepposekit.models import load_model
from scipy.signal import find_peaks

# parameter
from _initial_parameter import path_annotation

from _initial_parameter import path_densenet_log
from _initial_parameter import path_densenet_model

from _initial_parameter import path_video_test
from _initial_parameter import path_predictions_point

from _initial_parameter import reader_batch_size
from _initial_parameter import model_predict_verbose
from _initial_parameter import fps

from _initial_parameter import path_predictions_point_txt
from _initial_parameter import path_dists_txt
from _initial_parameter import path_annotation_merge

from _initial_parameter import prediction_if
from _initial_parameter import plot_possible
from _initial_parameter import idx_pick
from _initial_parameter import plot_if
from _initial_parameter import ylim_if
from _initial_parameter import scatter_s
from _initial_parameter import height_confidence
from _initial_parameter import height_coordinate

f_log = h5py.File(path_densenet_log, 'r')
for group in f_log.keys():
    print(group)
    for dataset in f_log[group]:
        print('__________')
        print(f_log[group][dataset])
        print(f_log[group][dataset][()])

predictions = numpy.load(path_predictions_point)
frames = predictions.shape[0]
points = predictions.shape[1]
# split predictions into coordinates and confidence scores: -1, frames * points
x, y, confidence = numpy.split(predictions, 3, -1)
# save predictions in .txt format: -1, frames * points
predictions_txt = predictions.reshape(-1, 3)
numpy.savetxt(path_predictions_point_txt, predictions_txt, delimiter=',')

# analysis the acc_1

if prediction_if:
    dists = numpy.array([])

    data_generator = DataGenerator(path_annotation, mode='annotated')
    model = load_model(path_densenet_model)
    for idx in data_generator.annotated_index:
        image, keypoints = data_generator[idx]
        prediction = model.predict(image,
                                   verbose=model_predict_verbose)
        err = prediction[..., :2] - keypoints
        dist = numpy.linalg.norm(err, ord=2, axis=-1, keepdims=False).mean(-1)
        dists = numpy.concatenate((dists, dist), axis=None)

        if plot_if and (random.random() < plot_possible or (numpy.array(idx_pick)-1).__contains__(idx)):
            matplotlib.pyplot.figure()
            matplotlib.pyplot.subplot(2, 2, 1)
            image = image[0] if image.shape[-1] is 3 else image[0, ..., 0]
            cmap = None if image.shape[-1] is 3 else 'gray'
            matplotlib.pyplot.imshow(image, cmap=cmap, interpolation='none')
            for inode, jnode in enumerate(data_generator.graph):
                if jnode > -1:
                    matplotlib.pyplot.plot([keypoints[0, inode, 0], keypoints[0, jnode, 0]],
                                           [keypoints[0, inode, 1], keypoints[0, jnode, 1]],
                                           'r-')
            matplotlib.pyplot.scatter(keypoints[..., 0], keypoints[..., 1],
                                      c=numpy.arange(data_generator.keypoints_shape[0]),
                                      s=scatter_s, cmap=matplotlib.pyplot.cm.hsv)
            matplotlib.pyplot.title('human-applied labels (%s/%s)' % (idx+1, data_generator.n_annotated))

            matplotlib.pyplot.subplot(2, 2, 3)
            matplotlib.pyplot.imshow(image, cmap=cmap, interpolation='none')
            for inode, jnode in enumerate(data_generator.graph):
                if jnode > -1:
                    matplotlib.pyplot.plot([prediction[..., :2][0, inode, 0], prediction[..., :2][0, jnode, 0]],
                                           [prediction[..., :2][0, inode, 1], prediction[..., :2][0, jnode, 1]],
                                           'y-')
            matplotlib.pyplot.scatter(prediction[..., :2][..., 0], prediction[..., :2][..., 1],
                                      c='y',
                                      s=scatter_s)
            matplotlib.pyplot.title('network-applied labels (%s/%s)' % (idx+1, data_generator.n_annotated))

            matplotlib.pyplot.subplot(1, 2, 2)
            matplotlib.pyplot.imshow(image, cmap=cmap, interpolation='none')
            matplotlib.pyplot.plot(keypoints[..., 0], keypoints[..., 1], 'r+')
            matplotlib.pyplot.plot(prediction[..., :2][..., 0], prediction[..., :2][..., 1], 'y+')
            matplotlib.pyplot.title('differences between network-applied labels and human-applied labels (pixels: %s)' % dist[0])
            matplotlib.pyplot.show()

    numpy.savetxt(path_dists_txt, dists, delimiter=',')
else:
    dists = numpy.loadtxt(path_dists_txt)

# analysis the acc_2
times = numpy.arange(frames).reshape(frames, 1) / fps

confidences = confidence.mean(-1).mean(-1)
confidences_diff = numpy.diff(confidences)
confidences_outlier_peaks = find_peaks(numpy.abs(confidences_diff), height=height_confidence)[0]

coordinates_diff = numpy.diff(predictions[..., :2], axis=0)
coordinates_diff_norm = numpy.linalg.norm(coordinates_diff, ord=2, axis=-1, keepdims=False)
coordinates_diff_norm_mean = coordinates_diff_norm.mean(-1)
velocity_abs = coordinates_diff_norm_mean * fps
velocity_abs_outlier_peaks = find_peaks(velocity_abs, height=height_coordinate)[0]

if plot_if:
    ##
    matplotlib.pyplot.figure()
    matplotlib.pyplot.subplot(2, 1, 1)
    matplotlib.pyplot.scatter(numpy.linspace(1, data_generator.n_annotated, data_generator.n_annotated), dists,
                              c='b')
    matplotlib.pyplot.title('distance of annotated between network-applied labels and human-applied labels (pixels)')

    matplotlib.pyplot.subplot(2, 1, 2)
    matplotlib.pyplot.boxplot(dists,
                              notch=False,  # box instead of notch shape
                              sym='ro',  # red squares for outliers 'rs'
                              vert=True)
    matplotlib.pyplot.show()

    ##
    matplotlib.pyplot.figure()
    matplotlib.pyplot.subplot(3, 2, 1)
    matplotlib.pyplot.plot(times, confidences)
    matplotlib.pyplot.xlim(0, times.max())
    matplotlib.pyplot.ylim(0, 1)
    matplotlib.pyplot.title('confidence')

    matplotlib.pyplot.subplot(3, 2, 2)
    matplotlib.pyplot.plot(times[0:-1], confidences_diff)
    matplotlib.pyplot.xlim(0, times.max())
    if ylim_if:
        matplotlib.pyplot.ylim(-1, 1)
    matplotlib.pyplot.title('confidence derivatives')

    matplotlib.pyplot.subplot(3, 1, 2)
    matplotlib.pyplot.plot(times[0:-1], numpy.abs(confidences_diff))
    matplotlib.pyplot.plot(confidences_outlier_peaks / fps, numpy.abs(confidences_diff[confidences_outlier_peaks]),
                           'ro')
    matplotlib.pyplot.xlim(0, times.max())
    matplotlib.pyplot.ylim(bottom=0)
    if ylim_if:
        matplotlib.pyplot.ylim(top=1)
    matplotlib.pyplot.title('confidence derivatives with peaks-marked')

    matplotlib.pyplot.subplot(3, 1, 3)
    matplotlib.pyplot.plot(times[0:-1], velocity_abs)
    matplotlib.pyplot.plot(velocity_abs_outlier_peaks / fps, velocity_abs[velocity_abs_outlier_peaks], 'ro')
    matplotlib.pyplot.xlim(0, times.max())
    matplotlib.pyplot.ylim(bottom=0)
    matplotlib.pyplot.xlabel('times/ s')
    matplotlib.pyplot.title('abs of velocity with peaks-marked')
    matplotlib.pyplot.show()

outlier_index = numpy.concatenate((confidences_outlier_peaks, velocity_abs_outlier_peaks), axis=None)
outlier_index = numpy.unique(outlier_index)  # make sure there are no repeats

reader = VideoReader(path_video_test,
                     batch_size=reader_batch_size,
                     gray=True)

outlier_images = []
outlier_keypoints = []
for idx in outlier_index:
    outlier_images.append(reader[idx])
    outlier_keypoints.append(predictions[idx])

outlier_images = numpy.concatenate(outlier_images)
outlier_keypoints = numpy.stack(outlier_keypoints)

reader.close()

merge_new_images(datapath=path_annotation,
                 merged_datapath=path_annotation_merge,
                 images=outlier_images,
                 keypoints=outlier_keypoints,
                 overwrite=True  # This overwrites the merged dataset if it already exists
                 )
