import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/category.dart';
import 'package:tt/models/repository.dart';
import 'package:tt/models/voucher.dart';
import 'package:tt/routes/category/add_category.dart';
import 'package:vtable/vtable.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resCategories,
      child: FutureBuilder<List<Category>>(
          future: fetchRepositories("Category", Category.fromJson),
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
      filterWidgets: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddCategory());
            },
            icon: Icon(Icons.add))
      ],
      actions: const [Icon(Icons.delete)],
      showToolbar: true,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: Category.columnConfigs(context),
    );
  }

  Future<List<T>>? fetchRepositories<T>(
      String controller, T Function(Map<String, dynamic>) create) async {
    var paging = RepositoryApiPagingRequest(pageNumber: 1, pageSize: 10);
    ApiPagingResponse<T> data =
        await fetchDataFromServer(paging, controller, create);
    return data.data!;
  }

  Future<ApiPagingResponse<T>> fetchDataFromServer<T>(
      RepositoryApiPagingRequest paging,
      String controller,
      T Function(Map<String, dynamic>) create) async {
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ';
    dio.options.headers.addAll(paging.toJson());

    var response = await dio.get("${host}${controller}/List");
    var data = ApiPagingResponse.fromJson(response.data, create);
    return data;
  }
}
