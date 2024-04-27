import 'package:flutter/material.dart';

// a flutter popup dialog shows a widget i pass as an argument
void showDialogBox(BuildContext context, Widget widget) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          content: SizedBox(
              height: 200, child: SingleChildScrollView(child: widget)));
    },
  );
}
