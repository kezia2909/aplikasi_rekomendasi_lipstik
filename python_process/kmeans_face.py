import cv2
from sklearn.cluster import KMeans
from collections import Counter
import numpy as np
from euclediance_distance import checkCategory
import pandas as pd
import xlsxwriter

def kmeansFace(filename):
    img_arr = cv2.imread("./python_process/Images_New/"+filename)
    
    numClusters = 3

    img_arr_ycrcb = cv2.cvtColor(img_arr, cv2.COLOR_BGR2YCrCb)
    # print(img_arr_ycrcb)
    channelY = []
    for char in "0":
        channelY.append(int(char))
    img_arr_y = img_arr_ycrcb[:,:,channelY]
    reshaped_y = img_arr_y.reshape(img_arr_y.shape[0] * img_arr_y.shape[1], img_arr_y.shape[2])
    # print(reshaped_y)
    
    channelIndices = []
    for char in "12":
        channelIndices.append(int(char))
    img_arr_crcb = img_arr_ycrcb[:,:,channelIndices]
    reshapedCrCb = img_arr_crcb.reshape(img_arr_crcb.shape[0] * img_arr_crcb.shape[1], img_arr_crcb.shape[2])
    # print(reshapedCrCb)

    kmeans_model_crcb = KMeans(n_clusters=numClusters, random_state=0) 
    cluster_labels_crcb = kmeans_model_crcb.fit_predict(reshapedCrCb)
    labels_count_crcb = Counter(cluster_labels_crcb)
    # print(cluster_labels_crcb)
    print(labels_count_crcb)

    u, c = np.unique(cluster_labels_crcb, return_counts = True)
    choosenCluster = u[c == c.max()]
    print(choosenCluster)

    img_quant_crcb = np.reshape(np.array(kmeans_model_crcb.labels_, dtype=np.uint8),
        (img_arr_crcb.shape[0], img_arr_crcb.shape[1]))
    labels_count_crcb = Counter(cluster_labels_crcb)
    cols_crcb = kmeans_model_crcb.cluster_centers_.round(0).astype(int)
    print(cols_crcb)

    counter=0

    skinColorY = []
    skinColorCr = []
    skinColorCb = []

    for index, pixel in enumerate(cluster_labels_crcb):
        if pixel == choosenCluster[0] :
            skinColorY.append(reshaped_y[index][0]+0)
            skinColorCr.append(reshapedCrCb[index][0]+0)
            skinColorCb.append(reshapedCrCb[index][1]+0)
            counter += 1


    # # print(skinColorCb)

    # data = {'y': skinColorY,
    #         'cr': skinColorCr,
    #         'cb': skinColorCb}

    # # print(data['y'])
    # # data = {'y': [0, 1, 2, 3, 4, 5, 6, 7, 8],
    # #         'cr': [4, 6, 8, 2, 7, 3, 7, 2, 8],
    # #         'cb': [5, 6, 1, 3, 7, 0, 9, 1, 1]}

    # # print("array")
    # # array = [['a1', 'a2', 'a3'],
    # #      ['a4', 'a5', 'a6'],
    # #      ['a7', 'a8', 'a9'],
    # #      ['a10', 'a11', 'a12', 'a13', 'a14']]
    
    # # workbook = xlsxwriter.Workbook("./python_process/xls/"+filename+".xlsx")
    # # worksheet = workbook.add_worksheet()
    # # row = 0
    # # for col, data in enumerate([skinColorY, skinColorCr, skinColorCb]):
    # #     worksheet.write_column(row, col, data)
    # # workbook.close()
    # # print("worksheet done")

    # df = pd.DataFrame(data, columns=['y', 'cr', 'cb'])
    # # df.to_excel(excel_writer = "./python_process/xls/test"+filename+".xlsx")

    # # print(df)
    # kmeans = KMeans(n_clusters=1).fit(df)
    # centroids = kmeans.cluster_centers_

    # # print(centroids)

    # inputCheck = [round(centroids[0][0]), round(centroids[0][1]), round(centroids[0][2])]

    # print("AAAAAAAa")
    data = {'y': skinColorY,
            'cr': skinColorCr,
            'cb': skinColorCb}
    
    

    df = pd.DataFrame(data, columns=['y', 'cr', 'cb'])
    # print(df)
    kmeans = KMeans(n_clusters=1).fit(df)
    centroids = kmeans.cluster_centers_

    print(centroids)

    inputCheck = [round(centroids[0][0]), round(centroids[0][1]), round(centroids[0][2])]
    return checkCategory(inputCheck)
