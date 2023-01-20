import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePageCopy extends StatefulWidget {
  final User firebaseUser;
  const HomePageCopy({Key? key, required this.firebaseUser}) : super(key: key);
  @override
  State<HomePageCopy> createState() => _HomePageCopyState();
}

class _HomePageCopyState extends State<HomePageCopy> {
  late User user = widget.firebaseUser;
  String imagePath = "";
  // "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new3d8ae0ca-5956-4675-ad57-cecf57b83b6d5784227203977822763.jpg?alt=media";

  late String uniqueCode;
  final uniqueCodeController = TextEditingController();
  late String pathNgrok;

  File? _selectedImage;

  List<int>? _selectedFile;
  Uint8List? _bytesData;

// coba stack over flow
  Uint8List? fileBytes;

  String? filePath;

  String? fileName;

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          _bytesData =
              Base64Decoder().convert(reader.result.toString().split(',').last);
          _selectedFile = _bytesData;
        });
      });
      reader.readAsDataUrl(file);
    });
  }

  Future uploadImage() async {
    var url =
        Uri.parse("https://9c9b-114-125-86-155.ap.ngrok.io/face_detection");
    var request = http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromBytes(
        'image', _selectedFile!,
        contentType: MediaType('image', 'jpg'), filename: "baru.jpg"));
    // Map<String, String> headers = {"Content-type": "multipart/form-data"};
    // Map<String, String> headers = {
    //   'Content-Type': "text/plain",
    //   'Accept': "*/*",
    //   'Content-Length': _selectedFile.toString(),
    //   'Connection': 'keep-alive',
    // };

    // request.headers.addAll(headers);

    request.send().then((response) {
      if (response.statusCode == 200) {
        print("file uploaded");
      } else {
        print("failed");
      }
    });
  }

  // Future<void> uploadImage(Uint8List binaryImage) async {
  //   Response response = await http.post(
  //     Uri.parse('<your url here> '),
  //     headers: {
  //       'Content-Type': "text/plain",
  //       'Accept': "*/*",
  //       'Content-Length': binaryImage.toString(),
  //       'Connection': 'keep-alive',
  //     },
  //     body: binaryImage,
  //   );
  //   }

  Future<void> imageFromCamera() async {
    final image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    if (image != null) {
      _selectedImage = File(image.path);
    }
    setState(() {});
  }

  Future<void> imageFromGallery() async {
    // final image =
    //     await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   _selectedImage = File(image.path);
    // }

    final image = await FilePicker.platform
        .pickFiles(type: FileType.image, allowCompression: true);

    if (image != null) {
      // _selectedImage = image.files.first.bytes as File?;
      if (kIsWeb) {
        fileBytes = image.files.first.bytes;
      } else {
        filePath = image.files.first.path;
      }
      fileName = image.files.single.name;
    }

    setState(() {});
  }

  Future<http.Response> getRecommendationWeb(String link) async {
    print("coord1");
    print("coord2");
    print(link);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(link),
    );
    print("coord3");
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    print("coord4");
    request.files.add(
      http.MultipartFile.fromBytes('image', fileBytes!,
          contentType: new MediaType("image", "jpg"), filename: fileName),
    );
    print("coord5");
    request.headers.addAll(headers);
    print("coord6");
    print("request: " + request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:" + response.body);
    print("This is response: ${res.statusCode} ");
    print("This is response: ${res.statusCode} ");
    return response;
  }

  Future<http.Response> getRecommendation(File file, String link) async {
    print("coord1");
    String filename = file.path.split('/').last;
    print("coord2");
    print(link);
    print(filename);
    print(file);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(link),
    );
    print("coord3");
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    print("coord4");
    // request.files.add(
    //   http.MultipartFile(
    //     'image',
    //     file.readAsBytes().asStream(),
    //     file.lengthSync(),
    //     // // _selectedFile!.any(file),
    //     // _selectedFile!.length,
    //     filename: filename,
    //   ),
    // );

    // request.files.add(await http.MultipartFile.fromBytes(
    //     'image', _selectedFile!,
    //     contentType: MediaType('image', 'jpg'), filename: "baru.jpg"));

    if (kIsWeb) {
      print("web");
      request.files.add(
        http.MultipartFile.fromBytes('image', fileBytes!,
            contentType: new MediaType("image", "jpg"), filename: fileName),
      );
      print("request done");
    } else {
      request.files.add(
        http.MultipartFile(
          'image',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: filename,
        ),
      );
    }

    print("coord5");
    request.headers.addAll(headers);
    print("coord6");
    print("request: " + request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:" + response.body);
    print("This is response: ${res.statusCode} ");
    print("This is response: ${res.statusCode} ");
    return response;
  }

  // Future<http.Response> getRecommendationWeb(File file, String link) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                Text(user.uid),
                Text(user.isAnonymous ? "ANONIM" : "USER"),
                const SizedBox(
                  height: 30,
                ),
                (imagePath != "")
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.green, width: 5),
                            image: DecorationImage(
                                image: NetworkImage(imagePath),
                                fit: BoxFit.cover)),
                      )
                    : (filePath == null)
                        ? reusablePhotoFrame(
                            Image.asset(
                              "assets/images/model.png",
                              fit: BoxFit.cover,
                            ),
                          )
                        : kIsWeb
                            ? reusablePhotoFrame(Image.file(
                                File(filePath!),
                                fit: BoxFit.cover,
                                // width: double.infinity,
                              ))
                            // ? reusablePhotoFrame(
                            //     Image.network(
                            //       _selectedImage!.path,
                            //       fit: BoxFit.cover,
                            //     ),
                            //   )
                            : reusablePhotoFrame(
                                Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Tentukan Foto"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        imageFromCamera();
                        setState(() {});
                      },
                      child: const Icon(Icons.photo_camera_outlined),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        imageFromGallery();
                        setState(() {});
                      },
                      child: const Icon(Icons.photo_library_outlined),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        startWebFilePicker();
                        setState(() {});
                      },
                      child: const Icon(Icons.new_label),
                    ),
                  ],
                ),
                _bytesData != null
                    ? Image.memory(
                        _bytesData!,
                        width: 200,
                        height: 200,
                      )
                    : Container(),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadImage();
                  },
                  child: const Icon(Icons.new_label),
                ),
                TextField(
                  controller: uniqueCodeController,
                ),
                ElevatedButton(
                  onPressed: () {
                    uniqueCode = uniqueCodeController.text;
                    pathNgrok =
                        "https://" + uniqueCode + ".ap.ngrok.io/face_detection";
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the that user has entered by using the
                          // TextEditingController.
                          content: Text(uniqueCode),
                        );
                      },
                    );
                  },
                  child: const Text("submit code"),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("aaaaaaaaaaaaaaaaaa");
                    final res = await getRecommendationWeb(pathNgrok);
                    // final res = await getRecommendation(
                    //     File(_selectedImage!.path), pathNgrok);
                    print("bbbbbbbbbbb");
                    debugPrint(res.body);
                    final val = jsonDecode(res.body);
                    imagePath = val['url'];
                    print(val['url']);
                    // List<List<int>> data = [];
                    // for (var items in val['faces']) {
                    //   List<int> s = [];
                    //   for (var item in items as List) {
                    //     s.add(int.parse("$item"));
                    //   }
                    //   data.add(s);
                    // }
                    // debugPrint("$data");
                    // facesCoordinates = data;

                    setState(() {});
                  },
                  child: const Text("Cari Rekomendasi"),
                ),
                ElevatedButton(
                    child: Text("LOG OUT"),
                    onPressed: () async {
                      await AuthServices.logOut();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<PickedFile?> chooseImage() async {
//   print("choosee");
//   PickedFile? pickedFile =
//       await ImagePicker.platform.pickImage(source: ImageSource.gallery);
//   print(pickedFile);
//   print("choose oke");
//   return pickedFile;
// }
