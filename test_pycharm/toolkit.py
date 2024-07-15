import torch
import numpy as np
import scipy.io as io


def strCode(num, nCode):
    code = str(num)
    nCode_temp = code.__len__()

    if nCode_temp < nCode:
        n_temp = nCode - nCode_temp
        for r in range(n_temp):
            if r == 0:
                str_temp = '0'
            else:
                str_temp = str_temp + '0'
        code = str_temp + code

    return code


def loadData(fileName):
    dataTemp1 = io.loadmat(fileName)
    dataTemp2 = dataTemp1['of_data']

    for r in range(dataTemp2.shape[0]):
        if r == 0:
            dataTemp3 = dataTemp2[r][0]
            data = np.expand_dims(dataTemp3, axis=0)
        else:
            dataTemp3 = dataTemp2[r][0]
            dataTemp4 = np.expand_dims(dataTemp3, axis=0)
            data = np.append(data, dataTemp4, axis=0)

    data = torch.tensor(data, dtype=torch.float)

    return data


def loadBehavior(fileName):
    dataTemp1 = io.loadmat(fileName)
    data = dataTemp1['of_target']

    data = torch.tensor(data, dtype=torch.float)

    return data
