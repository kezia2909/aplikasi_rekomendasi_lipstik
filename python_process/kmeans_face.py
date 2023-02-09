import cv2
from sklearn.cluster import KMeans
from collections import Counter
import numpy as np
from euclediance_distance import checkCategory
import pandas as pd

def kmeansFace(filename):
    img_arr = cv2.imread("./python_process/Images_New/"+filename)
    numClusters = 3

    img_arr_ycrcb = cv2.cvtColor(img_arr, cv2.COLOR_BGR2YCrCb)
    channelY = []
    for char in "0":
        channelY.append(int(char))
    img_arr_y = img_arr_ycrcb[:,:,channelY]
    reshaped_y = img_arr_y.reshape(img_arr_y.shape[0] * img_arr_y.shape[1], img_arr_y.shape[2])

    channelIndices = []
    for char in "12":
        channelIndices.append(int(char))
    img_arr_crcb = img_arr_ycrcb[:,:,channelIndices]
    reshapedCrCb = img_arr_crcb.reshape(img_arr_crcb.shape[0] * img_arr_crcb.shape[1], img_arr_crcb.shape[2])

    kmeans_model_crcb = KMeans(n_clusters=numClusters, random_state=0) 
    cluster_labels_crcb = kmeans_model_crcb.fit_predict(reshapedCrCb)
    labels_count_crcb = Counter(cluster_labels_crcb)

    u, c = np.unique(cluster_labels_crcb, return_counts = True)
    choosenCluster = u[c == c.max()]

    img_quant_crcb = np.reshape(np.array(kmeans_model_crcb.labels_, dtype=np.uint8),
        (img_arr_crcb.shape[0], img_arr_crcb.shape[1]))
    labels_count_crcb = Counter(cluster_labels_crcb)
    cols_crcb = kmeans_model_crcb.cluster_centers_.round(0).astype(int)

    counter=0

    skinColorY = []
    skinColorCr = []
    skinColorCb = []

    for index, pixel in enumerate(cluster_labels_crcb):
        if pixel == choosenCluster[0] :
            skinColorY.append(reshaped_y[index][0])
            skinColorCr.append(reshapedCrCb[index][0])
            skinColorCb.append(reshapedCrCb[index][1])
            counter += 1

    data = {'y': skinColorY,
            'cr': skinColorCr,
            'cb': skinColorCb}

    df = pd.DataFrame(data, columns=['y', 'cr', 'cb'])
    kmeans = KMeans(n_clusters=1).fit(df)
    centroids = kmeans.cluster_centers_

    inputCheck = [round(centroids[0][0]), round(centroids[0][1]), round(centroids[0][2])]
    return checkCategory(inputCheck)
