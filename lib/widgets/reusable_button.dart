import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';

class ReusableButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? color;
  final double? widthPercent;
  final Icon? icon;
  const ReusableButton({Key? key, required this.text, required this.onPressed, this.color, this.widthPercent, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: UiHelper.verticalSymmetricPadding1x,
      child: SizedBox(
        height: height / 100 * 7,
        width: widthPercent != null ? width * widthPercent! : width,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.black,
            shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular1x),
          ),
          icon: icon ?? const SizedBox.shrink(),
          label: Text(
            text,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
