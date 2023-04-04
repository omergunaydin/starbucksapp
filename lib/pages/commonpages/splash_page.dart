import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/main_wrapper.dart';
import 'package:starbucksapp/pages/commonpages/welcome_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    navigateToPages();
  }

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    return isFirstTime;
  }

  void _setFirstTimeFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  navigateToPages() async {
    bool isFirst = await isFirstTime();
    Future.delayed(const Duration(seconds: 2), () {
      //if first time navigate to Welcome Page, else navigate to Home Page
      if (isFirst) {
        _setFirstTimeFalse();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/WelcomePage"),
            builder: (context) => WelcomePage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/MainWrapper"),
            builder: (context) => MainWrapper(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: UiColorHelper.logoColor,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: width * 0.20,
              height: width * 0.20,
              child: Image.asset(
                'assets/images/starbucks_logo_white.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              child: Image.asset('assets/images/splash_bg.png'),
            ),
          ),
        ],
      ),
    );
  }
}
