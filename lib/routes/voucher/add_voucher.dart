import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/enums/server_enums.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
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
  int? creditAccountId;
  int? debitAccountId;

  bool loading = false;

  List<Account> suggestions = [];

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
              onSearchTextChanged: onSearchTextChanged,
              hint: resFund,
              onSuggestionTap: (item) {
                debitAccountId = item.item?.id;
              },
              emptyWidget: autoCompshitEmptyWidget(loading),
              suggestions: getAccountSuggestions(showFund: true),
            ),
            SearchField(
              onSearchTextChanged: onSearchTextChanged,
              hint: resAccount,
              onSuggestionTap: (item) {
                creditAccountId = item.item?.id;
              },
              emptyWidget: autoCompshitEmptyWidget(loading),
              suggestions: getAccountSuggestions(),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_value != null &&
                    _value! > 1 &&
                    debitAccountId != null &&
                    creditAccountId != null) {
                  _formKey.currentState!.save();
                  // Here you can handle the submission, for example:
                  var request = CreateVoucherRequest(
                    type: _selectedType!,
                    value: _value!,
                    creditAccountId: creditAccountId!,
                    debitAccountId: debitAccountId!,
                  );
                  showLoadingPanel(context);
                  try {
                    var response = await sendPost("Voucher", request);
                    if (response.statusCode == 200) {
                      // clear fields
                      _value = null;
                      debitAccountId = null;
                      creditAccountId = null;

                      hideLoadingPanel(context);
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

  List<SearchFieldListItem<Account>>? onSearchTextChanged(query) {
    setState(() {
      debitAccountId = null;
      loading = true;
      suggestions = <Account>[];
    });
    var dio = Dio();
    var header = ListAccountRequest(name: query, pageNumber: 1, pageSize: 10);
    dio
        .get("${host}Account/List", options: Options(headers: header.toJson()))
        .then((value) {
      var response =
          ApiPagingResponse<Account>.fromJson(value.data, Account.fromJson);
      setState(() {
        suggestions = response.data
                ?.where(
                    (x) => x.name.toLowerCase().contains(query.toLowerCase()))
                .toList() ??
            <Account>[];
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
