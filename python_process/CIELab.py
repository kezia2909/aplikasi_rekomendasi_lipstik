import cv2
import math

def checkCIELab(resultRGB) :
    print("result:", resultRGB)
    # r = result[0][0][0]
    # g = result[0][0][1]
    # b = result[0][0][2]
    resultRGB = resultRGB.astype("float32") / 255
    newCIELab = cv2.cvtColor(resultRGB, cv2.COLOR_RGB2Lab)
    print("NEW CIELAB : ", newCIELab)
    L = newCIELab[0][0][0]
    a = newCIELab[0][0][1]
    b = newCIELab[0][0][2]

    ITA = math.atan((L-50)/b)*180/math.pi
    print("ITA : ", ITA)
    skintone = ""
    if ITA < -30 :
        skintone = "deep"
    elif ITA < 10 : 
        skintone = "tan"
    elif ITA < 28 :
        skintone = "medium"
    elif ITA < 41 :
        skintone = "medium"
    elif ITA < 55 :
        skintone = "light"
    else :
        skintone = "fair"

    hue = math.atan(b/a)*180/math.pi
    print("hue : ", hue)
    undertone = ""
    if hue > 60 :
        undertone = "warm"
    elif hue > 52 :
        undertone = "netral"
    else :
        undertone = "cool"

    

    print("skintone : ", skintone, " - undertone : ", undertone)


    resultSkin = skintone + "_" + undertone


    return resultSkin