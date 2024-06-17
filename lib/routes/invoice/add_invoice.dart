import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/gap.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/enums/main_account_enum.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/models/invoice.dart';
import 'package:tt/models/material.dart';
import 'package:vtable/vtable.dart';

class AddInvoice extends StatefulWidget {
  const AddInvoice({super.key});

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

Invoice newInvoice = Invoice(
  type: InvoiceType.sell,
  notes: "",
  discount: 0,
  payType: PayType.direct,
  clientAccountId: 0,
  cashAccountId: 0,
  repositoryId: 0,
  items: [],
  xItems: [],
);

class _AddInvoiceState extends State<AddInvoice> {
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
          compareFunction: (a, b) => a.materialName.compareTo(b.materialName),
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
  PickMaterial? material;
  var quantityController = TextEditingController();
  var unitPriceController = TextEditingController();
  var notesController = TextEditingController();
  var discountController = TextEditingController();
  var totalPriceController = TextEditingController();
  bool loading = false;
  var suggestions = <PickMaterial>[];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          onSearchTextChanged: onSearchTextChanged,
          hint: resMaterial,
          onSuggestionTap: (item) {
            material = item.item;
            unitPriceController.text = (item.item?.unitPrice ?? 0).toString();
            totalPriceController.text = calculateTotalPrice().toString();
          },
          emptyWidget: autoCompshitEmptyWidget(loading),
          suggestions: getAccountSuggestions(),
          itemHeight: 56,
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
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPriceController.text = calculateTotalPrice().toString();
                },
                decoration: InputDecoration(labelText: resDiscount),
                controller: discountController,
              ),
            ),
            gap(8),
            Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(labelText: resTotalPrice),
                controller: totalPriceController,
              ),
            ),
          ],
        ),
        TextField(
          decoration: InputDecoration(labelText: resNotes),
          controller: notesController,
        ),
        gap(5),
        ElevatedButton(
            onPressed: () {
              // validate fields
              if (material == null ||
                  quantityController.text.isEmpty ||
                  unitPriceController.text.isEmpty) {
                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(resAllFieldsRequired),
                  duration: Duration(seconds: 2),
                ));
                return;
              }
              if (material?.materialId == null) {}
              var item = Item(
                  amount: int.parse(quantityController.text),
                  discount: double.tryParse(discountController.text) ?? 0,
                  unitPrice: double.parse(unitPriceController.text),
                  notes: notesController.text,
                  materialId: material!.materialId,
                  materialName: material!.materialName);

              newInvoice.items.add(item);
              Navigator.pop(context);
            },
            child: Text(resAdd))
      ],
    );
  }

  double calculateTotalPrice() =>
      ((double.tryParse(unitPriceController.text) ?? 0) *
              (double.tryParse(quantityController.text) ?? 0) -
          (double.tryParse(discountController.text) ?? 0));

  List<SearchFieldListItem<PickMaterial>> getAccountSuggestions() {
    return suggestions
        .map((e) => SearchFieldListItem<PickMaterial>(e.materialName,
            item: e,
            child: CuteListTile(
              material: e,
            )))
        .toList();
  }

  List<SearchFieldListItem<PickMaterial>>? onSearchTextChanged(String query) {
    if (query.length > 1) {
      setState(() {
        material = null;
        loading = true;
        suggestions = <PickMaterial>[];
      });
      fetchFromServer(
              controller: "Material",
              fromJson: PickMaterial.fromJson,
              headers: PickMaterialRequest(name: query),
              action: "Pick")
          .then((value) {
        suggestions = value;
        setState(() => loading = false);
      }).onError((error, stackTrace) {
        // show snack bar with error messae
        setState(() => loading = false);
      });
    }
    return suggestions
        .map((e) => SearchFieldListItem<PickMaterial>(e.materialName,
            item: e, child: CuteListTile(material: e)))
        .toList();
  }
}

class CuteListTile extends StatelessWidget {
  final PickMaterial material;

  CuteListTile({required this.material});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              material.materialName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              (material.amount).toString(),
              style: TextStyle(color: Colors.green, fontSize: 10),
            )
          ],
        ),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              material.repositoryName,
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.grey[800],
                  fontSize: 11),
            ),
            Text(
              material.buyDate.substring(2, 10).replaceAll('-', '/'),
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.grey[800],
                  fontSize: 11),
            )
          ],
        )
      ],
    );
  }
}
