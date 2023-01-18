import base64

from upload_images import uploadToFirebase
  
  
# with open("aaa.jpg", "rb") as image2string:
#     converted_string = base64.b64encode(image2string.read())
# print(converted_string)
  
# with open('encode.bin', "wb") as file:
#     file.write(converted_string)


# file = open('news3', 'rb')
# byte = file.read()
# file.close()
  
# decodeit = open('news3.jpeg', 'wb')
# decodeit.write(base64.b64decode((byte)))
# decodeit.close()

# uploadToFirebase("encode.bin", "encodess")
uploadToFirebase("news3.jpeg", "news333")
