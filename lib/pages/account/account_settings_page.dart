import 'package:intl/intl.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/widgets/reusable_button.dart';
import 'package:starbucksapp/widgets/reusable_dropdown_list.dart';
import 'package:starbucksapp/widgets/reusable_snackbar.dart';
import 'package:starbucksapp/widgets/reusable_textfield.dart';
import 'package:starbucksapp/widgets/reusable_top_bar.dart';
import '../../constants/dimens/uihelper.dart';
import '../../data/user_api_client.dart';
import '../../models/user.dart';
import '../../widgets/reusable_alert_dialog.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late StarUser? user;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneNumberTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _birthDateTextController = TextEditingController();
  var phoneMaskFormatter = MaskTextInputFormatter(mask: '+90(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  final List<String> _genderOptions = ['Select', 'Male', 'Female', 'Other'];
  String _selectedGender = 'Select';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    if (user != null) {
      _emailTextController.text = user!.email!;
      _phoneNumberTextController.text = phoneMaskFormatter.maskText(user!.phoneNumber!);
      _nameTextController.text = user!.name!;
      if (user!.birthDate != null) {
        final String formattedDate = formatter.format(user!.birthDate!);
        _birthDateTextController.text = formattedDate;
      }
      if (user!.gender != null) {
        print('gender seçti');
        _selectedGender = user!.gender!;
      } else {
        print('select e girdi');
        _selectedGender = 'Select';
      }
      setState(() {});
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: UiColorHelper.mainGreen,
              onPrimary: Colors.white,
              surface: UiColorHelper.mainGreen,
              onSurface: UiColorHelper.mainGreen,
            ),
            textTheme: TextTheme(
              subtitle1: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final String formattedDate = formatter.format(selectedDate);
        _birthDateTextController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ReusableTopBar(text: 'Account Settings', iconData: MdiIcons.cogs),
              Padding(
                padding: UiHelper.allPadding3x,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Information', style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen)),
                    const SizedBox(height: 10),
                    Text('E-mail', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                    ReusableTextField(controller: _emailTextController, enabled: false),
                    Text('Phone Number', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                    ReusableTextField(controller: _phoneNumberTextController, hintText: '+90(###) ###-##-##', inputFormatters: [phoneMaskFormatter], enabled: false),
                    const SizedBox(height: 20),
                    Text('Personal Information', style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen)),
                    const SizedBox(height: 10),
                    Text('Name', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                    ReusableTextField(controller: _nameTextController),
                    Text('BirthDate', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: ReusableTextField(
                        controller: _birthDateTextController,
                        enabled: false,
                        hintText: 'Select Your BirthDate',
                      ),
                    ),
                    Text('Gender', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                    ReusableDropDownList(
                        selectedValue: _selectedGender,
                        optionsList: _genderOptions,
                        onChanged: (val) {
                          setState(() {
                            _selectedGender = val!;
                          });
                        }),
                    ReusableButton(
                        text: 'Save',
                        color: UiColorHelper.mainGreen,
                        onPressed: () async {
                          if (_birthDateTextController.text == '') {
                            showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'You have to enter your birthDate!', type: '1'));
                            return;
                          }
                          if (_selectedGender == 'Select') {
                            showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'You have to select your Gender!', type: '1'));
                            return;
                          }
                          StarUser userNew = user!.copyWith(name: _nameTextController.text, birthDate: selectedDate, gender: _selectedGender);
                          await UserApiClient().updateUserData(userNew);
                          Future(() {
                            scheduleMicrotask(() => Navigator.of(context).pop());
                          });
                          showSnackBar(context: context, msg: 'Your settings saved successfully!', type: 'success');
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
