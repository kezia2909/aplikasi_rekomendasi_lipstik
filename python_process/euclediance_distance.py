# Python code to find Euclidean distance
# using dot()

import numpy as np

# initializing points in
# numpy arrays
list_fair_neutral = [(221, 144, 119), (221, 143, 118), (221, 142, 117), (221, 141, 117), (221, 141, 117), (219, 138, 117)]
list_fair_cool = [(206, 149, 117), (206, 148, 117)]
list_fair_warm = [(206, 146, 113), (206, 145, 112), (204, 143, 112), (205, 142, 112)]
list_light_cool= [(189, 153, 116), (189, 151, 112), (189, 150, 112), (174, 155, 113), (174, 153, 112), (157, 158, 113)]
list_light_neutral = [(173, 151, 109), (172, 151, 107), (156, 155, 109), (156, 153, 108), (156, 151, 107)]
list_light_warm = [(190, 148, 108), (188, 146, 108), (188, 144, 107), (172, 148, 106), (171, 146, 105), (156, 149, 106), (156, 146, 103)]
list_medium_cool = [(141, 157, 112), (122, 158, 113), (123, 155, 111)]
list_medium_neutral = [(140, 155, 108), (140, 154, 107), (138, 151, 106), (122, 153, 108), (122, 151, 107)]
list_medium_warm = [(138, 149, 106), (138, 148, 103), (121, 148, 106), (121, 146, 103)]
list_tan_cool = [(106, 155, 113), (106, 154, 112), (88, 153, 116), (88, 151, 113)]
list_tan_neutral = [(106, 151, 108), (103, 150, 107), (89, 148, 111), (89, 148, 109)]
list_tan_warm = [(104, 147, 106), (104, 144, 105), (87, 146, 108), (88, 143, 106)]
list_deep_cool = [(72, 149, 117), (72, 147, 115), (72, 146, 113)]
list_deep_warm = [(71, 144, 112), (71, 143, 111), (71, 141, 111)]
list_deep_neutral = [(56, 144, 121), (56, 143, 118), (56, 143, 117), (56, 140, 116), (56, 139, 117), (56, 138, 117)]

# point1 = np.array((1, 2, 3))
# point1 = np.array(list_light_cool[5])
# inputPoint = np.array((165, 159, 108))

def checkCategory(inputPoint):

    # first
    temp = inputPoint - np.array(list_fair_neutral[0])
    minimumDistance = np.sqrt(np.dot(temp.T, temp))
    minimumCategory = "fair_neutral"
    minimumIndex = 0

    # fair
    for index, point in enumerate(list_fair_neutral) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "fair_neutral"
            minimumIndex = index

    for index, point in enumerate(list_fair_cool) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "fair_cool"
            minimumIndex = index

    for index, point in enumerate(list_fair_warm) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "fair_warm"
            minimumIndex = index

    # light
    for index, point in enumerate(list_light_neutral) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "light_neutral"
            minimumIndex = index

    for index, point in enumerate(list_light_cool) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "light_cool"
            minimumIndex = index

    for index, point in enumerate(list_light_warm) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "light_warm"
            minimumIndex = index

    # medium
    for index, point in enumerate(list_medium_neutral) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "medium_neutral"
            minimumIndex = index

    for index, point in enumerate(list_medium_cool) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "medium_cool"
            minimumIndex = index

    for index, point in enumerate(list_medium_warm) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "medium_warm"
            minimumIndex = index

    # tan
    for index, point in enumerate(list_tan_neutral) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "tan_neutral"
            minimumIndex = index

    for index, point in enumerate(list_tan_cool) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "tan_cool"
            minimumIndex = index

    for index, point in enumerate(list_tan_warm) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "tan_warm"
            minimumIndex = index

    # deep
    for index, point in enumerate(list_deep_neutral) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "deep_neutral"
            minimumIndex = index

    for index, point in enumerate(list_deep_cool) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "deep_cool"
            minimumIndex = index

    for index, point in enumerate(list_deep_warm) :
        temp = inputPoint - np.array(point)
        sum_sq = np.dot(temp.T, temp)
        distance = np.sqrt(sum_sq)
        if distance < minimumDistance :
            minimumDistance = distance
            minimumCategory = "deep_warm"
            minimumIndex = index

    print("Hasil : ", minimumDistance, "-", minimumCategory, "-", minimumIndex)
    return(minimumCategory)
    # print(minimumCategory)
    # print(minimumIndex)

# print(point1)
# print(point2)

# subtracting vector
# temp = point1 - point2

# doing dot product
# for finding
# sum of the squares
# sum_sq = np.dot(temp.T, temp)

# Doing squareroot and
# printing Euclidean distance
# print(np.sqrt(sum_sq))
