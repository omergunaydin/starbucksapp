import 'package:flutter/material.dart';
import '../constants/dimens/uihelper.dart';

class ReusableWelcomePage extends StatelessWidget {
  const ReusableWelcomePage({Key? key, required this.imagePath, required this.title, required this.subTitle}) : super(key: key);
  final String imagePath;
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: UiHelper.allPadding8x,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: UiHelper.borderRadiusCircular6x,
              child: SizedBox(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: textTheme.headline4!.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            textAlign: TextAlign.center,
            textScaleFactor: 0.8,
          ),
          Text(
            subTitle,
            style: textTheme.subtitle1,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
