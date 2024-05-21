import 'package:flutter/material.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/category_group.dart';
import 'package:tt/models/voucher.dart';
import 'package:vtable/vtable.dart';

import '../enums/main_account_enum.dart';

class Category {
  int id;
  String name;
  int? baseCategoryId;

  Category({
    this.id = -1,
    required this.name,
    this.baseCategoryId,
  });
  @override
  String toString() => name;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baseCategoryId': baseCategoryId,
      };

  static Category fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        baseCategoryId: json['baseCategoryId'],
      );
  static List<Category> fromJsonList(List<Map<String, dynamic>> json) {
    List<Category> categories = [];
    for (var i = 0; i < json.length; i++) {
      categories.add(Category.fromJson(json[i]));
    }
    return categories;
  }

  static List<VTableColumn<Category>> columnConfigs(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return [
      VTableColumn(
        label: '#',
        width: (width * 2 / 12).round(),
        alignment: Alignment.center,
        transformFunction: (row) => (row.id).toString(),
        compareFunction: (a, b) => a.id.compareTo(b.id),
        icon: Icons.numbers,
      ),
      VTableColumn(
        label: resName,
        width: (width * 5 / 12).round() - 1,
        alignment: Alignment.center,
        transformFunction: (row) => row.name,
        compareFunction: (a, b) => a.name.compareTo(b.name),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: '',
        width: (width * 1 / 12).round(),
        alignment: Alignment.center,
        renderFunction: (context, object, out) {
          return GestureDetector(
              onTap: () {
                showBottomDrawer(context, object.id, "Category");
              },
              child: Icon(Icons.more_horiz));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }
}

class ListCategoryRequest extends ApiPagingRequest {
  String? name;
  ListCategoryRequest(
      {this.name, required super.pageNumber, required super.pageSize});
  Map<String, dynamic> toJson() => {
        'name': name,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
}

class SellCategory {
  Category category;
  double amount;
  double price;
  String extraDetails;

  double get totalPrice => price * amount;
  SellCategory({
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

  static SellCategory fromJson(Map<String, dynamic> json) => SellCategory(
        category: Category.fromJson(json['category']),
        amount: json['amount'],
        price: json['price'],
        extraDetails: json['extraDetails'],
      );
}
