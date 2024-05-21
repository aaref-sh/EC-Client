import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/account.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/models/voucher.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  var nameController = TextEditingController();
  var notesController = TextEditingController();
  int? baseAccountId;
  var suggestions = <Account>[];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard by removing focus from the text field
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: resName),
            controller: nameController,
          ),
          SearchField(
            onSearchTextChanged: onSearchTextChanged,
            hint: resBaseAccount,
            onSuggestionTap: (item) {
              baseAccountId = item.item?.id;
            },
            emptyWidget: autoCompshitEmptyWidget(),
            suggestions: getAccountSuggestions(),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: resNotes),
            controller: notesController,
          ),
          const SizedBox(height: 5),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                var dio = Dio();
                dio.options.headers['Authorization'] = 'Bearer ';
                dio.options.headers['Content-Type'] = 'application/json';
                var cat = Account(
                    id: -1,
                    name: nameController.text,
                    notes: notesController.text,
                    baseAccountId: baseAccountId);
                try {
                  var response =
                      await dio.post("${host}Account/Create", data: cat);
                  if (response.statusCode == 200) {
                    nameController.text = notesController.text = '';
                    baseAccountId = null;

                    var cat = response.data;
                    hideLoadingPanel(context);
                    showErrorMessage(context, resDone);
                  }
                } catch (e) {
                  // show toast error message
                  hideLoadingPanel(context);
                  showErrorMessage(context, resError);

                  print(e);
                }
              },
              child: Text(resAdd))
        ],
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
      baseAccountId = null;
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
