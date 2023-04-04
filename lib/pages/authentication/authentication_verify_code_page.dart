import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../widgets/reusable_alert_dialog.dart';
import '../../widgets/reusable_snackbar.dart';
import 'authentication_new_user_page.dart';

class AuthenticationVerifyCodePage extends StatefulWidget {
  final String phoneNumber;
  final bool registered;
  const AuthenticationVerifyCodePage({Key? key, required this.phoneNumber, required this.registered}) : super(key: key);

  @override
  State<AuthenticationVerifyCodePage> createState() => _AuthenticationVerifyCodePageState();
}

class _AuthenticationVerifyCodePageState extends State<AuthenticationVerifyCodePage> {
  final _verifyCodeTextController = TextEditingController();
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late String mVerificationId;
  late int mResendToken;
  late bool mVerificationInProgress = false;
  late PhoneAuthCredential credential;

  @override
  void initState() {
    super.initState();
    startPhoneNumberVerification();
  }

  // 1. Process: StartPhoneNumberVerification
  startPhoneNumberVerification() async {
    debugPrint('phone number verification started! $widget.phoneNumber');
    mVerificationInProgress = true;

    await mAuth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint('onVerificationCompleted : $credential');
        mVerificationInProgress = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('onVerificationFailed : $e');
        mVerificationInProgress = false;
        ReusableAlertDialog(text: 'Verification Failed!\n Something went wrong :(', type: '1');
      },
      codeSent: (String verificationId, int? resendToken) async {
        debugPrint('onCodeSent: $verificationId');
        mVerificationId = verificationId;
        mResendToken = resendToken!;

        /* setState(() {
          codeTextFieldVisible = true;
          codeButtonVisible = true;
          sendTheCodeButtonEnabled = false;
        });*/
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // 2. Process : Verify the Phone number with Code
  verifyPhoneNumberWithCode(String verificationId, String code) {
    try {
      credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      //signInWithPhoneAuthCredential(credential);
      if (widget.registered) {
        signInWithPhoneAuthCredential(credential);
      } else {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AuthenticationNewUserPage(phoneNumber: widget.phoneNumber, credential: credential),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
      //createUser();
    } else {
      debugPrint('existing user!');
      showSnackBar(context: context, msg: 'You are signed in successfully!', type: 'success');
    }
    Future(() {
      scheduleMicrotask(() => Navigator.of(context).pop());
    });
    debugPrint(mAuth.currentUser!.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: UiColorHelper.mainGreen,
      //appBar: ReusableAppBar(text: 'Onay Kodu', width: width, height: height),
      body: SafeArea(
        child: Column(
          children: [
            //Phone icon & info text
            Container(
              width: width,
              height: height * 0.30,
              decoration: const BoxDecoration(
                color: UiColorHelper.mainGreen,
                image: DecorationImage(
                  image: AssetImage('assets/images/starbucks_logo_white.png'),
                  fit: BoxFit.fitWidth,
                  opacity: 0.05,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    MdiIcons.cellphoneCheck,
                    size: 85,
                    color: Colors.white,
                  ),
                  Text(
                    'Please enter the verification code\n sent to your mobile number ${widget.phoneNumber}\nin the boxes below.',
                    style: textTheme.subtitle2!.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),

            //Verify Code TextField
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: UiHelper.horizontalSymmetricPadding6x,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        animationType: AnimationType.fade,
                        controller: _verifyCodeTextController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        textStyle: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          activeFillColor: UiColorHelper.mainGreen,
                          activeColor: UiColorHelper.mainGreen,
                          inactiveColor: UiColorHelper.mainGreen,
                          selectedColor: UiColorHelper.mainGreen,
                        ),
                        onCompleted: (code) {
                          debugPrint("Completed");
                          // when complete start auth process...
                          verifyPhoneNumberWithCode(mVerificationId, code);
                        },
                        onChanged: (value) {
                          /*debugPrint(value);
                          code = value;*/
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    //Re-send SMS Button
                    GestureDetector(
                      onTap: () {
                        //Resend SMS Process
                      },
                      child: Text(
                        'Resend Verify Code',
                        style: textTheme.subtitle2!.copyWith(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
