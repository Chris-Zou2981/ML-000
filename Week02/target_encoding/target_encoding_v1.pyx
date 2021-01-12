# distutils:language=c++
# coding='utf-8'

import pandas as pd
import numpy as np
import time
cimport numpy as np

def target_mean_v1(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    for i in range(data.shape[0]):
        groupby_result = data[data.index != i].groupby([x_name], as_index=False).agg(['mean'])
        result[i] = groupby_result.loc[groupby_result.index == data.loc[i, x_name], (y_name, 'mean')]
    return result


def target_mean_v2(data, y_name, x_name):
    length = data.shape[0]
    result = np.zeros(length)
    value_dict = dict()
    count_dict = dict()

    for i in range(length):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i,x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1

    print(count_dict)
    for i in range(length):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result



def target_mean_v2(data, y_name, x_name):
    length = data.shape[0]
    result = np.zeros(length)
    value_dict = dict()
    count_dict = dict()

    for i in range(length):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i,x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1

    print(count_dict)
    for i in range(length):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result


cpdef target_mean_v3(data, y_name, x_name):
    cdef int length = data.shape[0]
    cdef double[:] result = np.zeros(length)
    cdef dict value_dict = dict()
    cdef count_dict = dict()

    cdef int i = 0
    for i in range(length):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i,x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1

    print(count_dict)
    for i in range(length):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result

def main():
    np.random.seed(1)
    length = 50
    y = np.random.randint(2, size=(length, 1))
    x = np.random.randint(10, size=(length, 1))

    data = pd.DataFrame(np.concatenate([y, x], axis=1), columns=['y', 'x'])

    start = time.time()
    result_1 = target_mean_v1(data, 'y', 'x')
    end = time.time()
    print('time for v1: %s', end - start)

    start = time.time()
    result_2 = target_mean_v2(data, 'y', 'x')
    end = time.time()
    print('time for v2: %s', end - start)


if __name__ == '__main__':
    main()