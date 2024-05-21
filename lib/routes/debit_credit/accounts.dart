import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/account.dart';
import 'package:tt/models/repository.dart';
import 'package:tt/models/voucher.dart';
import 'package:tt/routes/debit_credit/add_account.dart';
import 'package:vtable/vtable.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resVouchers,
      child: FutureBuilder<List<Account>>(
          future: fetchAccounts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return createTable(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
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
              showDialogBox(context, AddAccount());
            },
            icon: Icon(Icons.add))
      ],
      filterWidgets: [
        CustomSearchBar(
          onSearchPressed: () {
            // Define what should happen when the button is pressed
            print('Search button was pressed!');
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

  Future<List<Account>>? fetchAccounts() async {
    var dio = Dio();
    var paging = RepositoryApiPagingRequest(pageNumber: 1, pageSize: 10);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ';
    dio.options.headers.addAll(paging.toJson());

    var response = await dio.get("${host}Account/List");
    var data = ApiPagingResponse.fromJson(response.data, Account.fromJson);
    return data.data!;
  }
}

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onSearchPressed;

  CustomSearchBar({required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearchPressed,
          ),
        ),
      ),
    );
  }
}
