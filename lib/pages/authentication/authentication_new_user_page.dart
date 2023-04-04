import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:starbucksapp/models/user.dart';
import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../data/user_api_client.dart';
import '../../widgets/reusable_alert_dialog.dart';
import '../../widgets/reusable_button.dart';
import '../../widgets/reusable_checkbox.dart';
import '../../widgets/reusable_snackbar.dart';
import '../../widgets/reusable_textfield.dart';

class AuthenticationNewUserPage extends StatefulWidget {
  final String phoneNumber;
  final PhoneAuthCredential credential;
  const AuthenticationNewUserPage({Key? key, required this.phoneNumber, required this.credential}) : super(key: key);

  @override
  State<AuthenticationNewUserPage> createState() => _AuthenticationNewUserPageState();
}

class _AuthenticationNewUserPageState extends State<AuthenticationNewUserPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  FirebaseAuth mAuth = FirebaseAuth.instance;
  final _phoneNumberController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  bool checkBox1State = false;
  bool checkBox2State = false;

  var phoneMaskFormatter = MaskTextInputFormatter(mask: '+90(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = widget.phoneNumber;
  }

  //CreateUser Function
  Future<void> createUser() async {
    StarUser newUser = StarUser(
        id: mAuth.currentUser?.uid,
        name: _nameTextController.text,
        email: _emailTextController.text,
        createdAt: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
        phoneNumber: mAuth.currentUser?.phoneNumber,
        userAgreement: checkBox1State,
        memberType: 'Green Member',
        totalStars: 0,
        freeDrinks: 0,
        offers: checkBox2State);
    await UserApiClient().addUserToDatabase(newUser).then((value) {
      Navigator.of(context).pop();
      showSnackBar(context: context, msg: 'Your account has been created!', type: 'success');
    });
  }

  // 3. Process : If verification completed, SignIn!
  signInWithPhoneAuthCredential(PhoneAuthCredential credential) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: UiColorHelper.mainGreen,
            ),
          );
        });

    final UserCredential authResult = await mAuth.signInWithCredential(credential);

    Future(() {
      scheduleMicrotask(() => Navigator.of(context).pop());
    });

    if (authResult.additionalUserInfo!.isNewUser) {
      debugPrint('newUser created');
      createUser();
    } else {
      debugPrint('existing user!');
      showSnackBar(context: context, msg: 'You are already signed-up!', type: 'success');
    }
    debugPrint(mAuth.currentUser!.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            //New User Icon
            Container(
              width: width,
              height: height * 0.25,
              decoration: const BoxDecoration(
                color: UiColorHelper.mainGreen,
                image: DecorationImage(
                  image: AssetImage('assets/images/starbucks_logo_white.png'),
                  fit: BoxFit.fitWidth,
                  opacity: 0.05,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    MdiIcons.account,
                    size: 100,
                    color: Colors.white,
                  ),
                  Text(
                    'Create Your New Account',
                    style: textTheme.subtitle1!.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            //New User Form
            Padding(
              padding: UiHelper.horizontalSymmetricPadding3x,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Phone Number TextField
                  Text('Phone Number', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _phoneNumberController, inputFormatters: [phoneMaskFormatter], hintText: '+90(---)-------', enabled: false, textInputAction: TextInputAction.next),
                  //Name Surname TextField
                  Text('Name Surname', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _nameTextController, textInputAction: TextInputAction.next),
                  //Name Surname TextField
                  Text('Email*', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _emailTextController, textInputAction: TextInputAction.done),
                  //User Contract CheckBoxes
                  ReusableCheckBox(
                      text: 'I have read and approve the user agreement.',
                      checkBoxState: checkBox1State,
                      onChanged: (val) {
                        setState(() {
                          checkBox1State = val!;
                        });
                      }),
                  ReusableCheckBox(
                      text: 'I have read and approved the information text within General Data Protection Regulation.',
                      checkBoxState: checkBox2State,
                      onChanged: (val) {
                        setState(() {
                          checkBox2State = val!;
                        });
                      }),
                  //Create User Button
                  ReusableButton(
                      text: 'Create Your Account',
                      color: UiColorHelper.mainGreen,
                      onPressed: () {
                        //close keyboard
                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                        //if phoneNumber lenght is less than 10 digits Show Error
                        if (_phoneNumberController.text.length < 13) {
                          showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Please enter a valid phone number!', type: '1'));
                        } else {
                          if (_nameTextController.text.isEmpty) {
                            showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Name Surname field cannot be empty!', type: '1'));
                          } else {
                            if (!EmailValidator.validate(_emailTextController.text)) {
                              showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Please enter a valid email address!', type: '1'));
                            } else {
                              //Call Create user function
                              if (!checkBox1State) {
                                showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Please confirm the user agreement!', type: '1'));
                              } else {
                                if (!checkBox2State) {
                                  showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Please confirm the GDPR!', type: '1'));
                                } else {
                                  //createUser();
                                  signInWithPhoneAuthCredential(widget.credential);
                                }
                              }
                            }
                          }
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
