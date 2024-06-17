import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/dialog.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/components/search_bar.dart';
import 'package:tt/enums/server_enums.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/voucher.dart';
import 'package:intl/intl.dart';
import 'package:tt/routes/voucher/add_voucher.dart';

class Vouchers extends StatefulWidget {
  const Vouchers({super.key});

  @override
  State<Vouchers> createState() => _VouchersState();
}

class _VouchersState extends State<Vouchers> {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
// future builder to fetch data from server
    return BaseRout(
      routeName: resVouchers,
      child: FutureBuilder<List<VoucherViewModel>>(
          future: fetchFromServer<VoucherViewModel>(
              controller: "Voucher",
              fromJson: VoucherViewModel.fromJson,
              headers: VoucherViewModelApiPagingRequest(
                  pageNumber: 1, pageSize: 10)),
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

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  GVTable createTable(List<VoucherViewModel> items) {
    return GVTable<VoucherViewModel>(
      actions: [
        IconButton(
            onPressed: () {
              showDialogBox(context, AddVoucherScreen());
            },
            icon: Icon(Icons.add))
      ],
      filterWidgets: [
        CustomSearchBar(
          controller: searchController,
          onSearchPressed: () {},
        )
      ],
      showToolbar: showTableHeaders,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columnConfigs: VoucherViewModel.columnConfigs(context),
    );
  }
}

class VoucherViewModelApiPagingRequest extends ApiPagingRequest {
  VoucherType? type;
  DateTime? voucherDate;
  int? debit;

  VoucherViewModelApiPagingRequest({
    required super.pageNumber,
    required super.pageSize,
    this.type,
    this.debit,
    this.voucherDate,
  });
}
