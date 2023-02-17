import cv2
import numpy as np
from sklearn.cluster import KMeans
from collections import Counter

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
            
            for x, y, w, h in rightEye:
                if(mouth_x_coordinate>x+w):
                    checkLeftEye = False

            for x, y, w, h in leftEye:
                if(mouth_x_coordinate+mouth_width<x):
                    checkRightEye = False

            if(checkLeftEye == True and checkRightEye == True):
                # temp = []
                # temp.append(mouth_x_coordinate)
                # temp.append(mouth_y_coordinate)
                # temp.append(mouth_width)
                # temp.append(mouth_height)
                temp = [mouth_x_coordinate, mouth_y_coordinate, mouth_width, mouth_height]
                lips.append(temp)
        print("SAVEEEEE LIPSSSS")
        # cv2.imwrite('./python_process/Images_New/'+str(counter)+'_'+fileName, crop_faces)
        cv2.imwrite('./python_process/Image_Lips/'+imageName, roi_color_new)
    print("END DETECT LIPS")
    return lips