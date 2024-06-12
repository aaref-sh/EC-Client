import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/search_bar.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/repository.dart';
import 'package:tt/routes/repository/add_repository.dart';
import 'package:vtable/vtable.dart';

class Repositories extends StatefulWidget {
  const Repositories({super.key});

  @override
  State<Repositories> createState() => _RepositoriesState();
}

class _RepositoriesState extends State<Repositories> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resRepos,
      child: FutureBuilder<List<Repository>>(
          future: fetchFromServer<Repository>(
              controller: "Repository",
              fromJson: Repository.fromJson,
              headers: RepositoryApiPagingRequest(name: searchController.text)),
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

  VTable createTable(List<Repository> items) {
    return VTable<Repository>(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddRepository());
            },
            icon: Icon(Icons.add))
      ],
      filterWidgets: [
        CustomSearchBar(
          controller: searchController,
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
      columns: Repository.columnConfigs(context),
    );
  }
}
