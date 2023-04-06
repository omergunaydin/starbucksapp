import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/dimens/uihelper.dart';

class ReusableTopBar extends StatelessWidget {
  String text;
  IconData iconData;
  ReusableTopBar({Key? key, required this.text, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: height * 0.08,
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/splash_bg.png'), fit: BoxFit.cover)),
      child: Padding(
        padding: UiHelper.allPadding3x,
        child: Row(
          children: [
            Icon(iconData, size: 30),
            const SizedBox(width: 10),
            Text(text, style: textTheme.headline6),
            const Divider(height: 1, thickness: 2, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
