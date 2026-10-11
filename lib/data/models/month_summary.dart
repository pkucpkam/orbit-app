import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_summary.freezed.dart';
part 'month_summary.g.dart';

@freezed
abstract class MonthSummary with _$MonthSummary {
  const factory MonthSummary({
    required String monthKey,
    @Default(0) int totalIncome,
    @Default(0) int totalExpense,
    @Default(0) int totalSaved,
    @Default({}) Map<String, int> byCategory,
    @Default([]) List<String> loggedDays,
    DateTime? updatedAt,
  }) = _MonthSummary;

  factory MonthSummary.fromJson(Map<String, dynamic> json) =>
      _$MonthSummaryFromJson(json);
}
