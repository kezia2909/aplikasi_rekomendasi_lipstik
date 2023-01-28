import cv2

faceCascade = cv2.CascadeClassifier("./python_process/haarcascade/haarcascade_frontalface_default.xml")
eyeCascade = cv2.CascadeClassifier("./python_process/haarcascade/haarcascade_eye.xml")

def detectEye(detectFace):
    eyes = eyeCascade.detectMultiScale(detectFace)
    print("eyes :")
    print(len(eyes))
    return len(eyes)
    
def detectFace(fileName):
    print("start")
    image = cv2.imread(str('./python_process/Images_Ori/'+fileName))
    face_detect = faceCascade.detectMultiScale(
        image,
        scaleFactor=1.1,
        minNeighbors=5,
        minSize=(30, 30),
    )

    counter = 0
    for x, y, w, h in face_detect:
        crop_faces = image[y:y + h, x:x + w]
        if detectEye(crop_faces) > 0 :
            cv2.imwrite('./python_process/Images_New/'+str(counter)+'_'+fileName, crop_faces)
            counter += 1
    
    print("faces :")
    print(len(face_detect))

    return counter
    
