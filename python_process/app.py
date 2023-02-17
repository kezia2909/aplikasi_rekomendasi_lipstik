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
from detect_lips import detectLips
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
    print(url)
    downloadImage(url, name)

    face_detected = False
    list_face_url = []
    list_face_category = []
    temp_list_area_lips = []

    # CROP IMAGE
    list_area_faces = detectFace(name+".jpg")
    counter = len(list_area_faces)
    
    if counter != 0:
        for i in range(counter):
            uploadToFirebase(str(i)+"_"+name+".jpg")
            url = "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new"+str(i)+"_"+name+".jpg?alt=media"
            list_face_url.append(url)
            list_face_category.append(kmeansFace(str(i)+"_"+name+".jpg"))
            temp_list_area_lips.append(detectLips(str(i)+"_"+name+".jpg"))
            print("OUT LIPS", i)
        face_detected = True
    print("DONEEEEE")
    print(temp_list_area_lips)
    print(url)
    list_area_lips = [[28, 73, 59, 29], [25, 58, 51, 25], [17, 60, 51, 25], []]
    print("bbbb", list_area_lips, "aaaa - ", type(list_area_lips))
    list_area_lips = temp_list_area_lips
    print("bbbb", list_area_lips, "aaaa - ", type(list_area_lips))

    list_area_lips = [[[int(e) for e in t] for t in l]for l in list_area_lips]
    print("bbbb", list_area_lips, "aaaa - ", type(list_area_lips))
    
    list_area_faces = [[int(e) for e in f] for f in list_area_faces]

    # return json.dumps({"urlNew": url, "faceDetected": face_detected, "listFaceUrl": list_face_url, "listFaceCategory": list_face_category, "listAreaLips": list_area_lips})
    return json.dumps({"faceDetected": face_detected, "listFaceUrl": list_face_url, "listFaceCategory": list_face_category, "listAreaLips": list_area_lips, "listAreaFaces": list_area_faces})


# Running the app
app.run()