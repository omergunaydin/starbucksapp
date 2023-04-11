import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/dimens/uihelper.dart';
import '../../widgets/custom_radio_list_tile.dart';

class CartChangePickUpTimePage extends StatefulWidget {
  String selectedDate;
  String selectedHour;
  Function function;
  CartChangePickUpTimePage({Key? key, required this.selectedDate, required this.selectedHour, required this.function}) : super(key: key);

  @override
  State<CartChangePickUpTimePage> createState() => _CartChangePickUpTimePageState();
}

class _CartChangePickUpTimePageState extends State<CartChangePickUpTimePage> {
  String selectedValue = '';
  late List<String> hoursList;
  late int hourNow;

  @override
  void initState() {
    hourNow = DateTime.now().hour;
    hoursList = getHoursList();
    selectedValue = widget.selectedHour;

    super.initState();
  }

  List<String> getHoursList() {
    List<String> hoursList = [];
    DateTime startDate = DateTime(2023, 1, 1, 9, 0); // 9:00 AM
    DateTime endDate = DateTime(2023, 1, 1, 21, 0); // 21:00 PM
    int interval = 60; // 1 hour in minutes
    while (startDate.isBefore(endDate)) {
      DateTime endOfInterval = startDate.add(Duration(minutes: interval));
      String timeRange = "${DateFormat.Hm().format(startDate)}-${DateFormat.Hm().format(endOfInterval)}";
      hoursList.add(timeRange);
      startDate = endOfInterval;
    }
    return hoursList;
  }

  String getTodayString() {
    DateFormat dateFormat = DateFormat('dd MMMM y EEEE');
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    String nowString = dateFormat.format(now);
    return nowString;
  }

  changeSelectedValue(val) {
    setState(() {
      selectedValue = (val as String);
      widget.selectedHour = selectedValue;
      widget.selectedDate = getTodayString();
      widget.function(widget.selectedDate, widget.selectedHour);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Sabah
              hourNow >= 12
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: UiHelper.allPadding3x,
                      child: Text(
                        'Morning',
                        style: textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                    ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    hourNow >= 10
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[0], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[0], onChanged: changeSelectedValue),
                    hourNow >= 11
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[1], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[1], onChanged: changeSelectedValue),
                    hourNow >= 12
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[2], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[2], onChanged: changeSelectedValue),
                  ],
                ),
              ),
              //Öğle
              hourNow >= 17
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: UiHelper.allPadding3x,
                      child: Text(
                        'Noon',
                        style: textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                    ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    hourNow >= 13
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[3], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[3], onChanged: changeSelectedValue),
                    hourNow >= 14
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[4], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[4], onChanged: changeSelectedValue),
                    hourNow >= 15
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[5], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[5], onChanged: changeSelectedValue),
                    hourNow >= 16
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[6], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[6], onChanged: changeSelectedValue),
                    hourNow >= 17
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[7], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[7], onChanged: changeSelectedValue),
                  ],
                ),
              ),
              //Akşam
              hourNow >= 21
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: UiHelper.allPadding3x,
                      child: Text(
                        'Evening',
                        style: textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                    ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    hourNow >= 18
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[8], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[8], onChanged: changeSelectedValue),
                    hourNow >= 19
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[9], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[9], onChanged: changeSelectedValue),
                    hourNow >= 20
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[10], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[10], onChanged: changeSelectedValue),
                    hourNow >= 21
                        ? const SizedBox.shrink()
                        : CustomRadioListTile(value: hoursList[11], selectedValue: selectedValue, widget: widget, status: 'Available', text: hoursList[11], onChanged: changeSelectedValue),
                  ],
                ),
              ),
              //Kapalı Zaman
              (hourNow >= 21 && hourNow < 24)
                  ? SizedBox(
                      width: width,
                      height: height * 0.75,
                      child: const Center(child: Text('No available pick up time for today!!')),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
