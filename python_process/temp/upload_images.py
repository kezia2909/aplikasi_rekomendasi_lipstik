import pyrebase

config = {
    "apiKey": "AIzaSyA3OvMosQWlYZ9gZtfc-THWLf53UeQ3E8A",
    "authDomain": "skripsi-c47d7.firebaseapp.com",
    "projectId": "skripsi-c47d7",
    "storageBucket": "skripsi-c47d7.appspot.com",
    "messagingSenderId": "86744107893",
    "appId": "1:86744107893:web:fbb69433d9b9c656a7e13c",
    "measurementId": "G-D97XNKXXEN",
    "serviceAccount": "python_process\serviceAccount.json",
    "databaseURL": "https://skripsi-c47d7-default-rtdb.firebaseio.com/"
}



def uploadToFirebase(imagePath, filename):
    print("start upload")
    firebase = pyrebase.initialize_app(config)
    print("config")

    storage = firebase.storage()
    print("storage")

    storage.child("new"+filename).put(imagePath)
    # url = storage.child("newimage_picker8651999042837450779.jpg").get_url(None)
    # print(url)
    print("end upload")

