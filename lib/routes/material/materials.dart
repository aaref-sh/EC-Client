import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/search_bar.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/material.dart';
import 'package:tt/models/repository.dart';
import 'package:tt/models/voucher.dart';
import 'package:tt/routes/material/add_material.dart';
import 'package:vtable/vtable.dart';

class Materials extends StatefulWidget {
  const Materials({super.key});

  @override
  State<Materials> createState() => _MaterialsState();
}

class _MaterialsState extends State<Materials> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resMaterials,
      child: FutureBuilder<List<Materiale>>(
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

  VTable createTable(List<Materiale> items) {
    return VTable<Materiale>(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddMaterial());
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
      columns: Materiale.columnConfigs(context),
    );
  }

  Future<List<Materiale>>? fetchRepositories() async {
    var dio = Dio();
    var paging = RepositoryApiPagingRequest(pageNumber: 1, pageSize: 10);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ';
    dio.options.headers.addAll(paging.toJson());

    var response = await dio.get("${host}Material/List");
    var data = ApiPagingResponse.fromJson(response.data, Materiale.fromJson);
    return data.data!;
  }
}
