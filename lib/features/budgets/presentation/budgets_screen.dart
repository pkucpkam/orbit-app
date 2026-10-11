import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/amount_text.dart';
import 'package:quy_dao/core/widgets/budget_bar.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/repositories/app_mock_providers.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsProvider);
    final summary = ref.watch(currentMonthSummaryProvider);
    final categories = ref.watch(categoriesProvider);

    final totalPlanned = budgets.fold<int>(
      0,
      (sum, b) => sum + b.plannedAmount,
    );
    final totalSpent = summary.totalExpense;

    return Scaffold(
      backgroundColor: AppTokens.canvasCream,
      appBar: AppBar(
        title: const Text(AppStrings.tabBudgets),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.copy_outlined, size: 20.0),
            tooltip: AppStrings.copyFromLastMonth,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            // Thẻ tổng quan ngân sách tháng
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppTokens.space24),
                  decoration: BoxDecoration(
                    color: AppTokens.liftedCream,
                    borderRadius: BorderRadius.circular(
                      AppTokens.radiusStadium,
                    ),
                    border: Border.all(
                      color: AppTokens.dustTaupe.withValues(alpha: 0.6),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Tổng ngân sách tháng',
                            style: TextStyle(
                              fontFamily: AppTokens.fontFamilyPrimary,
                              fontWeight: AppTokens.weightBold,
                              fontSize: 13.0,
                              color: AppTokens.slateGray,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppTokens.white,
                              borderRadius: BorderRadius.circular(
                                AppTokens.radiusPill,
                              ),
                            ),
                            child: Text(
                              'Đã dùng ${((totalSpent / totalPlanned) * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: AppTokens.weightBold,
                                color: AppTokens.signalOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTokens.space16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          AmountText(
                            amount: totalSpent,
                            fontSize: 28.0,
                            fontWeight: AppTokens.weightMedium,
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                '/ ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppTokens.slateGray,
                                ),
                              ),
                              AmountText(
                                amount: totalPlanned,
                                fontSize: 16.0,
                                color: AppTokens.slateGray,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTokens.space16),
                      BudgetBar(
                        spentAmount: totalSpent,
                        plannedAmount: totalPlanned,
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tiêu đề danh sách danh mục
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppTokens.space24,
                  AppTokens.space16,
                  AppTokens.space24,
                  AppTokens.space8,
                ),
                child: Text(
                  'Chi tiết theo danh mục',
                  style: TextStyle(
                    fontFamily: AppTokens.fontFamilyPrimary,
                    fontSize: 17.0,
                    fontWeight: AppTokens.weightMedium,
                    color: AppTokens.inkBlack,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),

            // Danh sách các danh mục ngân sách
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space24,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final budget = budgets[index];
                  final cat = categories.firstWhere(
                    (c) => c.id == budget.categoryId,
                    orElse: () => const Category(
                      id: '',
                      name: 'Khác',
                      type: 'expense',
                      icon: 'category',
                      colorToken: 'slateGray',
                    ),
                  );

                  final spent = summary.byCategory[budget.categoryId] ?? 0;
                  final remaining = budget.plannedAmount - spent;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppTokens.space8),
                    padding: const EdgeInsets.all(AppTokens.space16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CategoryAvatar(iconName: cat.icon, size: 36.0),
                            const SizedBox(width: AppTokens.space16),
                            Expanded(
                              child: Text(
                                cat.name,
                                style: const TextStyle(
                                  fontFamily: AppTokens.fontFamilyPrimary,
                                  fontSize: 15.0,
                                  fontWeight: AppTokens.weightMedium,
                                  color: AppTokens.inkBlack,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                AmountText(
                                  amount: spent,
                                  fontSize: 14.5,
                                  fontWeight: AppTokens.weightBold,
                                ),
                                Text(
                                  'Dự tính: ${budget.plannedAmount ~/ 1000}k',
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    color: AppTokens.slateGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTokens.space128 * 0.08),
                        BudgetBar(
                          spentAmount: spent,
                          plannedAmount: budget.plannedAmount,
                          height: 6.0,
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              spent > budget.plannedAmount
                                  ? 'Đã vượt ${(spent - budget.plannedAmount) ~/ 1000}k'
                                  : 'Còn lại ${remaining ~/ 1000}k',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: AppTokens.weightMedium,
                                color: spent > budget.plannedAmount
                                    ? AppTokens.semanticBudgetExceeded
                                    : AppTokens.slateGray,
                              ),
                            ),
                            Text(
                              '${((spent / budget.plannedAmount) * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppTokens.slateGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }, childCount: budgets.length),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTokens.space32),
            ),
          ],
        ),
      ),
    );
  }
}
