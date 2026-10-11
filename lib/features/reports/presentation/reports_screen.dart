import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/amount_text.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/pill_chip.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/providers/app_state_providers.dart';

enum ReportPeriod { month, quarter, year }

/// Màn hình Báo cáo Chi tiết (RPT-1).
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.month;
  int _touchedPieIndex = -1;

  // Bảng màu chuẩn phong cách Mastercard cho Donut Chart
  static const List<Color> _chartColors = [
    AppTokens.orbitOrange,
    AppTokens.linkBlue,
    AppTokens.brandYellow,
    AppTokens.semanticIncome,
    AppTokens.clayBrown,
    AppTokens.lightSignalOrange,
    AppTokens.charcoal,
    AppTokens.granite,
    Color(0xFF8B5CF6), // Purple accent
    Color(0xFF06B6D4), // Cyan accent
  ];

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final summary = ref.watch(currentMonthSummaryProvider);

    // Lọc giao dịch theo chi tiêu (expense)
    final expenseTxs = transactions
        .where((tx) => tx.type == 'expense')
        .toList();

    // Tính tổng chi tiêu
    final totalExpense = expenseTxs.fold<int>(0, (sum, tx) => sum + tx.amount);

    // Nhóm chi tiêu theo danh mục
    final categoryExpenseMap = <String, int>{};
    for (final tx in expenseTxs) {
      final catId = tx.categoryId ?? 'uncategorized';
      categoryExpenseMap[catId] = (categoryExpenseMap[catId] ?? 0) + tx.amount;
    }

    // Sắp xếp danh mục theo số tiền chi giảm dần
    final sortedCategoryEntries = categoryExpenseMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Top 5 khoản chi lớn nhất
    final sortedExpenses = List<Transaction>.from(expenseTxs)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final top5Expenses = sortedExpenses.take(5).toList();

    // Map tra cứu danh mục nhanh
    final categoryMap = {for (final c in categories) c.id: c};

    return Scaffold(
      backgroundColor: AppTokens.canvasCream,
      appBar: AppBar(
        title: const Text(AppStrings.reports),
        backgroundColor: AppTokens.canvasCream,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            // Bộ lọc kỳ thời gian (Tháng / Quý / Năm)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                  vertical: AppTokens.space12,
                ),
                child: Row(
                  children: <Widget>[
                    PillChip(
                      label: AppStrings.periodMonth,
                      isSelected: _selectedPeriod == ReportPeriod.month,
                      onTap: () =>
                          setState(() => _selectedPeriod = ReportPeriod.month),
                    ),
                    const SizedBox(width: AppTokens.space8),
                    PillChip(
                      label: AppStrings.periodQuarter,
                      isSelected: _selectedPeriod == ReportPeriod.quarter,
                      onTap: () => setState(
                        () => _selectedPeriod = ReportPeriod.quarter,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space8),
                    PillChip(
                      label: AppStrings.periodYear,
                      isSelected: _selectedPeriod == ReportPeriod.year,
                      onTap: () =>
                          setState(() => _selectedPeriod = ReportPeriod.year),
                    ),
                  ],
                ),
              ),
            ),

            if (totalExpense <= 0)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pie_chart_outline_rounded,
                        size: 64.0,
                        color: AppTokens.dustTaupe,
                      ),
                      SizedBox(height: AppTokens.space16),
                      Text(
                        AppStrings.emptyReport,
                        style: TextStyle(
                          fontFamily: AppTokens.fontFamilyPrimary,
                          fontSize: 15.0,
                          color: AppTokens.slateGray,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Card Donut Chart Phân bổ danh mục
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
                        const Text(
                          AppStrings.reportOverview,
                          style: TextStyle(
                            fontFamily: AppTokens.fontFamilyPrimary,
                            fontSize: 16.0,
                            fontWeight: AppTokens.weightMedium,
                            color: AppTokens.inkBlack,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: AppTokens.space24),
                        SizedBox(
                          height: 220.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          _touchedPieIndex = -1;
                                          return;
                                        }
                                        _touchedPieIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 3.0,
                                  centerSpaceRadius: 65.0,
                                  sections: List.generate(
                                    sortedCategoryEntries.length,
                                    (i) {
                                      final isTouched = i == _touchedPieIndex;
                                      final radius = isTouched ? 38.0 : 30.0;
                                      final entry = sortedCategoryEntries[i];
                                      final color =
                                          _chartColors[i % _chartColors.length];
                                      final percent =
                                          (entry.value / totalExpense) * 100;

                                      return PieChartSectionData(
                                        color: color,
                                        value: entry.value.toDouble(),
                                        title: isTouched
                                            ? '${percent.toStringAsFixed(0)}%'
                                            : '',
                                        radius: radius,
                                        titleStyle: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: AppTokens.weightBold,
                                          color: AppTokens.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Thông tin tổng chi ở tâm Donut
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Tổng chi',
                                    style: TextStyle(
                                      fontFamily: AppTokens.fontFamilyPrimary,
                                      fontSize: 12.0,
                                      color: AppTokens.slateGray,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  AmountText(
                                    amount: totalExpense,
                                    fontSize: 17.0,
                                    fontWeight: AppTokens.weightBold,
                                    color: AppTokens.inkBlack,
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

              // So sánh Kế hoạch vs Thực tế (Thu & Chi)
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
                        color: AppTokens.dustTaupe.withValues(alpha: 0.5),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          AppStrings.reportIncomeVsExpense,
                          style: TextStyle(
                            fontFamily: AppTokens.fontFamilyPrimary,
                            fontSize: 16.0,
                            fontWeight: AppTokens.weightMedium,
                            color: AppTokens.inkBlack,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: AppTokens.space16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppTokens.space16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTokens.canvasCream,
                                  borderRadius: BorderRadius.circular(
                                    AppTokens.radiusButton,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.income,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: AppTokens.slateGray,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    AmountText(
                                      amount: summary.totalIncome,
                                      type: AmountDisplayType.income,
                                      fontSize: 16.0,
                                      fontWeight: AppTokens.weightBold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTokens.space12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppTokens.space16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTokens.canvasCream,
                                  borderRadius: BorderRadius.circular(
                                    AppTokens.radiusButton,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.expense,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: AppTokens.slateGray,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    AmountText(
                                      amount: summary.totalExpense,
                                      color: AppTokens.inkBlack,
                                      fontSize: 16.0,
                                      fontWeight: AppTokens.weightBold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Cơ cấu chi tiết theo danh mục (Danh sách tiến độ phần trăm)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppTokens.space24,
                    AppTokens.space16,
                    AppTokens.space24,
                    AppTokens.space8,
                  ),
                  child: Text(
                    AppStrings.reportCategories,
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontSize: 16.0,
                      fontWeight: AppTokens.weightMedium,
                      color: AppTokens.inkBlack,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final entry = sortedCategoryEntries[index];
                    final cat = categoryMap[entry.key];
                    final catName = cat?.name ?? 'Khác';
                    final catIcon = cat?.icon ?? 'more_horiz';
                    final color = _chartColors[index % _chartColors.length];
                    final ratio = totalExpense > 0
                        ? (entry.value / totalExpense)
                        : 0.0;
                    final percent = (ratio * 100).toStringAsFixed(1);

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTokens.space12),
                      padding: const EdgeInsets.all(AppTokens.space16),
                      decoration: BoxDecoration(
                        color: AppTokens.white,
                        borderRadius: BorderRadius.circular(
                          AppTokens.radiusButton,
                        ),
                        border: Border.all(
                          color: AppTokens.dustTaupe.withValues(alpha: 0.4),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppTokens.space8),
                              CategoryAvatar(iconName: catIcon, size: 36.0),
                              const SizedBox(width: AppTokens.space12),
                              Expanded(
                                child: Text(
                                  catName,
                                  style: const TextStyle(
                                    fontFamily: AppTokens.fontFamilyPrimary,
                                    fontSize: 14.5,
                                    fontWeight: AppTokens.weightMedium,
                                    color: AppTokens.inkBlack,
                                  ),
                                ),
                              ),
                              AmountText(
                                amount: entry.value,
                                fontSize: 14.5,
                                fontWeight: AppTokens.weightBold,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTokens.space8),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppTokens.radiusPill,
                                  ),
                                  child: LinearProgressIndicator(
                                    value: ratio,
                                    backgroundColor: AppTokens.dustTaupe
                                        .withValues(alpha: 0.25),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      color,
                                    ),
                                    minHeight: 5.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppTokens.space12),
                              Text(
                                '$percent%',
                                style: const TextStyle(
                                  fontFamily: AppTokens.fontFamilyPrimary,
                                  fontSize: 12.0,
                                  fontWeight: AppTokens.weightMedium,
                                  color: AppTokens.slateGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }, childCount: sortedCategoryEntries.length),
                ),
              ),

              // Top 5 khoản chi lớn nhất
              if (top5Expenses.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppTokens.space24,
                      AppTokens.space20,
                      AppTokens.space24,
                      AppTokens.space8,
                    ),
                    child: Text(
                      AppStrings.reportTopExpenses,
                      style: TextStyle(
                        fontFamily: AppTokens.fontFamilyPrimary,
                        fontSize: 16.0,
                        fontWeight: AppTokens.weightMedium,
                        color: AppTokens.inkBlack,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.space24,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final tx = top5Expenses[index];
                      final cat = categoryMap[tx.categoryId];
                      final catName = cat?.name ?? 'Khoản chi';
                      final catIcon = cat?.icon ?? 'shopping_bag';
                      final title = tx.note.isNotEmpty ? tx.note : catName;
                      final dateFormatted = DateFormat(
                        'dd/MM/yyyy',
                      ).format(tx.date);

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: AppTokens.space12,
                        ),
                        padding: const EdgeInsets.all(AppTokens.space16),
                        decoration: BoxDecoration(
                          color: AppTokens.white,
                          borderRadius: BorderRadius.circular(
                            AppTokens.radiusButton,
                          ),
                          border: Border.all(
                            color: AppTokens.dustTaupe.withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            CategoryAvatar(iconName: catIcon, size: 40.0),
                            const SizedBox(width: AppTokens.space12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontFamily: AppTokens.fontFamilyPrimary,
                                      fontSize: 14.5,
                                      fontWeight: AppTokens.weightMedium,
                                      color: AppTokens.inkBlack,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    '$catName • $dateFormatted',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: AppTokens.slateGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AmountText(
                              amount: tx.amount,
                              fontSize: 15.0,
                              fontWeight: AppTokens.weightBold,
                              color: AppTokens.inkBlack,
                            ),
                          ],
                        ),
                      );
                    }, childCount: top5Expenses.length),
                  ),
                ),
              ],

              const SliverToBoxAdapter(
                child: SizedBox(height: AppTokens.space32),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
