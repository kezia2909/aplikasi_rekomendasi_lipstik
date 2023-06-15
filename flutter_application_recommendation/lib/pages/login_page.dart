import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/main.dart';
import 'package:flutter_application_recommendation/pages/registration_page.dart';
import 'package:flutter_application_recommendation/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_recommendation/services/auth_service.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:is_first_run/is_first_run.dart';

// bool firstRun = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  var snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
  );

  // GUIDE
  List listGuide = [0, 1];
  List listGuideTitle = ["Take a selfie", "Get recommendation"];
  List listGuideDescription = [
    "Make sure your photo match your real skin color",
    "try on the recommended colors based on your skintone and undertone",
  ];
  bool finish = false;

  late double sizeFrame;
  late double sizePadding;
  late double sizePaddingTop;
  late double sizePaddingSpesial;
  int tempIndex = 0;

  @override
  void setState(VoidCallback fn) async {
    // TODO: implement setState
    // firstRun = await IsFirstRun.isFirstCall();
    print("LOGINN FIRSTRUN");
    print(firstRun);
    super.setState(fn);
  }

// START WIDGET
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
      sizePaddingSpesial = sizePadding;
      sizePaddingTop = sizePadding;
    } else {
      if (MediaQuery.of(context).size.height >= 700) {
        print("aaaaaa${MediaQuery.of(context).size.height}");
        sizeFrame = 350;
      } else {
        print("bbbbbbbbbbb${MediaQuery.of(context).size.height}");
        sizeFrame = MediaQuery.of(context).size.height * 0.5;
      }
      sizePaddingSpesial = (MediaQuery.of(context).size.width - sizeFrame) / 2;
      sizePadding = MediaQuery.of(context).size.width * 0.25;
      sizePaddingTop = MediaQuery.of(context).size.height * 0.1;
    }
    return firstRun
        ? Scaffold(
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
                  padding: EdgeInsets.fromLTRB(
                      sizePaddingSpesial, 10, sizePaddingSpesial, 0),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/good.jpg",
                                                        fit: BoxFit.fitWidth,
                                                        width:
                                                            sizeFrame / 2 - 10,
                                                      ),
                                                      Text("YES",
                                                          style: TextStyle(
                                                              color: colorTheme(
                                                                  colorGreen),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center),
                                                      Divider(
                                                        color: colorTheme(
                                                            colorBlack),
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
                                                        width:
                                                            sizeFrame / 2 - 10,
                                                      ),
                                                      Text("NO",
                                                          style: TextStyle(
                                                              color: colorTheme(
                                                                  colorRed),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center),
                                                      Divider(
                                                        color: colorTheme(
                                                            colorBlack),
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      guideDescriptionWidget(
                                                          "Shadows"),
                                                      guideDescriptionWidget(
                                                          "Uneven light"),
                                                      guideDescriptionWidget(
                                                          ""),
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
                                  guideDescriptionWidget(
                                      listGuideDescription[item]),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tempIndex == index
                                  ? colorTheme(colorAccent)
                                  : colorTheme(colorMidtone),
                            ),
                          );
                        }).toList(),
                      ),
                      (finish)
                          ? reusableButtonLog(
                              context,
                              "Let's Get Started",
                              colorTheme(colorAccent),
                              colorTheme(colorWhite), () async {
                              firstRun = false;
                              firstRun = await IsFirstRun.isFirstCall();
                              print("FIRST RUN");
                              print(firstRun);

                              // main();
                              setState(() {});

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => LoginPage()));
                            })
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            // resizeToAvoidBottomInset: false,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  colorTheme(colorShadow),
                  colorTheme(colorMidtone),
                  colorTheme(colorHighlight),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    sizePadding, sizePaddingTop, sizePadding, 0),

                // padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                // padding: EdgeInsets.fromLTRB(
                //     20, MediaQuery.of(context).size.height * 0.05, 20, 0),
                child: Column(
                  children: [
                    logoWidget("assets/images/logo.png"),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            children: <Widget>[
                              reusableTextFieldLog(
                                  "Enter Email",
                                  Icons.person_outline,
                                  false,
                                  _emailTextController),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableTextFieldLog(
                                  "Enter Password",
                                  Icons.lock_outline,
                                  true,
                                  _passwordTextController),
                              const SizedBox(
                                height: 20,
                              ),
                              reusableButtonLog(
                                  context,
                                  "SIGN IN",
                                  colorTheme(colorDark),
                                  // hexStringToColor("5a802a"),
                                  colorTheme(colorHighlight), () async {
                                print("TRYYYY");
                                var error = await AuthServices.logInEmail(
                                    _emailTextController.text,
                                    _passwordTextController.text);
                                var message = "Error Sign In";
                                print("END TRYYY");
                                print(error);
                                // if (error.toString() ==
                                //     "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                                //   message = "password wrong";
                                // }
                                switch (error.toString()) {
                                  case "[firebase_auth/unknown] Given String is empty or null":
                                    message = "Please input email & password";
                                    break;
                                  case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
                                    message = "Email is not registered";
                                    break;
                                  case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                    message = "Email is not valid";
                                    break;
                                  case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
                                    message = "Wrong password";
                                    break;
                                }

                                if (error.runtimeType.toString() != "User") {
                                  print("BUKANNN USERRR");
                                  print(error.runtimeType.toString());
                                  print("AAAAAAaa");
                                  snackBar = SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: colorTheme(colorWhite),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(message),
                                      ],
                                    ),
                                    backgroundColor: colorTheme(colorRed),
                                  );
                                } else {
                                  print("BETULLLL USERRR");
                                  print(error.runtimeType.toString());
                                  print("AAAAAAaa");
                                  message = "Signed in successfully";
                                  snackBar = SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: colorTheme(colorWhite),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(message),
                                      ],
                                    ),
                                    backgroundColor: colorTheme(colorShadow),
                                  );
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              // reusableButtonLog(
                              //     context,
                              //     "SKIP",
                              //     hexStringToColor("db9196"),
                              //     hexStringToColor("f9e8e6"), () async {
                              //   await AuthServices.logInAnonymous();
                              // }),
                              // Text("OR"),
                              // Text("Don't have an account?"),

                              // reusableLogOption(
                              //   context,
                              //   "Don't have an account?",
                              //   "SIGN UP",
                              //   () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => RegistrationPage()));
                              //   },
                              // ),
                              // USING BUTTON
                              // const SizedBox(
                              //   height: 30,
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Text(
                              //     "Don't have an account?",
                              //     style: TextStyle(
                              //       color: Colors.white.withOpacity(1.0),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // reusableButtonLog(
                              //     context,
                              //     "SIGN UP",
                              //     hexStringToColor("db9196"),
                              //     hexStringToColor("1b1c1e"), () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => RegistrationPage()));
                              // }),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // reusableButtonLog(
                              //     context,
                              //     "SKIP",
                              //     hexStringToColor("db9196"),
                              //     hexStringToColor("1b1c1e"), () async {
                              //   await AuthServices.logInAnonymous();
                              // }),
                              // USING TEXT
                              const SizedBox(
                                height: 20,
                              ),
                              reusableLogOption(
                                context,
                                "Don't have an account?",
                                "Sign Up",
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegistrationPage()));
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "or",
                                style: TextStyle(
                                  color: colorTheme(colorBlack),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              reusableLogOption(
                                context,
                                "Sign In",
                                "Anonymously",
                                () async {
                                  await AuthServices.logInAnonymous();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
