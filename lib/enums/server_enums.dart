// Enum for VoucherType with descriptions
enum VoucherType {
  // سند قبض
  receipt,
  // سند دفع
  payment,
}

String VoucherLabel(VoucherType voucher) => switch (voucher) {
      VoucherType.receipt => "قبض",
      VoucherType.payment => "دفع"
    };

// Extension on VoucherType to include values
extension VoucherTypeExtension on VoucherType {
  int get value {
    switch (this) {
      case VoucherType.receipt:
        return 1;
      case VoucherType.payment:
        return -1;
      default:
        return 0;
    }
  }
}

// Enum for ResultCode with descriptions
enum ResultCode {
  // نجاح
  success,
  // فشل
  failure,
  // غير موجود
  notFound,
  // بيانات غير صحيحة
  invalidData,
  // خطأ داخلي
  serverError,
}

// Extension on ResultCode to include values
extension ResultCodeExtension on ResultCode {
  int get value {
    switch (this) {
      case ResultCode.success:
        return 0;
      case ResultCode.failure:
        return 1;
      case ResultCode.notFound:
        return 2;
      case ResultCode.invalidData:
        return 3;
      case ResultCode.serverError:
        return 100;
      default:
        return 0;
    }
  }
}
