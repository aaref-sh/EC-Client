import 'package:flutter/material.dart';

class BaseRout extends StatefulWidget {
  final String routeName;
  final Widget child;
  const BaseRout({super.key, required this.routeName, required this.child});

  @override
  State<BaseRout> createState() => _BaseRoutState();
}

class _BaseRoutState extends State<BaseRout> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.routeName),
          ),
          body: Stack(
            children: [
              widget.child,
            ],
          ),
        ));
  }
}
