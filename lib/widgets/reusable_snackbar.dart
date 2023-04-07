import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void showSnackBar({required BuildContext context, String? msg, String? type}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color.fromARGB(255, 10, 138, 86),
      duration: const Duration(seconds: 2),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$msg"),
          () {
            if (type == 'error') {
              return const Icon(MdiIcons.alertCircle, color: Colors.white);
            }

            if (type == 'warning') {
              return const Icon(MdiIcons.alertOutline, color: Colors.white);
            }

            if (type == 'success') {
              return const Icon(MdiIcons.check, color: Colors.white);
            }

            return const Icon(MdiIcons.information, color: Colors.white);
          }(),
        ],
      ),
    ),
  );
}
