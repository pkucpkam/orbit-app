import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/core/utils/month_key.dart';

void main() {
  group('monthKeyFor tests', () {
    test('monthStartDay = 1 (chu kỳ theo lịch bình thường)', () {
      expect(monthKeyFor(DateTime(2026, 10, 1), 1), '2026-10');
      expect(monthKeyFor(DateTime(2026, 10, 15), 1), '2026-10');
      expect(monthKeyFor(DateTime(2026, 10, 31), 1), '2026-10');
      expect(monthKeyFor(DateTime(2026, 12, 31), 1), '2026-12');
      expect(monthKeyFor(DateTime(2027, 1, 1), 1), '2027-01');
    });

    test('monthStartDay = 25 (chu kỳ ngày nhận lương 25 hàng tháng)', () {
      // Ngày 25/10 bắt đầu chu kỳ 2026-10
      expect(monthKeyFor(DateTime(2026, 10, 25), 25), '2026-10');
      // Ngày 31/10 vẫn thuộc chu kỳ 2026-10
      expect(monthKeyFor(DateTime(2026, 10, 31), 25), '2026-10');
      // Ngày 01/11 chưa tới 25/11 nên vẫn thuộc chu kỳ bắt đầu từ 25/10 -> 2026-10
      expect(monthKeyFor(DateTime(2026, 11, 1), 25), '2026-10');
      expect(monthKeyFor(DateTime(2026, 11, 24), 25), '2026-10');
      // Ngày 25/11 bắt đầu chu kỳ mới 2026-11
      expect(monthKeyFor(DateTime(2026, 11, 25), 25), '2026-11');
      // Ngày 24/10 trước ngày 25/10 nên thuộc chu kỳ 2026-09
      expect(monthKeyFor(DateTime(2026, 10, 24), 25), '2026-09');
    });

    test('Ca biên chuyển giao cuối năm và đầu năm mới', () {
      // Ngày 25/12 bắt đầu chu kỳ 2026-12
      expect(monthKeyFor(DateTime(2026, 12, 25), 25), '2026-12');
      expect(monthKeyFor(DateTime(2026, 12, 31), 25), '2026-12');
      // Ngày 05/01/2027 chưa đến 25/01/2027 nên thuộc chu kỳ 2026-12
      expect(monthKeyFor(DateTime(2027, 1, 5), 25), '2026-12');
      expect(monthKeyFor(DateTime(2027, 1, 24), 25), '2026-12');
      // Ngày 25/01/2027 bắt đầu chu kỳ 2027-01
      expect(monthKeyFor(DateTime(2027, 1, 25), 25), '2027-01');
    });

    test('Đảm bảo assert lỗi nếu monthStartDay ngoài khoảng 1..28', () {
      expect(() => monthKeyFor(DateTime(2026, 10, 1), 0), throwsAssertionError);
      expect(
        () => monthKeyFor(DateTime(2026, 10, 1), 29),
        throwsAssertionError,
      );
    });
  });
}
