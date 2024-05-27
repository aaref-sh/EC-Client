import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/enums/main_account_enum.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/invoice.dart';
import 'package:tt/models/material.dart';
import 'package:vtable/vtable.dart';

class AddBuyInvoice extends StatefulWidget {
  const AddBuyInvoice({super.key});

  @override
  State<AddBuyInvoice> createState() => _AddBuyInvoiceState();
}

Invoice newInvoice = Invoice(
  type: InvoiceType.sell,
  notes: "",
  discount: 0,
  payType: PayType.direct,
  clientAccountId: 0,
  cashAccountId: 0,
  items: [],
  xItems: [],
);

class _AddBuyInvoiceState extends State<AddBuyInvoice> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resNewInvoice,
      child: createTable(),
    );
  }

  VTable createTable() {
    var width = MediaQuery.of(context).size.width;
    return VTable(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddInvoiceItem());
            },
            icon: Icon(Icons.add))
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
          width: (width * 4 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => row.materialName,
          compareFunction: (a, b) => a.marerialName.compareTo(b.marerialName),
        ),
        VTableColumn(
          label: resQuantity,
          width: (width * 2 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => row.amount.toString(),
          compareFunction: (a, b) => a.amount.compareTo(b.amount),
        ),
        VTableColumn(
          label: resTotalPrice,
          width: (width * 3 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => row.totalPrice.toString(),
          compareFunction: (a, b) => a.totalPrice.compareTo(b.totalPrice),
        ),
        VTableColumn(
          label: '',
          width: (width * 1 / 12).round(),
          renderFunction: (context, object, out) {
            return GestureDetector(onTap: () {}, child: Icon(Icons.more_vert));
          },
        ),
      ],
    );
  }
}

class AddInvoiceItem extends StatefulWidget {
  const AddInvoiceItem({super.key});

  @override
  State<AddInvoiceItem> createState() => _AddInvoiceItemState();
}

class _AddInvoiceItemState extends State<AddInvoiceItem> {
  Materiale? material;
  var quantityController = TextEditingController();
  var unitPriceController = TextEditingController();
  var notesController = TextEditingController();
  var totalPriceController = TextEditingController();
  bool loading = false;
  var suggestions = <Materiale>[];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          onSearchTextChanged: onSearchTextChanged,
          hint: resMaterial,
          onSuggestionTap: (item) {
            material = item.item;
            unitPriceController.text = (item.item?.price ?? 0).toString();
            totalPriceController.text = calculateTotalPrice().toString();
          },
          emptyWidget: autoCompshitEmptyWidget(loading),
          suggestions: getAccountSuggestions(),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPriceController.text = calculateTotalPrice().toString();
                },
                decoration: InputDecoration(labelText: resQuantity),
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
                decoration: InputDecoration(labelText: resPrice),
                controller: unitPriceController,
              ),
            ),
          ],
        ),
        TextField(
          enabled: false,
          decoration: InputDecoration(labelText: resTotalPrice),
          controller: totalPriceController,
        ),
        TextField(
          decoration: InputDecoration(labelText: resNotes),
          controller: notesController,
        ),
        gap(5),
        ElevatedButton(
            onPressed: () {
              // validate fields
              // if (material == null ||
              //     quantityController.text.isEmpty ||
              //     unitPriceController.text.isEmpty) {
              //   // show snackbar
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text(resAllFieldsRequired),
              //     duration: Duration(seconds: 2),
              //   ));
              //   return;
              // }
              if (material?.id == null) {
                var a = () => showDialogBox(context, Placeholder());
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (builder) {
                      return AlertDialog(
                        content: Text('لا يوجد سجل للمادة، هل تريد الإضافة؟'),
                        actions: [
                          ElevatedButton(onPressed: a, child: Text(resYes)),
                          ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(resNo))
                        ],
                      );
                    }).then(
                  (value) {
                    if (!value) return;
                    
                  },
                );
              }
              // var item = Item(
              //     amount: int.parse(quantityController.text),
              //     unitPrice: double.parse(unitPriceController.text),
              //     notes: notesController.text,
              //     materialId: material!.id,
              //     discount: 0,
              //     materialName: material!.name);

              // newInvoice.items.add(item);
            },
            child: Text(resAdd))
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
    if (query.length > 1) {
      setState(() {
        material = null;
        loading = true;
        suggestions = <Materiale>[];
      });
      fetchFromServer(
              controller: "Material",
              fromJson: Materiale.fromJson,
              headers: MaterialApiPagingRequest(
                  name: query, pageNumber: 1, pageSize: 10))
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

SizedBox gap(double x) => SizedBox(width: x, height: x);
