import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String name,
    required String type, // 'cash', 'bank', 'ewallet'
    required int balance,
    @Default(0) int initialBalance,
    @Default(false) bool archived,
    @Default(0) int order,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}
