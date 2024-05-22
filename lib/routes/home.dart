// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/main_screen_button.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/routes/category/add_category.dart';
import 'package:tt/routes/category/categories.dart';
import 'package:tt/routes/debit_credit/accounts.dart';
import 'package:tt/routes/material/add_material.dart';
import 'package:tt/routes/material/materials.dart';
import 'package:tt/routes/purchases/add_purchase.dart';
import 'package:tt/routes/purchases/purchases.dart';
import 'package:tt/routes/repository/add_repository.dart';
import 'package:tt/routes/repository/repositories.dart';
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
          title: Text('الرئيسية'),
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
                    addWidget: AddVoucherScreen(),
                  ),
                  MainScreenButton(
                    resMaterials,
                    Icons.abc,
                    Materials(),
                    addWidget: AddMaterial(),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(resCategories),
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    title: Text(resAdd),
                    onTap: () {
                      showDialogBox(context, AddCategory());
                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    title: Text(resView),
                    onTap: () {
                      navigateTo(context, to: Categories());
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(resRepos),
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    title: Text(resAdd),
                    onTap: () {
                      showDialogBox(context, AddRepository());
                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    title: Text(resView),
                    onTap: () {
                      navigateTo(context, to: Repositories());
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(resDebitCredit),
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    title: Text(resAccounts),
                    onTap: () {
                      navigateTo(context, to: Accounts());
                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    title: Text(resVouchers),
                    onTap: () {
                      navigateTo(context, to: Vouchers());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
