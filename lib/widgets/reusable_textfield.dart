import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final int? maxLines;
  final bool? enabled;
  final TextInputAction? textInputAction;
  ReusableTextField({Key? key, required this.controller, this.hintText, this.inputFormatters, this.maxLines, this.enabled, this.textInputAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiHelper.verticalSymmetricPadding2x,
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatters,
        enabled: enabled ?? true,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: UiHelper.allPadding3x,
        ),
        maxLines: maxLines,
        style: enabled == null || enabled == true ? Theme.of(context).textTheme.subtitle2 : Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey[500]),
        cursorColor: UiColorHelper.mainGreen,
      ),
    );
  }
}
