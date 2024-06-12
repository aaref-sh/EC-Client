import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/search_bar.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/account.dart';
import 'package:tt/routes/debit_credit/add_account.dart';
import 'package:vtable/vtable.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  var searchController = TextEditingController();
  var list = <Account>[];
  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resAccounts,
      child: FutureBuilder<List<Account>>(
          future: fetchFromServer(
              controller: "Account",
              fromJson: Account.fromJson,
              headers: ListAccountRequest(accountName: searchController.text)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              list = snapshot.data!;
              return createTable(list);
            } else if (snapshot.hasError) {
              return createTable([]);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  VTable createTable(List<Account> items) {
    return VTable<Account>(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, const AddAccount());
            },
            icon: const Icon(Icons.add))
      ],
      filterWidgets: [
        CustomSearchBar(
          controller: searchController,
          onSearchPressed: () {
            setState(() {});
            // Define what should happen when the button is pressed
          },
        )
      ],
      showToolbar: true,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: Account.columnConfigs(context),
    );
  }
}
