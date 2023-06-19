import cv2
import numpy as np
import matplotlib.pyplot as plt
from rgb2hsi import rgb2hsi
from hsi2rgb import hsi2rgb
from global_variable import bool_resize

# %%%%% Section 2 : Conventional image enhancement method %%%%%
def im2double(im):
    info = np.iinfo(im.dtype) # Get the data type of the input image
    return im.astype(np.float32) / info.max 

def preProcessing(fileName):
    # % just load and plot an image for test
    print("MASUK PREPROCESSING")
    # oriImage = cv2.imread(str('./python_process/Images_Resize/'+fileName))
    if bool_resize : 
        oriImage = cv2.imread(str('./python_process/Images_Resize/'+fileName))
    else :
        oriImage = cv2.imread(str('./python_process/Images_Ori/'+fileName))
    
    image = oriImage
    # print("SIZE ORI : ", image.shape)

    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    # print('Original Dimensions: ',image.shape)
    # print('Original: ',image)
    # sample_img = cv2.normalize(image.astype('float'), None, 0.0, 1.0, cv2.NORM_MINMAX)
    # sample_img = (image - image.min()) / (image.max() - image.min())
    sample_img = im2double(image)
    # IM2DOUBLE OK




    # plt_sample_img= plt.figure("sample_img")
    # plt.imshow(sample_img)
    # plt_sample_img.show()

    # print('Original Dimensions: ',sample_img.shape)
    # print('Original: ',sample_img)

    # The magnitude of each and every color channel is confined within the range [0 , L-1]
    L = 256

    # %%%%% 3. Proposed work %%%%%

    redChannel = sample_img[:,:,0]
    greenChannel = sample_img[:,:,1]
    blueChannel = sample_img[:,:,2]
    # print("redchannel shape: ", redChannel.shape)
    # print('R : ',redChannel)
    # print("greenChannel shape: ", greenChannel.shape)
    # print('G : ',greenChannel)
    # print("blueChannel shape: ", blueChannel.shape)
    # print('B : ',blueChannel)
    # RGB CHANNEL OK

    # %%%%% 3.1 color channel stretching %%%%%
    max_red = redChannel.max()
    max_green = greenChannel.max()
    max_blue = blueChannel.max()
    # print('maxR : ',max_red)
    # print('maxG : ',max_green)
    # print('maxB : ',max_blue)
    # MAX RGB OKE

    min_red = redChannel.min()
    min_green = greenChannel.min()
    min_blue = blueChannel.min()
    # print('minR : ',min_red)
    # print('minG : ',min_green)
    # print('minB : ',min_blue)
    # MIN RGB OKE

    # bagian atas (R-min(R))
    rn = redChannel - min_red
    gn = greenChannel - min_green
    bn = blueChannel - min_blue
    # print('Rn shape : ',rn.shape , 'Rn : ',rn)
    # print('Gn shape : ',gn.shape , 'Gn : ',gn)
    # print('Bn shape : ',bn.shape , 'Bn : ',bn)
    # Rn Bn Gn OK

    max_rn = rn.max()
    max_gn = gn.max()
    max_bn = bn.max()
    # print('maxRn : ',max_rn)
    # print('maxGn : ',max_gn)
    # print('maxBn : ',max_bn)
    # maxRn maxBn maxGn OK
    # !!! paper : gak pake ini

    r_stretched = rn/max_rn
    g_stretched = gn/max_gn
    b_stretched = bn/max_bn

    # print('R stretched shape: ',r_stretched.shape, 'R stretched: ',r_stretched)
    # print('G stretched shape: ',g_stretched.shape, 'G stretched: ',g_stretched)
    # print('B stretched shape: ',b_stretched.shape, 'B stretched: ',b_stretched)
    # R stretched G stretched B stretched OK
    # !!! paper : harusnya dibagi dengan maxRed - minRed, bukan dibagi max Rn

    before_stretched = (blueChannel+greenChannel+redChannel)/3
    # print("before_stretched shape: ", before_stretched.shape, "before_stretched: ", before_stretched)
    # before stretched OK

    after_stretched = (b_stretched+r_stretched+g_stretched)/3
    # print("after_stretched shape: ", after_stretched.shape, "after_stretched: ", after_stretched)
    #  after stretched OK

    rgb_stretched_Image = np.dstack((r_stretched, g_stretched, b_stretched))
    # print("rgb_stretched_Image: ", rgb_stretched_Image)
    # print("rgb stretched shape: ", rgb_stretched_Image.shape)
    # RGB stretched Image OKE

    # plt_rgb_stretched_Image= plt.figure("rgb_stretched_Image")
    # plt.imshow(rgb_stretched_Image)
    # plt_rgb_stretched_Image.show()

    # %%%%% Convert RGB to HSI %%%%%
    hsi_image = rgb2hsi(rgb_stretched_Image)
    # print("hsi_image shape: ", hsi_image.shape)
    # print("hsi_image: ", hsi_image)
    # HSI IMAGE OKE

    intensity = hsi_image[:, :, 2]
    # print("intensity shape: ", intensity.shape)
    # print("intensity: ", intensity)
    # intensity OKE


    # %%%% 3.2. Contrast enhancement with maximum information preservation %%%%

    # BUAT BIN SESUAI CENTER MATLAB
    binLocations = np.linspace(0, 1, 256) 
    # print("binLocations shape: ", binLocations.shape)
    # print("binLocations: ", binLocations)
    # binLocations OKE
    # BUAT BIN EDGES KARENA PYTHON PAKE PINGGIRAN KALO MATLAB CENTER
    bin_edges = np.r_[-np.Inf, 0.5 * (binLocations[:-1] + binLocations[1:]), 
            np.Inf]
    counts, binEdges =  np.histogram(intensity, bin_edges)
    # print("counts shape: ", counts.shape)
    # print("counts: ", counts)
    # counts OKE

    hist = counts
    # print("hist shape : ", hist.shape)
    # print("hist : ", hist)
    # hist OKE

    Tc = hist.mean(axis=0)
    # print("Tc : ", Tc)
    # TC OKE

    length_hist = hist.shape[0]
    # print("length_hist: ", length_hist)
    # length_hist OKE

    clipped_hist = np.zeros(length_hist, float)
    # print("clipped_hist shape: ", clipped_hist.shape, "clipped_hist: ", clipped_hist)
    # clipped_hist OKE
    # OKE OKE

    for hist_id in range(length_hist):
        if hist[hist_id]>=Tc:
            clipped_hist[hist_id] = Tc
        else:
            clipped_hist[hist_id] = hist[hist_id]
    # print("clipped_hist shape: ", clipped_hist.shape)
    # print("clipped_hist: ", clipped_hist)
    # clipped_hist OKE

    P = clipped_hist / sum(clipped_hist)
    # 3.619648437500000e+04
    # print("sum : ", sum(clipped_hist))
    # sum() OKE
    # print("P shape: ", P.shape)
    # print("P: ", P)
    # !!! P BEDA di bagian akhir mulai dari index 251, beda koma nya, angkanya sama

    C = np.cumsum(P)
    # print("C shape: ", C.shape)
    # print("C: ", C)
    # C OKE

    Pmin = np.min(P, axis=0)
    Pmax = np.max(P, axis=0)
    # print("Pmin: ", Pmin)
    # print("Pmax: ", Pmax)
    # PMin PMax OKE

    Pw = Pmax * (((P-Pmin)/(Pmax-Pmin))**C)
    # print("Pw shape: ", Pw.shape)
    # print("Pw: ", Pw)
    # !!! PW BEDA di bagian akhir mulai dari index 252, beda koma nya, angkanya sama

    Cw = np.zeros(L, float)
    gamma = np.zeros(L, float)
    # print("Cw shape: ", Cw.shape)
    # print("Cw: ", Cw)
    # print("gamma shape: ", gamma.shape)
    # print("gamma: ", gamma)
    # CW, Gamma OKE, shape di matlab 256x1(ke samping)

    # %%%% (12) the weighted PDF sum is defined as follows: %%%%
    Sum_Pw = sum(Pw)
    # print("Sum_Pw: ", Sum_Pw)
    # Sum_Pw beda diakhir nya, matlab = 1.21619335845470(4), python = 1.21619335845470(76)

    Cw = np.cumsum(Pw)/Sum_Pw
    # print("Cw shape: ", Cw.shape)
    # print("CW: ", Cw)
    # CW OKE

    # %%%% (10) the gamma parameter with weighted CDF is computed as: %%%%
    gamma = 1 - Cw
    # print("gamma shape: ", gamma.shape)
    # print("gamma: ", gamma)
    # !!! GAMMA BEDA di bagian akhir mulai dari index 253, beda koma nya, angkanya sama
    # index 256 di matlab -0.000000000026645, python 0.00000000e+00
    # kayaknya karena python float 8, matlab float 16 -> mungkin python bisa diganti pake yg float 16

    Length = intensity.shape[0]
    Width = intensity.shape[1]
    # print("Length: ", Length)
    # print("Width: ", Width)
    # Length Width intensity OKE

    result = np.zeros((Length, Width), float)
    # print("result shape: ", result.shape)
    # print("result: ", result)
    # result OKE

    intensity_max = (intensity.flatten()).max()
    # print("intensity_max: ", intensity_max)
    # kayaknya sama aja kalo gak pake flatten, hasilnya sama, gtw lagi

    # %%%% (9) Transformed pixel intensity %%%%
    # tempuint8(matlab) = round(python), kalo>5 naik, kalo<5 turun
    # for index in range(L):
    #     result[intensity*255+1 == index+1] = (intensity/intensity_max)**gamma[index]

    print("START")
    for l in range(Length):
        for w in range(Width):
            index = int(np.round(intensity[l][w]*255))
            result[l][w] = (intensity[l][w]/intensity_max)**gamma[index]
        print(l)
    # print("result shape : ", result.shape)
    # print("result : ", result)
    # result OKE
    print("END")

    H1 = hsi_image[:, :, 0]
    # print("H1 shape: ", H1.shape)
    # print("H1 : ", H1)
    # H1 OKE

    S1 = hsi_image[:, :, 1]
    # print("S1 shape: ", S1.shape)
    # print("S1 : ", S1)
    # S1 OKE

    I1 = result
    # print("I1 shape: ", I1.shape)
    # print("I1 : ", I1)
    # I1 OKE

    result_rgb = hsi2rgb(H1, S1, I1)

    save_RGB = np.zeros((H1.shape[0], H1.shape[1], 3))

    save_RGB[:, :, 0] = result_rgb[:, :, 2]
    save_RGB[:, :, 1] = result_rgb[:, :, 1]
    save_RGB[:, :, 2] = result_rgb[:, :, 0]
    print("MASUK SAVE")

    cv2.imwrite('./python_process/Images_PreProcessing/'+fileName, save_RGB)
    print("END SAVEEEE")

    return 1
    # return save_RGB

    # binLocationsResult = np.linspace(0, 1, 256) 
    # bin_edgesResult = np.r_[-np.Inf, 0.5 * (binLocationsResult[:-1] + binLocationsResult[1:]), 
    #         np.Inf]
    # countsResult, binEdgesResult =  np.histogram(result_rgb, bin_edgesResult)


    # plt.imshow(result_rgb)
    # plt.show()

    # input()