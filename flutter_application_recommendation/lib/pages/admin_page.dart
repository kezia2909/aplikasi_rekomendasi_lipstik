import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/services/data_seeder_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
                ElevatedButton(
                  onPressed: () {
                    // String testLink = "..............";
                    print("start");
                    // DataSeederService.createKategoriWarna();
                    DataSeederService.createListLipstik();
                    DataSeederService.createDataMapping();
                    print("end");
                    // setState(() {});
                  },
                  child: Text("seed data"),
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
