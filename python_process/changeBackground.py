# Requires "requests" to be installed (see python-requests.org)
import requests

def changeBackground(fileName) :
    response = requests.post(
        'https://api.remove.bg/v1.0/removebg',
        files={'image_file': open("./python_process/Images_New/"+fileName, 'rb')},
        data={'size': 'auto', 'bg_color': '0000ff'},
        headers={'X-Api-Key': 'eKFWHtLiKXcf16x264GppeSh'},
    )
    if response.status_code == requests.codes.ok:
        with open("./python_process/Images_NoBackground/"+fileName, 'wb') as out:
            out.write(response.content)
            return True
    else:
        print("Error:", response.status_code, response.text)
        return False