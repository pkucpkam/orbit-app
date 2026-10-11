/// Hằng số đường dẫn các collection và document trong Cloud Firestore
/// theo đúng thiết kế tại Mục 6 của docs/spec.md.
///
/// Mọi dữ liệu người dùng đều nằm trong cây con: users/{uid}/...
abstract final class FirestorePaths {
  // ---------------------------------------------------------------------------
  // Tên Collection & Doc ID cố định
  // ---------------------------------------------------------------------------
  static const String users = 'users';
  static const String wallets = 'wallets';
  static const String categories = 'categories';
  static const String transactions = 'transactions';
  static const String budgets = 'budgets';
  static const String monthSummaries = 'monthSummaries';
  static const String goals = 'goals';
  static const String recurring = 'recurring';
  static const String stats = 'stats';
  static const String streakDocId = 'streak';

  // ---------------------------------------------------------------------------
  // Helper xây dựng đường dẫn document & collection
  // ---------------------------------------------------------------------------

  /// Đường dẫn document người dùng: users/{uid}
  static String userDoc(String uid) => '$users/$uid';

  /// Collection ví: users/{uid}/wallets
  static String walletsCollection(String uid) => '${userDoc(uid)}/$wallets';

  /// Document ví cụ thể: users/{uid}/wallets/{walletId}
  static String walletDoc(String uid, String walletId) =>
      '${walletsCollection(uid)}/$walletId';

  /// Collection danh mục: users/{uid}/categories
  static String categoriesCollection(String uid) =>
      '${userDoc(uid)}/$categories';

  /// Document danh mục cụ thể: users/{uid}/categories/{categoryId}
  static String categoryDoc(String uid, String categoryId) =>
      '${categoriesCollection(uid)}/$categoryId';

  /// Collection giao dịch: users/{uid}/transactions
  static String transactionsCollection(String uid) =>
      '${userDoc(uid)}/$transactions';

  /// Document giao dịch cụ thể: users/{uid}/transactions/{txId}
  static String transactionDoc(String uid, String txId) =>
      '${transactionsCollection(uid)}/$txId';

  /// Collection ngân sách: users/{uid}/budgets
  static String budgetsCollection(String uid) => '${userDoc(uid)}/$budgets';

  /// Document ngân sách cụ thể: users/{uid}/budgets/{monthKey}_{categoryId}
  static String budgetDoc(
    String uid, {
    required String monthKey,
    required String categoryId,
  }) => '${budgetsCollection(uid)}/${monthKey}_$categoryId';

  /// Collection tổng kết tháng: users/{uid}/monthSummaries
  static String monthSummariesCollection(String uid) =>
      '${userDoc(uid)}/$monthSummaries';

  /// Document tổng kết tháng cụ thể: users/{uid}/monthSummaries/{monthKey}
  static String monthSummaryDoc(String uid, String monthKey) =>
      '${monthSummariesCollection(uid)}/$monthKey';

  /// Collection mục tiêu tiết kiệm: users/{uid}/goals
  static String goalsCollection(String uid) => '${userDoc(uid)}/$goals';

  /// Document mục tiêu tiết kiệm cụ thể: users/{uid}/goals/{goalId}
  static String goalDoc(String uid, String goalId) =>
      '${goalsCollection(uid)}/$goalId';

  /// Collection giao dịch định kỳ (v1.1): users/{uid}/recurring
  static String recurringCollection(String uid) => '${userDoc(uid)}/$recurring';

  /// Document giao dịch định kỳ cụ thể: users/{uid}/recurring/{recurringId}
  static String recurringDoc(String uid, String recurringId) =>
      '${recurringCollection(uid)}/$recurringId';

  /// Document thống kê streak: users/{uid}/stats/streak
  static String streakDoc(String uid) => '${userDoc(uid)}/$stats/$streakDocId';
}
