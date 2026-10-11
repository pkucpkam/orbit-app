import 'package:intl/intl.dart';

/// Định dạng số nguyên VND sang chuỗi tiền tệ tiếng Việt (ví dụ: 1500000 -> "1.500.000 ₫").
/// Tiền trong Quỹ Đạo luôn là số nguyên (int) không dùng số thực.
String formatMoneyVnd(int amount, {bool showPositiveSign = false}) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  final absoluteString = formatter.format(amount.abs()).trim();

  if (amount < 0) {
    return '-$absoluteString';
  }

  if (showPositiveSign && amount > 0) {
    return '+$absoluteString';
  }

  return absoluteString;
}
