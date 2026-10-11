import 'package:quy_dao/data/models/budget.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/month_summary.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/models/streak.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/models/wallet.dart';

abstract final class MockData {
  // ---------------------------------------------------------------------------
  // Danh sách Ví (Wallets)
  // ---------------------------------------------------------------------------
  static final List<Wallet> wallets = <Wallet>[
    const Wallet(
      id: 'w_cash',
      name: 'Tiền mặt',
      type: 'cash',
      balance: 1850000,
      initialBalance: 2000000,
      order: 1,
    ),
    const Wallet(
      id: 'w_vcb',
      name: 'Vietcombank',
      type: 'bank',
      balance: 28450000,
      initialBalance: 15000000,
      order: 2,
    ),
    const Wallet(
      id: 'w_momo',
      name: 'Ví MoMo',
      type: 'ewallet',
      balance: 920000,
      initialBalance: 500000,
      order: 3,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Danh mục (Categories)
  // ---------------------------------------------------------------------------
  static final List<Category> categories = <Category>[
    // Danh mục Chi
    const Category(
      id: 'c_food',
      name: 'Ăn uống',
      type: 'expense',
      icon: 'restaurant',
      colorToken: 'signalOrange',
      order: 1,
    ),
    const Category(
      id: 'c_housing',
      name: 'Nhà cửa & Điện nước',
      type: 'expense',
      icon: 'home',
      colorToken: 'charcoal',
      order: 2,
    ),
    const Category(
      id: 'c_transport',
      name: 'Di chuyển',
      type: 'expense',
      icon: 'directions_car',
      colorToken: 'granite',
      order: 3,
    ),
    const Category(
      id: 'c_shopping',
      name: 'Mua sắm',
      type: 'expense',
      icon: 'shopping_bag',
      colorToken: 'clayBrown',
      order: 4,
    ),
    const Category(
      id: 'c_entertainment',
      name: 'Giải trí',
      type: 'expense',
      icon: 'movie',
      colorToken: 'slateGray',
      order: 5,
    ),
    const Category(
      id: 'c_health',
      name: 'Sức khỏe',
      type: 'expense',
      icon: 'favorite',
      colorToken: 'linkBlue',
      order: 6,
    ),
    // Danh mục Thu
    const Category(
      id: 'c_salary',
      name: 'Lương chính',
      type: 'income',
      icon: 'payments',
      colorToken: 'semanticIncome',
      order: 10,
    ),
    const Category(
      id: 'c_freelance',
      name: 'Thu nhập phụ',
      type: 'income',
      icon: 'work',
      colorToken: 'semanticIncome',
      order: 11,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Mục tiêu Tiết kiệm (Saving Goals)
  // ---------------------------------------------------------------------------
  static final List<SavingGoal> savingGoals = <SavingGoal>[
    SavingGoal(
      id: 'g_laptop',
      name: 'MacBook M3 Pro',
      targetAmount: 38000000,
      savedAmount: 26600000, // 70%
      startDate: DateTime.utc(2026, 7, 1),
      targetDate: DateTime.utc(2026, 12, 31),
      icon: 'laptop_mac',
      colorToken: 'signalOrange',
      status: 'active',
      milestonesReached: const <int>[25, 50],
    ),
    SavingGoal(
      id: 'g_emergency',
      name: 'Quỹ khẩn cấp 6 tháng',
      targetAmount: 60000000,
      savedAmount: 48000000, // 80%
      startDate: DateTime.utc(2026, 1, 1),
      targetDate: DateTime.utc(2027, 3, 31),
      icon: 'shield',
      colorToken: 'inkBlack',
      status: 'active',
      milestonesReached: const <int>[25, 50, 75],
    ),
    SavingGoal(
      id: 'g_travel',
      name: 'Du lịch Nhật Bản',
      targetAmount: 35000000,
      savedAmount: 10500000, // 30%
      startDate: DateTime.utc(2026, 8, 15),
      targetDate: DateTime.utc(2027, 4, 15),
      icon: 'flight_takeoff',
      colorToken: 'clayBrown',
      status: 'active',
      milestonesReached: const <int>[25],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Giao dịch mẫu tháng 10/2026 (Transactions)
  // ---------------------------------------------------------------------------
  static final List<Transaction> transactions = <Transaction>[
    Transaction(
      id: 'tx_01',
      type: 'income',
      amount: 25000000,
      walletId: 'w_vcb',
      categoryId: 'c_salary',
      note: 'Lương công ty tháng 10',
      date: DateTime.utc(2026, 10, 5, 9, 30),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 5, 9, 30),
    ),
    Transaction(
      id: 'tx_02',
      type: 'saving',
      amount: 4000000,
      walletId: 'w_vcb',
      goalId: 'g_laptop',
      note: 'Trích gom quỹ mua MacBook',
      date: DateTime.utc(2026, 10, 6, 10, 0),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 6, 10, 0),
    ),
    Transaction(
      id: 'tx_03',
      type: 'expense',
      amount: 4500000,
      walletId: 'w_vcb',
      categoryId: 'c_housing',
      note: 'Tiền thuê nhà tháng 10',
      date: DateTime.utc(2026, 10, 6, 14, 15),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 6, 14, 15),
    ),
    Transaction(
      id: 'tx_04',
      type: 'expense',
      amount: 285000,
      walletId: 'w_momo',
      categoryId: 'c_food',
      note: 'Siêu thị WinMart cuối tuần',
      date: DateTime.utc(2026, 10, 8, 18, 45),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 8, 18, 45),
    ),
    Transaction(
      id: 'tx_05',
      type: 'expense',
      amount: 65000,
      walletId: 'w_cash',
      categoryId: 'c_food',
      note: 'Cà phê sáng cùng đồng nghiệp',
      date: DateTime.utc(2026, 10, 9, 8, 20),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 9, 8, 20),
    ),
    Transaction(
      id: 'tx_06',
      type: 'expense',
      amount: 150000,
      walletId: 'w_momo',
      categoryId: 'c_transport',
      note: 'Nạp thẻ xăng xe máy',
      date: DateTime.utc(2026, 10, 10, 11, 0),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 10, 11, 0),
    ),
    Transaction(
      id: 'tx_07',
      type: 'income',
      amount: 3000000,
      walletId: 'w_vcb',
      categoryId: 'c_freelance',
      note: 'Thanh toán dự án thiết kế UI',
      date: DateTime.utc(2026, 10, 10, 16, 30),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 10, 16, 30),
    ),
    Transaction(
      id: 'tx_08',
      type: 'expense',
      amount: 420000,
      walletId: 'w_cash',
      categoryId: 'c_food',
      note: 'Ăn trưa & cơm gia đình',
      date: DateTime.utc(2026, 10, 11, 12, 15),
      monthKey: '2026-10',
      createdAt: DateTime.utc(2026, 10, 11, 12, 15),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Ngân sách tháng 10/2026 (Budgets)
  // ---------------------------------------------------------------------------
  static final List<Budget> budgets = <Budget>[
    const Budget(
      monthKey: '2026-10',
      categoryId: 'c_food',
      type: 'expense',
      plannedAmount: 5000000,
    ),
    const Budget(
      monthKey: '2026-10',
      categoryId: 'c_housing',
      type: 'expense',
      plannedAmount: 5000000,
    ),
    const Budget(
      monthKey: '2026-10',
      categoryId: 'c_transport',
      type: 'expense',
      plannedAmount: 1200000,
    ),
    const Budget(
      monthKey: '2026-10',
      categoryId: 'c_shopping',
      type: 'expense',
      plannedAmount: 2000000,
    ),
    const Budget(
      monthKey: '2026-10',
      categoryId: 'c_entertainment',
      type: 'expense',
      plannedAmount: 1500000,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Tổng kết tháng 10/2026 (MonthSummary)
  // ---------------------------------------------------------------------------
  static final MonthSummary monthSummary = MonthSummary(
    monthKey: '2026-10',
    totalIncome: 28000000,
    totalExpense: 5420000,
    totalSaved: 4000000,
    byCategory: const <String, int>{
      'c_housing': 4500000,
      'c_food': 770000,
      'c_transport': 150000,
    },
    loggedDays: const <String>[
      '2026-10-05',
      '2026-10-06',
      '2026-10-08',
      '2026-10-09',
      '2026-10-10',
      '2026-10-11',
    ],
    updatedAt: DateTime.utc(2026, 10, 11, 12, 15),
  );

  // ---------------------------------------------------------------------------
  // Streak ghi chép
  // ---------------------------------------------------------------------------
  static const Streak streak = Streak(
    currentStreak: 12,
    longestStreak: 28,
    lastLogDate: '2026-10-11',
  );
}
