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
  int? categoryId;
  String? categoryName;

  Materiale({
    required this.id,
    required this.name,
    required this.code,
    required this.notes,
    required this.categoryId,
    required this.categoryName,
  });

  factory Materiale.fromJson(Map<String, dynamic> json) {
    return Materiale(
      id: json['id'],
      name: json['name'] as String,
      code: json['code'] as String,
      notes: json['notes'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
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

class MaterialApiPagingRequest extends ApiPagingRequest {
  String? name;
  String? code;
  MaterialApiPagingRequest(
      {this.code,
      this.name,
      required super.pageNumber,
      required super.pageSize});

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}
