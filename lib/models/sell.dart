import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tt/components/helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/category.dart';
import 'package:tt/models/fund.dart';
import 'package:tt/helpers/functions.dart';

class Repository {
  int id;
  String name;
  Repository(this.id, this.name);
}

class Sell {
  int id;
  String clientName;
  DateTime dateTime;
  List<SellCategory> soldCategories;
  String repository;
  String paymentType; // "USD" or "Local Pounds"
  String notes;
  bool inCash;
  Fund? fund;

  Sell({
    required this.id,
    required this.clientName,
    required this.dateTime,
    required this.soldCategories,
    required this.repository,
    required this.paymentType,
    required this.notes,
    required this.inCash,
    this.fund,
  });

  double get totalPrice => soldCategories.map((e) => e.totalPrice).sum;
  Map<String, dynamic> toJson() => {
        'id': id,
        'clientName': clientName,
        'dateTime': dateTime.toIso8601String(),
        'soldCategories': soldCategories.map((x) => x.toJson()).toList(),
        'repository': repository,
        'paymentType': paymentType,
        'notes': notes,
        'inCash': inCash,
        'fund': fund?.toJson() ?? "",
      };

  static Sell fromJson(Map<String, dynamic> json) => Sell(
        id: json['id'],
        clientName: json['clientName'],
        dateTime: DateTime.parse(json['dateTime']),
        soldCategories: List<SellCategory>.from(
            json['soldCategories'].map((x) => SellCategory.fromJson(x))),
        repository: json['repository'],
        paymentType: json['paymentType'],
        notes: json['notes'],
        inCash: json['inCash'],
        fund: Fund.fromJson(json['fund']),
      );

  static const disabledStyle =
      TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);
  static DateFormat formatter = DateFormat('yyyy-MM-dd');
  static List<ColumnConfig<Sell>> columnConfigs(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return [
      ColumnConfig(
        label: resNumber,
        width: width * 2 / 12,
        alignment: Alignment.center,
        transformFunction: (row) => (row.id).toString(),
        compareFunction: (a, b) => a.id.compareTo(b.id),
        icon: Icons.numbers,
      ),
      ColumnConfig(
        label: resDate,
        width: width * 3.5 / 12,
        alignment: Alignment.center,
        transformFunction: (row) => formatter.format(row.dateTime),
        styleFunction: (row) =>
            row.dateTime == DateTime.now() ? disabledStyle : null,
      ),
      ColumnConfig(
        label: resName,
        width: (width * 3.5 / 12).round() - 1,
        alignment: Alignment.center,
        transformFunction: (row) => row.clientName,
        compareFunction: (a, b) => a.clientName.compareTo(b.clientName),
        // validators: [SampleRowData.validateGravity],
      ),
      ColumnConfig(
        label: resAmount,
        width: width * 3 / 12,
        alignment: Alignment.center,
        compareFunction: (a, b) => a.totalPrice.compareTo(b.totalPrice),
        renderFunction: (context, object, _) {
          var price = object.totalPrice;
          Color? color;
          if (object.totalPrice > 1e5) {
            color = Colors.blue.withAlpha((price / 10000 * 255).round());
          }
          if (price > 5e5) {
            color = Colors.red[900]
                ?.toMaterialColor()
                .withAlpha((price / 5e5 * 255).round());
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
    ];
  }
}
