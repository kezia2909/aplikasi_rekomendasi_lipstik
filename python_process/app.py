# Imports
import json
# import werkzeug
from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2

import base64

from download_images import downloadImage
from detect_face import detectFace
from upload_images import uploadToFirebase
from kmeans_face import kmeansFace
from kmeans_face import kmeansFaceYCBCR
from kmeans_face import kmeansMixFace
from kmeans_face import kmeansFaceCIELAB
from detect_lips import detectLips
from resize_image import resizeImage
from preprocessing import preProcessing
from IAGCWD import preprocessingIAGCWD
from color_correction import percentile_whitebalance
from color_correction import whitepatch_balancing
from global_variable import temp_list_area_lips
from global_variable import temp_list_labels
from global_variable import temp_list_choosen_cluster
from global_variable import bool_preprocessing
from global_variable import bool_paper
from global_variable import bool_color_correction
from global_variable import bool_white_paper
from global_variable import mixResult
from global_variable import bool_cluster_CIELAB
from global_variable import bool_only_CbCr
from global_variable import bool_resize

# Flask
app = Flask(__name__)
CORS(app)
# Routes for API

# /face_detection POST Route detects the face using giveFacesCoordinates function in main.py and returns the list of faces coordinate
# in the body of the request we need to pass the image.
@app.route("/face_detection", methods=["POST"])
def index():
    # DOWNLOAD IMAGE FROM FIREBASE
    print("helloossss")
    print(request.json['oriURL'])
    print("aaaa")
    url="haii"
    print(url)
    url = request.json['oriURL']
    print("url done")
    name = request.json['oriName']
    print("name done")
    userId = request.json['userId']

    print(url)
    downloadImage(url, name)

    face_detected = False
    list_face_url = []
    list_face_category = []
    
    list_area_lips = []
    list_label_lips = []
    list_cluster_lips = []
    list_area_faces = []

    fileName = name+".jpg"

    if bool_resize :
        resizeImage(fileName)

    if bool_preprocessing:
        if bool_color_correction:
            if bool_white_paper:
                whitepatch_balancing(fileName)
                fileName = "pre_white_corection_"+fileName
            else:
                percentile_whitebalance(fileName)
                fileName = "pre_color_corection_"+fileName
        else:
            if bool_paper:
                preProcessing(fileName)
                fileName = "pre_"+fileName
            else:
                preprocessingIAGCWD(fileName)
                fileName = "pre_IAGCWD_"+fileName  
    

    # CROP IMAGE
    list_area_faces = detectFace(fileName)
    counter = len(list_area_faces)

    if request.json['check_using_lips'] :
        print("CEK LIPS")
    else :
        print("NO CEKKK")
    
    if counter != 0:
        for i in range(counter):
            # uploadToFirebase(str(i)+"_"+name+".jpg")
            # url = "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new"+str(i)+"_"+name+".jpg?alt=media"
            # url = "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new_image%2Fnew"+str(i)+"_"+name+".jpg?alt=media"
            uploadToFirebase(userId, str(i)+"_"+name+".jpg")
            url = "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new_image%2F"+userId+"%2Fnew"+str(i)+"_"+name+".jpg?alt=media"
            list_face_url.append(url)

            # KMEANS PROSES
            if bool_cluster_CIELAB :
                list_face_category.append(kmeansFaceCIELAB(str(i)+"_"+fileName))
            else :
                if mixResult :
                    list_face_category.append(kmeansMixFace(str(i)+"_"+fileName))
                else :
                    if bool_only_CbCr :
                        list_face_category.append(kmeansFace(str(i)+"_"+fileName))
                    else :
                        list_face_category.append(kmeansFaceYCBCR(str(i)+"_"+fileName))

            if request.json['check_using_lips'] :
                detectLips(str(i)+"_"+name+".jpg")
                # temp_list_area_lips.append()
                print("OUT LIPS", i)
        face_detected = True

    print("DONEEEEE")
    print(temp_list_area_lips)
    print(url)

    list_area_lips = temp_list_area_lips
    list_label_lips = temp_list_labels
    list_cluster_lips = temp_list_choosen_cluster
    print("LABEL - ", list_label_lips)
    print("CLUSTER - ", list_cluster_lips)

    list_area_lips = [[[int(e) for e in t] for t in l]for l in list_area_lips]
    list_label_lips = [[[int(e) for e in t] for t in l]for l in list_label_lips]
    list_cluster_lips = [[int(e) for e in t] for t  in list_cluster_lips]
    
    list_area_faces = [[int(e) for e in f] for f in list_area_faces]

    if request.json['check_using_lips'] :
        return json.dumps({"faceDetected": face_detected, "listFaceUrl": list_face_url, "listFaceCategory": list_face_category, "listAreaLips": list_area_lips, "listAreaFaces": list_area_faces, "listLabels": list_label_lips, "listChoosenCluster": list_cluster_lips})
    else :
        return json.dumps({"faceDetected": face_detected, "listFaceUrl": list_face_url, "listFaceCategory": list_face_category, "listAreaFaces": list_area_faces})


# Running the app
app.run()