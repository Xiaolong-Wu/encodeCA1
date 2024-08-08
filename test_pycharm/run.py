import os
import sys
import math
import torch
import torch.nn as nn
import numpy as np
import matplotlib.pyplot as plt
from toolkit import strCode, loadData, loadBehavior
from net.CA1 import BuildCA1

"""
2*(2*5)*6 = 120
"""

# 1, spike
# 2, mm
type1_feature = 2

# 1, absolute
# 2, relative
type2_a_coordinate = 2

# 1, location
# 2, posture
# 3, direction
# 4, speed
# 5, wall
# 6, turn
type2_b_task = 6

# 01, lstm-rolled mlp
# 02, lstm-rolled cnn
# 03, lstm-rolled attention
# 04, lstm-unrolled mlp
# 05, lstm-unrolled cnn
# 06, lstm-unrolled attention
type3_model = 6
"""
"""

trainEpoch = 128
trainBatch = 0
nCode = 5

# unit, m-second
"""
           tCord:           100           100        100
       tCordStep:         tCord         tCord      tCord
     tCordBehind: [-4000, 3000] [-2000, 1000] [-1000, 0]
         fsTrain:            10            10         10
tDetermine_d_seq:            70            30         10
"""
tCord = 100
tCordStep = tCord

tCordBehind = [-4000, 3000]

fsTrain = 10
testRate = -0.2

tDetermine_d_seq = 70
"""
"""
nElectrode = 31

# num of group and minute
nGroup = [[ 1, 16],
          [ 2, 25],
          [ 3, 29],
          [ 4, 36],
          [ 5, 36],
          [ 6, 52],
          [ 7, 31],
          [ 8, 39],
          [ 9, 39],
          [10, 35],
          [11, 29]
          ]
"""
"""

# featureName
if type1_feature == 1:
    featureName = 'spike'
    nFeature = 7
elif type1_feature == 2:
    featureName = 'mm'
    nFeature = 6
"""
RNN encoding
"""

dropout = 0.1

d_feature1 = nElectrode*nFeature
d_seq = tDetermine_d_seq

d_feature2 = 64
d_rnn_outpt = d_seq*d_feature2
"""
num_layer = 1
"""

# MLP
d_mlp = d_rnn_outpt

# CNN
nChannel = d_feature2
nKernel = [d_seq, 1]
nMaxpooling = [1, 4]

d_cnnSize = int(d_feature2/nMaxpooling[1])
d_cnn = nChannel*d_cnnSize

# attention
n_layer = 1
d_model = d_feature2
n_head = d_cnnSize
d_k = d_feature2
d_v = d_feature2
d_inner = d_feature2
"""
num_layer_fc = 1
"""

if type3_model == 1 or type3_model == 4:
    nNeuron_fc_input = int(d_mlp)
elif type3_model == 2 or type3_model == 5:
    nNeuron_fc_input = int(d_cnn)
elif type3_model == 3 or type3_model == 6:
    nNeuron_fc_input = int(d_rnn_outpt)
"""
"""

xLim = [0, trainEpoch]
yLim = [0, 1]
"""
"""

if not d_feature2 % nMaxpooling[1] == 0:
    print(' ')
    print(' ')
    print('d_feature2 / nMaxpooling[1] is not divisible:')
    print(' ')
    print('reset value of d_feature2 or nMaxpooling[1] !!!')
    print('reset value of d_feature2 or nMaxpooling[1] !!!')
    print('reset value of d_feature2 or nMaxpooling[1] !!!')
    sys.exit()
"""
"""
# targetColumn
isPhase = 0
nNeuron_fc_output = 2
if type2_a_coordinate == 1 and type2_b_task == 1:
    targetColumn = [0, 1]
elif type2_a_coordinate == 1 and type2_b_task == 2:
    targetColumn = [2, 3]
    isPhase = 1
elif type2_a_coordinate == 1 and type2_b_task == 3:
    targetColumn = [4, 5]
    isPhase = 1
elif type2_a_coordinate == 1 and type2_b_task == 4:
    type2_a_coordinate = 0
    targetColumn = [6]
    nNeuron_fc_output = 1
elif type2_a_coordinate == 2 and type2_b_task == 1:
    targetColumn = [8, 9]
elif type2_a_coordinate == 2 and type2_b_task == 2:
    targetColumn = [10, 11]
    isPhase = 1
elif type2_a_coordinate == 2 and type2_b_task == 3:
    targetColumn = [12, 13]
    isPhase = 1
elif type2_a_coordinate == 2 and type2_b_task == 4:
    type2_a_coordinate = 0
    targetColumn = [14]
    nNeuron_fc_output = 1
elif type2_b_task == 5:
    type2_a_coordinate = 0
    targetColumn = [9]
    nNeuron_fc_output = 1
elif type2_b_task == 6:
    type2_a_coordinate = 0
    targetColumn = [15, 16]

isPhase = 0
"""
"""

typeData = 'tB(' + str(tCordBehind[0]) + ',' + str(tCordBehind[1]) + ')tP(' + str(tCord) + ')tStep(' + str(tCordStep) + ')nSeq(' + str(fsTrain) + ')rate(' + str(testRate) + ')'
typeModel = 'feature(' + str(type1_feature) + ')coordinate(' + str(type2_a_coordinate) + ')task(' + str(type2_b_task) + ')model(' + str(type3_model) + ')'

pathData_train = os.path.join('data_train', typeData)
pathData_test = os.path.join('data_test', typeData)

path_1 = 'savedModel'
if not os.path.exists(path_1):
    os.makedirs(path_1)

path_2 = os.path.join(path_1, typeData)
if not os.path.exists(path_2):
    os.makedirs(path_2)

path_3 = os.path.join(path_2, typeModel)
if not os.path.exists(path_3):
    os.makedirs(path_3)

path_4 = os.path.join(path_3, 'epoch(' + str(trainEpoch) + ')batch(' + str(trainBatch) + ')')
if not os.path.exists(path_4):
    os.makedirs(path_4)

path_4_1 = os.path.join(path_4, 'loss.txt')
path_4_2 = os.path.join(path_4, 'CA1.pth')

if not os.path.isfile(path_4_2):
    CA1 = BuildCA1(type3_model, d_seq, d_feature1, d_feature2, d_rnn_outpt, d_mlp, nChannel, nKernel, nMaxpooling, n_layer, d_model, n_head, d_k, d_v, d_inner, nNeuron_fc_input, nNeuron_fc_output, dropout)
    CA1.train()

    loss_fun = nn.MSELoss()
    optimizer = torch.optim.Adam(CA1.parameters(), lr=1e-6)

    for r1 in range(trainEpoch):
        print(' ')
        print(' ')
        print('epoch({})'.format(r1 + 1))
        for r2 in range(nGroup.__len__()):
            print(' ')
            print('group({})'.format(r2 + 1))
            for r3 in range(nGroup[r2][1]):
                pathData_trainData = os.path.join(pathData_train, 'group_' + strCode(r2+1, nCode), featureName + '_' + strCode(r3+2, nCode) + '.mat')
                pathData_trainBehavior = os.path.join(pathData_train, 'group_' + strCode(r2+1, nCode), 'behavior_' + strCode(r3+2, nCode) + '.mat')

                trainData = loadData(pathData_trainData)
                trainBehavior = loadBehavior(pathData_trainBehavior)

                trainTarget = trainBehavior[:, targetColumn]

                if trainBatch == 0:
                    trainOutput = CA1(trainData, type3_model, isPhase, d_rnn_outpt, d_cnn, enc_mask=None)

                    optimizer.zero_grad()
                    loss = loss_fun(trainTarget, trainOutput)
                    loss.backward()
                    optimizer.step()

                    if r1 == 0 and r2 == 0 and r3 == 0:
                        loss_all = np.array(loss.item())
                    else:
                        loss_all = np.hstack((loss_all, np.array(loss.item())))

                    print('Loss: {}'.format(loss.item()))
                else:
                    nData_temp = trainData.size(0)
                    nTrain_temp = math.floor(nData_temp/trainBatch)

                    for r4 in range(nTrain_temp):
                        first = r4*trainBatch
                        if r4 == nTrain_temp-1:
                            last = nData_temp
                        else:
                            last = first+trainBatch

                        trainOutput = CA1(trainData[first:last], type3_model, isPhase, d_rnn_outpt, d_cnn, enc_mask=None)

                        optimizer.zero_grad()
                        loss = loss_fun(trainTarget[first:last], trainOutput)
                        loss.backward()
                        optimizer.step()

                        if r1 == 0 and r2 == 0 and r3 == 0 and r4 == 0:
                            loss_all = np.array(loss.item())
                        else:
                            loss_all = np.hstack((loss_all, np.array(loss.item())))

                        print('Loss: {}'.format(loss.item()))

    np.savetxt(path_4_1, loss_all, delimiter=',')
    CA1.eval()
    torch.save(CA1, path_4_2)

CA1 = torch.load(path_4_2)
CA1.eval()

path_5 = os.path.join(path_4, 'result')
if not os.path.exists(path_5):
    os.makedirs(path_5)

for r1 in range(nGroup.__len__()):
    print(' ')
    print('group({})'.format(r1 + 1))
    path_6 = os.path.join(path_5, 'group_' + strCode(r1+1, nCode))
    if not os.path.exists(path_6):
        os.makedirs(path_6)
    for r2 in range(nGroup[r1][1]):
        print('minute({})'.format(r2 + 2))
        path_6_1 = os.path.join(path_6, 'target_' + strCode(r2+2, nCode) + '.txt')
        if not os.path.isfile(path_6_1):
            pathData_testData = os.path.join(pathData_test, 'group_' + strCode(r1+1, nCode), featureName + '_' + strCode(r2+2, nCode) + '.mat')
            pathData_testBehavior = os.path.join(pathData_test, 'group_' + strCode(r1+1, nCode), 'behavior_' + strCode(r2+2, nCode) + '.mat')

            testData = loadData(pathData_testData)
            testBehavior = loadBehavior(pathData_testBehavior)

            testTarget = testBehavior[:, targetColumn]

            testOutput = CA1(testData, type3_model, isPhase, d_rnn_outpt, d_cnn, enc_mask=None)

            testOutput_np = testOutput.detach().numpy()
            np.savetxt(path_6_1, testOutput_np, delimiter=',')

loss_all = np.loadtxt(path_4_1, delimiter=',')

nTrainAll = loss_all.shape[0]
nTrain = nTrainAll/trainEpoch

plt.plot(np.linspace(1/nTrain, trainEpoch, nTrainAll), loss_all, color='blue')
plt.xlim((xLim[0], xLim[1]))
plt.ylim((yLim[0], yLim[1]))
plt.show()
