# step 1 - create annotation set

# in This script, load and sample images from video, define key-point skeleton, save data for labelling

import numpy
import tqdm

from deepposekit.annotate import KMeansSampler
from deepposekit.io import VideoReader, initialize_dataset

# parameter
from _initial_parameter import path_video_train
from _initial_parameter import path_skeleton
from _initial_parameter import path_annotation

from _initial_parameter import frame_batch
from _initial_parameter import frame_batch_random

from _initial_parameter import kmeans_n_clusters
from _initial_parameter import kmeans_max_iter
from _initial_parameter import kmeans_batch_size
from _initial_parameter import kmeans_verbose
from _initial_parameter import kmeans_n_init
from _initial_parameter import kmeans_n_samples_per_label

# load video in batches of batch_size frames, randomly sample
reader = VideoReader(path_video_train,
                     batch_size=frame_batch,
                     gray=True)
randomly_sampled_frames = []
for idx in tqdm.tqdm(range(len(reader) - 1)):
    batch = reader[idx]
    random_sample = batch[numpy.random.choice(batch.shape[0],
                                              frame_batch_random,
                                              replace=False)]
    randomly_sampled_frames.append(random_sample)
reader.close()
randomly_sampled_frames = numpy.concatenate(randomly_sampled_frames)

# apply kmeans algorithm to reduce correlation, estimated n_clusters distinctive poses
kmeans = KMeansSampler(n_clusters=kmeans_n_clusters,
                       max_iter=kmeans_max_iter,
                       batch_size=kmeans_batch_size,
                       verbose=kmeans_verbose,
                       n_init=kmeans_n_init)
kmeans.fit(randomly_sampled_frames)
kmeans_sampled_frames, kmeans_cluster_labels = kmeans.sample_data(randomly_sampled_frames,
                                                                  n_samples_per_label=kmeans_n_samples_per_label)

# initialize dataset for annotation
initialize_dataset(images=kmeans_sampled_frames,
                   datapath=path_annotation,
                   skeleton=path_skeleton)
