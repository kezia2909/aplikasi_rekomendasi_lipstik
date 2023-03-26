import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/pages/admin_page.dart';
import 'package:flutter_application_recommendation/pages/guidebook_page.dart';
import 'package:flutter_application_recommendation/pages/history_page.dart';
import 'package:flutter_application_recommendation/pages/home_page.dart';
// import 'package:flutter_application_recommendation/pages/home_page_copy.dart';
// import 'package:flutter_application_recommendation/pages/home_page_try.dart';
import 'package:flutter_application_recommendation/pages/login_page.dart';
import 'package:flutter_application_recommendation/pages/profile_page.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatefulWidget {
  final User firebaseUser;

  const BottomNavbar({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late User user = widget.firebaseUser;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userScreens = [
      HomePage(
          firebaseUser: user,
          ref: (int number) {
            setState(() {
              currentIndex = number;
            });
          }),
      HistoryPage(firebaseUser: user),
      const GuidebookPage(),
      ProfilePage(firebaseUser: user),
    ];
    final anonymScreens = [
      HomePage(
          firebaseUser: user,
          ref: (int number) {
            setState(() {
              currentIndex = number;
            });
          }),
      const GuidebookPage(),
    ];

    return (user.isAnonymous)
        ? Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: anonymScreens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'guidebook',
                ),
              ],
              unselectedItemColor: colorTheme(colorShadow),
              selectedItemColor: colorTheme(colorAccent),
              backgroundColor: colorTheme(colorHighlight),
            ),
          )
        : Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: userScreens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'history',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'guidebook',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'profile',
                ),
              ],
              unselectedItemColor: colorTheme(colorShadow),
              selectedItemColor: colorTheme(colorAccent),
              // backgroundColor: Colors.transparent,
              // fixedColor: Colors.transparent,
              elevation: 0,
            ),
          );
  }
}
