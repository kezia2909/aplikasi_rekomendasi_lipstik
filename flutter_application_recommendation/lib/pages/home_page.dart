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
  String imageOriURL = "";
  String imageRecomendationURL = "";

  String pathNgrok = "https://120b-140-213-42-45.ap.ngrok.io/face_detection";
  // String pathNgrok = "https://kezia24.pythonanywhere.com/face_detection";

  File? _selectedImage;
  PickedFile? pickedImage;
  bool recommendationStatus = false;
  bool isRecommendationLoading = false;

  Future<void> imageFromCamera() async {
    pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      recommendationStatus = false;
      _selectedImage = File(pickedImage!.path);
    }
    setState(() {});
  }

  Future<void> imageFromGallery() async {
    pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      recommendationStatus = false;
      _selectedImage = File(pickedImage!.path);
    }

    setState(() {});
  }

  Future<http.Response> getRecommendation(String oriURL, String oriName) async {
    print("start function");
    print(pathNgrok);
    Map data = {'oriURL': oriURL, 'oriName': oriName};
    print("map data");
    var body = json.encode(data);
    print("encode data");
    var response = await http.post(Uri.parse(pathNgrok),
        headers: {
          "Content-Type": "application/json",
          // "Access-Control-Allow-Origin": "*",
          // 'Accept': '*/*'
        },
        body: body);
    print("response done");
    print(response);
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
            child: Column(children: <Widget>[
              Text(user.uid),
              Text(user.isAnonymous ? "ANONIM" : "USER"),
              const SizedBox(
                height: 30,
              ),
              (isRecommendationLoading)
                  ? Center(child: CircularProgressIndicator())
                  : (_selectedImage == null || recommendationStatus)
                      ? (imageRecomendationURL != "")
                          ? Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: Colors.green, width: 5),
                                image: DecorationImage(
                                    image: NetworkImage(imageRecomendationURL),
                                    fit: BoxFit.cover),
                              ),
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
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          imageFromCamera();
                          setState(() {});
                        },
                        child: const Icon(Icons.photo_camera_outlined),
                      ),
                      Text("Kamera")
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          imageFromGallery();
                          setState(() {});
                        },
                        child: const Icon(Icons.photo_camera_outlined),
                      ),
                      Text("Galeri")
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  print("button start");
                  setState(() {
                    isRecommendationLoading = true;
                  });
                  imageOriURL = await DatabaseService.uploadImage(pickedImage!);
                  print("upload");
                  DatabaseService.createOrUpdateListImagesOri(user.uid,
                      imageURL: imageOriURL);
                  print("aaaaaaaaaa");
                  final res = await getRecommendation(
                      imageOriURL, _selectedImage!.path.split('/').last);
                  print("responseeee");
                  // final val = jsonDecode(res.body);
                  // print(val['urlNew'].toString());
                  final val = jsonDecode(res.body);
                  print("vallll");
                  print(val);

                  if (val['faceDetected']) {
                    if (val['urlNew'] != "") {
                      print("masukk");
                      recommendationStatus = true;
                      imageRecomendationURL = val['urlNew'];
                      // print("list color :");
                      // print(val["listColor"]);
                      // print(val["totalColor"]);
                    }
                  } else {
                    print("no face detected");
                  }

                  print(res.toString());
                  print(imageRecomendationURL);
                  setState(() {
                    isRecommendationLoading = false;
                  });
                },
                child: const Text("Cari Rekomendasi"),
              ),
              ElevatedButton(
                  child: Text("LOG OUT"),
                  onPressed: () async {
                    await AuthServices.logOut();
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
