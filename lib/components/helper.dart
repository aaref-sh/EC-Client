import 'package:flutter/material.dart';

class ColumnConfig<T> {
  final String label;
  final double width;
  final int Function(T, T)? compareFunction;
  final String Function(T)? transformFunction;
  final Widget? Function(BuildContext, T, String)? renderFunction;
  final Alignment alignment;
  final IconData? icon;
  final TextStyle? Function(T)? styleFunction;

  ColumnConfig({
    required this.label,
    this.width = 200,
    this.compareFunction,
    this.transformFunction,
    this.renderFunction,
    this.alignment = Alignment.centerLeft,
    this.icon,
    this.styleFunction,
  });
}
