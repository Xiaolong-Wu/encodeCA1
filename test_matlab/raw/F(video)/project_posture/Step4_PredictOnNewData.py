# step 4 - predict on new data

# in this script, use trained model to make predictions on novel video, visualize data output

import cv2
import matplotlib.pyplot
import numpy
import tqdm

from deepposekit.io import DataGenerator, VideoReader, VideoWriter
from deepposekit.models import load_model

# parameter
from _initial_parameter import path_annotation
from _initial_parameter import path_densenet_model

from _initial_parameter import path_video_test
from _initial_parameter import path_predictions_point
from _initial_parameter import path_predictions_video

from _initial_parameter import reader_batch_size
from _initial_parameter import model_predict_verbose
from _initial_parameter import fps

from _initial_parameter import line_if
from _initial_parameter import line_color
from _initial_parameter import line_thickness
from _initial_parameter import circle_radius
from _initial_parameter import circle_thickness

# load trained model
model = load_model(path_densenet_model)

# make predictions for full video
reader = VideoReader(path_video_test,
                     batch_size=reader_batch_size,
                     gray=True)
predictions = model.predict(reader,
                            verbose=model_predict_verbose)
reader.close()

# save data
numpy.save(path_predictions_point, predictions)

# (optional) visualize data as video
data_generator = DataGenerator(path_annotation)
c_map = matplotlib.pyplot.cm.hsv(numpy.linspace(0, 1, data_generator.keypoints_shape[0]))[:, :3][:, ::-1] * 255
predictions = predictions[..., :2]

reader = VideoReader(path_video_test,
                     batch_size=1)
resized_shape = (reader.width,
                 reader.height)
writer = VideoWriter(path_predictions_video + '.MP4',
                     resized_shape,
                     'MP4V',
                     fps)

for frame, keypoints in tqdm.tqdm(zip(reader, predictions)):
    frame = frame[0]
    frame = frame.copy()
    frame = cv2.resize(frame,
                       resized_shape)
    if line_if == 1:
        for idx, node in enumerate(data_generator.graph):
            if node >= 0:
                pt1 = keypoints[idx]
                pt2 = keypoints[node]
                cv2.line(frame,
                         (pt1[0], pt1[1]),
                         (pt2[0], pt2[1]),
                         line_color,
                         line_thickness,
                         cv2.LINE_AA)
    for idx, keypoint in enumerate(keypoints):
        keypoint = keypoint.astype(int)
        cv2.circle(frame,
                   (keypoint[0], keypoint[1]),
                   circle_radius,
                   tuple(c_map[idx]),
                   circle_thickness,
                   lineType=cv2.LINE_AA)

    writer.write(frame)

writer.close()
reader.close()
