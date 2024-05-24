import 'package:flutter/material.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/voucher.dart';
import 'package:vtable/vtable.dart';

class Account {
  int id;
  String name;
  String? notes;
  int? baseAccountId;
  bool isLeaf;
  Account(
      {required this.id,
      required this.name,
      this.notes,
      this.baseAccountId,
      this.isLeaf = true});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      name: json['name'] as String,
      notes: json['notes'] as String?,
      baseAccountId: json['baseAccountId'] as int?,
      isLeaf: json['isLeaf'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'baseAccountId': baseAccountId,
      'isLeaf': isLeaf,
    };
  }

  static List<VTableColumn<Account>> columnConfigs(BuildContext context) {
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
        label: resNotes,
        width: (width * 4 / 12).round(),
        alignment: Alignment.center,
        transformFunction: (row) => row.notes ?? "",
        compareFunction: (a, b) => (a.notes ?? "").compareTo(b.notes ?? ""),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: '',
        width: (width * 1 / 12).round(),
        alignment: Alignment.center,
        renderFunction: (context, object, out) {
          return GestureDetector(
              onTap: () {
                showBottomDrawer(context, object.id, "Account",
                    withDelete: false);
              },
              child: Icon(Icons.more_vert));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }
}

class ListAccountRequest extends ApiPagingRequest {
  String name;
  int? type;
  int? baseAccountId;

  // constructor
  ListAccountRequest(
      {required this.name,
      this.type,
      this.baseAccountId,
      required super.pageNumber,
      required super.pageSize});

  // toJson method
  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "baseAccountId": baseAccountId,
        "pageNumber": pageNumber,
        "pageSize": pageSize
      };
}
