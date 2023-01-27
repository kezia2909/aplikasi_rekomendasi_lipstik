# Imports
import json
from upload_images import uploadToFirebase
import werkzeug
from flask import Flask, request, jsonify
from flask_cors import CORS

# Importing only giveFacesCoordinates from main.py
from old_main import giveFacesCoordinates

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
    # Image
    imagefile = request.files["image"]
    # Getting file name of the image using werkzeug library
    filename = werkzeug.utils.secure_filename(imagefile.filename)
    print("\nReceived image File name : " + imagefile.filename)
    # Saving the image in images Directory
    imagefile.save("./python_process/Images_Ori/" + filename)
    # Passing the imagePath in this giveFacesCoordinates function and getting the list of faces coordinate
    print("startt")

    # upload to firebase
    uploadToFirebase("./python_process/Images_Ori/" + filename, filename)
    print("upload oke")

    faces = giveFacesCoordinates("./python_process/Images_Ori/" + filename)
    print("endd")

    url = "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new"+filename+"?alt=media"


    # file = open("./python_process/images/Any_name", 'rb')
    # byte = file.read()
    # file.close()
    
    # decodeit = open('hello_level.jpeg', 'wb')
    # decodeit.write(base64.b64decode((byte)))
    # decodeit.close()
    # img_new.save("./python_process/new/" + filename)

    # Returns faces Cordinate in the json Format
    return json.dumps({"faces": faces, "url": url})


# Running the app
app.run()