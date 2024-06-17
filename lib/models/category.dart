import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/bottom_sheet.dart';
import 'package:tt/components/gap.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/voucher.dart';
import 'package:vtable/vtable.dart';

class Category {
  int id;
  String name;
  int? baseCategoryId;
  String? baseCategoryName;
  Category({
    this.id = -1,
    required this.name,
    this.baseCategoryId,
    this.baseCategoryName,
  });
  @override
  String toString() => name;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baseCategoryId': baseCategoryId,
      };

  static Category fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        baseCategoryId: json['baseCategoryId'],
        baseCategoryName: json['baseCategoryName'],
      );
  static List<Category> fromJsonList(List<Map<String, dynamic>> json) {
    List<Category> categories = [];
    for (var i = 0; i < json.length; i++) {
      categories.add(Category.fromJson(json[i]));
    }
    return categories;
  }

  static List<VTableColumn<Category>> columnConfigs(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return [
      VTableColumn(
        label: '#',
        width: (width * 2 / 12).round(),
        alignment: Alignment.center,
        transformFunction: (row) => (row.id).toString(),
        compareFunction: (a, b) => a.id.compareTo(b.id),
        icon: Icons.numbers,
      ),
      VTableColumn(
        label: resName,
        width: (width * 5 / 12).round() - 1,
        alignment: Alignment.center,
        transformFunction: (row) => row.name,
        compareFunction: (a, b) => a.name.compareTo(b.name),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: resBaseCategory,
        width: (width * 4 / 12).round(),
        alignment: Alignment.center,
        transformFunction: (row) => row.baseCategoryName ?? "",
        compareFunction: (a, b) =>
            (a.baseCategoryName ?? "").compareTo(b.baseCategoryName ?? ""),
        // validators: [SampleRowData.validateGravity],
      ),
      VTableColumn(
        label: '',
        width: (width * 1 / 12).round(),
        alignment: Alignment.center,
        renderFunction: (context, object, out) {
          return GestureDetector(
              onTap: () {
                showBottomDrawer(context, object.id, "Category", obj: object);
              },
              child: Icon(Icons.more_horiz));
        },
        // validators: [SampleRowData.validateGravity],
      ),
    ];
  }

  Widget editDialog(BuildContext context) => CategoryEditDialog(item: this);
}

class CategoryEditDialog extends StatefulWidget {
  final Category item;
  const CategoryEditDialog({super.key, required this.item});

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  late TextEditingController name;

  var loading = false;
  int? baseCategoryId;
  var suggestions = <Category>[];

  @override
  initState() {
    super.initState();
    name = TextEditingController(text: widget.item.name);
    baseCategoryId = widget.item.baseCategoryId;

    fetchFromServer(controller: 'Category', fromJson: Category.fromJson).then(
        (v) => setState(() =>
            suggestions = v.where((x) => x.id != widget.item.id).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: resName),
          controller: name,
        ),
        SearchField(
            onSearchTextChanged: searchTextChange,
            hint: resBaseAccount,
            onSuggestionTap: (item) {
              baseCategoryId = item.item?.id;
            },
            controller: TextEditingController(
                text: suggestions
                    .where((a) => a.id == baseCategoryId)
                    .firstOrNull
                    ?.name),
            emptyWidget: autoCompshitEmptyWidget(loading),
            suggestions: getAccountSuggestions()),
        gap(5),
        ElevatedButton(
            onPressed: () async {
              // fields validation
              if (name.text.isEmpty) {
                showErrorMessage(context, resAllFieldsRequired);
                return;
              }
              widget.item.name = name.text;
              widget.item.baseCategoryId = baseCategoryId;
              try {
                showLoadingPanel(context);
                var response = await sendPut('Category', widget.item);
                if (response.statusCode == 200) {
                  hideLoadingPanel(context);
                  hideLoadingPanel(context);
                  showErrorMessage(context, resDone);
                }
              } catch (e) {
                hideLoadingPanel(context);
                showErrorMessage(context, resError);
              }
            },
            child: Text(resSave))
      ],
    );
  }

  List<SearchFieldListItem<Category>> getAccountSuggestions() {
    return suggestions
        .map((e) => SearchFieldListItem<Category>(e.name, item: e))
        .toList();
  }

  List<SearchFieldListItem<Category>>? searchTextChange(String query) {
    suggestions = suggestions.where((e) => e.name.contains(query)).toList();
    return getAccountSuggestions();
  }
}

class ListCategoryRequest extends ApiRequest {
  String? name;
  int? baseCategoryId;
  ListCategoryRequest({this.name, this.baseCategoryId});
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'baseCategoryId': baseCategoryId,
      };
}

class SellCategory {
  Category category;
  double amount;
  double price;
  String extraDetails;

  double get totalPrice => price * amount;
  SellCategory({
    required this.category,
    required this.amount,
    required this.price,
    required this.extraDetails,
  });

  Map<String, dynamic> toJson() => {
        'category': category.toJson(),
        'amount': amount,
        'price': price,
        'extraDetails': extraDetails,
      };

  static SellCategory fromJson(Map<String, dynamic> json) => SellCategory(
        category: Category.fromJson(json['category']),
        amount: json['amount'],
        price: json['price'],
        extraDetails: json['extraDetails'],
      );
}
