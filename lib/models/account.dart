import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/components/gap.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/voucher.dart';
import 'package:vtable/vtable.dart';

class Account {
  int id;
  String? type;
  String name;
  String? notes;
  int? baseAccountId;
  Account(
      {required this.id,
      required this.name,
      this.notes,
      this.type,
      this.baseAccountId});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      type: json['type'],
      name: json['name'] as String,
      notes: json['notes'] as String?,
      baseAccountId: json['baseAccountId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'notes': notes,
      'baseAccountId': baseAccountId,
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
                    withDelete: false, obj: object);
              },
              child: Icon(Icons.more_vert));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }

  Widget editDialog(BuildContext context) => AccountEditDialog(item: this);
}

class AccountEditDialog extends StatefulWidget {
  final Account item;
  const AccountEditDialog({super.key, required this.item});

  @override
  State<AccountEditDialog> createState() => _AccountEditDialogState();
}

class _AccountEditDialogState extends State<AccountEditDialog> {
  late TextEditingController name;
  late TextEditingController notes;
  var loading = false;
  int? baseAccountId;
  var isOrganizal = false;
  var suggestions = <Account>[];

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.item.name);
    notes = TextEditingController(text: widget.item.notes);
    baseAccountId = widget.item.baseAccountId;
    isOrganizal = baseAccounts.any(
        (e) => e.id == widget.item.id || e.baseAccountId == widget.item.id);
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
        if (!isOrganizal)
          SearchField(
              onSearchTextChanged: searchTextChange,
              hint: resBaseAccount,
              onSuggestionTap: (item) {
                baseAccountId = item.item?.id;
              },
              controller: TextEditingController(
                  text: baseAccounts
                      .where((a) => a.id == baseAccountId)
                      .firstOrNull
                      ?.name),
              emptyWidget: autoCompshitEmptyWidget(loading),
              suggestions: getAccountSuggestions()),
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
              widget.item.baseAccountId = baseAccountId;
              try {
                showLoadingPanel(context);
                var response = await sendPut('Account', widget.item);
                if (response.statusCode == 200) {
                  hideLoadingPanel(context);
                  hideLoadingPanel(context);
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

  List<SearchFieldListItem<Account>> getAccountSuggestions() {
    return suggestions
        .map((e) => SearchFieldListItem<Account>(e.name, item: e))
        .toList();
  }

  List<SearchFieldListItem<Account>>? searchTextChange(String query) {
    suggestions = baseAccounts
        .where((e) =>
            e.type == widget.item.type &&
            e.baseAccountId != null &&
            e.name.contains(query))
        .toList();
    return getAccountSuggestions();
  }
}

class ListAccountRequest extends ApiRequest {
  String? accountName;
  int? type;
  int? baseAccountId;
  int? level;
  // constructor
  ListAccountRequest({
    this.accountName,
    this.level,
    this.type,
    this.baseAccountId,
  });

  // toJson method
  @override
  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "type": type,
        "baseAccountId": baseAccountId,
        'level': level,
      };
}
