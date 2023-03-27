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
var list_lipstik = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("start run");
  runApp(const MyApp());
  print("done run");

  // DATA MAPPING
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var results_data_mapping = await firestore.collection("data_mapping").get();
  var results_list_lipstik = await firestore.collection("list_lipstik").get();

  if (results_list_lipstik.docs.length > 0) {
    results_list_lipstik.docs.forEach(
      (element) {
        var data = element.data();
        Map<String, dynamic> hasil = Map<String, dynamic>();
        for (dynamic type in data.keys) {
          hasil[type.toString()] = data[type];
        }
        var id = element.id;
        var tempdata = {
          'id': id,
          'kategori': hasil['kategori'],
          'kode_warna': hasil['kode_warna'],
          'nama_lipstik': hasil['nama_lipstik']
        };
        list_lipstik.add(tempdata);
      },
    );
  }

  if (results_data_mapping.docs.length > 0) {
    results_data_mapping.docs.forEach(
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
        // results_list_lipstik = await firestore
        //     .collection("list_lipstik")
        //     .where("kategori", arrayContainsAny: hasil['warna'])
        //     .get();
        // print("RESULTS");
        // print(results_list_lipstik);
        var tempdata = {'id': id, 'warna': hasil['warna']};
        mapping_lists.add(tempdata);
      },
    );
  } else {
    print("NO DATA");
  }
  print("LIPSTIK");
  print(list_lipstik);
  print("MAPPING");
  print(mapping_lists);
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
