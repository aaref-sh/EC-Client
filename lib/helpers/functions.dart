import 'package:flutter/material.dart';
import 'package:tt/routes/home.dart';

enum PushMethod { replacement, push }

void navigateTo(BuildContext context,
    {Widget? to, PushMethod type = PushMethod.replacement}) {
  type == PushMethod.replacement
      ? Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => to ?? const HomePage()))
      : Navigator.push(
          context, MaterialPageRoute(builder: (_) => to ?? const HomePage()));
}

extension ArabicStringExtension on String {
  bool get isRTL {
    // Regular expression for matching leading non-word characters and an Arabic letter
    final RegExp arabicRegex = RegExp(
        r'^\s*[^\w\s]*[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');

    // Check if the text starts with an Arabic letter
    return arabicRegex.hasMatch(this);
  }
}

Alignment getCellAlignment(String s) {
  switch (s.isRTL) {
    case true:
      return Alignment.centerRight;
    case false:
      return Alignment.centerLeft;
    default:
      throw Exception('Invalid String');
  }
}
