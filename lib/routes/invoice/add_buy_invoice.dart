import 'package:collection/collection.dart';
import 'package:tt/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/gap.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/enums/main_account_enum.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/account.dart';
import 'package:tt/models/invoice.dart';
import 'package:tt/models/material.dart';
import 'package:tt/models/repository.dart';
import 'package:vtable/vtable.dart';

class AddBuyInvoice extends StatefulWidget {
  const AddBuyInvoice({super.key});

  @override
  State<AddBuyInvoice> createState() => _AddBuyInvoiceState();
}

Invoice newInvoice = Invoice(
  type: InvoiceType.buy,
  notes: "",
  discount: 0,
  payType: PayType.direct,
  clientAccountId: 0,
  cashAccountId: 0,
  repositoryId: 0,
  items: [],
  xItems: [],
);

class _AddBuyInvoiceState extends State<AddBuyInvoice> {
  var searchController = TextEditingController();
  var discountController = TextEditingController(text: '0');
  var funds = <Account>[];
  var debits = <Account>[];
  var repos = <Repository>[];
  var loading = false;
  @override
  void initState() {
    super.initState();
    loadFundSeggestions(context, 11).then((value) => funds = value);
    loadFundSeggestions(context, 21).then((value) => debits = value);
    loadRepos(context);
  }

  Future<List<Account>> loadFundSeggestions(context, int baseAccountId) async {
    var header = ListAccountRequest(level: 3, baseAccountId: baseAccountId);
    try {
      return await fetchFromServer(
          controller: 'Account', fromJson: Account.fromJson, headers: header);
    } catch (e) {
      showErrorMessage(context, resCantAccessServer);
      return [];
    }
  }

  void loadRepos(context) async {
    var header = RepositoryApiPagingRequest();
    try {
      fetchFromServer(
              controller: 'Repository',
              fromJson: Repository.fromJson,
              headers: header)
          .then((value) => repos = value);
    } catch (e) {
      showErrorMessage(context, resCantAccessServer);
    }
  }

  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resNewInvoice,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    searchInputDecoration:
                        const InputDecoration(labelText: resFund),
                    suggestions: funds
                        .map((e) => SearchFieldListItem(e.name, item: e))
                        .toList(),
                    onSearchTextChanged: (s) {
                      newInvoice.cashAccountId = 0;
                      return null;
                    },
                    onSuggestionTap: (e) {
                      newInvoice.cashAccountId = e.item!.id;
                    },
                  ),
                ),
                gap(4),
                Expanded(
                  child: SearchField(
                    onSearchTextChanged: (s) {
                      newInvoice.clientAccountId = 0;
                      return debits
                          .where((e) => e.name.contains(s))
                          .map((e) => SearchFieldListItem(e.name, item: e))
                          .toList();
                    },
                    onSuggestionTap: (e) {
                      newInvoice.clientAccountId = e.item!.id;
                    },
                    searchInputDecoration:
                        const InputDecoration(labelText: resAccount),
                    suggestions: debits
                        .map((e) => SearchFieldListItem(e.name, item: e))
                        .toList(),
                  ),
                ),
                gap(4),
                Expanded(
                  child: SearchField(
                    onSearchTextChanged: (s) {
                      newInvoice.repositoryId = 0;
                      return repos
                          .where((e) => e.name.contains(s))
                          .map((e) => SearchFieldListItem(e.name, item: e))
                          .toList();
                    },
                    onSuggestionTap: (e) {
                      newInvoice.repositoryId = e.item!.id;
                    },
                    searchInputDecoration:
                        const InputDecoration(labelText: resRepo),
                    suggestions: repos
                        .map((e) => SearchFieldListItem(e.name, item: e))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: createTable()),
          Container(
            color: Colors.deepPurpleAccent[100]!.withAlpha(10),
            // padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text(resCashe),
                    Checkbox(
                        value: newInvoice.payType == PayType.direct,
                        onChanged: (v) {
                          setState(() {
                            newInvoice.payType =
                                v ?? false ? PayType.direct : PayType.latter;
                          });
                        }),
                  ],
                ),
                Row(
                  children: [
                    const Text('الحسم:'),
                    gap(2),
                    Container(
                      width: 80,
                      child: TextField(
                        controller: discountController,
                        onChanged: (x) => setState(() {
                          newInvoice.discount = double.parse(x);
                        }),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                Text((newInvoice.items.map((e) => e.totalPrice).sum +
                        newInvoice.xItems.map((e) => e.totalPrice).sum -
                        (int.tryParse(discountController.text) ?? 0))
                    .toString()),
                ElevatedButton(
                    onPressed: addNewBuyInvoice, child: const Text(resSave))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> addNewBuyInvoice() async {
    try {
      showLoadingPanel(context);
      var response =
          await sendPost("Invoice", newInvoice, action: "CreatePurchase");
      if (response.statusCode == 200) {
        hideLoadingPanel(context);
        showErrorMessage(context, resDone);
      }
    } catch (e) {
      hideLoadingPanel(context);
      showErrorMessage(context, resError);
    }
  }

  VTable createTable() {
    var width = MediaQuery.of(context).size.width;
    return VTable(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, const AddInvoiceItem());
            },
            icon: const Icon(Icons.add))
      ],
      filterWidgets: [],
      showToolbar: true,
      items: [...newInvoice.items, ...newInvoice.xItems],
      tableDescription:
          '${[...newInvoice.items, ...newInvoice.xItems].length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: [
        // VTableColumn(
        //   label: '#',
        //   width: (width * 2 / 12).round() - 1,
        //   alignment: Alignment.center,
        //   transformFunction: (row) => (row.id).toString(),
        //   compareFunction: (a, b) => a.id.compareTo(b.id),
        //   icon: Icons.numbers,
        // ),
        VTableColumn(
          label: resMaterial,
          width: (width * 4.5 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => row.materialName,
          compareFunction: (a, b) => a.materialName.compareTo(b.materialName),
        ),
        VTableColumn(
          label: resQuantity,
          width: (width * 2.5 / 12).round() - 1,
          alignment: Alignment.center,
          transformFunction: (row) => row.amount.toString(),
          compareFunction: (a, b) => a.amount.compareTo(b.amount),
        ),
        VTableColumn(
          label: resTotalPrice,
          width: (width * 4 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => row.totalPrice.toString(),
          compareFunction: (a, b) => a.totalPrice.compareTo(b.totalPrice),
        ),
        VTableColumn(
          label: '',
          width: (width * 1 / 12).round(),
          renderFunction: (context, object, out) {
            return GestureDetector(
                onTap: () {
                  showBottomSheet(object);
                },
                child: const Icon(Icons.more_vert));
          },
        ),
      ],
    );
  }

  void showBottomSheet(object) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Here you can return any widget that you want to show in the bottom drawer.
        return Container(
          height: 200,
          child: Column(
            children: [
              const Text("", style: TextStyle(fontSize: 20)),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text(
                  resDelete,
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    newInvoice.items.remove(object);
                    newInvoice.xItems.remove(object);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text(
                  resEdit,
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  showDialogBox(context, AddInvoiceItem(item: object));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddInvoiceItem extends StatefulWidget {
  final dynamic item;
  const AddInvoiceItem({super.key, this.item});

  @override
  State<AddInvoiceItem> createState() => _AddInvoiceItemState();
}

class _AddInvoiceItemState extends State<AddInvoiceItem> {
  bool loading = false;
  Materiale? material;
  dynamic item;
  late final bool isX;
  var suggestions = <Materiale>[];

  late TextEditingController searchController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController unitPriceController;
  late TextEditingController notesController;
  var totalPriceController = TextEditingController();

  bool showCategoryField = false;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    isX = widget.item is XItem;
    if (isX) {}
    showCategoryField = isX;
    material = isX || item == null
        ? null
        : Materiale(
            id: item.materialId,
            code: '',
            name: item.materialName,
            notes: '',
            categoryId: null,
            categoryName: '');
    searchController = TextEditingController(text: item?.materialName);
    categoryController = TextEditingController(text: isX ? item?.category : '');

    unitPriceController =
        TextEditingController(text: item?.unitPrice?.toString());
    quantityController = TextEditingController(text: item?.amount?.toString());
    notesController = TextEditingController(text: item?.notes);
  }

  @override
  Widget build(BuildContext context) {
    showCategoryField = item != null
        ? showCategoryField
        : searchController.text.isNotEmpty && material == null;

    return Column(
      children: [
        SearchField(
          controller: searchController,
          searchInputDecoration: const InputDecoration(labelText: resMaterial),
          onSearchTextChanged: onSearchTextChanged,
          onSuggestionTap: (item) {
            setState(() => material = item.item);
            unitPriceController.text = (item.item?.price ?? 0).toString();
            totalPriceController.text = calculateTotalPrice().toString();
          },
          emptyWidget: autoCompshitEmptyWidget(loading),
          suggestions: getAccountSuggestions(),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              child: child,
            );
          },
          child: showCategoryField
              ? TextField(
                  decoration: const InputDecoration(labelText: resCategory),
                  controller: categoryController,
                )
              : Container(),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPriceController.text = calculateTotalPrice().toString();
                },
                decoration: const InputDecoration(labelText: resQuantity),
                controller: quantityController,
              ),
            ),
            gap(8),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPriceController.text = calculateTotalPrice().toString();
                },
                decoration: const InputDecoration(labelText: resPrice),
                controller: unitPriceController,
              ),
            ),
          ],
        ),
        TextField(
          enabled: false,
          decoration: const InputDecoration(labelText: resTotalPrice),
          controller: totalPriceController,
        ),
        TextField(
          decoration: const InputDecoration(labelText: resNotes),
          controller: notesController,
        ),
        gap(5),
        ElevatedButton(
            onPressed: () {
              if (material == null && categoryController.text.isEmpty) {
                showErrorMessage(
                    context, "يجب اختيار مادة من القائمة أو إدخال اسم التصنيف");
                return;
              }
              var quantity = int.tryParse(quantityController.text);
              var price = double.tryParse(unitPriceController.text);
              // validate fields
              if (quantity == null ||
                  quantity < 1 ||
                  price == null ||
                  price < 1) {
                showErrorMessage(context, resAllFieldsRequired);
                return;
              }
              if (item != null) {
                item.materialName = searchController.text;
                item.amount = quantity;
                item.unitPrice = price;

                if (item is Item) {
                  item.materialId = material!.id;
                }
                if (item is XItem) {
                  item.caegoryName = categoryController.text;
                }
                Navigator.of(context).pop();
                return;
              } else if (material?.id == null) {
                var item = XItem(
                    amount: int.parse(quantityController.text),
                    unitPrice: double.parse(unitPriceController.text),
                    notes: notesController.text,
                    category: categoryController.text,
                    discount: 0,
                    materialName: searchController.text);

                newInvoice.xItems.add(item);
              } else {
                var item = Item(
                    amount: int.parse(quantityController.text),
                    unitPrice: double.parse(unitPriceController.text),
                    notes: notesController.text,
                    materialId: material!.id,
                    discount: 0,
                    materialName: material!.name);

                newInvoice.items.add(item);
              }

              hideLoadingPanel(context);
            },
            child: Text(item == null ? resAdd : resSave))
      ],
    );
  }

  double calculateTotalPrice() =>
      ((double.tryParse(unitPriceController.text) ?? 0) *
          (double.tryParse(quantityController.text) ?? 0));

  List<SearchFieldListItem<Materiale>> getAccountSuggestions() {
    return suggestions
        .map((e) => SearchFieldListItem<Materiale>(e.name, item: e))
        .toList();
  }

  List<SearchFieldListItem<Materiale>>? onSearchTextChanged(String query) {
    setState(() => material = null);
    if (query.length > 1) {
      setState(() {
        loading = true;
        suggestions = <Materiale>[];
      });
      fetchFromServer(
              controller: "Material",
              fromJson: Materiale.fromJson,
              headers: MaterialApiPagingRequest(name: query))
          .then((value) {
        suggestions = value;
        setState(() => loading = false);
      }).onError((error, stackTrace) {
        // show snack bar with error messae
        setState(() => loading = false);
      });
    }
    return suggestions
        .map((e) => SearchFieldListItem<Materiale>(e.name, item: e))
        .toList();
  }
}
