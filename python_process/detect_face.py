import cv2

faceCascade = cv2.CascadeClassifier("./python_process/haarcascade_frontalface_default.xml")

def detectFace(fileName):
    print("start")
    image = cv2.imread(str('./python_process/Images_Ori/'+fileName))
    face_detect = faceCascade.detectMultiScale(
        image,
        scaleFactor=1.1,
        minNeighbors=5,
        minSize=(30, 30),
    )

    for x, y, w, h in face_detect:
        crop_faces = image[y:y + h, x:x + w]
        cv2.imwrite('./python_process/Images_New/'+fileName, crop_faces)
    
    print(len(face_detect))

    if len(face_detect) == 0:
        return False
    return True
    
