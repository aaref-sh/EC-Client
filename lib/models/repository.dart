import 'package:flutter/material.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/voucher.dart';
import 'package:vtable/vtable.dart';

class Repository {
  int id;
  String name;
  String? notes;
  Repository({this.id = -1, required this.name, this.notes});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'notes': notes,
      };

  static Repository fromJson(Map<String, dynamic> json) => Repository(
        id: json['id'],
        name: json['name'],
        notes: json['notes'],
      );

  static List<VTableColumn<Repository>> columnConfigs(BuildContext context) {
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
                showBottomDrawer(context, object.id, "Repository");
              },
              child: Icon(Icons.more_horiz));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }
}

class RepositoryApiPagingRequest extends ApiPagingRequest {
  RepositoryApiPagingRequest(
      {required super.pageNumber, required super.pageSize});

  Map<String, dynamic> toJson() =>
      {"pageNumber": pageNumber, "pageSize": pageSize};
}
