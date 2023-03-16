import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';

class GuidebookPage extends StatefulWidget {
  const GuidebookPage({Key? key}) : super(key: key);

  @override
  State<GuidebookPage> createState() => _GuidebookPageState();
}

class _GuidebookPageState extends State<GuidebookPage> {
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
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text("How to use this app?"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
