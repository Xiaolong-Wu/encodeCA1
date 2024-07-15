# set all parameter variables

path_data = 'D:/test_matlab/project_LFP/data_2022/raw/F(video)/'

# all video name
all_group = [
    'group_00001',
    'group_00002',
    'group_00003',
    'group_00004',
    'group_00005',
    'group_00006',
    'group_00007',
    'group_00008',
    'group_00009',
    'group_00010',
    'group_00011'
]
all_video = [
    'ec013.527',
    'ec013.528',
    'ec013.529',
    'ec013.713',
    'ec013.714',
    'ec013.754',
    'ec013.755',
    'ec013.756',
    'ec013.757',
    'ec013.808',
    'ec013.844'
]

# [0, 10]
r_video = 8

# step 1
path_video_train = path_data + all_group[0] + '/' + all_video[0] + '.MPG'
# currently DeepPoseKit only supports image resolutions that can be repeatedly divided by 2.

path_skeleton = path_data + 'project_posture/data/raw/example_skeleton.csv'
path_annotation = path_data + 'project_posture/data/example_annotation_set.h5'

frame_batch = 50
frame_batch_random = 10

kmeans_n_clusters = 10
kmeans_max_iter = 1000
kmeans_batch_size = 50
kmeans_verbose = 1
kmeans_n_init = 3

kmeans_n_samples_per_label = 5

# step 2
annotate_text_scale = 0.5

# step 3
path_densenet_log = path_data + 'project_posture/data/log_densenet.h5'
path_densenet_model = path_data + 'project_posture/data/best_model_densenet.h5'

sometimes_scale_1 = {"x": (0.95, 1.05), "y": (0.95, 1.05)}
sometimes_translate_percent = {'x': (-0.05, 0.05), 'y': (-0.05, 0.05)}
sometimes_shear = (-8, 8)
sometimes_scale_2 = (0.8, 1.2)
sometimes_p = 0.75

augmenter_rotate = (-45, 45)

train_generator_downsample_factor = 3
train_generator_sigma = 5
train_generator_validation_split = 0.1
train_generator_graph_scale = 1
train_generator_random_seed = 1

model_densenet_n_stacks = 2
model_densenet_n_transitions = -1
model_densenet_growth_rate = 32
model_densenet_bottleneck_factor = 1
model_densenet_compression_factor = 0.5

early_stop_min_delta = 0
early_stop_patience = 50
early_stop_verbose = 1

reduce_lr_factor = 0.5
reduce_lr_patience = 10
reduce_lr_verbose = 1

model_checkpoint_verbose = 1

logger_validation_batch_size = 1

model_fit_epochs_optional = 0

model_fit_batch_size = 2  # at least 2, bigger is better
model_fit_validation_batch_size = model_fit_batch_size
model_fit_epochs = 1000
model_fit_n_workers = 1  # in general, the more processes, the faster the calculation

# step 4
path_video_test = path_data + all_group[r_video] + '/' + all_video[r_video] + '.MPG'
# currently DeepPoseKit only supports image resolutions that can be repeatedly divided by 2.

path_predictions_point = path_data + 'project_posture/data/predictions/' + all_group[r_video] + '/' + all_video[r_video] + '.npy'
path_predictions_video = path_data + 'project_posture/data/predictions/' + all_group[r_video] + '/' + all_video[r_video]

reader_batch_size = 1
model_predict_verbose = 1
fps = 29.97

line_if = 1
line_color = (0, 0, 255)
line_thickness = 1
circle_radius = 2
circle_thickness = -1

# step 5
path_predictions_point_txt = path_data + 'project_posture/data/predictions/' + all_group[r_video] + '/' + all_video[r_video] + '.txt'
path_dists_txt = path_data + 'project_posture/data/predictions/' + all_group[r_video] + '/dist_' + all_video[r_video] + '.txt'
path_annotation_merge = path_data + 'project_posture/data/predictions/' + all_group[r_video] + '/merge_annotation_set.h5'

prediction_if = 1
plot_possible = 0.005
idx_pick = []

plot_if = 1
ylim_if = 1
scatter_s = 10
height_confidence = 0.1
height_coordinate = float('inf')
