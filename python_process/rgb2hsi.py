import numpy as np
import math

def im2double(im):
    info = np.iinfo(im.dtype) # Get the data type of the input image
    return im.astype(np.float32) / info.max 

def rgb2hsi(rgb):
    # rgb = im2double(rgb)
    # gak perlu im2double karena udah double rgb nya, di matlab juga hasilnya same gak berubah
    # print("rgb shape : ", rgb.shape, "rgb : ", rgb)
    # RGB OKE

    r = rgb[:, :, 0]
    g = rgb[:, :, 1]
    b = rgb[:, :, 2]
    # print("r shape : ", r.shape, "r : ", r)
    # print("g shape : ", g.shape, "g : ", g)
    # print("b shape : ", b.shape, "b : ", b)
    # R, G, B OKE

    # % Implement the conversion equations.
    # num = numerator = pembilang
    # den = denominator = penyebut
    # num/den OR pembilang/penyebut

    num = 0.5*((r - g) + (r - b))
    # print("num shape : ", num.shape , "num : ", num)
    # num OKE

    den = np.sqrt((r - g)**2 + (r - b)*(g - b))
    # temp = (r - g)**2
    # print("temp shape : ",temp.shape, "temp : ", temp)
    # **2 OKE
    # print("den shape : ", den.shape , "den : ", den)
    # den OKE

    # theta = np.arccos(np.divide(num, (den + np.finfo(float).eps)))
    # print(np.finfo(float).eps)
    # print("eps : ", eps+1)
    eps = 2.2204e-16
    eps = np.finfo(float).eps
    # eps OKE
    theta = np.arccos(np.divide(num, den+eps))
    # tempDivide = np.divide(num, den+eps)
    # print("tempDivide shape : ",tempDivide.shape , "tempDivide : ",tempDivide)
    # np.divide OKE
    # print("theta shape: ", theta.shape)
    # print("theta: ", theta)
    # theta OKE

    H = theta
    # print("H shape : ", H.shape, "H : ", H)
    # H OKE

    H[b>g] = 2 * math.pi - H[b>g]
    # print("H shape : ", H.shape, "H : ", H)
    # H[b>g] OKE

    H = H/(2*math.pi)
    # print("H shape : ", H.shape, "H : ", H)
    # H OKE, pake np.eps OKE

    num = np.min(np.array([r, g, b]), axis=0)
    # print("num shape : ", num.shape, "num : ", num)
    # num OKE

    den = r + g + b
    # print("den shape : ", den.shape, "den : ", den)
    # den OKE

    den[den == 0] = np.finfo(float).eps
    # print("den shape : ", den.shape, "den : ", den)
    # den OKE

    S = 1 - 3 * num/den
    # tempND = num/den
    # print("tempND shape : ", tempND.shape, "tempND : ", tempND)
    # tempND OKE
    # print("S shape : ", S.shape, "S : ", S)
    # S OKE

    H[S == 0] = 0
    # print("H shape : ", H.shape, "H : ", H)
    # H OKE

    I = (r + g + b)/3
    # print("I shape : ", I.shape, "I : ", I)
    # I OKE

    hsi = np.dstack((H, S, I))
    # print("hsi shape: ", hsi.shape)
    # print("hsi: ", hsi)
    # HSI OKE

    return hsi