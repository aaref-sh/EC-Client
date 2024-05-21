import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/helpers/functions.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/enums/server_enums.dart';
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
              onSaved: (String? value) {
                _value = double.tryParse(value ?? '');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: resDebit),
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                debitAccountId = int.tryParse(value ?? '');
              },
            ),
            SearchField(
              onSearchTextChanged: onSearchTextChanged,
              hint: resCredit,
              onSuggestionTap: (item) {
                creditAccountId = item.item?.id;
              },
              emptyWidget: autoCompshitEmptyWidget(),
              suggestions: getAccountSuggestions(),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Here you can handle the submission, for example:
                  // var request = CreateVoucherRequest(
                  //   type: _selectedType!,
                  //   value: _value!,
                  //   creditAccountId: _creditAccountId!,
                  //   debitAccountId: _debitAccountId!,
                  // );
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

  List<SearchFieldListItem<Account>> getAccountSuggestions() {
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

  SizedBox autoCompshitEmptyWidget() {
    return SizedBox(
        height: 100,
        child: Center(
            child: !loading
                ? const Text("No data")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color:
                                  Colors.deepPurple[900]?.toMaterialColor())),
                      const SizedBox(width: 10),
                      const Text("Loading ...")
                    ],
                  )));
  }
}
