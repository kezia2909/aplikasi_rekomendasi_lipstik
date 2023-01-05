import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_application_recommendation/services/painter_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/login_page.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';

class HomePage extends StatefulWidget {
  final User firebaseUser;
  // const HomePage(User firebaseUser, {Key? key}) : super(key: key);
  const HomePage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = widget.firebaseUser;

// Selected Image storing in a Variable
  File? _selectedImage;
  // Faces Coordinates List wrt x, y, w, h
  List<List<int>> facesCoordinates = <List<int>>[];
  // Boolean value whether the face is detected or not
  bool get isFaceDetected => facesCoordinates.isEmpty ? false : true;

  late String uniqueCode;
  final uniqueCodeController = TextEditingController();
  late String pathNgrok;

  Future<http.Response> getFaceCoordinate(File file, String link) async {
    ///MultiPart request
    String filename = file.path.split('/').last;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(link),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:" + response.body);
    print("This is response: ${res.statusCode} ");
    print("This is response: ${res.statusCode} ");
    return response;
  }

  Future<void> _addImage() async {
    facesCoordinates.clear();
    final image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
    }
    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    uniqueCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(colors: [
        //     hexStringToColor("CB2B93"),
        //     hexStringToColor("9546C4"),
        //     hexStringToColor("5E61F4"),
        //   ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        // ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: [
                Text(user.uid),
                Text(user.isAnonymous ? "ANONIM" : "USER"),
                // Center(
                //   child: ElevatedButton(
                //       child: Text("Logout"),
                //       onPressed: () {
                //         FirebaseAuth.instance.signOut().then(
                //           (value) {
                //             print("logout");
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => LoginPage()),
                //             );
                //           },
                //         );
                //       }),
                // ),
                ElevatedButton(
                    child: Text("LOG OUT"),
                    onPressed: () async {
                      await AuthServices.logOut();
                    }),
                const Text("aaa"),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: uniqueCodeController,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uniqueCode = uniqueCodeController.text;
                        pathNgrok = "https://" +
                            uniqueCode +
                            ".ap.ngrok.io/face_detection";
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
                      child: Text("submit"),
                    ),
                  ],
                ),
                if (_selectedImage == null)
                  const Text(
                    'Please Select a Image',
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.file(File(_selectedImage!.path))),
                      ElevatedButton(
                        onPressed: () async {
                          final res = await getFaceCoordinate(
                              File(_selectedImage!.path), pathNgrok);
                          debugPrint(res.body);
                          final val = jsonDecode(res.body);
                          List<List<int>> data = [];
                          for (var items in val['faces']) {
                            List<int> s = [];
                            for (var item in items as List) {
                              s.add(int.parse("$item"));
                            }
                            data.add(s);
                          }
                          debugPrint("$data");
                          facesCoordinates = data;

                          setState(() {});
                        },
                        child: const Text("aaaa"),
                      ),
                      isFaceDetected
                          ? FutureBuilder<ui.Image>(
                              future: decodeImageFromList(
                                  File(_selectedImage!.path).readAsBytesSync()),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                return SizedBox(
                                  width: snapshot.data!.width.toDouble(),
                                  height: snapshot.data!.height.toDouble(),
                                  child: CustomPaint(
                                    painter: FacePainter(
                                      snapshot.data!,
                                      facesCoordinates,
                                    ),
                                  ),
                                );
                              })
                          : const Text(
                              "No Face Detected or click Detect Face Button"),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addImage,
        tooltip: 'Image',
        child: const Icon(Icons.add),
      ),
    );
  }
}
