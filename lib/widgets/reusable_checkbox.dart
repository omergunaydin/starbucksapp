import 'package:flutter/material.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import '../constants/dimens/uihelper.dart';

class ReusableCheckBox extends StatefulWidget {
  bool checkBoxState;
  String text;
  void Function(bool?)? onChanged;
  ReusableCheckBox({Key? key, required this.text, required this.checkBoxState, required this.onChanged}) : super(key: key);

  @override
  State<ReusableCheckBox> createState() => _ReusableCheckBoxState();
}

class _ReusableCheckBoxState extends State<ReusableCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiHelper.verticalSymmetricPadding2x,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: widget.checkBoxState,
              onChanged: widget.onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              checkColor: Colors.white,
              activeColor: UiColorHelper.mainGreen,
              focusColor: UiColorHelper.mainGreen,
            ),
          ),
          Expanded(
            child: Padding(
              padding: UiHelper.leftPadding2x,
              child: Text(
                widget.text,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
