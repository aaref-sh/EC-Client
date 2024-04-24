import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

List cols = [
  {"title": 'Name', 'widthFactor': 0.3, 'key': 'name', 'editable': false},
  {"title": 'Date', 'widthFactor': 0.2, 'key': 'date'},
  {"title": 'Month', 'widthFactor': 0.1, 'key': 'month', 'editable': false},
  {"title": 'Status', 'widthFactor': 0.1, 'key': 'status'},
];
List rows = [
  {
    "name": 'James Joe',
    "date": '23/09/2020',
    "month": 'June',
  },
  {
    "name": 'Daniel Paul',
    "date": '12/4/2020',
    "month": 'March',
    "status": 'new'
  },
];

class _PurchaseState extends State<Purchase> {
  @override
  Widget build(BuildContext context) {
    return BaseRout(
      routeName: "المدفوعات",
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Editable(
          columns: cols,
          rows: rows,
          zebraStripe: true,
          // stripeColor2: Colors.grey[200],
          borderColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
