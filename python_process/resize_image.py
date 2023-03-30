import cv2

def resizeImage(fileName):
    oriImage = cv2.imread(str('./python_process/Images_Ori/'+fileName))
    print("SIZE ORI : ", oriImage.shape)

    # RESIZE
    scale_percent = 0
    if(oriImage.shape[0] > oriImage.shape[1]):
        if(oriImage.shape[0] > 500):
            scale_percent = (500 * 100) / oriImage.shape[0]
    else :
        if(oriImage.shape[1] > 500):
            scale_percent = (500 * 100) / oriImage.shape[1]

    print(scale_percent)

    if(scale_percent>0):
        width = int(oriImage.shape[1] * scale_percent / 100)
        height = int(oriImage.shape[0] * scale_percent / 100)
        dsize = (width, height)

        image = cv2.resize(oriImage, dsize)
    else:
        image = oriImage
    print("SIZE : ", image.shape)

    cv2.imwrite('./python_process/Images_Resize/'+fileName, image)

    return 1