import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/amount_text.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/empty_state_view.dart';
import 'package:quy_dao/core/widgets/orbit_progress_ring.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/providers/app_state_providers.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';
import 'package:quy_dao/data/repositories/budget_repository.dart';
import 'package:quy_dao/features/auth/presentation/auth_sheet.dart';
import 'package:quy_dao/features/transactions/presentation/add_transaction_sheet.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingToSpend = ref.watch(remainingToSpendProvider);
    final dailyAllowance = ref.watch(dailySpendAllowanceProvider);
    final summary = ref.watch(currentMonthSummaryProvider);
    final goals = ref.watch(savingGoalsProvider);
    final recentTxs = ref.watch(recentTransactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final streak = ref.watch(streakProvider);

    final featuredGoal = goals.isNotEmpty ? goals.first : null;

    final authUser = ref.watch(firebaseAuthProvider)?.currentUser;
    final displayName = authUser?.displayName?.isNotEmpty == true
        ? authUser!.displayName!
        : (authUser != null
              ? (authUser.isAnonymous ? 'Khách' : authUser.email ?? 'Bạn')
              : 'Bạn');
    final avatarLetter = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : 'Q';

    return Scaffold(
      backgroundColor: AppTokens.canvasCream,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTokens.inkBlack,
        foregroundColor: AppTokens.canvasCream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        ),
        icon: const Icon(Icons.add, size: 20.0),
        label: const Text(
          AppStrings.addTransaction,
          style: TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontWeight: AppTokens.weightMedium,
          ),
        ),
        onPressed: () => AddTransactionSheet.show(context),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            // Header: Lời chào + Avatar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Xin chào,',
                          style: TextStyle(
                            fontFamily: AppTokens.fontFamilyPrimary,
                            fontSize: 14.0,
                            color: AppTokens.slateGray,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '$displayName 👋',
                          style: const TextStyle(
                            fontFamily: AppTokens.fontFamilyPrimary,
                            fontSize: 22.0,
                            fontWeight: AppTokens.weightMedium,
                            color: AppTokens.inkBlack,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => context.push('/reports'),
                          child: Container(
                            width: 44.0,
                            height: 44.0,
                            margin: const EdgeInsets.only(
                              right: AppTokens.space12,
                            ),
                            decoration: BoxDecoration(
                              color: AppTokens.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTokens.dustTaupe,
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.pie_chart_outline_rounded,
                              size: 22.0,
                              color: AppTokens.inkBlack,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => AuthSheet.show(context),
                          child: Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: BoxDecoration(
                              color: AppTokens.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTokens.dustTaupe,
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              avatarLetter,
                              style: const TextStyle(
                                fontFamily: AppTokens.fontFamilyPrimary,
                                fontWeight: AppTokens.weightBold,
                                fontSize: 18.0,
                                color: AppTokens.inkBlack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Thẻ Streak ghi chép + "Hôm nay không chi"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space4,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.space16,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.white,
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                    border: Border.all(
                      color: AppTokens.dustTaupe.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Text('🔥', style: TextStyle(fontSize: 20.0)),
                      const SizedBox(width: AppTokens.space8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${streak.currentStreak} ${AppStrings.streakDays}',
                              style: const TextStyle(
                                fontFamily: AppTokens.fontFamilyPrimary,
                                fontSize: 13.5,
                                fontWeight: AppTokens.weightBold,
                                color: AppTokens.inkBlack,
                              ),
                            ),
                            const Text(
                              'Duy trì kỷ lục ghi chép mỗi ngày',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: AppTokens.slateGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTokens.orbitOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTokens.radiusButton,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                        ),
                        onPressed: () async {
                          final uid = ref.read(currentUidProvider);
                          if (uid != null) {
                            final monthKey = ref.read(currentMonthKeyProvider);
                            final now = DateTime.now();
                            final todayStr =
                                '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                            await ref
                                .read(monthSummaryRepositoryProvider)
                                .recordStreakDay(uid, monthKey, todayStr);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Đã ghi nhận hôm nay không chi!',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            await AuthSheet.show(context);
                          }
                        },
                        child: const Text(
                          AppStrings.streakToday,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppTokens.signalOrange,
                            fontWeight: AppTokens.weightMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Card lớn "Còn có thể chi"
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
                          Row(
                            children: <Widget>[
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: const BoxDecoration(
                                  color: AppTokens.signalOrange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppTokens.space8),
                              const Text(
                                AppStrings.remainingToSpend,
                                style: TextStyle(
                                  fontFamily: AppTokens.fontFamilyPrimary,
                                  fontSize: 13.0,
                                  fontWeight: AppTokens.weightBold,
                                  letterSpacing: 0.52,
                                  color: AppTokens.slateGray,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Tháng 10/2026',
                            style: TextStyle(
                              fontFamily: AppTokens.fontFamilyPrimary,
                              fontSize: 13.0,
                              color: AppTokens.slateGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTokens.space16),
                      AmountText(
                        amount: remainingToSpend,
                        fontSize: 34.0,
                        fontWeight: AppTokens.weightMedium,
                      ),
                      const SizedBox(height: AppTokens.space8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTokens.space16,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppTokens.white,
                          borderRadius: BorderRadius.circular(
                            AppTokens.radiusPill,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.today_outlined,
                              size: 16.0,
                              color: AppTokens.signalOrange,
                            ),
                            const SizedBox(width: AppTokens.space8),
                            const Text(
                              'Chi được ',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: AppTokens.charcoal,
                              ),
                            ),
                            AmountText(
                              amount: dailyAllowance,
                              fontSize: 13.0,
                              fontWeight: AppTokens.weightBold,
                            ),
                            const Text(
                              ' mỗi ngày (còn 20 ngày)',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: AppTokens.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3 Hàng Thu / Chi / Dư thực tế
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space8,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _MetricPill(
                        label: AppStrings.income,
                        amount: summary.totalIncome,
                        type: AmountDisplayType.income,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space8),
                    Expanded(
                      child: _MetricPill(
                        label: AppStrings.expense,
                        amount: summary.totalExpense,
                        type: AmountDisplayType.expense,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space8),
                    Expanded(
                      child: _MetricPill(
                        label: AppStrings.actualBalance,
                        amount: summary.totalIncome - summary.totalExpense,
                        type: AmountDisplayType.income,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mục tiêu Quỹ đạo nổi bật
            if (featuredGoal != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.space24,
                    vertical: AppTokens.space8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppTokens.space24),
                    decoration: BoxDecoration(
                      color: AppTokens.white,
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
                          progress:
                              featuredGoal.savedAmount /
                              featuredGoal.targetAmount,
                          size: 76.0,
                          strokeWidth: 5.5,
                          child: Text(
                            '${((featuredGoal.savedAmount / featuredGoal.targetAmount) * 100).toInt()}%',
                            style: const TextStyle(
                              fontFamily: AppTokens.fontFamilyPrimary,
                              fontWeight: AppTokens.weightBold,
                              fontSize: 16.0,
                              color: AppTokens.inkBlack,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTokens.space16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTokens.canvasCream,
                                      borderRadius: BorderRadius.circular(
                                        AppTokens.radiusPill,
                                      ),
                                    ),
                                    child: const Text(
                                      AppStrings.onTrack,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: AppTokens.weightBold,
                                        color: AppTokens.signalOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                featuredGoal.name,
                                style: const TextStyle(
                                  fontFamily: AppTokens.fontFamilyPrimary,
                                  fontSize: 16.0,
                                  fontWeight: AppTokens.weightMedium,
                                  color: AppTokens.inkBlack,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              AmountText(
                                amount: featuredGoal.savedAmount,
                                fontSize: 13.0,
                                color: AppTokens.slateGray,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14.0,
                          color: AppTokens.slateGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Streak Ghi chép
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space8,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.space24,
                    vertical: AppTokens.space16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.liftedCream,
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                    border: Border.all(
                      color: AppTokens.dustTaupe.withValues(alpha: 0.6),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text('🔥', style: TextStyle(fontSize: 22.0)),
                          const SizedBox(width: AppTokens.space128 * 0.08),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${streak.currentStreak} ${AppStrings.streakDays}',
                                style: const TextStyle(
                                  fontFamily: AppTokens.fontFamilyPrimary,
                                  fontWeight: AppTokens.weightBold,
                                  fontSize: 15.0,
                                  color: AppTokens.inkBlack,
                                ),
                              ),
                              Text(
                                'Kỷ lục dài nhất: ${streak.longestStreak} ngày',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppTokens.slateGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      PillButton(
                        label: AppStrings.streakToday,
                        variant: PillButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tiêu đề: Giao dịch gần nhất
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppTokens.space24,
                  AppTokens.space16,
                  AppTokens.space24,
                  AppTokens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Giao dịch gần đây',
                      style: TextStyle(
                        fontFamily: AppTokens.fontFamilyPrimary,
                        fontSize: 17.0,
                        fontWeight: AppTokens.weightMedium,
                        color: AppTokens.inkBlack,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      AppStrings.all,
                      style: TextStyle(
                        fontFamily: AppTokens.fontFamilyPrimary,
                        fontSize: 14.0,
                        color: AppTokens.signalOrange,
                        fontWeight: AppTokens.weightMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Danh sách 5 giao dịch gần nhất
            if (recentTxs.isEmpty)
              SliverToBoxAdapter(
                child: EmptyStateView(
                  message: AppStrings.emptyTransactions,
                  icon: Icons.receipt_long_outlined,
                  actionLabel: AppStrings.addTransaction,
                  onAction: () => AddTransactionSheet.show(context),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tx = recentTxs[index];
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

                    return _TransactionItem(transaction: tx, category: cat);
                  }, childCount: recentTxs.length),
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

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.amount,
    required this.type,
  });

  final String label;
  final int amount;
  final AmountDisplayType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space16,
        vertical: AppTokens.space16,
      ),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        border: Border.all(
          color: AppTokens.dustTaupe.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 12.0, color: AppTokens.slateGray),
          ),
          const SizedBox(height: 6.0),
          AmountText(
            amount: amount,
            type: type,
            fontSize: 14.0,
            fontWeight: AppTokens.weightBold,
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.transaction, required this.category});

  final Transaction transaction;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final isSaving = transaction.type == 'saving';

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space16,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        border: Border.all(
          color: AppTokens.dustTaupe.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          CategoryAvatar(
            iconName: isSaving ? 'savings' : category.icon,
            size: 40.0,
          ),
          const SizedBox(width: AppTokens.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  transaction.note.isNotEmpty
                      ? transaction.note
                      : (isSaving ? 'Gửi tiết kiệm' : category.name),
                  style: const TextStyle(
                    fontFamily: AppTokens.fontFamilyPrimary,
                    fontWeight: AppTokens.weightMedium,
                    fontSize: 14.5,
                    color: AppTokens.inkBlack,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${category.name} • 10/10/2026',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppTokens.slateGray,
                  ),
                ),
              ],
            ),
          ),
          AmountText(
            amount: transaction.amount,
            type: isIncome
                ? AmountDisplayType.income
                : (isSaving
                      ? AmountDisplayType.neutral
                      : AmountDisplayType.expense),
            fontSize: 15.0,
            fontWeight: AppTokens.weightMedium,
          ),
        ],
      ),
    );
  }
}
