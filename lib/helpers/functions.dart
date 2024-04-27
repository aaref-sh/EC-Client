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

extension ColorsExt on Color {
  MaterialColor toMaterialColor() {
    final int red = this.red;
    final int green = this.green;
    final int blue = this.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(value, shades);
  }
}
