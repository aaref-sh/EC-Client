import 'package:flutter/material.dart';

// a flutter popup dialog shows a widget i pass as an argument
void showDialogBox(BuildContext context, Widget widget, {double? height}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: height ?? 300,
                  child: Center(child: SingleChildScrollView(child: widget)))));
    },
  );
}
