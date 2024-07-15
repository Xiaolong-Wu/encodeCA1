# step 3 - train model

# in this script, use annotated data to train deep learning model applying data augmentation

import imgaug as ia
import imgaug.augmenters as iaa

from deepposekit.augment import FlipAxis
from deepposekit.callbacks import Logger, ModelCheckpoint
from deepposekit.io import DataGenerator, TrainingGenerator
from deepposekit.models import StackedDenseNet, load_model
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau

# parameter
from _initial_parameter import path_annotation

from _initial_parameter import path_densenet_log
from _initial_parameter import path_densenet_model

from _initial_parameter import sometimes_scale_1
from _initial_parameter import sometimes_translate_percent
from _initial_parameter import sometimes_shear
from _initial_parameter import sometimes_scale_2
from _initial_parameter import sometimes_p

from _initial_parameter import augmenter_rotate

from _initial_parameter import train_generator_downsample_factor
from _initial_parameter import train_generator_sigma
from _initial_parameter import train_generator_validation_split
from _initial_parameter import train_generator_graph_scale
from _initial_parameter import train_generator_random_seed

from _initial_parameter import model_densenet_n_stacks
from _initial_parameter import model_densenet_n_transitions
from _initial_parameter import model_densenet_growth_rate
from _initial_parameter import model_densenet_bottleneck_factor
from _initial_parameter import model_densenet_compression_factor

from _initial_parameter import early_stop_min_delta
from _initial_parameter import early_stop_patience
from _initial_parameter import early_stop_verbose

from _initial_parameter import reduce_lr_factor
from _initial_parameter import reduce_lr_patience
from _initial_parameter import reduce_lr_verbose

from _initial_parameter import model_checkpoint_verbose

from _initial_parameter import logger_validation_batch_size

from _initial_parameter import model_fit_epochs_optional

from _initial_parameter import model_fit_batch_size
from _initial_parameter import model_fit_validation_batch_size
from _initial_parameter import model_fit_epochs
from _initial_parameter import model_fit_n_workers

# create DataGenerator
data_generator = DataGenerator(path_annotation, mode='annotated')

# create augmentation pipeline
sometimes = []
sometimes.append(iaa.Affine(scale=sometimes_scale_1,
                            translate_percent=sometimes_translate_percent,
                            shear=sometimes_shear,
                            order=ia.ALL,
                            cval=ia.ALL,
                            mode=ia.ALL))
sometimes.append(iaa.Affine(scale=sometimes_scale_2,
                            order=ia.ALL,
                            cval=ia.ALL,
                            mode=ia.ALL))

augmenter = []
augmenter.append(FlipAxis(data_generator,
                          axis=0))
augmenter.append(FlipAxis(data_generator,
                          axis=1))
augmenter.append(iaa.Sometimes(sometimes_p,
                               sometimes))
augmenter.append(iaa.Affine(rotate=augmenter_rotate,
                            order=ia.ALL,
                            cval=ia.ALL,
                            mode=ia.ALL))

augmenter = iaa.Sequential(augmenter)

# define callbacks to enhance model training
early_stop = EarlyStopping(monitor="val_loss",
                           min_delta=early_stop_min_delta,
                           patience=early_stop_patience,
                           verbose=early_stop_verbose)
reduce_lr = ReduceLROnPlateau(monitor="val_loss",
                              factor=reduce_lr_factor,
                              patience=reduce_lr_patience,
                              verbose=reduce_lr_verbose)
model_checkpoint = ModelCheckpoint(path_densenet_model,
                                   monitor="val_loss",
                                   verbose=model_checkpoint_verbose,
                                   save_best_only=True, )
logger = Logger(filepath=path_densenet_log,
                validation_batch_size=logger_validation_batch_size)
callbacks = [early_stop, reduce_lr, model_checkpoint, logger]

if model_fit_epochs_optional == 0:  # fit model for epochs

    # create trainingGenerator
    train_generator = TrainingGenerator(generator=data_generator,
                                        downsample_factor=train_generator_downsample_factor,
                                        use_graph=True,
                                        augmenter=augmenter,
                                        shuffle=True,
                                        sigma=train_generator_sigma,
                                        validation_split=train_generator_validation_split,
                                        graph_scale=train_generator_graph_scale,
                                        random_seed=train_generator_random_seed)
    train_generator.get_config()

    # define model
    model = StackedDenseNet(train_generator,
                            n_stacks=model_densenet_n_stacks,
                            n_transitions=model_densenet_n_transitions,
                            growth_rate=model_densenet_growth_rate,
                            bottleneck_factor=model_densenet_bottleneck_factor,
                            compression_factor=model_densenet_compression_factor,
                            pretrained=True,
                            subpixel=True)
    model.get_config()

    model.fit(batch_size=model_fit_batch_size,
              validation_batch_size=model_fit_validation_batch_size,
              callbacks=callbacks,
              epochs=model_fit_epochs,
              n_workers=model_fit_n_workers,
              steps_per_epoch=None)

else:  # (optional) load model and resume training for another epochs

    model = load_model(path_densenet_model,
                       generator=data_generator,
                       augmenter=augmenter)

    model.fit(batch_size=model_fit_batch_size,
              validation_batch_size=model_fit_validation_batch_size,
              callbacks=callbacks,
              epochs=model_fit_epochs_optional,
              n_workers=model_fit_n_workers,
              steps_per_epoch=None)
