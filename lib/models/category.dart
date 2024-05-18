import 'package:tt/models/category_group.dart';
import 'package:tt/models/voucher.dart';

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
