import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';

class GuidebookPage extends StatefulWidget {
  const GuidebookPage({Key? key}) : super(key: key);

  @override
  State<GuidebookPage> createState() => _GuidebookPageState();
}

class _GuidebookPageState extends State<GuidebookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorTheme(colorHighlight),
        foregroundColor: colorTheme(colorAccent),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "How to use this app?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorTheme(colorHighlight)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[],
            ),
          ),
        ),
      ),
    );
  }
}
