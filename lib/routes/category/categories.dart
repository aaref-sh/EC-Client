import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/search_bar.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/category.dart';
import 'package:tt/routes/category/add_category.dart';
import 'package:vtable/vtable.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resCategories,
      child: FutureBuilder<List<Category>>(
          future: fetchRepositories(searchController.text),
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

  VTable createTable(List<Category> items) {
    return VTable<Category>(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddCategory());
            },
            icon: Icon(Icons.add))
      ],
      filterWidgets: [
        CustomSearchBar(
          controller: searchController,
          onSearchPressed: () => setState(() {}),
        )
      ],
      showToolbar: true,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: Category.columnConfigs(context),
    );
  }

  Future<List<Category>> fetchRepositories(String s) async {
    var header = ListCategoryRequest(name: s);
    return fetchFromServer(
        controller: 'Category', fromJson: Category.fromJson, headers: header);
  }
}
