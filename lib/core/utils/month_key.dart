/// Hàm thuần tính toán khóa tháng dạng "YYYY-MM" (ví dụ: "2026-10")
/// theo quy tắc nghiệp vụ trong spec mục 5.
///
/// [monthStartDay] là ngày bắt đầu chu kỳ tính tháng (1 đến 28, thường là ngày nhận lương).
/// - Nếu [date.day] >= [monthStartDay]: Giao dịch thuộc chu kỳ tháng của tháng [date.month].
/// - Nếu [date.day] < [monthStartDay]: Giao dịch thuộc chu kỳ tháng bắt đầu từ tháng trước ([date.month] - 1).
String monthKeyFor(DateTime date, int monthStartDay) {
  assert(
    monthStartDay >= 1 && monthStartDay <= 28,
    'monthStartDay phải nằm trong khoảng từ 1 đến 28',
  );

  final int cycleYear;
  final int cycleMonth;

  if (date.day >= monthStartDay) {
    cycleYear = date.year;
    cycleMonth = date.month;
  } else {
    if (date.month == 1) {
      cycleYear = date.year - 1;
      cycleMonth = 12;
    } else {
      cycleYear = date.year;
      cycleMonth = date.month - 1;
    }
  }

  final yearStr = cycleYear.toString().padLeft(4, '0');
  final monthStr = cycleMonth.toString().padLeft(2, '0');
  return '$yearStr-$monthStr';
}
