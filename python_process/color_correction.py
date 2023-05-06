import numpy as np
import matplotlib.pyplot as plt
from skimage.io import imread, imshow
from skimage import img_as_ubyte
from matplotlib.patches import Rectangle
import cv2
from global_variable import bool_resize
from global_variable import percentile_value
from global_variable import folderName

def percentile_whitebalance(fileName):
    if bool_resize : 
        oriImage = cv2.imread(str('./python_process/Images_Resize/'+fileName))
    else :
        oriImage = cv2.imread(str('./python_process/Images_Ori/'+folderName+fileName))

    image_rgb = cv2.cvtColor(oriImage, cv2.COLOR_BGR2RGB)


    # fig, ax = plt.subplots(1,3, figsize=(12,6))
    for channel, color in enumerate('rgb'):
        channel_values = image_rgb[:,:,channel]
        value = np.percentile(channel_values, percentile_value)
        # ax[0].step(np.arange(256), 
        #         np.bincount(channel_values.flatten(), 
        #         minlength=256)*1.0 / channel_values.size, 
        #         c=color)
        # ax[0].set_xlim(0, 255)
        # ax[0].axvline(value, ls='--', c=color)
        # ax[0].text(value-70, .01+.012*channel, 
        #         "{}_max_value = {}".format(color, value), 
        #             weight='bold', fontsize=10)
        # ax[0].set_xlabel('channel value')
        # ax[0].set_ylabel('fraction of pixels')
        # ax[0].set_title('Histogram of colors in RGB channels')    
        whitebalanced = img_as_ubyte(
                (image_rgb*1.0 / np.percentile(image_rgb, 
                percentile_value, axis=(0, 1))).clip(0, 1))
        # ax[1].imshow(whitebalanced)
        # ax[1].set_title('Whitebalanced Image_rgb')
        # ax[2].imshow(image_rgb)
        # ax[2].set_title('Original Image_rgb')

        result = cv2.cvtColor(whitebalanced, cv2.COLOR_RGB2BGR)

        cv2.imwrite('./python_process/Images_PreProcessing/pre_color_corection_'+fileName, result)
    
    # fig.show()

    return 1

def whitepatch_balancing(fileName):
    if bool_resize : 
        oriImage = cv2.imread(str('./python_process/Images_Resize/'+fileName))
    else :
        oriImage = cv2.imread(str('./python_process/Images_Ori/'+folderName+fileName))

    image_rgb = cv2.cvtColor(oriImage, cv2.COLOR_BGR2RGB)

    row_width = int(0.1 * image_rgb.shape[1])
    column_width = row_width
    from_row = int(image_rgb.shape[0] * 3/100)
    from_column = int(image_rgb.shape[1] / 2) - int(row_width/2)

    # row_width = 10
    # column_width = 10
    # from_row = 230
    # from_column = 30
    

    print("shape : ", image_rgb.shape)

    fig, ax = plt.subplots(1,2, figsize=(10,5))
    ax[0].imshow(image_rgb)
    ax[0].add_patch(Rectangle((from_column, from_row), 
                            column_width, 
                            row_width, 
                            linewidth=3,
                            edgecolor='r', facecolor='none'))
    ax[0].set_title('Original image')
    image_patch = image_rgb[from_row:from_row+row_width, 
                        from_column:from_column+column_width]
    image_max = (image_rgb*1.0 / 
                image_patch.max(axis=(0, 1))).clip(0, 1)
    ax[1].imshow(image_max)
    ax[1].set_title('Whitebalanced Image')

    whitebalanced = img_as_ubyte(image_max)

    result = cv2.cvtColor(whitebalanced, cv2.COLOR_RGB2BGR)
    cv2.imwrite('./python_process/Images_PreProcessing/pre_white_corection_'+fileName, result)
    # fig.show()
    fig.savefig('./python_process/Images_PreProcessing/compare_'+fileName)
    # input()
    return 1

