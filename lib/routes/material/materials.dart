import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/search_bar.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/material.dart';
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
          future: fetchFromServer(
              controller: "Material",
              fromJson: Materiale.fromJson,
              headers: MaterialApiPagingRequest(pageNumber: 1, pageSize: 10)),
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
}
