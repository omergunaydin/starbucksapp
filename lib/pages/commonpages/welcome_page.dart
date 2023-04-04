import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starbucksapp/main_wrapper.dart';
import 'package:starbucksapp/widgets/reusable_button.dart';
import 'package:starbucksapp/widgets/reusable_welcome_page.dart';

import '../../constants/values/colors.dart';
import '../../constants/values/constants.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: UiColorHelper.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: height / 10 * 7,
            child: PageView(
              controller: _controller,
              children: [
                ReusableWelcomePage(
                  imagePath: Constants.welcomePageImagePath1,
                  title: Constants.welcomePageTitle1,
                  subTitle: Constants.welcomePageSubTitle1,
                ),
                ReusableWelcomePage(
                  imagePath: Constants.welcomePageImagePath2,
                  title: Constants.welcomePageTitle2,
                  subTitle: Constants.welcomePageSubTitle2,
                ),
                ReusableWelcomePage(
                  imagePath: Constants.welcomePageImagePath3,
                  title: Constants.welcomePageTitle3,
                  subTitle: Constants.welcomePageSubTitle3,
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: WormEffect(
                activeDotColor: UiColorHelper.buttonColor,
                dotColor: Colors.grey.shade300,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 16,
              )),
          ReusableButton(
              text: 'Get Started',
              widthPercent: 0.70,
              color: UiColorHelper.buttonColor,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "/MainWrapper"),
                    builder: (context) => MainWrapper(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
