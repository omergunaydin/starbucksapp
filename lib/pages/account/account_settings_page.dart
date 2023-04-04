import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('account settings'),
      ),
    );
  }
}
