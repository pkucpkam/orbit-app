import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String type, // 'income', 'expense', 'transfer', 'saving'
    required int amount,
    required String walletId,
    String? toWalletId,
    String? categoryId,
    String? goalId,
    @Default('') String note,
    required DateTime date,
    required String monthKey,
    String? recurringId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
