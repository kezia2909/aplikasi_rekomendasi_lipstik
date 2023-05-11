import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';

class GuidebookPage extends StatefulWidget {
  const GuidebookPage({Key? key}) : super(key: key);

  @override
  State<GuidebookPage> createState() => _GuidebookPageState();
}

class _GuidebookPageState extends State<GuidebookPage> {
  List listGuide = [0, 1];
  List listGuideTitle = ["Take a selfie", "Get recommendation"];
  List listGuideDescription = [
    "Make sure your photo match your real skin color",
    "try on the recommended colors based on your skintone and undertone",
  ];
  bool finish = false;

  late double sizeFrame;
  late double sizePadding;
  int tempIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      if (MediaQuery.of(context).size.width * 0.1 >= 40) {
        print("aaaaaa${MediaQuery.of(context).size.width}");
        sizePadding = 40;
        // sizePadding = MediaQuery.of(context).size.width * 0.1;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.width}");
        sizePadding = MediaQuery.of(context).size.width * 0.1;
      }
      sizeFrame = (MediaQuery.of(context).size.width - sizePadding * 2);
    } else {
      if (MediaQuery.of(context).size.height >= 700) {
        print("aaaaaa${MediaQuery.of(context).size.height}");
        sizeFrame = 350;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.height}");
        sizeFrame = MediaQuery.of(context).size.height * 0.5;
      }
      sizePadding = (MediaQuery.of(context).size.width - sizeFrame) / 2;
    }
    return Scaffold(
      // extendBodyBehindAppBar: true,
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
            padding: EdgeInsets.fromLTRB(sizePadding, 10, sizePadding, 0),
            child: Column(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 2 / 3,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) async {
                      setState(() {
                        tempIndex = index;

                        if (index == 1) {
                          finish = true;
                        }
                      });
                    },
                  ),
                  items: listGuide.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            guideTitleWidget(listGuideTitle[item]),
                            const SizedBox(height: 20),
                            (item == 0)
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/images/good.jpg",
                                                  fit: BoxFit.fitWidth,
                                                  width: sizeFrame / 2 - 10,
                                                ),
                                                Text("YES",
                                                    style: TextStyle(
                                                        color: colorTheme(
                                                            colorGreen),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                                Divider(
                                                  color: colorTheme(colorBlack),
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                guideDescriptionWidget(
                                                    "Sufficient light"),
                                                guideDescriptionWidget(
                                                    "No filter / flash"),
                                                guideDescriptionWidget(
                                                    "No makeup"),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/images/bad.jpg",
                                                  fit: BoxFit.fitWidth,
                                                  width: sizeFrame / 2 - 10,
                                                ),
                                                Text("NO",
                                                    style: TextStyle(
                                                        color: colorTheme(
                                                            colorRed),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                                Divider(
                                                  color: colorTheme(colorBlack),
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                guideDescriptionWidget(
                                                    "Shadows"),
                                                guideDescriptionWidget(
                                                    "Uneven light"),
                                                guideDescriptionWidget(""),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : (item == 1)
                                    ? Image.asset(
                                        "assets/images/try_on.jpg",
                                        fit: BoxFit.fitWidth,
                                        width: sizeFrame / 1.75,
                                      )
                                    : Container(),
                            const SizedBox(height: 30),

                            // guideImageWidget(listGuideIcon[int.parse(item)]),
                            // const SizedBox(height: 20),
                            // guideTitleWidget(listGuideTitle[int.parse(item)]),
                            // const SizedBox(height: 20),
                            guideDescriptionWidget(listGuideDescription[item]),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: listGuide.map((item) {
                    int index = listGuide.indexOf(item);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tempIndex == index
                            ? colorTheme(colorAccent)
                            : colorTheme(colorMidtone),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
