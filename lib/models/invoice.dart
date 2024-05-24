import 'package:tt/enums/main_account_enum.dart';

class Item {
  int amount;
  double unitPrice;
  double discount;
  String notes;
  int materialId;
  String materialName;

  Item({
    required this.amount,
    required this.unitPrice,
    required this.discount,
    required this.notes,
    required this.materialId,
    this.materialName = "",
  });
  double get totalPrice => unitPrice * amount - discount;
  factory Item.fromJson(Map<String, dynamic> json) => Item(
        amount: json['amount'],
        unitPrice: json['unitPrice'].toDouble(),
        discount: json['discount'].toDouble(),
        notes: json['notes'],
        materialId: json['materialId'],
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'unitPrice': unitPrice,
        'discount': discount,
        'notes': notes,
        'materialId': materialId,
      };
}

class XItem {
  String materialName;
  String category;
  int amount;
  double unitPrice;
  double discount;
  String notes;

  double get totalPrice => unitPrice * amount - discount;
  XItem({
    required this.materialName,
    required this.category,
    required this.amount,
    required this.unitPrice,
    required this.discount,
    required this.notes,
  });

  factory XItem.fromJson(Map<String, dynamic> json) => XItem(
        materialName: json['materialName'],
        category: json['category'],
        amount: json['amount'],
        unitPrice: json['unitPrice'].toDouble(),
        discount: json['discount'].toDouble(),
        notes: json['notes'],
      );

  Map<String, dynamic> toJson() => {
        'materialName': materialName,
        'category': category,
        'amount': amount,
        'unitPrice': unitPrice,
        'discount': discount,
        'notes': notes,
      };
}

class Invoice {
  InvoiceType type;
  String notes;
  double discount;
  PayType payType;
  int clientAccountId;
  int cashAccountId;
  List<Item> items;
  List<XItem> xItems;

  Invoice({
    required this.type,
    required this.notes,
    required this.discount,
    required this.payType,
    required this.clientAccountId,
    required this.cashAccountId,
    required this.items,
    required this.xItems,
  });

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'notes': notes,
        'discount': discount,
        'payType': payType.index,
        'clientAccountId': clientAccountId,
        'cashAccountId': cashAccountId,
        'items': List<Map<String, dynamic>>.from(items.map((x) => x.toJson())),
        'xItems':
            List<Map<String, dynamic>>.from(xItems.map((x) => x.toJson())),
      };
}
