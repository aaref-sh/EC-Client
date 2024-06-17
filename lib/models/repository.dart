import 'package:flutter/material.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/components/gap.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/neteork_helper.dart';
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
                showBottomDrawer(context, object.id, "Repository", obj: object);
              },
              child: Icon(Icons.more_horiz));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }

  Widget editDialog(BuildContext context) => RepositoryEditDialog(item: this);
}

class RepositoryEditDialog extends StatefulWidget {
  final Repository item;
  const RepositoryEditDialog({super.key, required this.item});
  @override
  State<RepositoryEditDialog> createState() => _RepositoryEditDialogState();
}

class _RepositoryEditDialogState extends State<RepositoryEditDialog> {
  late TextEditingController name;
  late TextEditingController notes;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.item.name);
    notes = TextEditingController(text: widget.item.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: resName),
          controller: name,
        ),
        TextField(
          decoration: InputDecoration(labelText: resNotes),
          controller: notes,
        ),
        gap(5),
        ElevatedButton(
            onPressed: () async {
              // fields validation
              if (name.text.isEmpty) {
                showErrorMessage(context, resAllFieldsRequired);
                return;
              }
              widget.item.notes = notes.text;
              widget.item.name = name.text;
              try {
                showLoadingPanel(context);
                var response = await sendPut('Repository', widget.item);
                if (response.statusCode == 200) {
                  hideLoadingPanel(context);
                  Navigator.pop(context);
                  showErrorMessage(context, resDone);
                }
              } catch (e) {
                hideLoadingPanel(context);
                showErrorMessage(context, resError);
              }
            },
            child: Text(resSave))
      ],
    );
  }
}

class RepositoryApiPagingRequest extends ApiRequest {
  String? name;

  RepositoryApiPagingRequest({this.name});

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
