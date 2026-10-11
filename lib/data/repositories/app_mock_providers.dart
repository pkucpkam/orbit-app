import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/data/mock/mock_data.dart';
import 'package:quy_dao/data/models/budget.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/month_summary.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/models/streak.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/models/wallet.dart';

// -----------------------------------------------------------------------------
// Core Mock Providers
// -----------------------------------------------------------------------------

/// Danh sách ví
final walletsProvider = Provider<List<Wallet>>((ref) {
  return MockData.wallets;
});

/// Tổng số dư tất cả các ví
final totalWalletBalanceProvider = Provider<int>((ref) {
  final wallets = ref.watch(walletsProvider);
  return wallets.fold<int>(0, (sum, w) => sum + w.balance);
});

/// Danh sách danh mục
final categoriesProvider = Provider<List<Category>>((ref) {
  return MockData.categories;
});

/// Danh sách mục tiêu tiết kiệm
final savingGoalsProvider = Provider<List<SavingGoal>>((ref) {
  return MockData.savingGoals;
});

/// Toàn bộ giao dịch
final transactionsProvider = Provider<List<Transaction>>((ref) {
  return MockData.transactions;
});

/// 5 giao dịch gần nhất cho màn hình Tổng quan
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final txs = ref.watch(transactionsProvider);
  return txs.take(5).toList();
});

/// Ngân sách tháng 10/2026
final budgetsProvider = Provider<List<Budget>>((ref) {
  return MockData.budgets;
});

/// Tổng kết tháng 10/2026
final currentMonthSummaryProvider = Provider<MonthSummary>((ref) {
  return MockData.monthSummary;
});

/// Streak ghi chép
final streakProvider = Provider<Streak>((ref) {
  return MockData.streak;
});

// -----------------------------------------------------------------------------
// Computed Financial Metrics
// -----------------------------------------------------------------------------

/// Số tiền còn có thể chi trong tháng
/// Công thức: Tổng dự tính chi (5.000.000 + 5.000.000 + 1.200.000 + 2.000.000 + 1.500.000 = 14.700.000) - Đã chi (5.420.000)
final remainingToSpendProvider = Provider<int>((ref) {
  final budgets = ref.watch(budgetsProvider);
  final summary = ref.watch(currentMonthSummaryProvider);

  final totalPlannedExpense = budgets
      .where((b) => b.type == 'expense')
      .fold<int>(0, (sum, b) => sum + b.plannedAmount);

  return totalPlannedExpense - summary.totalExpense;
});

/// Chi được mỗi ngày cho những ngày còn lại trong tháng
final dailySpendAllowanceProvider = Provider<int>((ref) {
  final remaining = ref.watch(remainingToSpendProvider);
  const remainingDays = 20; // 31 - 11 = 20 ngày
  if (remainingDays <= 0) return 0;
  return (remaining / remainingDays).round();
});
