import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/category.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/models/voucher.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  int? _parentCategory;
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
            onTapOutside: (e) => FocusManager.instance.primaryFocus?.unfocus(),
            onSearchTextChanged: onSearchTextChanged,
            hint: 'التصنيف الأب',
            onSuggestionTap: (item) {
              _parentCategory = item.item?.id;
            },
            emptyWidget: autoCompshitEmptyWidget(loading),
            suggestions: suggestions
                .map((e) => SearchFieldListItem<Category>(e.name, item: e))
                .toList(),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                var dio = Dio();
                dio.options.headers['Authorization'] = 'Bearer ';
                dio.options.headers['Content-Type'] = 'application/json';
                var cat = Category(
                    name: nameController.text, baseCategoryId: _parentCategory);
                showLoadingPanel(context);
                try {
                  var response =
                      await dio.post("${host}Category/Create", data: cat);
                  if (response.statusCode == 200) {
                    hideLoadingPanel(context);
                    hideLoadingPanel(context);
                    showErrorMessage(context, resDone);
                  }
                } catch (e) {
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

  List<SearchFieldListItem<Category>>? onSearchTextChanged(query) {
    setState(() {
      _parentCategory = null;
      loading = true;
      suggestions = <Category>[];
    });
    var dio = Dio();
    var header = ListCategoryRequest(name: query);
    dio
        .get(
      "${host}Category/List",
      options: Options(
        headers: {"request": header.toJson()},
      ),
    )
        .then((value) {
      var response =
          ApiPagingResponse<Category>.fromJson(value.data, Category.fromJson);
      setState(() {
        suggestions = response.data
                ?.where(
                    (x) => x.name.toLowerCase().contains(query.toLowerCase()))
                .toList() ??
            <Category>[];
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
