import 'package:flutter/material.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/voucher.dart';
import 'package:vtable/vtable.dart';

class Materiale {
  int id;
  String name;
  String code;
  String notes;
  String? tag;
  int? categoryId;
  String? categoryName;
  double? price;

  Materiale({
    required this.id,
    required this.name,
    required this.code,
    required this.notes,
    required this.categoryId,
    required this.categoryName,
    this.price,
    this.tag,
  });

  factory Materiale.fromJson(Map<String, dynamic> json) {
    return Materiale(
      id: json['id'],
      name: json['name'] as String,
      code: json['code'] as String,
      notes: json['notes'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      price: json['price'] as double?,
      tag: json['tag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'notes': notes,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'price': price,
      'tag': tag,
    };
  }

  static List<VTableColumn<Materiale>> columnConfigs(BuildContext context) {
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
        width: (width * 4 / 12).round() - 1,
        alignment: Alignment.center,
        transformFunction: (row) => row.name,
        compareFunction: (a, b) => a.name.compareTo(b.name),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: resCode,
        width: (width * 2 / 12).round(),
        alignment: Alignment.center,
        transformFunction: (row) => row.code,
        compareFunction: (a, b) => a.code.compareTo(b.code),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: resNotes,
        width: (width * 3 / 12).round(),
        alignment: Alignment.center,
        transformFunction: (row) => row.notes,
        compareFunction: (a, b) => a.notes.compareTo(b.notes),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: '',
        width: (width * 1 / 12).round(),
        alignment: Alignment.center,
        renderFunction: (context, object, out) {
          return GestureDetector(
              onTap: () {
                showBottomDrawer(context, object.id, "Material");
              },
              child: Icon(Icons.more_horiz));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }
}

class MaterialApiPagingRequest extends ApiRequest {
  String? name;
  String? code;
  MaterialApiPagingRequest({
    this.code,
    this.name,
  });

  // toJson method
  @override
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}

class PickMaterialRequest extends ApiRequest {
  String name;
  int? categoryId;
  PickMaterialRequest({required this.name, this.categoryId});
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'categpryId': categoryId,
      };
}

class PickMaterial {
  final int materialId;
  final String materialName;
  final int repositoryId;
  final String repositoryName;
  final int id;
  final String buyDate;
  final double amount;
  final double? unitPrice;

  PickMaterial({
    required this.materialId,
    required this.materialName,
    required this.repositoryId,
    required this.repositoryName,
    required this.id,
    required this.buyDate,
    required this.amount,
    required this.unitPrice,
  });

  factory PickMaterial.fromJson(Map<String, dynamic> json) {
    return PickMaterial(
      materialId: json['materialId'] as int,
      materialName: json['materialName'] as String,
      repositoryId: json['repositoryId'] as int,
      repositoryName: json['repositoryName'] as String,
      id: json['id'] as int,
      buyDate: json['buyDate'] as String,
      amount: json['amount'] as double,
      unitPrice: json['unitPrice'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'materialName': materialName,
      'repositoryId': repositoryId,
      'repositoryName': repositoryName,
      'id': id,
      'buyDate': buyDate,
      'amount': amount,
    };
  }
}
