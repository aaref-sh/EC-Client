import 'package:flutter/material.dart';

// a flutter popup dialog shows a widget i pass as an argument
void showDialogBox(BuildContext context, Widget widget) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Center(child: SingleChildScrollView(child: widget))));
    },
  );
}
