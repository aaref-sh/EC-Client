// Defining the VoucherModel class
import 'package:flutter/material.dart';
import 'package:tt/components/helper.dart';
import 'package:tt/enums/server_enums.dart';
import 'package:intl/intl.dart';
import 'package:tt/helpers/resources.dart';

class VoucherModel {
  String? notes;
  VoucherType type;
  double value;

  VoucherModel({this.notes, required this.type, required this.value});
}

// Extending VoucherModel to create VoucherViewModel
class VoucherViewModel extends VoucherModel {
  int id;
  String? voucherDate;
  String? debitAccountName;
  String? creditAccountName;

  VoucherViewModel({
    required this.id,
    this.voucherDate,

    /// مدين
    this.debitAccountName,
    // مدفوعات
    this.creditAccountName,
    super.notes,
    required super.type,
    required super.value,
  });

  static List<ColumnConfig<VoucherViewModel>> columnConfigs(
      BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return [
      ColumnConfig(
        label: resNumber,
        width: width * 2 / 12,
        alignment: Alignment.center,
        transformFunction: (row) => (row.id).toString(),
        compareFunction: (a, b) => a.id.compareTo(b.id),
        icon: Icons.numbers,
      ),
      ColumnConfig(
        label: "",
        width: width * 1 / 12,
        alignment: Alignment.center,
        renderFunction: (context, row, p2) => Icon(
            row.type == VoucherType.payment ? Icons.download : Icons.upload),
        compareFunction: (a, b) => a.id.compareTo(b.id),
      ),
      ColumnConfig(
        label: "الدائن",
        width: width * 3 / 12,
        alignment: Alignment.center,
        transformFunction: (row) => row.creditAccountName!,
        compareFunction: (a, b) => a.id.compareTo(b.id),
      ),
      ColumnConfig(
        label: "مدين",
        width: width * 3 / 12,
        alignment: Alignment.center,
        transformFunction: (row) => row.debitAccountName!,
        compareFunction: (a, b) => a.id.compareTo(b.id),
      ),
      ColumnConfig(
        label: "المبلغ",
        width: width * 3 / 12,
        alignment: Alignment.center,
        transformFunction: (row) => row.value.toString(),
        compareFunction: (a, b) => a.id.compareTo(b.id),
      ),
    ];
  }
}

// CreateVoucherRequest class extending from VoucherModel
class CreateVoucherRequest extends VoucherModel {
  int creditAccountId;
  int debitAccountId;

  CreateVoucherRequest({
    required this.creditAccountId,
    required this.debitAccountId,
    super.notes,
    required super.type,
    required super.value,
  });
}

// ApiResponse class to be used for CreateVoucherResponse
class ApiResponse<T> {
  ResultCode code;
  T? data;
  String? message;

  ApiResponse(this.code, [this.data, this.message]);
}

// CreateVoucherResponse class extending ApiResponse
class CreateVoucherResponse extends ApiResponse<VoucherViewModel> {
  CreateVoucherResponse(super.code, super.data, super.message);
}

// Assuming ApiPagingRequest is already defined in your Dart codebase
class ListVoucherRequest extends ApiPagingRequest {
  DateTime? voucherDate;
  VoucherType? type;
  int? accountId;

  ListVoucherRequest(
      {this.voucherDate,
      this.type,
      this.accountId,
      required super.pageNumber,
      required super.pageSize});

  // Method to parse headers for DateTime, since Dart doesn't have FromHeader attribute
  void fromHeaders(Map<String, String> headers) {
    if (headers.containsKey('VoucherDate')) {
      voucherDate = DateFormat('yyyy-MM-dd').parse(headers['VoucherDate']!);
    }
    if (headers.containsKey('Type')) {
      type = VoucherType.values.byName(headers['Type']!);
    }
    if (headers.containsKey('AccountId')) {
      accountId = int.tryParse(headers['AccountId']!);
    }
  }
}

// Assuming ApiPagingResponse is already defined in your Dart codebase
class ListVoucherResponse extends ApiPagingResponse<VoucherViewModel> {
  ListVoucherResponse(super.code, List<VoucherViewModel>? data, int? pageNumber,
      int? totalPages, String? message)
      : super(
            data: data,
            pageNumber: pageNumber,
            totalPages: totalPages,
            message: message);
}

// Generic ApiPagingResponse class in Dart
class ApiPagingResponse<T> {
  Iterable<T>? data;
  int? pageNumber;
  int? totalPages;
  ResultCode code;
  String? message;

  ApiPagingResponse(this.code,
      {this.data, this.pageNumber, this.totalPages, this.message});
}
// Dart does not have attributes like C#'s FromHeader and Range,
// so you would handle validation and header extraction manually.

class ApiPagingRequest {
  int pageNumber;
  int pageSize;

  ApiPagingRequest({required this.pageNumber, required this.pageSize});
}

// Assuming Transaction is already defined in your Dart codebase
class Voucher {
  int id;
  VoucherType type;
  String? document;
  DateTime? voucherDate;
  double value; // Dart doesn't have a decimal type; double is commonly used.
  String? notes;
  int transactionId;
  Transaction? transaction;

  Voucher({
    required this.id,
    required this.type,
    this.document,
    this.voucherDate,
    required this.value,
    this.notes,
    required this.transactionId,
  });

  // Method to format DateTime as a string, since Dart doesn't have annotations like C#
  String? get formattedVoucherDate => voucherDate != null
      ? DateFormat('yyyy-MM-dd').format(voucherDate!)
      : null;

  // Method to parse DateTime from a string, since Dart doesn't have annotations like C#
  set formattedVoucherDate(String? dateString) {
    if (dateString != null) {
      voucherDate = DateFormat('yyyy-MM-dd').parse(dateString);
    }
  }
}

// Assuming Account is already defined in your Dart codebase
class Transaction {
  int id;
  String? notes;
  DateTime? createdDate;
  List<TransactionItem> items;

  Transaction({
    required this.id,
    this.notes,
    this.createdDate,
    List<TransactionItem>? items,
  }) : items = items ?? [];

  // Method to format DateTime as a string, since Dart doesn't have annotations like C#
  String? get formattedCreatedDate => createdDate != null
      ? DateFormat('yyyy-MM-dd').format(createdDate!)
      : null;

  // Method to parse DateTime from a string, since Dart doesn't have annotations like C#
  set formattedCreatedDate(String? dateString) {
    if (dateString != null) {
      createdDate = DateFormat('yyyy-MM-dd').parse(dateString);
    }
  }
}

class TransactionItem {
  int id;
  double debit; // Dart doesn't have a decimal type; double is commonly used.
  double credit; // Dart doesn't have a decimal type; double is commonly used.
  int accountId;
  Account? account;
  int transactionId;
  Transaction? transaction;

  TransactionItem(
      {required this.id,
      required this.debit,
      required this.credit,
      required this.accountId,
      required this.transactionId});
}

// Enum for AccountType with descriptions as comments
enum AccountType {
  // الأصول
  asset,
  // الخصوم
  liability,
  // الإيرادات
  income,
  // النفقات
  expense,
  // حقوق الملكية
  equity,
}

// Dart class for Account
class Account {
  int id;
  String name;
  bool enabled;
  String? notes;
  AccountType type;
  int? baseAccountId;
  Account? baseAccount;

  Account({
    required this.id,
    required this.name,
    required this.enabled,
    this.notes,
    required this.type,
    this.baseAccountId,
  });
}
