import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/repository.dart';
import 'package:tt/models/voucher.dart';
import 'package:tt/routes/repository/add_repository.dart';
import 'package:vtable/vtable.dart';

class Repositories extends StatefulWidget {
  const Repositories({super.key});

  @override
  State<Repositories> createState() => _RepositoriesState();
}

class _RepositoriesState extends State<Repositories> {
  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resRepos,
      child: FutureBuilder<List<Repository>>(
          future: fetchRepositories(),
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
      filterWidgets: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddRepository());
            },
            icon: Icon(Icons.add))
      ],
      actions: const [Icon(Icons.delete)],
      showToolbar: true,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: Repository.columnConfigs(context),
    );
  }

  Future<List<Repository>>? fetchRepositories() async {
    var dio = Dio();
    var paging = RepositoryApiPagingRequest(pageNumber: 1, pageSize: 10);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ';
    dio.options.headers.addAll(paging.toJson());

    var response = await dio.get("${host}Repository/List");
    var data = ApiPagingResponse.fromJson(response.data, Repository.fromJson);
    return data.data!;
  }
}
