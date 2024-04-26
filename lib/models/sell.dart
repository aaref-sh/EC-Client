import 'package:collection/collection.dart';
import 'package:tt/models/category.dart';
import 'package:tt/models/fund.dart';

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
}
