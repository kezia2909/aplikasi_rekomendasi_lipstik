import math
import numpy as np
import cv2
# skimage.util.img_as_ubyte

def hsi2rgb(H1, S1, I1) :
    # print("H1 shape: ", H1.shape)
    # print("H1 : ", H1)
    # H1 OKE

    # print("S1 shape: ", S1.shape)
    # print("S1 : ", S1)
    # S1 OKE

    # print("I1 shape: ", I1.shape)
    # print("I1 : ", I1)
    # I1 OKE

    H1=H1*360
    # print("H1 shape: ", H1.shape)
    # print("H1 : ", H1)                                  
    # H1 beberapa beda angka dibelakang koma yg ke 4, mungkin karena beda 16 bit dan 8 bit


    # %%%%Preallocate the R,G and B components  %%%%
    R1 = np.zeros(H1.shape)
    # print("R1 shape: ", R1.shape)
    # print("R1 : ", R1)  
    # R1 OKE

    G1 = np.zeros(H1.shape)
    # print("G1 shape: ", G1.shape)
    # print("G1 : ", G1)  
    # G1 OKE

    B1 = np.zeros(H1.shape)
    # print("B1 shape: ", B1.shape)
    # print("B1 : ", B1)  
    # B1 OKE

    RGB1 = np.zeros((H1.shape[0], H1.shape[1], 3))
    # print("RGB1 shape: ", RGB1.shape)
    # print("RGB1 : ", RGB1)  
    # RGB1 OKE

    # %%%%RG Sector(0<=H<120)  %%%%
    # When H is in the above sector, the RGB components equations are  
    # %Subtract 120 from Hue  

    B1[H1<120]=I1[H1<120]*(1-S1[H1<120])
    # print("B1 shape: ", B1.shape)
    # print("B1 : ", B1) 
    # B1 OKE

    R1[H1<120]=I1[H1<120]*(1+((S1[H1<120]*np.cos(H1[H1<120]*math.pi/180))/np.cos((60-H1[H1<120])*math.pi/180)))
    # print("R1 shape: ", R1.shape)
    # print("R1 : ", R1)  
    # R1 OKE

    G1[H1<120]=3*I1[H1<120]-(R1[H1<120]+B1[H1<120])
    # print("G1 shape: ", G1.shape)
    # print("G1 : ", G1)  
    # G1 OKE


    # %%%%%GB Sector(120<=H<240)  
    # %When H is in the above sector, the RGB components equations are  
    # %Subtract 120 from Hue
    
    H2=H1-120
    # print("H2 shape: ", H2.shape)
    # print("H2 : ", H2)    
    # H2 beberapa beda angka dibelakang koma yg ke 4, mungkin karena beda 16 bit dan 8 bit

    R1[(H1>=120)&(H1<240)]=I1[(H1>=120)&(H1<240)]*(1-S1[(H1>=120)&(H1<240)])
    # print("R1 shape: ", R1.shape)
    # print("R1 : ", R1) 
    # R1 OKE
    

    G1[(H1>=120)&(H1<240)]=I1[(H1>=120)&(H1<240)]*(1+((S1[(H1>=120)&(H1<240)]*np.cos(H2[(H1>=120)&(H1<240)]*math.pi/180))/np.cos((60-H2[(H1>=120)&(H1<240)])*math.pi/180)))
    # print("G1 shape: ", G1.shape)
    # print("G1 : ", G1) 
    # G1 OKE
    
    
    # B1 ============================
    B1[(H1>=120)&(H1<240)]=3*I1[(H1>=120)&(H1<240)]-(R1[(H1>=120)&(H1<240)]+G1[(H1>=120)&(H1<240)])
    # print("B1 shape: ", B1.shape)
    # print("B1 : ", B1) 
    # B1 OKE


    # %%%%BR Sector(240<=H<=360)  
    # %When H is in the above sector, the RGB components equations are  
    # %Subtract 240 from Hue 
    H2=H1-240
    # print("H2 shape: ", H2.shape)
    # print("H2 : ", H2) 
    # H2 beberapa beda angka dibelakang koma yg ke 4, mungkin karena beda 16 bit dan 8 bit

    G1[(H1>=240)&(H1<=360)]=I1[(H1>=240)&(H1<=360)]*(1-S1[(H1>=240)&(H1<=360)])
    # print("G1 shape: ", G1.shape)
    # print("G1 : ", G1) 
    # G1 OKE

    B1[(H1>=240)&(H1<=360)]=I1[(H1>=240)&(H1<=360)]*(1+((S1[(H1>=240)&(H1<=360)]*np.cos(H2[(H1>=240)&(H1<=360)]*math.pi/180))/np.cos((60-H2[(H1>=240)&(H1<=360)])*math.pi/180)))
    # print("B1 shape: ", B1.shape)
    # print("B1 : ", B1) 
    # B1 OKE

    R1[(H1>=240)&(H1<=360)]=3*I1[(H1>=240)&(H1<=360)]-(G1[(H1>=240)&(H1<=360)]+B1[(H1>=240)&(H1<=360)])
    # print("R1 shape: ", R1.shape)
    # print("R1 : ", R1) 
    # R1 OKE

    RGB1[:, :, 0] = R1
    RGB1[:, :, 1] = G1
    RGB1[:, :, 2] = B1
    # print("RGB1 shape : ", RGB1.shape)
    # print("RGB1 : ", RGB1)
    # RGB1 OKE

    # RGB1=im2uint8(RGB1);  
    # RGB1 = bytescale(RGB1.astype(float), cmin=-32768, cmax=32767)
    # RGB1 = np.float64(RGB1)
    # RGB1 = 255*RGB1
    # RGB1 = RGB1.astype(np.uint8)
    # RGB1= (RGB1).astype(np.uint8)
    # RGB1 = cv2.convertScaleAbs(RGB1, alpha=0.03)

    # high = 
    # scale = float(high - low) / cscale
    # bytedata = (data - cmin) * scale + low
    # return (bytedata.clip(low, high) + 0.5).astype(np.uint8)
    # RGB1 = bytescale(RGB1)
    RGB1 = cv2.normalize(RGB1, None, 0, 255, cv2.NORM_MINMAX, dtype=cv2.CV_8U)
    print("RGB1 shape : ", RGB1.shape)
    print("RGB1 : ", RGB1)
    # BEDAAAA

    return RGB1