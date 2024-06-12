import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/category.dart';
import 'package:tt/models/material.dart' as models;
import 'package:tt/helpers/functions.dart';
import 'package:tt/models/voucher.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AddMaterial extends StatefulWidget {
  const AddMaterial({super.key});

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  var nameController = TextEditingController();
  var notesController = TextEditingController();
  var codeController = TextEditingController();
  int? categoryId;
  String? categoryName;
  var suggestions = <Category>[];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: resName),
            controller: nameController,
          ),
          SearchField(
            onSearchTextChanged: onSearchTextChanged,
            hint: resCategory,
            onSuggestionTap: (item) {
              categoryName = null;
              categoryId = item.item?.id;
            },
            emptyWidget: autoCompshitEmptyWidget(loading),
            suggestions: getCategorySuggestions(),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: resNotes),
            controller: notesController,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: resCode),
            controller: codeController,
          ),
          const SizedBox(height: 5),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                var cat = models.Materiale(
                    id: -1,
                    name: nameController.text,
                    categoryId: categoryId,
                    categoryName: categoryName,
                    notes: notesController.text,
                    code: codeController.text);
                try {
                  var response = await sendPost("Material", cat);
                  if (response.statusCode == 200) {
                    nameController.text = notesController.text = '';
                    codeController.text = categoryName = '';
                    categoryId = null;

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

  List<SearchFieldListItem<Category>> getCategorySuggestions() {
    return suggestions
        .map((e) => SearchFieldListItem<Category>(e.name, item: e))
        .toList();
  }

  List<SearchFieldListItem<Category>>? onSearchTextChanged(String query) {
    setState(() {
      categoryName = query;
      categoryId = null;
      loading = true;
      suggestions = <Category>[];
    });
    var header = ListCategoryRequest(name: query, pageNumber: 1, pageSize: 7);
    fetchFromServer(
            controller: "Category",
            fromJson: Category.fromJson,
            headers: header)
        .then((value) {
      setState(() {
        suggestions = value
            .where((x) => x.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        loading = false;
      });
      return suggestions
          .map((e) => SearchFieldListItem<Category>(e.name, item: e))
          .toList();
    }).onError((error, stackTrace) {
      setState(() => loading = false);
      return <SearchFieldListItem<Category>>[];
    });
    return null;
  }
}
