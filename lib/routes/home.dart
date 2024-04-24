// sells

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/routes/purchases/add_forward_purchase.dart';
import 'package:tt/routes/purchases/purchases.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class CardItem {
  Icon icon;
  String name;
  String route;
  bool withAddButton;
  CardItem(this.icon, this.name, this.route, this.withAddButton);
}

class _HomePageState extends State<HomePage> {
  var list = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      drawer: Drawer(
          // Add your drawer items here
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainItem(size, "sells", Icons.abc,
                    addWidget: AddForwardPurchase()),
                mainItem(size, "sells", Icons.abc),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainItem(size, "sells", Icons.abc),
                mainItem(size, "sells", Icons.abc),
              ],
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                // Handle panel expansion
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return Text("data");
                    },
                    body: Icon(Icons.ac_unit))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container mainItem(Size size, String text, IconData icon,
      {Widget? addWidget}) {
    return Container(
        // height: 100,
        width: size.width / 2 - 12,
        color: Colors.white,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MainScreenButton(
            Icons.balance,
            "المبيعات",
            addWidget: addWidget,
          ),
        ));
  }
}

class MainScreenButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? addWidget;
  const MainScreenButton(this.icon, this.label, {this.addWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, to: Purchase(), type: PushMethod.xxx);
        print("f");
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
                Icon(icon, size: 50.0), // Big icon

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                        // Take 50% of the screen width
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey), // Thin, rounded border
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Label',
                          style: TextStyle(fontSize: 15),
                        )), // Label
                    SizedBox(width: 5.0),
                  ],
                ),
              ],
            ),
            Positioned(
                right: 20,
                bottom: 2,
                child: addWidget == null
                    ? Container()
                    : IconButton(
                        padding: EdgeInsets.all(5.0),
                        icon: Icon(Icons.add, size: 25.0),
                        onPressed: () => {
                          navigateTo(context,
                              to: addWidget, type: PushMethod.xxx)
                        },
                      ))
          ],
        ),
      ),
    );
  }
}

// gain/spend
// buyes
// accounts
