import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:starbucksapp/pages/account/account_settings_page.dart';
import 'package:starbucksapp/widgets/reusable_button.dart';
import 'package:starbucksapp/widgets/reusable_snackbar.dart';
import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../cubit/user_cubit.dart';
import 'package:intl/intl.dart';

import '../../data/user_api_client.dart';
import '../../models/user.dart';
import '../authentication/authentication_page.dart';

class AccountMainPage extends StatefulWidget {
  AccountMainPage({Key? key}) : super(key: key);

  @override
  State<AccountMainPage> createState() => _AccountMainPageState();
}

class _AccountMainPageState extends State<AccountMainPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  Future<String> uploadProfileImage(String type) async {
    XFile? getFile;
    final ImagePicker picker = ImagePicker();
    if (type == 'Camera') {
      getFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      getFile = await picker.pickImage(source: ImageSource.gallery);
    }
    final storageRef = FirebaseStorage.instance.ref().child('profileImages').child(mAuth.currentUser!.uid).child('profileImage.png');
    UploadTask uploadTask = storageRef.putFile(File(getFile!.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  showModalBottomSheetForImage(StarUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: UiHelper.allPadding3x,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableButton(
                  text: 'Import from Gallery',
                  color: UiColorHelper.mainGreen,
                  onPressed: () async {
                    String imageUrl = await uploadProfileImage('Gallery');
                    setUserImageUrl(user, imageUrl);
                  }),
              ReusableButton(
                  text: 'Take Photo with Camera',
                  color: UiColorHelper.mainGreen,
                  onPressed: () async {
                    String imageUrl = await uploadProfileImage('Camera');
                    setUserImageUrl(user, imageUrl);
                  }),
            ],
          ),
        );
      },
    );
  }

  setUserImageUrl(StarUser user, String imageUrl) async {
    StarUser userNew = user.copyWith(imageUrl: imageUrl);
    await UserApiClient().updateUserData(userNew);
    Future(() {
      scheduleMicrotask(() => Navigator.of(context).pop());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header of Account Page
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserSignIn) {
                  return const SizedBox.shrink();
                }
                return Container(
                  height: height * 0.08,
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/splash_bg.png'), fit: BoxFit.cover)),
                  child: Padding(
                    padding: UiHelper.horizontalSymmetricPadding3x,
                    child: Row(
                      children: [
                        Container(
                          width: height * 0.06,
                          height: height * 0.06,
                          padding: UiHelper.rightPadding2x,
                          child: Image.asset('assets/images/starbucks_logo.png'),
                        ),
                        Text('Starbucks', style: textTheme.headline6),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Menu Items of Account Page
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      padding: UiHelper.allPadding2x,
                      decoration: const BoxDecoration(
                        color: UiColorHelper.mainGreen,
                        image: DecorationImage(
                          image: AssetImage('assets/images/starbucks_logo_white.png'),
                          fit: BoxFit.fitWidth,
                          opacity: 0.05,
                        ),
                      ),
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UserSignIn) {
                            return Column(
                              children: [
                                Container(
                                  width: width * 0.12,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(150),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150),
                                    child: Builder(builder: (context) {
                                      final userState = context.watch<UserCubit>().state;
                                      if (userState is UserSignIn) {
                                        if (userState.user.imageUrl != null) {
                                          return InkWell(onTap: () => showModalBottomSheetForImage(userState.user), child: Image.network(userState.user.imageUrl!, fit: BoxFit.cover));
                                        } else {
                                          String userName = userState.user.name ?? 'User Name';
                                          List<String> names = userName.split(" ");
                                          String initials = "${names[0].substring(0, 1)}${names[1].substring(0, 1)}";
                                          return InkWell(
                                              onTap: () => showModalBottomSheetForImage(userState.user),
                                              child: Center(
                                                  child: Text(
                                                initials,
                                                style: textTheme.headline5!.copyWith(color: UiColorHelper.mainGreen),
                                              )));
                                        }
                                      }
                                      return const SizedBox.shrink();
                                    }),
                                  ),
                                ),
                                Padding(
                                  padding: UiHelper.verticalSymmetricPadding1x,
                                  child: Text(state.user.name!, style: textTheme.subtitle2!.copyWith(color: Colors.white)),
                                ),
                                Text(state.user.memberType!, style: textTheme.button!.copyWith(color: Colors.white70)),
                                SignButtons(
                                    text: 'Sign Out',
                                    onPressed: () {
                                      setState(() {
                                        mAuth.signOut();
                                        Navigator.of(context).pop();
                                        showSnackBar(context: context, msg: 'You are signed out successfully!', type: 'success');
                                      });
                                    })
                              ],
                            );
                          } else if (state is UserSignOut) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SignButtons(
                                    text: 'Sign In',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: AuthenticationPage(registered: true),
                                        ),
                                      );
                                    }),
                                const SizedBox(width: 15),
                                SignButtons(
                                    text: 'Sign Up',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: AuthenticationPage(registered: false),
                                        ),
                                      ).then((value) => setState(() {}));
                                    })
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    //Menu List Items
                    Padding(
                      padding: UiHelper.allPadding3x,
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UserSignIn) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTileTitle(text: 'Account', firstTitle: true),
                                ListTileItem(
                                    text: 'Account Settings',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: AccountSettingsPage(),
                                        ),
                                      );
                                    }),
                                ListTileItem(text: 'Rewards Transactions', onTap: () {}),
                                ListTileItem(text: 'Past Purchases', onTap: () {}),
                                ListTileItem(text: 'Favorites', onTap: () {}),
                                ListTileTitle(text: 'Starbucks Card'),
                                ListTileItem(text: 'Payment Methods', onTap: () {}),
                                ListTileItem(text: 'Auto Reload', onTap: () {}),
                                ListTileItem(text: 'Renew Card', onTap: () {}),

                                /////
                                ListTileTitle(text: 'Language Preferences'),
                                ListTileItem(text: 'Change Language / Dil Değiştir', onTap: () {}),
                                /////
                                ListTileTitle(text: 'Contact Us'),
                                ListTileItem(text: 'Contact Us', onTap: () {}),
                                /////
                                ListTileTitle(text: 'Help & Policies'),
                                ListTileItem(text: 'Help', onTap: () {}),
                                ListTileItem(text: 'Terms of Use', onTap: () {}),
                                ListTileItem(text: 'Personal Data Information Notice', onTap: () {}),

                                Padding(
                                  padding: UiHelper.verticalSymmetricPadding5x,
                                  child: Text('App Version: 1.0.1 - \'Coffee Americano\'', style: textTheme.caption!.copyWith(color: Colors.grey)),
                                )
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTileTitle(text: 'Language Preferences'),
                              ListTileItem(text: 'Change Language / Dil Değiştir', onTap: () {}),
                              /////
                              ListTileTitle(text: 'Contact Us'),
                              ListTileItem(text: 'Contact Us', onTap: () {}),
                              /////
                              ListTileTitle(text: 'Help & Policies'),
                              ListTileItem(text: 'Help', onTap: () {}),
                              ListTileItem(text: 'Terms of Use', onTap: () {}),
                              ListTileItem(text: 'Personal Data Information Notice', onTap: () {}),

                              Padding(
                                padding: UiHelper.verticalSymmetricPadding5x,
                                child: Text('App Version: 1.0.1 - \'Coffee Americano\'', style: textTheme.caption!.copyWith(color: Colors.grey)),
                              )
                            ],
                          );
                        },
                      ),
                    ),
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

class ListTileItem extends StatelessWidget {
  String text;
  Function()? onTap;
  ListTileItem({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: ListTile(
        dense: true,
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        title: Text(text, style: textTheme.subtitle2),
      ),
    );
  }
}

class ListTileTitle extends StatelessWidget {
  String text;
  bool? firstTitle;
  ListTileTitle({Key? key, required this.text, this.firstTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(padding: EdgeInsets.only(top: firstTitle != null || firstTitle == true ? 20 : 40, bottom: 10), child: Text(text, style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)));
  }
}

class SignButtons extends StatelessWidget {
  String text;
  Function()? onPressed;
  SignButtons({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      child: Padding(
        padding: UiHelper.horizontalSymmetricPadding3x,
        child: Text(
          text,
          style: textTheme.button!.copyWith(color: UiColorHelper.mainGreen),
        ),
      ),
    );
  }
}
