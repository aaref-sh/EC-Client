import 'package:flutter/material.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/enums/server_enums.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/account.dart';
import 'package:tt/models/voucher.dart';

class AddVoucherScreen extends StatefulWidget {
  @override
  _AddVoucherScreenState createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  final _formKey = GlobalKey<FormState>();
  VoucherType? _selectedType;
  double? _value;
  int? fundAccountId;
  int? debitAccountId;

  bool loading = false;

  List<Account> suggestions = [];

  List<Account> fundSuggestions = [];

  @override
  void initState() {
    super.initState();
    loadFundSeggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<VoucherType>(
              value: _selectedType,
              onChanged: (VoucherType? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              items: VoucherType.values.map((VoucherType type) {
                return DropdownMenuItem<VoucherType>(
                  value: type,
                  child: Text(VoucherLabel(type)),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: resType,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: resValue),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _value = double.tryParse(value);
              },
            ),
            SearchField(
              onSearchTextChanged: (s) {
                return fundSuggestions
                    .where((e) => e.name.contains(s))
                    .map((e) => SearchFieldListItem(e.name, item: e))
                    .toList();
              },
              hint: resFund,
              onSuggestionTap: (item) {
                fundAccountId = item.item?.id;
              },
              emptyWidget: autoCompshitEmptyWidget(false),
              suggestions: fundSuggestions
                  .map((e) => SearchFieldListItem(e.name, item: e))
                  .toList(),
            ),
            SearchField(
              onSearchTextChanged: onSearchTextChanged,
              hint: resAccount,
              onSuggestionTap: (item) {
                debitAccountId = item.item?.id;
              },
              emptyWidget: autoCompshitEmptyWidget(loading),
              suggestions: getAccountSuggestions(),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_value != null &&
                    _value! > 1 &&
                    debitAccountId != null &&
                    fundAccountId != null) {
                  _formKey.currentState!.save();
                  // Here you can handle the submission, for example:
                  var request = CreateVoucherRequest(
                    type: _selectedType!,
                    value: _value!,
                    creditAccountId: fundAccountId!,
                    debitAccountId: debitAccountId!,
                  );
                  showLoadingPanel(context);
                  try {
                    var response = await sendPost("Voucher", request);
                    if (response.statusCode == 200) {
                      // clear fields
                      _value = null;
                      debitAccountId = null;
                      fundAccountId = null;
                      hideLoadingPanel(context);
                      Navigator.pop(context);
                      showErrorMessage(context, resDone);
                    } else {
                      hideLoadingPanel(context);
                      showErrorMessage(context, resError);
                    }
                  } catch (e) {
                    hideLoadingPanel(context);
                    showErrorMessage(context, resError);
                  }
                  // You would then pass this request to your API or data layer.
                }
              },
              child: Text(resAdd),
            ),
          ],
        ),
      ),
    );
  }

  List<SearchFieldListItem<Account>> getAccountSuggestions(
      {bool showFund = false}) {
    return suggestions
        .map((e) => SearchFieldListItem<Account>(e.name, item: e))
        .toList();
  }

  void loadFundSeggestions() {
    loading = true;
    var header = ListAccountRequest(level: 3, baseAccountId: 11);
    fetchFromServer(
            controller: "Account", fromJson: Account.fromJson, headers: header)
        .then((value) {
      setState(() {
        fundSuggestions = value;
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() => loading = false);
    });
  }

  List<SearchFieldListItem<Account>>? onSearchTextChanged(query,
      {int? baseAccountId}) {
    setState(() {
      debitAccountId = null;
      loading = true;
      suggestions = <Account>[];
    });
    var header = ListAccountRequest(
        accountName: query, level: 3, baseAccountId: baseAccountId);
    fetchFromServer(
            controller: "Account", fromJson: Account.fromJson, headers: header)
        .then((value) {
      setState(() {
        suggestions = value
            .where((x) => x.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        loading = false;
      });
      return suggestions
          .map((e) => SearchFieldListItem<Account>(e.name, item: e))
          .toList();
    }).onError((error, stackTrace) {
      setState(() => loading = false);
      return <SearchFieldListItem<Account>>[];
    });
    return null;
  }
}
