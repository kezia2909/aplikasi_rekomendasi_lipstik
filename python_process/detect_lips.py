import cv2
import numpy as np
from sklearn.cluster import KMeans
from collections import Counter
from global_variable import temp_list_area_lips
from global_variable import temp_list_labels
from global_variable import temp_list_choosen_cluster
from global_variable import bool_cluster_CIELAB


eyeCascade = cv2.CascadeClassifier("./python_process/haarcascade/haarcascade_eye.xml")
smileCascade = cv2.CascadeClassifier("./python_process/haarcascade/haarcascade_smile.xml")
leftEyeCascade = cv2.CascadeClassifier("./python_process/haarcascade/haarcascade_lefteye_2splits.xml")
rightEyeCascade = cv2.CascadeClassifier("./python_process/haarcascade/haarcascade_righteye_2splits.xml")

def detectLips(imageName):
    print("START DETECT LIPS")
    face = cv2.imread(str("./python_process/Images_New/"+imageName))
    eyes = eyeCascade.detectMultiScale(face)
    leftEye = leftEyeCascade.detectMultiScale(face)
    rightEye = rightEyeCascade.detectMultiScale(face)
    roi_color_new = face.copy()

    lips = []
    lips_label = []
    choosen_cluster = []
    if len(leftEye) > 0 and len(rightEye) > 0 :
        grayscale_image = cv2.cvtColor(face, cv2.COLOR_BGR2GRAY)
        roi_gray = grayscale_image
        roi_color = face.copy()
        roi_color_new = face.copy()

        mouth = smileCascade.detectMultiScale(roi_gray, scaleFactor=1.3, minNeighbors=4, flags=cv2.CASCADE_SCALE_IMAGE)
        counter_lips = 0
        for (mouth_x_coordinate, mouth_y_coordinate, mouth_width, mouth_height) in mouth:
            cv2.rectangle(roi_color_new, (mouth_x_coordinate, mouth_y_coordinate),(mouth_x_coordinate + mouth_width, mouth_y_coordinate + mouth_height), (0, 255, 255), 2)
            checkLeftEye = True
            checkRightEye = True
            checkBelowEye = True
            
            for x, y, w, h in rightEye:
                if(mouth_x_coordinate>x+w):
                    checkLeftEye = False
                if(mouth_y_coordinate < y+h):
                    checkBelowEye = False

            for x, y, w, h in leftEye:
                if(mouth_x_coordinate+mouth_width<x):
                    checkRightEye = False
                if(mouth_y_coordinate < y+h):
                    checkBelowEye = False

            if(checkLeftEye == True and checkRightEye == True and checkBelowEye == True):
                temp = [mouth_x_coordinate, mouth_y_coordinate, mouth_width, mouth_height]
                lips.append(temp)

                # KMEANS
                if bool_cluster_CIELAB :
                    crop_lips = face[mouth_y_coordinate:mouth_y_coordinate + mouth_height, mouth_x_coordinate:mouth_x_coordinate + mouth_width]
                    numClusters = 2
                    img_arr = crop_lips.astype("float32") / 255
                    print("depth : ", img_arr.dtype)
                    print("new arr : ", img_arr)
                    img_arr_Lab = cv2.cvtColor(img_arr, cv2.COLOR_BGR2Lab)
                    
                    (h_Lab,w_Lab,c_Lab) = img_arr_Lab.shape
                    reshapedLab = img_arr_Lab.reshape(h_Lab*w_Lab,c_Lab)
                    kmeans_model_Lab = KMeans(n_clusters=numClusters, random_state=0) 
                    cluster_labels_Lab = kmeans_model_Lab.fit_predict(reshapedLab)
                    labels_count_Lab = Counter(cluster_labels_Lab)
                    u, c = np.unique(cluster_labels_Lab, return_counts = True)
                    choosenCluster = u[c == c.max()]
                    img_quant_Lab = np.reshape(np.array(kmeans_model_Lab.labels_, dtype=np.uint8),
                        (img_arr_Lab.shape[0], img_arr_Lab.shape[1]))
                    cols_Lab = kmeans_model_Lab.cluster_centers_.round(0).astype(int)
                    temp_label = kmeans_model_Lab.labels_
                    print(temp_label)
                    lips_label.append(temp_label.tolist()) 
                    print(lips_label)
                    choosen_cluster.append(choosenCluster[0])
                else :
                    crop_lips = face[mouth_y_coordinate:mouth_y_coordinate + mouth_height, mouth_x_coordinate:mouth_x_coordinate + mouth_width]
                    numClusters = 2
                    img_arr_rgb = cv2.cvtColor(crop_lips, cv2.COLOR_BGR2RGB)
                    img_arr_ycrcb = cv2.cvtColor(crop_lips, cv2.COLOR_BGR2YCrCb)
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
                    print("choosen : ", choosenCluster[0])
                    img_quant_crcb = np.reshape(np.array(kmeans_model_crcb.labels_, dtype=np.uint8),
                        (img_arr_crcb.shape[0], img_arr_crcb.shape[1]))
                    labels_count_crcb = Counter(cluster_labels_crcb)
                    cols_crcb = kmeans_model_crcb.cluster_centers_.round(0).astype(int)
                    print("cluster")
                    print(cols_crcb)
                    print(img_quant_crcb)
                    print("height", img_arr_rgb.shape[0])
                    print("width", img_arr_rgb.shape[1])
                    # print(img_arr_rgb[img_arr_rgb.shape[0]-1])
                    print(kmeans_model_crcb.labels_)
                    # for index, pixel in enumerate(img_arr_rgb[img_arr_rgb.shape[0]-1]):
                    #     roi_color_new[img_arr_rgb.shape[0]-1][index] = [0,0,0]
                    # for index, pixel in enumerate(img_arr_rgb[img_arr_rgb.shape[0]-2]):
                    #     roi_color_new[img_arr_rgb.shape[0]-1][index] = [0,0,0]
                    # for index, pixel in enumerate(img_arr_rgb[img_arr_rgb.shape[0]-3]):
                    #     roi_color_new[img_arr_rgb.shape[0]-1][index] = [0,0,0]
                    # for index, pixel in enumerate(img_arr_rgb[img_arr_rgb.shape[0]-4]):
                    #     roi_color_new[img_arr_rgb.shape[0]-1][index] = [0,0,0]
                    print("TESTING")
                    temp_label = kmeans_model_crcb.labels_
                    print(temp_label)
                    lips_label.append(temp_label.tolist()) 
                    print(lips_label)
                    choosen_cluster.append(choosenCluster[0])
                    # tempCount=0
                    # for y in range(mouth_y_coordinate, mouth_y_coordinate+mouth_height):
                    #     for x in range(mouth_x_coordinate, mouth_x_coordinate+mouth_width):
                    #         if(kmeans_model_crcb.labels_[tempCount] != choosenCluster[0]):
                    #             roi_color_new[y][x] = [rgb[2],rgb[1],rgb[0]]
                    #             # if(counter_lips == 0) :
                    #             #     roi_color_new[y][x] = [0,0,255]
                    #             # else:
                    #             #     roi_color_new[y][x] = [0,255,0]
                    #         tempCount+=1
        print("SAVEEEEE LIPSSSS")
        # cv2.imwrite('./python_process/Images_New/'+str(counter)+'_'+fileName, crop_faces)
        cv2.imwrite('./python_process/Image_Lips/'+imageName, roi_color_new)
    print("END DETECT LIPS")
    temp_list_area_lips.append(lips)
    temp_list_labels.append(lips_label)
    temp_list_choosen_cluster.append(choosen_cluster)
    # return lips