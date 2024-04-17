// sells

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      drawer: Drawer(
          // Add your drawer items here
          ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  height: 55,
                  width: 22,
                  child: Container(
                    color: Colors.black26,
                    // Add your container content and styling here
                  ),
                )
              ],
            ),
          ),
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              // Handle panel expansion
            },
            children: [
              // Add your ExpansionPanel items here
            ],
          ),
        ],
      ),
    );
    ;
  }
}

// gain/spend
// buyes
// accounts
