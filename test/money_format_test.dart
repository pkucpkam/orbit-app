import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/core/utils/money_format.dart';

void main() {
  group('formatMoneyVnd tests', () {
    test('Format số dương chuẩn VND', () {
      final formatted = formatMoneyVnd(1500000);
      // intl format có thể dùng space hoặc non-breaking space
      expect(formatted.replaceAll('\u00A0', ' '), '1.500.000 ₫');
    });

    test('Format số 0', () {
      final formatted = formatMoneyVnd(0);
      expect(formatted.replaceAll('\u00A0', ' '), '0 ₫');
    });

    test('Format số âm', () {
      final formatted = formatMoneyVnd(-50000);
      expect(formatted.replaceAll('\u00A0', ' '), '-50.000 ₫');
    });

    test('Format số dương có dấu +', () {
      final formatted = formatMoneyVnd(2000000, showPositiveSign: true);
      expect(formatted.replaceAll('\u00A0', ' '), '+2.000.000 ₫');
    });
  });
}
