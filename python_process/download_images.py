import requests

def downloadImage(imageURL, imageName):
    response = requests.get(imageURL)
    open("./python_process/Images_Ori/" + imageName + ".jpg", "wb").write(response.content)
    
    return 
