import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../widgets/reusable_alert_dialog.dart';
import '../../widgets/reusable_button.dart';
import '../../widgets/reusable_textfield.dart';
import 'authentication_verify_code_page.dart';

class AuthenticationPage extends StatefulWidget {
  bool registered;
  AuthenticationPage({Key? key, required this.registered}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _phoneNumberController = TextEditingController();
  var phoneMaskFormatter = MaskTextInputFormatter(mask: '+90(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Spacer(),
                    const Icon(MdiIcons.cellphoneCheck, size: 65, color: Colors.white),
                    Padding(
                      padding: UiHelper.allPadding3x,
                      child: Text(
                        'Please enter your phone number. \nYou will be able to log in with the code that will be sent to your mobile phone via SMS.',
                        style: textTheme.subtitle2!.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              const SizedBox(height: 30),
              //Phone number text & textfield & button
              Padding(
                padding: UiHelper.horizontalSymmetricPadding3x,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone Number', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                    ReusableTextField(
                      controller: _phoneNumberController,
                      inputFormatters: [phoneMaskFormatter],
                      hintText: '+90(---)-------',
                      textInputAction: TextInputAction.done,
                    ),
                    ReusableButton(
                        text: 'Continue',
                        onPressed: () {
                          //close keyboard
                          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                          //if phoneNumber lenght is less than 10 digits Show Error
                          if (phoneMaskFormatter.getUnmaskedText().toString().length < 10) {
                            showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Please enter a valid phone number!', type: '1'));
                            //if phoneNumber is ok --> Navigate to AuthenticationVerifyCodePage
                          } else {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AuthenticationVerifyCodePage(phoneNumber: '+90${phoneMaskFormatter.getUnmaskedText()}', registered: widget.registered),
                              ),
                            );
                          }
                        },
                        color: UiColorHelper.mainGreen),
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
