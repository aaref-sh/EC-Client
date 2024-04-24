import 'package:flutter/material.dart';
import 'package:tt/routes/home.dart';

enum PushMethod { replacement, xxx }

void navigateTo(context,
    {Widget? to, PushMethod type = PushMethod.replacement}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    type == PushMethod.replacement
        ? Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => to ?? const HomePage()))
        : Navigator.push(
            context, MaterialPageRoute(builder: (_) => to ?? const HomePage()));
  });
}
