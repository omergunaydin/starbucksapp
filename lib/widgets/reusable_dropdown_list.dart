import 'package:flutter/material.dart';
import 'package:starbucksapp/constants/dimens/uihelper.dart';

import '../constants/values/colors.dart';

class ReusableDropDownList extends StatefulWidget {
  String selectedValue;
  List<String> optionsList;
  void Function(String?)? onChanged;
  ReusableDropDownList({Key? key, required this.selectedValue, required this.optionsList, required this.onChanged}) : super(key: key);

  @override
  State<ReusableDropDownList> createState() => _ReusableDropDownListState();
}

class _ReusableDropDownListState extends State<ReusableDropDownList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiHelper.verticalSymmetricPadding2x,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
          border: const OutlineInputBorder(borderSide: BorderSide(color: UiColorHelper.mainGreen)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: UiColorHelper.mainGreen)),
        ),
        value: widget.selectedValue,
        onChanged: widget.onChanged,
        items: widget.optionsList.map((gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
      ),
    );
  }
}
