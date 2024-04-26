// sells

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/routes/purchases/add_forward_purchase.dart';
import 'package:tt/routes/purchases/purchases.dart';
import 'package:tt/routes/sell/sell.dart';

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
                mainItem(size, "المشتريات", Icons.add_shopping_cart_outlined,
                    Purchase(),
                    addWidget: AddForwardPurchase()),
                mainItem(size, "المبيعات", Icons.paid_outlined, Sells()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainItem(size, "sells", Icons.abc, Purchase()),
                mainItem(size, "sells", Icons.abc, Purchase()),
              ],
            ),
            ExpansionTile(
              title: Text('Click to Expand'),
              children: [
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {},
                ),
              ],
            ),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container mainItem(Size size, String text, IconData icon, Widget route,
      {Widget? addWidget}) {
    return Container(
        // height: 100,
        width: size.width / 2 - 12,
        color: Colors.white,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: MainScreenButton(
            icon,
            text,
            route,
            addWidget: addWidget,
          ),
        ));
  }
}

class MainScreenButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? addWidget;
  final Widget route;
  const MainScreenButton(this.icon, this.label, this.route,
      {this.addWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, to: route, type: PushMethod.push);
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
                              color: Colors.deepPurple), // Thin, rounded border
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(fontSize: 15),
                        )), // Label
                    SizedBox(width: 5.0),
                  ],
                ),
              ],
            ),
            Positioned(
                right: 10,
                bottom: -2,
                child: addWidget == null
                    ? Container()
                    : IconButton(
                        padding: EdgeInsets.all(5.0),
                        icon: Icon(Icons.add, size: 25.0),
                        onPressed: () {
                          navigateTo(context, to: route, type: PushMethod.push);
                          navigateTo(context,
                              to: addWidget, type: PushMethod.push);
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
