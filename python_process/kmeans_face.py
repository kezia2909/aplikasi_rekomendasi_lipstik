import cv2
from sklearn.cluster import KMeans
from collections import Counter
import numpy as np
from euclediance_distance import checkCategory
from CIELab import checkCIELab
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from global_variable import numClusters
from global_variable import bool_CIELAB
from global_variable import bool_masking
from global_variable import bool_maxCluster
import math


def convertRGB2LAB(img_arr):
    print("START CONVERT")
    print("ORI : ", img_arr)
    img_arr = img_arr.astype("float32") / 255
    temp = img_arr

    img_arr[(temp > 0.04045)] = ( ( temp[(temp > 0.04045)] + 0.055 ) / 1.055 ) ** 2.4
    img_arr[(temp <= 0.04045)] = temp[(temp <= 0.04045)] / 12.92
    # img_arr[(temp.astype("float32") / 255) > 0.04045] = ((temp[(temp.astype("float32") / 255) > 0.04045] + 0.055) / 1.055) ** 2.4
    # img_arr[(temp.astype("float32") / 255) <= 0.04045] = temp[(temp.astype("float32") / 255) <= 0.04045] / 12.92
    img_arr = img_arr * 100

    channel_R = img_arr[:, :, 0]
    channel_G = img_arr[:, :, 1]
    channel_B = img_arr[:, :, 2]

    X = np.full(channel_R.shape, 0)
    Y = np.full(channel_G.shape, 0)
    Z = np.full(channel_B.shape, 0)

    X = channel_R * 0.4124 + channel_G * 0.3576 + channel_B * 0.1805
    Y = channel_R * 0.2126 + channel_G * 0.7152 + channel_B * 0.0722
    Z = channel_R * 0.0193 + channel_G * 0.1192 + channel_B * 0.9505

    # X = round(X, 4)
    # Y = round(Y, 4)
    # Z = round(Z, 4)

    X = X.astype("float32") / 95.047         # ref_X =  95.047   Observer= 2°, Illuminant= D65
    Y = Y.astype("float32") / 100.0          # ref_Y = 100.000
    Z = Z.astype("float32") / 108.883        # ref_Z = 108.883

    tempX = X
    tempY = Y
    tempZ = Z

    X[(tempX > 0.008856)] = tempX[(tempX > 0.008856)] ** (1/3)
    X[(tempX <= 0.008856)] = ( 7.787 * tempX[(tempX <= 0.008856)] ) + (16/116)

    Y[(tempY > 0.008856)] = tempY[(tempY > 0.008856)] ** (1/3)
    Y[(tempY <= 0.008856)] = ( 7.787 * tempY[(tempY <= 0.008856)] ) + (16/116)
    
    Z[(tempZ > 0.008856)] = tempZ[(tempZ > 0.008856)] ** (1/3)
    Z[(tempZ <= 0.008856)] = ( 7.787 * tempZ[(tempZ <= 0.008856)] ) + (16/116)

    newL = (116 * Y) - 16
    newA = 500 * (X - Y)
    newB = 200 * (Y - Z)

    # newL = round(newL, 4)
    # newA = round(newA, 4)
    # newB = round(newB, 4)

    convertResult = np.dstack((newL, newA, newB))
    print("result : ", convertResult)

    return convertResult


def maskingSkin(inputArr, fileName, inputType, outputType):
    print("mulai masking")
    print("BGR : ", inputArr)
    if(inputType != "LAB"):
        inputArrNew = inputArr.astype("float32") / 255
        inputArrNew = cv2.cvtColor(inputArrNew, cv2.COLOR_BGR2Lab)
    else :
        inputArrNew = inputArr

    print("NEW : ", inputArrNew)
    (h,w,c) = inputArrNew.shape
    img2D_arrNew = inputArrNew.reshape(h*w,c)
    print("NEW 2d: ", img2D_arrNew)

    channel_L = inputArrNew[:, :, 0]
    channel_A = inputArrNew[:, :, 1]
    channel_B = inputArrNew[:, :, 2]
    print("L shape: ", channel_L.shape)
    print("L : ", channel_L)
    print("A : ", channel_A)
    print("B : ", channel_B)

    L1 = np.full(channel_L.shape, 0)
    print("L1 : ", L1)
    A1 = np.full(channel_A.shape, 0)
    print("A1 : ", A1)
    B1 = np.full(channel_B.shape, 0)
    print("B1 : ", B1)

    # L1[(channel_L>=20)&(channel_L<=75)] = channel_L[(channel_L>=20)&(channel_L<=75)]
    # A1[(channel_L>=20)&(channel_L<=75)] = channel_A[(channel_L>=20)&(channel_L<=75)]
    # B1[(channel_L>=20)&(channel_L<=75)] = channel_B[(channel_L>=20)&(channel_L<=75)]
    # L1[((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)] = channel_L[((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)]
    # A1[((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)] = channel_A[((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)]
    # B1[((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)] = channel_B[((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)]
    L1[(channel_L>=20)&(channel_L<=75)&((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)] = channel_L[(channel_L>=20)&(channel_L<=75)&((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)]
    A1[(channel_L>=20)&(channel_L<=75)&((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)] = channel_A[(channel_L>=20)&(channel_L<=75)&((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)]
    B1[(channel_L>=20)&(channel_L<=75)&((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)] = channel_B[(channel_L>=20)&(channel_L<=75)&((np.arctan(channel_B/channel_A)*180/np.pi)>=44)&((np.arctan(channel_B/channel_A)*180/np.pi)<=68)]
    print("L1 : ", L1)
    print("A1 : ", A1)
    print("B1 : ", B1)

    L1 = (L1*255/100).astype('uint8')
    A1 = (A1+128).astype('uint8')
    B1 = (B1+128).astype('uint8')
    LAB_RESULT = np.dstack((L1, A1, B1))
    print("LAB_RESULT shape : ", LAB_RESULT.shape)
    print("LAB_RESULT : ", LAB_RESULT)

    if(outputType != "LAB") :
        LAB_RESULT = cv2.cvtColor(LAB_RESULT, cv2.COLOR_Lab2RGB)
    

    SAVEBGR = cv2.cvtColor(LAB_RESULT, cv2.COLOR_Lab2BGR)
    print("MASKING SAVE : ", SAVEBGR)
    # NEW_FIGURE = plt.figure("MASKING")
    # plt.imshow(SAVERGB)
    # NEW_FIGURE.savefig("./Images_Masking/"+fileName)
    cv2.imwrite('./Images_Masking/'+fileName, SAVEBGR)


    # print("channel_L : ", channel_L)
    # new_LAB = np.zeros((channel_L.shape[0], channel_L.shape[1], 3))
    # new_LAB[:, :, 0] = channel_L
    # new_LAB[:, :, 1] = channel_A
    # new_LAB[:, :, 2] = channel_B
    # print("NEW LAB : ", new_LAB)
    # channel_L = []
    # for char in "0":
    #     channel_L.append(int(char))
    # img_arr_L = inputArrNew[:,:,channel_L]
    # reshaped_L = img_arr_L.reshape(img_arr_L.shape[0] * img_arr_L.shape[1], img_arr_L.shape[2])

    # print("2d L : ", reshaped_L)

    return LAB_RESULT

# KMEANS - CBCR
def kmeansFace(fileName):
    img_arr = cv2.imread("./python_process/Images_New/"+fileName)
    
    # numClusters = 3

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

    # print("AAAAAAAa")
    data = {'y': skinColorY,
            'cr': skinColorCr,
            'cb': skinColorCb}
    
    df = pd.DataFrame(data, columns=['y', 'cr', 'cb'])
    # print(df)
    kmeans = KMeans(n_clusters=1).fit(df)
    centroids = kmeans.cluster_centers_
    inputCheck = [round(centroids[0][0]), round(centroids[0][1]), round(centroids[0][2])]
    
    cluster_crcb = plt.figure("cluster crcb")

    if(numClusters == 2):
        cmap = ListedColormap(["brown", "black"])
        if(choosenCluster[0] == 1):
            cmap = ListedColormap(["black", "brown"])
    elif(numClusters == 3):
        cmap = ListedColormap(["brown", "black", "white"])
        if(choosenCluster[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white"])
        elif(choosenCluster[0] == 2):
            cmap = ListedColormap(["black", "white", "brown"])
    elif(numClusters == 4):
        cmap = ListedColormap(["brown", "black", "white", "grey"])
        if(choosenCluster[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white", "grey"])
        elif(choosenCluster[0] == 2):
            cmap = ListedColormap(["black", "white", "brown", "grey"])
        elif(choosenCluster[0] == 3):
            cmap = ListedColormap(["black", "white", "grey", "brown"])

    plt.imshow(img_quant_crcb, cmap=cmap)
    cluster_crcb.savefig("./python_process/Images_Cluster/"+"crcb_"+fileName)

    if bool_CIELAB :
        temp = np.uint8([[[inputCheck[0],inputCheck[1],inputCheck[2]]]])
        print("TEMP : ", temp)
        newRGB = cv2.cvtColor(temp, cv2.COLOR_YCrCb2RGB)
        print("NEW RGB : ", newRGB)
        result = checkCIELab(newRGB)
    else :
        result = checkCategory(inputCheck)

    return result

# KMEANS - YCBCR
def kmeansFaceYCBCR(fileName):
    img_arr = cv2.imread("./python_process/Images_New/"+fileName)

    if (bool_masking) :
        img_arr = maskingSkin(img_arr, fileName, "BGR", "YCbCr")
        img_arr_ycrcb = cv2.cvtColor(img_arr, cv2.COLOR_RGB2YCrCb)
    else:
        img_arr_ycrcb = cv2.cvtColor(img_arr, cv2.COLOR_BGR2YCrCb)

    # ycrcb
    (h_ycrcb,w_ycrcb,c_ycrcb) = img_arr_ycrcb.shape
    img2D_ycrcb = img_arr_ycrcb.reshape(h_ycrcb*w_ycrcb,c_ycrcb)
    kmeans_model_ycrcb = KMeans(n_clusters=numClusters, random_state=0) 
    cluster_labels_ycrcb = kmeans_model_ycrcb.fit_predict(img2D_ycrcb)
    labels_count_ycrcb = Counter(cluster_labels_ycrcb)
    cols_ycrcb = kmeans_model_ycrcb.cluster_centers_.round(0).astype(int)
    img_quant_ycrcb = np.reshape(cols_ycrcb[cluster_labels_ycrcb],(h_ycrcb,w_ycrcb,c_ycrcb))
    u, c = np.unique(cluster_labels_ycrcb, return_counts = True)
    
    if bool_maxCluster :
        choosenClusterycrcb = u[c == c.max()]
    else :
        choosenClusterycrcb = u[c == c.min()]
    print("labels_count_ycrcb : ", labels_count_ycrcb)
    print("choosenClusterycrcb : ", choosenClusterycrcb)
    print("cols_ycrcb : ", cols_ycrcb)


    inputCheck = cols_ycrcb[choosenClusterycrcb[0]]
    img_quant_ycrcb = np.reshape(np.array(kmeans_model_ycrcb.labels_, dtype=np.uint8),
        (img_arr_ycrcb.shape[0], img_arr_ycrcb.shape[1]))

    cluster_ycrcb = plt.figure("cluster ycrcb")
    # cmap = ListedColormap(["brown", "black", "white"])
    if(numClusters == 2):
        cmap = ListedColormap(["brown", "black"])
        if(choosenClusterycrcb[0] == 1):
            cmap = ListedColormap(["black", "brown"])
    elif(numClusters == 3):
        cmap = ListedColormap(["brown", "black", "white"])
        if(choosenClusterycrcb[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white"])
        elif(choosenClusterycrcb[0] == 2):
            cmap = ListedColormap(["black", "white", "brown"])
    elif(numClusters == 4):
        cmap = ListedColormap(["brown", "black", "white", "grey"])
        if(choosenClusterycrcb[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white", "grey"])
        elif(choosenClusterycrcb[0] == 2):
            cmap = ListedColormap(["black", "white", "brown", "grey"])
        elif(choosenClusterycrcb[0] == 3):
            cmap = ListedColormap(["black", "white", "grey", "brown"])


    plt.imshow(img_quant_ycrcb, cmap=cmap)
    cluster_ycrcb.savefig("./python_process/Images_Cluster/"+"Ycrcb_"+fileName)
    
    print("INPUT CHECK : ", inputCheck)

    if bool_CIELAB :
        temp = np.uint8([[[inputCheck[0],inputCheck[1],inputCheck[2]]]])
        print("TEMP : ", temp)
        newRGB = cv2.cvtColor(temp, cv2.COLOR_YCrCb2RGB)
        print("NEW RGB : ", newRGB)
        result = checkCIELab(newRGB)
    else :
        result = checkCategory(inputCheck)
    
    return result


# KMEANS - MIX
def kmeansMixFace(fileName):
    img_arr = cv2.imread("./Images_New/"+fileName)
    img_RGB = cv2.cvtColor(img_arr, cv2.COLOR_BGR2RGB)

    img_arr_ycrcb = cv2.cvtColor(img_arr, cv2.COLOR_BGR2YCrCb)

    # ycrcb
    (h_ycrcb,w_ycrcb,c_ycrcb) = img_arr_ycrcb.shape
    img2D_ycrcb = img_arr_ycrcb.reshape(h_ycrcb*w_ycrcb,c_ycrcb)
    kmeans_model_ycrcb = KMeans(n_clusters=numClusters, random_state=0) 
    cluster_labels_ycrcb = kmeans_model_ycrcb.fit_predict(img2D_ycrcb)
    labels_count_ycrcb = Counter(cluster_labels_ycrcb)
    cols_ycrcb = kmeans_model_ycrcb.cluster_centers_.round(0).astype(int)
    img_quant_ycrcb = np.reshape(cols_ycrcb[cluster_labels_ycrcb],(h_ycrcb,w_ycrcb,c_ycrcb))
    u, c = np.unique(cluster_labels_ycrcb, return_counts = True)
    choosenClusterycrcb = u[c == c.max()]

    inputCheck = cols_ycrcb[choosenClusterycrcb[0]]

    print("choosenClusterycrcb : ",choosenClusterycrcb[0])
    print("img_quant_ycrcb : ", img_quant_ycrcb)

    cluster_ycrcb = plt.figure("cluster ycrcb")
    cmap = ListedColormap(["brown", "black", "white"])
    img_quant_ycrcb = np.reshape(np.array(kmeans_model_ycrcb.labels_, dtype=np.uint8),
        (img_arr_ycrcb.shape[0], img_arr_ycrcb.shape[1]))
    
    # crcb
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
    choosenClustercrcb = u[c == c.max()]

    img_quant_crcb = np.reshape(np.array(kmeans_model_crcb.labels_, dtype=np.uint8),
        (img_arr_crcb.shape[0], img_arr_crcb.shape[1]))
    
    labels_count_crcb = Counter(cluster_labels_crcb)
    cols_crcb = kmeans_model_crcb.cluster_centers_.round(0).astype(int)

    counter=0

    skinColorY = []
    skinColorCr = []
    skinColorCb = []

    for index, pixel in enumerate(cluster_labels_crcb):
        if pixel == choosenClustercrcb[0] :
            skinColorY.append(reshaped_y[index][0]+0)
            skinColorCr.append(reshapedCrCb[index][0]+0)
            skinColorCb.append(reshapedCrCb[index][1]+0)
            counter += 1

    data = {'y': skinColorY,
            'cr': skinColorCr,
            'cb': skinColorCb}

    df = pd.DataFrame(data, columns=['y', 'cr', 'cb'])
    kmeans = KMeans(n_clusters=1).fit(df)
    centroids = kmeans.cluster_centers_

    inputCheck = [round(centroids[0][0]), round(centroids[0][1]), round(centroids[0][2])]

    

    # B1[H1<120]

    if(numClusters == 3):
        cmap = ListedColormap(["brown", "black", "white"])
        if(choosenClusterycrcb[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white"])
        elif(choosenClusterycrcb[0] == 2):
            cmap = ListedColormap(["black", "white", "brown"])
    elif(numClusters == 4):
        cmap = ListedColormap(["brown", "black", "white", "grey"])
        if(choosenClusterycrcb[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white", "grey"])
        elif(choosenClusterycrcb[0] == 2):
            cmap = ListedColormap(["black", "white", "brown", "grey"])
        elif(choosenClusterycrcb[0] == 3):
            cmap = ListedColormap(["black", "white", "grey", "brown"])

    plt.imshow(img_quant_ycrcb, cmap=cmap)
    cluster_ycrcb.savefig("./Images_Cluster/"+"ycrcb_"+fileName)

    

    # MIX
    print("img_quant_ycrcb : ", img_quant_ycrcb.shape, "img_arr_ycrcb : ", img_arr_ycrcb.shape, "img_quant_crcb : ", img_quant_crcb.shape)

    # img_quant_ycrcb[] = -1
    
    img_quant_crcb[img_quant_crcb==choosenClustercrcb[0]] = 5
    img_quant_ycrcb[img_quant_ycrcb==choosenClusterycrcb[0]] = 5
    choosenClustercrcb[0] = 5
    choosenClusterycrcb[0] = 5
    img_quant_crcb[(img_quant_ycrcb==choosenClusterycrcb[0])&(img_quant_crcb==choosenClustercrcb[0])] = 10

    img_RGB[img_quant_crcb!=10]=[0,0,255]
    ori = plt.figure("ori")
    plt.imshow(img_RGB)
    # ori.show()
    ori.savefig("./Images_Cluster/"+"ycrcb_mix_"+fileName)

    # kmeans MIX
    mix_arr_ycrcb = cv2.cvtColor(img_RGB, cv2.COLOR_RGB2YCrCb)
    (h_ycrcb,w_ycrcb,c_ycrcb) = mix_arr_ycrcb.shape
    img2D_ycrcb = mix_arr_ycrcb.reshape(h_ycrcb*w_ycrcb,c_ycrcb)
    kmeans_model_ycrcb = KMeans(n_clusters=2, random_state=0) 
    cluster_labels_ycrcb = kmeans_model_ycrcb.fit_predict(img2D_ycrcb)
    labels_count_ycrcb = Counter(cluster_labels_ycrcb)
    cols_ycrcb = kmeans_model_ycrcb.cluster_centers_.round(0).astype(int)
    img_quant_ycrcb = np.reshape(cols_ycrcb[cluster_labels_ycrcb],(h_ycrcb,w_ycrcb,c_ycrcb))
    u, c = np.unique(cluster_labels_ycrcb, return_counts = True)
    choosenClusterycrcb = u[c == c.max()]
    # choosenClusterycrcb = 0
    if(cols_ycrcb[0][0] == 29 and cols_ycrcb[0][1] == 107 and cols_ycrcb[0][2] == 255) :
        print("ya")
        choosenClusterycrcb = 1
    else:
        print("tidak")
        choosenClusterycrcb = 0

    print("cols_ycrcb : ", cols_ycrcb[0][0], "-", cols_ycrcb[0][1], "-", cols_ycrcb[0][2])
    inputCheck = cols_ycrcb[choosenClusterycrcb]
    print("choosenClusterycrcb : ", choosenClusterycrcb)

    
    print("MIXXXXXXx=======================")
    print("cols_ycrcb : ", cols_ycrcb)
    print("cluster_labels_ycrcb : ", cluster_labels_ycrcb)

    
    # cielab
    print("INPUT CHECK : ", inputCheck)
    temp = np.uint8([[[inputCheck[0],inputCheck[1],inputCheck[2]]]])
    print("TEMP : ", temp)
    newRGB = cv2.cvtColor(temp, cv2.COLOR_YCrCb2RGB)
    print("NEW RGB : ", newRGB)

    if bool_CIELAB :
        result = checkCIELab(newRGB)
    else :
        result = checkCategory(inputCheck)
    
    return result


# CMAP CLUSTER
def getCMap(numClusters, choosenCluster):
    if(numClusters == 1):
        cmap = ListedColormap(["brown"])
    elif(numClusters == 2):
        cmap = ListedColormap(["brown", "black"])
        if(choosenCluster[0] == 1):
            cmap = ListedColormap(["black", "brown"])
    elif(numClusters == 3):
        cmap = ListedColormap(["brown", "black", "white"])
        if(choosenCluster[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white"])
        elif(choosenCluster[0] == 2):
            cmap = ListedColormap(["black", "white", "brown"])
    elif(numClusters == 4):
        cmap = ListedColormap(["brown", "black", "white", "grey"])
        if(choosenCluster[0] == 1):
            cmap = ListedColormap(["black",  "brown", "white", "grey"])
        elif(choosenCluster[0] == 2):
            cmap = ListedColormap(["black", "white", "brown", "grey"])
        elif(choosenCluster[0] == 3):
            cmap = ListedColormap(["black", "white", "grey", "brown"])
    return cmap


# KMEANS - CIELAB
def kmeansFaceCIELAB(fileName):
    clusterUse = numClusters
    img_arr = cv2.imread("./python_process/Images_New/"+fileName)
    # img_arr = cv2.imread("./Images_Ori/dataset 1 frontal face/"+"21 - Copy.jpeg")
    print("img_arr shape : ", img_arr.shape)
    print("img_arr: ", img_arr)
    print("depth : ", img_arr.dtype)

    # OLD LAB - BETULLLL
    print("ORI BGR : ", img_arr)
    img_arr = img_arr.astype("float32") / 255
    print("depth : ", img_arr.dtype)
    print("new arr : ", img_arr)
    img_arr_Lab = cv2.cvtColor(img_arr, cv2.COLOR_BGR2Lab)
    print("depth lab : ", img_arr_Lab.dtype)

    cv2.imwrite('./python_process/Images_OLD_LAB/'+fileName, img_arr_Lab)
    print("RESULT LAB OLD : ", img_arr_Lab)


    # NEW LAB - SUDAH HILANG
    # img_arr = cv2.cvtColor(img_arr, cv2.COLOR_BGR2RGB)
    # img_arr_Lab = convertRGB2LAB(img_arr)
    # cv2.imwrite('./Images_NEW_LAB/'+fileName, img_arr_Lab)

    (h_Lab,w_Lab,c_Lab) = img_arr_Lab.shape

    reshapedLab = img_arr_Lab.reshape(h_Lab*w_Lab,c_Lab)
    print("reshapedLab shape : ", reshapedLab.shape)
    print("reshapedLab : ", reshapedLab)

    kmeans_model_Lab = KMeans(n_clusters=numClusters, random_state=0) 
    cluster_labels_Lab = kmeans_model_Lab.fit_predict(reshapedLab)
    labels_count_Lab = Counter(cluster_labels_Lab)
    print("labels_count_Lab : ", labels_count_Lab)

    u, c = np.unique(cluster_labels_Lab, return_counts = True)
    choosenCluster = u[c == c.max()]
    print("choosenCluster : ", choosenCluster)
    percentage = labels_count_Lab[choosenCluster[0]]/(labels_count_Lab[0]+labels_count_Lab[1]+labels_count_Lab[2])*100


    print("percentage-3 : ", percentage)
    if(percentage<=44):
        print("start cluster 2")
        # KMEANS CLUSTER 2
        kmeans_model_Lab = KMeans(n_clusters=2, random_state=0) 
        cluster_labels_Lab = kmeans_model_Lab.fit_predict(reshapedLab)
        labels_count_Lab = Counter(cluster_labels_Lab)
        print("labels_count_Lab : ", labels_count_Lab)

        u, c = np.unique(cluster_labels_Lab, return_counts = True)
        choosenCluster = u[c == c.max()]
        print("choosenCluster : ", choosenCluster)
        percentage = labels_count_Lab[choosenCluster[0]]/(labels_count_Lab[0]+labels_count_Lab[1]+labels_count_Lab[2])*100
        clusterUse = 2

    print("percentage end : ", percentage)
    img_quant_Lab = np.reshape(np.array(kmeans_model_Lab.labels_, dtype=np.uint8),
        (img_arr_Lab.shape[0], img_arr_Lab.shape[1]))
    
    print("img_quant_Lab shape : ", img_quant_Lab.shape)
    print("img_quant_Lab : ", img_quant_Lab)

    print("kmeans_model_Lab.labels_ shape : ", kmeans_model_Lab.labels_.shape)
    print("kmeans_model_Lab.labels_  : ", kmeans_model_Lab.labels_)

    
    
    
    # labels_count_Lab = Counter(cluster_labels_Lab)
    cols_Lab = kmeans_model_Lab.cluster_centers_.round(0).astype(int)
    print("cols_Lab : ", cols_Lab)
    

    
    
    if (bool_masking) :
        cluster_Lab = plt.figure("cluster Lab")
        cmap = getCMap(clusterUse, choosenCluster)
        plt.imshow(img_quant_Lab, cmap=cmap)
        cluster_Lab.savefig("./python_process/Images_Cluster/"+"Before_Mask_"+fileName)

        print("MASKING")
        # clusterUse = 2
        reshapedLab_NEW = reshapedLab
        reshapedLab_NEW[kmeans_model_Lab.labels_ != choosenCluster[0]] = [0, 0, 0]
        print("reshapedLab shape : ", reshapedLab_NEW.shape)
        print("reshapedLab : ", reshapedLab_NEW)
        img_after_cluster_NEW = np.reshape(np.array(reshapedLab_NEW, dtype=np.uint8), (img_arr_Lab.shape[0], img_arr_Lab.shape[1], 3))
    

        img_arr_NEW = maskingSkin(img_after_cluster_NEW, fileName, "LAB", "LAB")

        img_arr_NEW = cv2.imread("./python_process/Images_Masking/"+fileName)

        img_arr_Lab_NEW = img_arr_NEW

        print("NEWWWW : ", img_arr_Lab_NEW)


        img_arr_Lab_NEW = img_arr_Lab_NEW.astype("float32") / 255
        img_arr_Lab_NEW = cv2.cvtColor(img_arr_Lab_NEW, cv2.COLOR_BGR2Lab)

        (h_Lab_NEW,w_Lab_NEW,c_Lab_NEW) = img_arr_Lab_NEW.shape

        reshapedLab_NEW = img_arr_Lab_NEW.reshape(h_Lab_NEW*w_Lab_NEW,c_Lab_NEW)
        print("reshapedLab shape : ", reshapedLab_NEW.shape)
        print("reshapedLab : ", reshapedLab_NEW)

        kmeans_model_Lab_NEW = KMeans(n_clusters=2, random_state=0) 
        cluster_labels_Lab_NEW = kmeans_model_Lab_NEW.fit_predict(reshapedLab_NEW)
        labels_count_Lab_NEW = Counter(cluster_labels_Lab_NEW)
        print("labels_count_Lab : ", labels_count_Lab_NEW)

        # u, c = np.unique(cluster_labels_Lab_NEW, return_counts = True)
        # choosenCluster_NEW = u[c == c.max()]
        # print("choosenCluster : ", choosenCluster_NEW)
        # percentage = labels_count_Lab_NEW[choosenCluster_NEW[0]]/(labels_count_Lab[0]+labels_count_Lab[1]+labels_count_Lab[2])*100

        cols_Lab_NEW = kmeans_model_Lab_NEW.cluster_centers_.round(0).astype(int)

        temp0 = cols_Lab_NEW[0] - np.array((0, 0, 0))
        distance0 = np.sqrt(np.dot(temp0.T, temp0))

        temp1 = cols_Lab_NEW[1] - np.array((0, 0, 0))
        distance1 = np.sqrt(np.dot(temp1.T, temp1))

        if distance0 > distance1 :
            choosenCluster_NEW = np.array([0])
        else :
            choosenCluster_NEW = np.array([1])

        print("choosenCluster : ", choosenCluster_NEW)

        print("CLUSTERRRR : ", cols_Lab_NEW)
        inputCheck = cols_Lab_NEW[choosenCluster_NEW[0]]

        cluster_Lab_NEW = plt.figure("cluster Lab_NEW")
        # plt.legend(["blue", "orange", "red"], loc=0, frameon=True)

        cmap_NEW = getCMap(2, choosenCluster_NEW)

        # # img_quant_Lab = np.reshape(cols_Lab[cluster_labels_Lab],(h_Lab,w_Lab,c_Lab))
        # cluster_Lab_NEW = plt.figure("cluster Lab")

        # plt.imshow(img_quant_Lab, cmap=cmap_NEW)
        # # plt.imshow(img_quant_Lab)
        # cluster_Lab_NEW.savefig("./Images_Cluster_NEW"+fileName)

        img_quant_Lab_NEW = np.reshape(np.array(kmeans_model_Lab_NEW.labels_, dtype=np.uint8),
        (img_arr_Lab_NEW.shape[0], img_arr_Lab_NEW.shape[1]))
        
        cluster_Lab_NEW = plt.figure("cluster Lab_NEW")
        # plt.legend(["blue", "orange", "red"], loc=0, frameon=True)

        cmap_NEW = getCMap(2, choosenCluster_NEW)
        plt.imshow(img_quant_Lab_NEW, cmap=cmap_NEW)
        cluster_Lab_NEW.savefig("./python_process/Images_Cluster/"+"Lab_"+fileName)

    else :
        inputCheck = cols_Lab[choosenCluster[0]]

        cluster_Lab = plt.figure("cluster Lab")
        # plt.legend(["blue", "orange", "red"], loc=0, frameon=True)

        cmap = getCMap(clusterUse, choosenCluster)

        # img_quant_Lab = np.reshape(cols_Lab[cluster_labels_Lab],(h_Lab,w_Lab,c_Lab))

        plt.imshow(img_quant_Lab, cmap=cmap)
        # plt.imshow(img_quant_Lab)
        cluster_Lab.savefig("./python_process/Images_Cluster/"+"Lab_"+fileName)
    

    if bool_CIELAB:
        print("check : ", inputCheck)
        L = inputCheck[0];a = inputCheck[1];b = inputCheck[2]

        ITA = math.atan((L-50)/b)*180/math.pi
        print("ITA : ", ITA)
        skintone = ""
        if ITA < -30 :
            skintone = "deep"
        elif ITA < 10 : 
            skintone = "tan"
        elif ITA < 28 :
            skintone = "medium"
        elif ITA < 41 :
            skintone = "medium"
        elif ITA < 55 :
            skintone = "light"
        else :
            skintone = "fair"

        hue = math.atan(b/a)*180/math.pi
        # hue = math.atan(b/a)
        print("hue : ", hue)
        undertone = ""
        if hue > 60 :
            undertone = "warm"
        elif hue > 52 :
            undertone = "netral"
        else :
            undertone = "cool"

        print("skintone : ", skintone, " - undertone : ", undertone)
        resultSkin = skintone + "_" + undertone
    else:
        temp = np.uint8([[[inputCheck[0],inputCheck[1],inputCheck[2]]]])
        print("TEMP : ", temp)
        temp[0][0][0] = temp[0][0][0]*255/100
        temp[0][0][1] = temp[0][0][1]+128
        temp[0][0][2] = temp[0][0][2]+128
        newRGB = cv2.cvtColor(temp, cv2.COLOR_Lab2RGB)
        print("NEW RGB : ", newRGB)
        # newRGB = newRGB.astype("float32") / 255
        print("NEW RGB : ", newRGB)
        newYCrCb = cv2.cvtColor(newRGB, cv2.COLOR_RGB2YCrCb)
        print("NEW YCRCB : ", newYCrCb)
        resultSkin = checkCategory(newYCrCb[0][0])


    return resultSkin