import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final User firebaseUser;
  const HomePage({Key? key, required this.firebaseUser}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = widget.firebaseUser;
  String imageURL = "";
  String imagePath = "";
  // "https://firebasestorage.googleapis.com/v0/b/skripsi-c47d7.appspot.com/o/new3d8ae0ca-5956-4675-ad57-cecf57b83b6d5784227203977822763.jpg?alt=media";

  late String uniqueCode;
  final uniqueCodeController = TextEditingController();
  late String pathNgrok;

  File? _selectedImage;
  PickedFile? picked;

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
    picked = await chooseImage();
    _selectedImage = File(picked!.path);

    setState(() {});
  }

  Future<http.Response> getRecommendation(
      String linkNGROK, String oriURL, String oriName) async {
    // print("fungsi rekom");
    // print(oriURL);
    // print(linkNGROK);
    // http.Response response = await http.post(Uri.parse(linkNGROK),
    //     body: json.encode({'oriURL': oriURL}));
    // print("return response");
    // print(response);
    Map data = {'oriURL': oriURL, 'oriName': oriName};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(linkNGROK),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<http.Response> getRecommendationOld(File file, String link) async {
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
    request.files.add(
      http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        // // _selectedFile!.any(file),
        // _selectedFile!.length,
        filename: filename,
      ),
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
                (_selectedImage == null)
                    ? (imagePath != "")
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: Colors.green, width: 5),
                                image: DecorationImage(
                                    image: NetworkImage(imagePath),
                                    fit: BoxFit.cover)),
                          )
                        : reusablePhotoFrame(
                            Image.asset(
                              "assets/images/model.png",
                              fit: BoxFit.cover,
                            ),
                          )
                    : kIsWeb
                        ? reusablePhotoFrame(
                            Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                            ),
                          )
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
                      onPressed: () async {
                        imageFromGallery();

                        // PickedFile? picked = await chooseImage();
                        // imagePath = await DatabaseService.uploadImage(picked!);
                        setState(() {});
                      },
                      child: const Icon(Icons.photo_library_outlined),
                    ),
                  ],
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
                    print("button start");
                    imageURL = await DatabaseService.uploadImage(picked!);
                    print("upload");
                    DatabaseService.createOrUpdateListImagesOri(user.uid,
                        imageURL: imageURL);
                    print("aaaaaaaaaa");
                    final res = await getRecommendation(pathNgrok, imageURL,
                        _selectedImage!.path.split('/').last);
                    print("responseeee");
                    final val = jsonDecode(res.body);
                    imagePath = val['urlNew'];
                    print(res.toString());
                    print(imagePath);
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

Future<PickedFile?> chooseImage() async {
  print("choosee");
  PickedFile? pickedFile =
      await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  print(pickedFile);
  print("choose oke");
  return pickedFile;
}
