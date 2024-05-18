import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/category.dart';
import 'package:tt/models/sell.dart';

final items = <Sell>[
  Sell(
      id: 0,
      clientName: 'طط',
      dateTime: DateTime.now(),
      soldCategories: [
        SellCategory(
            amount: 6,
            category: Category(id: 0, name: "صنف 1"),
            price: 40000,
            extraDetails: '')
      ],
      repository: 'repository',
      paymentType: 'paymentType',
      notes: 'notes',
      inCash: false)
];

class Sells extends StatefulWidget {
  Sells({super.key});

  @override
  State<Sells> createState() => _SellsState();
}

class _SellsState extends State<Sells> {
  @override
  Widget build(BuildContext context) {
    return BaseRout(
      routeName: "المبيعات",
      child: createTable(),
    );
  }

  GVTable createTable() {
    return GVTable<Sell>(
      filterWidgets: [Icon(Icons.home_outlined)],
      actions: [Icon(Icons.delete)],
      showToolbar: showTableHeaders,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columnConfigs: Sell.columnConfigs(context),
    );
  }
}
