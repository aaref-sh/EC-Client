import 'package:tt/models/category_group.dart';

import '../enums/main_account_enum.dart';

class Category {
  int id;
  String name;
  CategoryGroup categoryGroup;
  DateTime dateTime;
  double initialAmount;
  double price;
  String notes;
  DateTime expireDate;
  String imagePath;
  SaleingType saleingType;

  Category({
    required this.id,
    required this.name,
    required this.categoryGroup,
    required this.dateTime,
    required this.initialAmount,
    required this.price,
    required this.notes,
    required this.expireDate,
    required this.imagePath,
    required this.saleingType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'categoryGroup': categoryGroup.toJson(),
        'dateTime': dateTime.toIso8601String(),
        'initialAmount': initialAmount,
        'price': price,
        'notes': notes,
        'expireDate': expireDate.toIso8601String(),
        'imagePath': imagePath,
        'saleingType': saleingType.name,
      };

  static Category fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        categoryGroup: CategoryGroup.fromJson(json['categoryGroup']),
        dateTime: DateTime.parse(json['dateTime']),
        initialAmount: json['initialAmount'],
        price: json['price'],
        notes: json['notes'],
        expireDate: DateTime.parse(json['expireDate']),
        imagePath: json['imagePath'],
        saleingType:
            SaleingType.values.firstWhere((e) => e.name == json['saleingType']),
      );
}

class SaleCategory {
  Category category;
  double amount;
  double price;
  String extraDetails;

  SaleCategory({
    required this.category,
    required this.amount,
    required this.price,
    required this.extraDetails,
  });

  Map<String, dynamic> toJson() => {
        'category': category.toJson(),
        'amount': amount,
        'price': price,
        'extraDetails': extraDetails,
      };

  static SaleCategory fromJson(Map<String, dynamic> json) => SaleCategory(
        category: Category.fromJson(json['category']),
        amount: json['amount'],
        price: json['price'],
        extraDetails: json['extraDetails'],
      );
}
