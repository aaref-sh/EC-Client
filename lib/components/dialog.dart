import 'package:flutter/material.dart';

class AddDialog extends StatefulWidget {
  final Widget content;
  const AddDialog({super.key, required this.content});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(child: Text('Leaderboard')),
                        SizedBox(height: 20),
                        widget.content
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Show dialog'),
        ),
      ),
    );
  }
}
