import 'package:flutter/material.dart';
import 'package:tt/components/helper.dart';
import 'package:vtable/vtable.dart';

class GVTable<T> extends StatelessWidget {
  final List<T> items;
  final List<ColumnConfig<T>> columnConfigs;
  final List<Widget> filterWidgets;
  final List<Widget> actions;
  final bool showToolbar;
  final bool startsSorted;
  final String? tableDescription;
  final bool includeCopyToClipboardAction;
  final IconData? icon;
  const GVTable(
      {super.key,
      required this.items,
      required this.columnConfigs,
      this.filterWidgets = const [],
      this.actions = const [],
      this.showToolbar = false,
      this.tableDescription,
      this.startsSorted = false,
      this.includeCopyToClipboardAction = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return VTable<T>(
      filterWidgets: filterWidgets,
      actions: actions,
      showToolbar: showToolbar,
      tableDescription: tableDescription,
      startsSorted: startsSorted,
      includeCopyToClipboardAction: includeCopyToClipboardAction,
      items: items,
      columns: columnConfigs.map((config) {
        return VTableColumn(
          label: config.label,
          width: config.width.round(),
          compareFunction: config.compareFunction,
          transformFunction: config.transformFunction,
          renderFunction: (context, row, _) =>
              // ignore: unnecessary_cast
              config.renderFunction?.call(context, row as T, config.label),
          alignment: config.alignment,
        );
      }).toList(),
    );
  }
}
