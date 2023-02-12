import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_application_recommendation/pages/login_page.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/wrapper.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

var mapping_lists = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("start run");
  runApp(const MyApp());

  print("done run");

  // DEMO - PERCOBAAN BERHASIL
  // var datas = {
  //   'id': 'sky',
  //   'skintone': 'fly',
  //   'undertone': 'ribbon',
  //   'warna': ['falcon', 'red', 'blue'],
  // };
  // var datas2 = {
  //   'id': 'sky2',
  //   'skintone': 'fly2',
  //   'undertone': 'ribbon2',
  //   'warna': ['falcon2', 'yellow', 'purple', 'green'],
  // };
  // var lists = [];
  // var tempWarna = [];
  // lists.add(datas);
  // lists.add(datas2);
  // print(lists);
  // var getData = lists.where(
  //   (element) {
  //     if (element['id'] == "sky") {
  //       return true;
  //     }
  //     return false;
  //   },
  // ).take(1);
  // tempWarna = getData.first['warna'];
  // print(tempWarna.toString());
  // print(tempWarna[0]);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var results = await firestore
      .collection("data_mapping")
      // .where("skintone", isEqualTo: "tan")
      // .where("warna", arrayContains: "dark mauve")
      .get();
  // print(results.docs);
  // print("testing");

  // var hasilmapping = results;

  // print(hasilmapping);
  if (results.docs.length > 0) {
    results.docs.forEach(
      (element) {
        var id = element.id;
        var data = element.data();
        print("id: $id");
        print("data: $data");
        Map<String, dynamic> hasil = Map<String, dynamic>();

        for (dynamic type in data.keys) {
          hasil[type.toString()] = data[type];
        }
        print(hasil['warna']);
        print(hasil['warna'][0]);

        var tempdata = {'id': id, 'warna': hasil['warna']};
        mapping_lists.add(tempdata);
      },
    );
  } else {
    print("NO DATA");
  }
  print("MAPPING");
  print(mapping_lists);

  // var tempMap = mapping_lists.where(
  //   (element) {
  //     print("masuk");
  //     print(element);
  //     print("element");
  //     print(element['id']);
  //     if (element['id'] == "tan_warm") {
  //       print("berhasil");
  //       return true;
  //     }
  //     print("gagal");
  //     return false;
  //   },
  // ).take(1);
  // print("dapat");
  // String testWarna = tempMap.first['warna'].toString();
  // print(testWarna);
  // List<String> productName= [];

  //   Stream<DocumentSnapshot<Map<String, dynamic>>> productRef = FirebaseFirestore.instance
  //       .collection("data_mapping")
  //       .doc("medium_netral")
  //       .snapshots();
  //   productRef.forEach((field) {
  //     field.data().ma().forEach((index, data) {
  //       productName.add(field.documents[index]["name"]);
  //     });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // session user
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const LoginPage(),
        home: const Wrapper(),
      ),
    );
  }
}
