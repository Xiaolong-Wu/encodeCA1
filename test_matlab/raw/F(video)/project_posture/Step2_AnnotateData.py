# step 2 - annotate data

# in this script, annotate training data with user-defined keypoints

from deepposekit import Annotator

# parameter
from _initial_parameter import path_skeleton
from _initial_parameter import path_annotation
from _initial_parameter import annotate_text_scale

''' hot-keys for annotation

    +/- = rescale image by ±10%
    left mouse button = move active keypoint to cursor location
    W/A/S/D = move active keypoint 1px or 10px
    space = change W/A/S/D mode (swaps between 1px or 10px movements)
    J/L = next or previous image
    <> = jump 10 images forward or backward
    I/K or tab, shift+tab = switch active key-point
    R = mark image as unannotated ("reset")
    F = mark image as annotated ("finished")
    V = mark active keypoint as visible
    esc or Q = quit
'''

# annotate data, skeleton turns blue when frame fully annotated
app = Annotator(datapath=path_annotation,
                skeleton=path_skeleton,
                dataset='images',
                shuffle_colors=False,
                text_scale=annotate_text_scale)
app.run()
