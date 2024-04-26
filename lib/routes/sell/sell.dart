import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/enums/main_account_enum.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/category.dart';
import 'package:tt/models/category_group.dart';
import 'package:tt/models/sell.dart';
import 'package:vtable/vtable.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class Sells extends StatefulWidget {
  Sells({super.key});

  final items = <Sell>[
    Sell(
        id: 0,
        clientName: 'طط',
        dateTime: DateTime.now(),
        soldCategories: [
          SellCategory(
              amount: 6,
              category: Category(
                  id: 0,
                  name: "name",
                  categoryGroup: CategoryGroup(id: 1, name: "name"),
                  dateTime: DateTime.now(),
                  initialAmount: 2,
                  price: 1,
                  notes: 'notes',
                  expireDate: DateTime.now().add(Duration(days: 1)),
                  imagePath: 'imagePath',
                  saleingType: SellingType.gram),
              price: 40000,
              extraDetails: '')
        ],
        repository: 'repository',
        paymentType: 'paymentType',
        notes: 'notes',
        inCash: false)
  ];

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

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  VTable createTable() {
    var width = MediaQuery.of(context).size.width;
    const disabledStyle =
        TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

    return VTable<Sell>(
      filterWidgets: [Icon(Icons.home_outlined)],
      actions: [Icon(Icons.delete)],
      showToolbar: false,
      items: widget.items,
      tableDescription: '${widget.items.length} items',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: [
        VTableColumn(
          label: resNumber,
          width: (width * 2 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => (row.id).toString(),
          icon: Icons.numbers,
        ),
        VTableColumn(
          label: resDate,
          width: (width * 3.5 / 12).round(),
          grow: 1,
          alignment: Alignment.center,
          transformFunction: (row) => formatter.format(row.dateTime),
          styleFunction: (row) =>
              row.dateTime == DateTime.now() ? disabledStyle : null,
        ),
        VTableColumn(
          label: resName,
          width: (width * 3.5 / 12).round() - 1,
          alignment: Alignment.center,
          transformFunction: (row) => row.clientName,
          compareFunction: (a, b) => a.clientName.compareTo(b.clientName),
          // validators: [SampleRowData.validateGravity],
        ),
        VTableColumn(
          label: resAmount,
          width: (width * 3 / 12).round(),
          transformFunction: (row) =>
              row.soldCategories.map((e) => e.totalPrice).sum.toString(),
          alignment: Alignment.center,
          compareFunction: (a, b) => a.totalPrice.compareTo(b.totalPrice),
          renderFunction: (context, object, _) {
            var price = object.totalPrice;
            Color? color;
            if (object.totalPrice > 1e5) {
              color = Colors.blue.withAlpha((price / 10000 * 255).round());
            }
            if (price > 5e5) {
              color = Colors.red.withAlpha((price / 5e5 * 255).round());
            }
            return Container(
              color: color,
              child: Center(
                  child: Text(
                price.toString(),
                style: TextStyle(fontSize: 15),
              )),
            );
          },
          // validators: [SampleRowData.validateGravity],
        ),
      ],
    );
  }
}
