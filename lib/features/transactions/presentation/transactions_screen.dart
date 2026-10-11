import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/amount_text.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/pill_chip.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/repositories/app_mock_providers.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    final allTxs = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final wallets = ref.watch(walletsProvider);

    final filteredTxs = allTxs.where((tx) {
      if (_selectedType == 'all') return true;
      return tx.type == _selectedType;
    }).toList();

    return Scaffold(
      backgroundColor: AppTokens.canvasCream,
      appBar: AppBar(title: const Text(AppStrings.tabTransactions)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space24,
                vertical: AppTokens.space8,
              ),
              child: Row(
                children: <Widget>[
                  PillChip(
                    label: AppStrings.all,
                    isSelected: _selectedType == 'all',
                    onTap: () => setState(() => _selectedType = 'all'),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  PillChip(
                    label: AppStrings.expense,
                    isSelected: _selectedType == 'expense',
                    onTap: () => setState(() => _selectedType = 'expense'),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  PillChip(
                    label: AppStrings.income,
                    isSelected: _selectedType == 'income',
                    onTap: () => setState(() => _selectedType = 'income'),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  PillChip(
                    label: AppStrings.saving,
                    isSelected: _selectedType == 'saving',
                    onTap: () => setState(() => _selectedType = 'saving'),
                  ),
                ],
              ),
            ),

            // Danh sách giao dịch
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space8,
                ),
                itemCount: filteredTxs.length,
                itemBuilder: (context, index) {
                  final tx = filteredTxs[index];
                  final cat = categories.firstWhere(
                    (c) => c.id == tx.categoryId,
                    orElse: () => const Category(
                      id: '',
                      name: 'Tiết kiệm',
                      type: 'saving',
                      icon: 'savings',
                      colorToken: 'signalOrange',
                    ),
                  );
                  final wallet = wallets.firstWhere(
                    (w) => w.id == tx.walletId,
                    orElse: () => const Wallet(
                      id: '',
                      name: 'Ví mặc định',
                      type: 'cash',
                      balance: 0,
                    ),
                  );

                  final isIncome = tx.type == 'income';
                  final isSaving = tx.type == 'saving';

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppTokens.space8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTokens.space16,
                      vertical: 14.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.white,
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusButton,
                      ),
                      border: Border.all(
                        color: AppTokens.dustTaupe.withValues(alpha: 0.5),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        CategoryAvatar(
                          iconName: isSaving ? 'savings' : cat.icon,
                          size: 42.0,
                        ),
                        const SizedBox(width: AppTokens.space16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                tx.note.isNotEmpty ? tx.note : cat.name,
                                style: const TextStyle(
                                  fontFamily: AppTokens.fontFamilyPrimary,
                                  fontWeight: AppTokens.weightMedium,
                                  fontSize: 15.0,
                                  color: AppTokens.inkBlack,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                '${cat.name} • ${wallet.name}',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppTokens.slateGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AmountText(
                              amount: tx.amount,
                              type: isIncome
                                  ? AmountDisplayType.income
                                  : (isSaving
                                        ? AmountDisplayType.neutral
                                        : AmountDisplayType.expense),
                              fontSize: 15.0,
                              fontWeight: AppTokens.weightMedium,
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              '${tx.date.day.toString().padLeft(2, '0')}/${tx.date.month.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: AppTokens.slateGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
