// sells

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/routes/category/add_category.dart';
import 'package:tt/routes/purchases/add_purchase.dart';
import 'package:tt/routes/purchases/purchases.dart';
import 'package:tt/routes/sell/add_sell.dart';
import 'package:tt/routes/sell/sell.dart';
import 'package:tt/routes/voucher/add_voucher.dart';
import 'package:tt/routes/voucher/voucher.dart';

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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                  MainScreenButton(resPurchases,
                      Icons.add_shopping_cart_outlined, Purchase(),
                      addWidget: AddForwardPurchase()),
                  MainScreenButton(resSells, Icons.paid_outlined, Sells(),
                      addWidget: AddSells()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainScreenButton(
                    resVouchers,
                    Icons.payments,
                    Vouchers(),
                    addWidget: CreateVoucherScreen(),
                  ),
                  MainScreenButton("sells", Icons.abc, Purchase()),
                ],
              ),
              ExpansionTile(
                title: Text(resCategories),
                children: [
                  ListTile(
                    title: Text(resAdd),
                    onTap: () {
                      showDialogBox(context, AddCategory());
                    },
                  ),
                ],
              ),
              SizedBox(
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
      ),
    );
  }
}

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

// gain/spend
// buyes
// accounts
