import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/list_table.dart';
import 'package:tt/enums/server_enums.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/voucher.dart';
import 'package:intl/intl.dart';

final items = <VoucherViewModel>[
  VoucherViewModel(
      id: 0,
      type: VoucherType.payment,
      value: 200,
      creditAccountName: "ss",
      debitAccountName: "kk",
      notes: "",
      voucherDate: "")
];

class Vouchers extends StatefulWidget {
  const Vouchers({super.key});

  @override
  State<Vouchers> createState() => _VouchersState();
}

class _VouchersState extends State<Vouchers> {
  @override
  Widget build(BuildContext context) {
    return BaseRout(
      routeName: "المبيعات",
      child: createTable(),
    );
  }

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  GVTable createTable() {
    return GVTable<VoucherViewModel>(
      filterWidgets: const [Icon(Icons.home_outlined)],
      actions: const [Icon(Icons.delete)],
      showToolbar: showTableHeaders,
      items: items,
      tableDescription: '${items.length} عنصر',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columnConfigs: VoucherViewModel.columnConfigs(context),
    );
  }
}