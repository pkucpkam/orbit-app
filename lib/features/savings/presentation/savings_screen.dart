import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/amount_text.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/empty_state_view.dart';
import 'package:quy_dao/core/widgets/orbit_progress_ring.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/data/providers/app_state_providers.dart';
import 'package:quy_dao/features/savings/presentation/add_goal_sheet.dart';
import 'package:quy_dao/features/transactions/presentation/add_transaction_sheet.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(savingGoalsProvider);

    final totalTarget = goals.fold<int>(0, (sum, g) => sum + g.targetAmount);
    final totalSaved = goals.fold<int>(0, (sum, g) => sum + g.savedAmount);
    final overallRatio = totalTarget > 0 ? (totalSaved / totalTarget) : 0.0;

    return Scaffold(
      backgroundColor: AppTokens.canvasCream,
      appBar: AppBar(title: const Text(AppStrings.tabSavings)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTokens.inkBlack,
        foregroundColor: AppTokens.canvasCream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        ),
        icon: const Icon(Icons.add, size: 20.0),
        label: const Text(
          AppStrings.newGoal,
          style: TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontWeight: AppTokens.weightMedium,
          ),
        ),
        onPressed: () => AddGoalSheet.show(context),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            // Thẻ tổng quan tích lũy quỹ đạo
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
                  child: Row(
                    children: <Widget>[
                      OrbitProgressRing(
                        progress: overallRatio,
                        size: 84.0,
                        strokeWidth: 6.0,
                        child: Text(
                          '${(overallRatio * 100).toInt()}%',
                          style: const TextStyle(
                            fontFamily: AppTokens.fontFamilyPrimary,
                            fontWeight: AppTokens.weightBold,
                            fontSize: 18.0,
                            color: AppTokens.inkBlack,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTokens.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Tổng tích lũy quỹ đạo',
                              style: TextStyle(
                                fontFamily: AppTokens.fontFamilyPrimary,
                                fontWeight: AppTokens.weightBold,
                                fontSize: 13.0,
                                color: AppTokens.slateGray,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            AmountText(
                              amount: totalSaved,
                              fontSize: 22.0,
                              fontWeight: AppTokens.weightMedium,
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Mục tiêu: ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppTokens.slateGray,
                                  ),
                                ),
                                AmountText(
                                  amount: totalTarget,
                                  fontSize: 12.0,
                                  color: AppTokens.slateGray,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Nút Tạo mục tiêu + Tiêu đề
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTokens.space24,
                  AppTokens.space16,
                  AppTokens.space24,
                  AppTokens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Mục tiêu đang theo đuổi',
                      style: TextStyle(
                        fontFamily: AppTokens.fontFamilyPrimary,
                        fontSize: 17.0,
                        fontWeight: AppTokens.weightMedium,
                        color: AppTokens.inkBlack,
                        letterSpacing: -0.3,
                      ),
                    ),
                    PillButton(
                      label: AppStrings.newGoal,
                      icon: const Icon(Icons.add, size: 16.0),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Danh sách các mục tiêu
            if (goals.isEmpty)
              SliverToBoxAdapter(
                child: EmptyStateView(
                  message: AppStrings.emptySavings,
                  icon: Icons.savings_outlined,
                  actionLabel: AppStrings.newGoal,
                  onAction: () => AddGoalSheet.show(context),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final goal = goals[index];
                    final progress = goal.savedAmount / goal.targetAmount;
                    final remainingDays = goal.targetDate
                        .difference(DateTime.now())
                        .inDays;

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTokens.space16),
                      padding: const EdgeInsets.all(AppTokens.space24),
                      decoration: BoxDecoration(
                        color: AppTokens.white,
                        borderRadius: BorderRadius.circular(
                          AppTokens.radiusStadium,
                        ),
                        border: Border.all(
                          color: AppTokens.dustTaupe.withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CategoryAvatar(iconName: goal.icon, size: 44.0),
                              const SizedBox(width: AppTokens.space16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      goal.name,
                                      style: const TextStyle(
                                        fontFamily: AppTokens.fontFamilyPrimary,
                                        fontSize: 16.0,
                                        fontWeight: AppTokens.weightMedium,
                                        color: AppTokens.inkBlack,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      'Còn $remainingDays ngày',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: AppTokens.slateGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OrbitProgressRing(
                                progress: progress,
                                size: 56.0,
                                strokeWidth: 4.5,
                                child: Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: AppTokens.weightBold,
                                    color: AppTokens.inkBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTokens.space16),
                          Container(
                            padding: const EdgeInsets.all(AppTokens.space16),
                            decoration: BoxDecoration(
                              color: AppTokens.canvasCream,
                              borderRadius: BorderRadius.circular(
                                AppTokens.radiusButton,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      AppStrings.savedAmount,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: AppTokens.slateGray,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    AmountText(
                                      amount: goal.savedAmount,
                                      fontSize: 14.5,
                                      fontWeight: AppTokens.weightBold,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    const Text(
                                      AppStrings.targetAmount,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: AppTokens.slateGray,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    AmountText(
                                      amount: goal.targetAmount,
                                      fontSize: 14.5,
                                      color: AppTokens.charcoal,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTokens.space12),

                          // Hàng 4 cột mốc tiến độ trực quan (SAV-4)
                          Row(
                            children: const [25, 50, 75, 100].map((m) {
                              final isReached =
                                  goal.milestonesReached.contains(m) ||
                                  (progress * 100).toInt() >= m;
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isReached
                                        ? AppTokens.orbitOrange.withValues(
                                            alpha: 0.12,
                                          )
                                        : AppTokens.dustTaupe.withValues(
                                            alpha: 0.2,
                                          ),
                                    borderRadius: BorderRadius.circular(
                                      AppTokens.radiusPill,
                                    ),
                                    border: isReached
                                        ? Border.all(
                                            color: AppTokens.orbitOrange
                                                .withValues(alpha: 0.4),
                                            width: 1.0,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isReached) ...[
                                        const Icon(
                                          Icons.check,
                                          size: 11.0,
                                          color: AppTokens.orbitOrange,
                                        ),
                                        const SizedBox(width: 2.0),
                                      ],
                                      Text(
                                        '$m%',
                                        style: TextStyle(
                                          fontFamily:
                                              AppTokens.fontFamilyPrimary,
                                          fontSize: 10.5,
                                          fontWeight: isReached
                                              ? AppTokens.weightBold
                                              : AppTokens.weightRegular,
                                          color: isReached
                                              ? AppTokens.orbitOrange
                                              : AppTokens.slateGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: AppTokens.space16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              PillButton(
                                label: AppStrings.depositMore,
                                variant: PillButtonVariant.secondary,
                                icon: const Icon(
                                  Icons.arrow_upward,
                                  size: 14.0,
                                ),
                                onPressed: () => AddTransactionSheet.show(
                                  context,
                                  initialType: 'saving',
                                  initialGoalId: goal.id,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }, childCount: goals.length),
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
