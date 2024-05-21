import 'package:flutter/material.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/helpers/functions.dart';

class MainScreenButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? addWidget;
  final Widget route;
  const MainScreenButton(this.label, this.icon, this.route,
      {this.addWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 12,
      color: Colors.white,
      height: 100,
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          navigateTo(context, to: route);
        },
        child: Container(
          // Take 50% of the screen width
          decoration: BoxDecoration(
            border: Border.all(
                width: 1.0, color: Colors.grey), // Thin, rounded border
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 50.0,
                    color: Colors.deepPurple[900],
                  ), // Big icon

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                          // Take 50% of the screen width
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[100],
                            border: Border.all(
                                width: 1.0,
                                color:
                                    Colors.deepPurple), // Thin, rounded border
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          )), // Label
                      SizedBox(width: 5.0),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 0,
                bottom: 20,
                child: addWidget == null
                    ? Container()
                    : IconButton(
                        color: Colors.deepPurple[900],
                        icon:
                            Icon(Icons.add_circle_outline_rounded, size: 30.0),
                        onPressed: () {
                          navigateTo(context, to: route);
                          showDialogBox(context, addWidget!);
                          // navigateTo(context,
                          //     to: addWidget, type: PushMethod.push);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
