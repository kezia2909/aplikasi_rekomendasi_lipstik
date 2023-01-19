# Imports
import json
from download_images import downloadImage
import werkzeug
from flask import Flask, request, jsonify
from flask_cors import CORS


import base64

# Flask
app = Flask(__name__)
CORS(app)
# Routes for API

# /face_detection POST Route detects the face using giveFacesCoordinates function in main.py and returns the list of faces coordinate
# in the body of the request we need to pass the image.
@app.route("/face_detection", methods=["POST"])
def index():
    print("helloossss")
    print(request.json['oriURL'])
    print("aaaa")
    url="haii"
    # url = request.json("oriURL")
    print(url)
    # url = request.oriURL
    # url = "halo halo halo"
    url = request.json['oriURL']
    name = request.json['oriName']
    print(url)
    downloadImage(url, name)
    # url="haiiiii haloooo"
    return json.dumps({"urlNew": url})


# Running the app
app.run()