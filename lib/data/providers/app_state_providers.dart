/// State providers kết nối Firestore thời gian thực với giao diện người dùng.
///
/// Tự động lắng nghe snapshot stream từ Firestore (thông qua Repositories),
/// và chuyển đổi thành state phản ứng để các màn hình Flutter cập nhật tức thì
/// khi có bất kỳ giao dịch, ví, ngân sách hay mục tiêu nào thay đổi.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/core/utils/month_key.dart';
import 'package:quy_dao/data/models/budget.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/month_summary.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/models/streak.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/repositories/budget_repository.dart';
import 'package:quy_dao/data/repositories/category_repository.dart';
import 'package:quy_dao/data/repositories/goal_repository.dart';
import 'package:quy_dao/data/repositories/transaction_repository.dart';
import 'package:quy_dao/data/repositories/user_repository.dart';
import 'package:quy_dao/data/repositories/wallet_repository.dart';

// ---------------------------------------------------------------------------
// Month & Profile Providers
// ---------------------------------------------------------------------------

/// Ngày bắt đầu chu kỳ tính tháng của user (1..28, mặc định 1).
final monthStartDayProvider = Provider<int>((ref) {
  final profile = ref.watch(userProfileStreamProvider).value;
  return profile?.monthStartDay ?? 1;
});

/// Khóa tháng hiện tại dạng YYYY-MM (ví dụ "2026-10").
final currentMonthKeyProvider = Provider<String>((ref) {
  final startDay = ref.watch(monthStartDayProvider);
  return monthKeyFor(DateTime.now(), startDay);
});

// ---------------------------------------------------------------------------
// Core Data Providers (Real-time Firestore)
// ---------------------------------------------------------------------------

/// Danh sách ví active từ Firestore
final walletsProvider = Provider<List<Wallet>>((ref) {
  return ref.watch(walletsStreamProvider).value ?? const [];
});

/// Tổng số dư tất cả các ví
final totalWalletBalanceProvider = Provider<int>((ref) {
  final wallets = ref.watch(walletsProvider);
  return wallets.fold<int>(0, (sum, w) => sum + w.balance);
});

/// Danh sách danh mục (Firestore, fallback sang 12 danh mục mặc định)
final categoriesProvider = Provider<List<Category>>((ref) {
  final expenseCats = ref.watch(expenseCategoriesProvider).value ?? const [];
  final incomeCats = ref.watch(incomeCategoriesProvider).value ?? const [];
  if (expenseCats.isEmpty && incomeCats.isEmpty) {
    return CategoryRepository.defaultCategories();
  }
  return [...expenseCats, ...incomeCats];
});

/// Danh sách mục tiêu tiết kiệm active
final savingGoalsProvider = Provider<List<SavingGoal>>((ref) {
  return ref.watch(activeGoalsStreamProvider).value ?? const [];
});

/// Toàn bộ giao dịch trong chu kỳ tháng hiện tại
final transactionsProvider = Provider<List<Transaction>>((ref) {
  final monthKey = ref.watch(currentMonthKeyProvider);
  return ref.watch(transactionsStreamProvider(monthKey)).value ?? const [];
});

/// 5 giao dịch gần nhất cho màn hình Tổng quan
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final txs = ref.watch(transactionsProvider);
  return txs.take(5).toList();
});

/// Ngân sách chu kỳ tháng hiện tại
final budgetsProvider = Provider<List<Budget>>((ref) {
  final monthKey = ref.watch(currentMonthKeyProvider);
  return ref.watch(budgetsStreamProvider(monthKey)).value ?? const [];
});

/// Tổng kết tháng hiện tại từ Firestore
final currentMonthSummaryProvider = Provider<MonthSummary>((ref) {
  final monthKey = ref.watch(currentMonthKeyProvider);
  return ref.watch(monthSummaryStreamProvider(monthKey)).value ??
      MonthSummary(
        monthKey: monthKey,
        totalIncome: 0,
        totalExpense: 0,
        totalSaved: 0,
        loggedDays: const [],
      );
});

/// Streak ghi chép tự động tính theo loggedDays từ monthSummary
final streakProvider = Provider<Streak>((ref) {
  final summary = ref.watch(currentMonthSummaryProvider);
  final loggedDays = summary.loggedDays.toSet();
  final now = DateTime.now();

  var current = 0;
  var checkDate = DateTime(now.year, now.month, now.day);
  final todayStr =
      '${checkDate.year.toString().padLeft(4, '0')}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';

  if (!loggedDays.contains(todayStr)) {
    // Nếu hôm nay chưa log, kiểm tra xem hôm qua có log không
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  while (true) {
    final dStr =
        '${checkDate.year.toString().padLeft(4, '0')}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
    if (loggedDays.contains(dStr)) {
      current++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return Streak(
    currentStreak: current,
    longestStreak: current,
    lastLogDate: loggedDays.isNotEmpty ? loggedDays.last : null,
  );
});

// ---------------------------------------------------------------------------
// Computed Financial Metrics (Theo spec.md mục 5)
// ---------------------------------------------------------------------------

/// Số tiền còn có thể chi trong tháng
/// Công thức: Tổng dự tính chi - Đã chi
final remainingToSpendProvider = Provider<int>((ref) {
  final budgets = ref.watch(budgetsProvider);
  final summary = ref.watch(currentMonthSummaryProvider);

  final totalPlannedExpense = budgets
      .where((b) => b.type == 'expense')
      .fold<int>(0, (sum, b) => sum + b.plannedAmount);

  if (totalPlannedExpense > 0) {
    return totalPlannedExpense - summary.totalExpense;
  }
  // Nếu chưa đặt ngân sách chi, dùng: Dự tính thu - Đã chi - Đã gom tiết kiệm
  return summary.totalIncome - summary.totalExpense - summary.totalSaved;
});

/// Chi được mỗi ngày cho những ngày còn lại trong tháng
final dailySpendAllowanceProvider = Provider<int>((ref) {
  final remaining = ref.watch(remainingToSpendProvider);
  final now = DateTime.now();
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final remainingDays = (daysInMonth - now.day) + 1;
  if (remainingDays <= 0) return 0;
  return (remaining / remainingDays).round();
});
