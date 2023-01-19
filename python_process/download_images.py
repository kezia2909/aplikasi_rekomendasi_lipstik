import requests

def downloadImage(imageURL, imageName):
    response = requests.get(imageURL)
    open("./python_process/oriImages/" + imageName + ".jpg", "wb").write(response.content)
