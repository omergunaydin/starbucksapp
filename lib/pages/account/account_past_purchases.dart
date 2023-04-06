import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../widgets/reusable_top_bar.dart';

class AccountPastPurchases extends StatefulWidget {
  AccountPastPurchases({Key? key}) : super(key: key);

  @override
  State<AccountPastPurchases> createState() => _AccountPastPurchasesState();
}

class _AccountPastPurchasesState extends State<AccountPastPurchases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ReusableTopBar(text: 'Past Purchases', iconData: MdiIcons.cartOutline),
            ],
          ),
        ),
      ),
    );
  }
}
