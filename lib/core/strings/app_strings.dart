/// Toàn bộ chuỗi hiển thị UI tiếng Việt dùng trong ứng dụng Quỹ Đạo.
/// Không hardcode chuỗi text trực tiếp trong widget.
abstract final class AppStrings {
  // ---------------------------------------------------------------------------
  // Tên ứng dụng & Định danh
  // ---------------------------------------------------------------------------
  static const String appName = 'Quỹ Đạo';
  static const String appTagline = 'Quản lý thu chi & tích lũy theo quỹ đạo';

  // ---------------------------------------------------------------------------
  // Thanh điều hướng chính (Bottom Tabs)
  // ---------------------------------------------------------------------------
  static const String tabOverview = 'Tổng quan';
  static const String tabTransactions = 'Giao dịch';
  static const String tabBudgets = 'Ngân sách';
  static const String tabSavings = 'Tiết kiệm';

  // ---------------------------------------------------------------------------
  // Hành động chung
  // ---------------------------------------------------------------------------
  static const String add = 'Thêm';
  static const String edit = 'Sửa';
  static const String delete = 'Xóa';
  static const String save = 'Lưu';
  static const String saveAndContinue = 'Lưu và thêm tiếp';
  static const String cancel = 'Hủy';
  static const String undo = 'Hoàn tác';
  static const String retry = 'Thử lại';
  static const String search = 'Tìm kiếm';
  static const String filter = 'Lọc';
  static const String settings = 'Cài đặt';
  static const String reports = 'Báo cáo';
  static const String all = 'Tất cả';
  static const String confirm = 'Xác nhận';
  static const String close = 'Đóng';

  // ---------------------------------------------------------------------------
  // Báo cáo & Thống kê
  // ---------------------------------------------------------------------------
  static const String reportOverview = 'Tổng quan phân bổ';
  static const String reportCategories = 'Cơ cấu theo danh mục';
  static const String reportIncomeVsExpense = 'Thu & Chi theo thời gian';
  static const String reportTopExpenses = 'Top 5 khoản chi lớn nhất';
  static const String periodMonth = 'Tháng này';
  static const String periodQuarter = 'Quý này';
  static const String periodYear = 'Năm nay';
  static const String emptyReport = 'Chưa có dữ liệu giao dịch trong kỳ này';

  // ---------------------------------------------------------------------------
  // Trạng thái chung (Loading, Empty, Error, Offline)
  // ---------------------------------------------------------------------------
  static const String loading = 'Đang tải dữ liệu...';
  static const String emptyTransactions =
      'Chưa có giao dịch tháng này, thêm khoản đầu tiên';
  static const String emptyBudgets = 'Chưa có dự tính ngân sách cho tháng này';
  static const String emptySavings =
      'Chưa có mục tiêu tiết kiệm, hãy tạo mục tiêu đầu tiên';
  static const String errorGeneral = 'Đã xảy ra sự cố, vui lòng thử lại';
  static const String offlineBanner =
      'Đang offline, dữ liệu sẽ đồng bộ khi có mạng';

  // ---------------------------------------------------------------------------
  // Giao dịch (Thu, Chi, Chuyển ví, Tiết kiệm)
  // ---------------------------------------------------------------------------
  static const String expense = 'Chi';
  static const String income = 'Thu';
  static const String transfer = 'Chuyển ví';
  static const String saving = 'Gửi tiết kiệm';
  static const String amount = 'Số tiền';
  static const String category = 'Danh mục';
  static const String wallet = 'Ví';
  static const String destinationWallet = 'Ví nhận';
  static const String note = 'Ghi chú';
  static const String date = 'Ngày';
  static const String today = 'Hôm nay';

  // ---------------------------------------------------------------------------
  // Tổng quan & Ngân sách
  // ---------------------------------------------------------------------------
  static const String remainingToSpend = 'Còn có thể chi';
  static const String dailySpendAllowance = 'Chi được mỗi ngày';
  static const String actualBalance = 'Dư thực tế';
  static const String plannedBalance = 'Dư dự tính';
  static const String difference = 'Chênh lệch';
  static const String plannedExpense = 'Dự tính chi';
  static const String plannedIncome = 'Dự tính thu';
  static const String copyFromLastMonth = 'Sao chép từ tháng trước';

  /// Thông báo tỷ lệ ngân sách với ngôn ngữ trung tính, không phán xét.
  static String budgetUsageNotice({
    required int percent,
    required String category,
  }) => 'Đã dùng $percent% ngân sách $category';

  // ---------------------------------------------------------------------------
  // Tiết kiệm & Động lực
  // ---------------------------------------------------------------------------
  static const String newGoal = 'Tạo mục tiêu';
  static const String depositMore = 'Gửi thêm';
  static const String withdraw = 'Rút bớt';
  static const String onTrack = 'Đúng tiến độ';
  static const String behindTrack = 'Chậm';
  static const String overdue = 'Quá hạn';
  static const String completed = 'Hoàn thành';
  static const String monthlySavingTarget = 'Cần gom mỗi tháng';
  static const String targetAmount = 'Mục tiêu';
  static const String savedAmount = 'Đã gom';
  static const String streakToday = 'Hôm nay không chi';
  static const String streakDays = 'ngày liên tiếp';
  static const String milestone25 = '25%';
  static const String milestone50 = '50%';
  static const String milestone75 = '75%';
  static const String milestone100 = '100%';
  static const String milestoneKeepGoing = 'Tiếp tục phát huy';
  static const String milestoneCompletedTitle = 'Mục tiêu hoàn thành!';

  /// Tiêu đề chúc mừng theo cột mốc
  static String milestoneTitle(int milestone) {
    return switch (milestone) {
      25 => 'Khởi đầu tuyệt vời!',
      50 => 'Hơn nửa chặng đường!',
      75 => 'Rất gần đích đến!',
      100 => 'Chúc mừng bạn đã về đích!',
      _ => 'Cột mốc tuyệt vời!',
    };
  }

  /// Thông điệp động lực theo cột mốc và thời gian
  static String milestoneMessage({
    required int milestone,
    required String goalName,
    int? remainingMonths,
    int? remainingDays,
  }) {
    if (milestone >= 100) {
      return 'Bạn đã hoàn thành trọn vẹn mục tiêu "$goalName". Một cột mốc tài chính đáng tự hào!';
    }
    final timeStr = remainingMonths != null && remainingMonths > 0
        ? 'Còn $remainingMonths tháng'
        : (remainingDays != null ? 'Còn $remainingDays ngày' : '');
    final prefix = timeStr.isNotEmpty ? '$timeStr, bạn' : 'Bạn';
    return switch (milestone) {
      25 => '$prefix đã tích lũy được một phần tư chặng đường cho "$goalName".',
      50 => '$prefix đã đi được hơn nửa chặng đường cho "$goalName".',
      75 =>
        '$prefix đã đạt 75% mục tiêu "$goalName". Đích đến đang ở ngay phía trước!',
      _ => '$prefix đã đạt mốc $milestone% cho "$goalName".',
    };
  }

  // ---------------------------------------------------------------------------
  // Thông báo & Cảnh báo (Local Notifications)
  // ---------------------------------------------------------------------------
  static const String notificationChannelName = 'Quỹ Đạo';
  static const String notificationChannelDesc =
      'Nhắc nhở ghi chép hằng ngày và cảnh báo ngân sách';
  static const String dailyReminderTitle = 'Đã đến giờ tổng kết ngày';
  static const String dailyReminderBody =
      'Dành 10 giây ghi lại các khoản thu chi hôm nay để giữ vững quỹ đạo tài chính.';
  static const String budgetAlertTitle = 'Cập nhật ngân sách';

  // ---------------------------------------------------------------------------
  // Xác thực & Tài khoản
  // ---------------------------------------------------------------------------
  static const String loginTitle = 'Bắt đầu hành trình';
  static const String loginSubtitle =
      'Quản lý thu chi & tích lũy theo quỹ đạo thời gian thực';
  static const String signInWithGoogle = 'Đăng nhập bằng Google';
  static const String signInWithEmail = 'Đăng nhập bằng Email';
  static const String createAccount = 'Tạo tài khoản mới';
  static const String continueAsGuest = 'Trải nghiệm ngay (Khách)';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String signOut = 'Đăng xuất';
  static const String deleteAccount = 'Xóa tài khoản';
  static const String profile = 'Hồ sơ';

  // ---------------------------------------------------------------------------
  // Biểu mẫu nhập liệu & Thao tác
  // ---------------------------------------------------------------------------
  static const String addTransaction = 'Thêm giao dịch';
  static const String setBudget = 'Đặt ngân sách';
  static const String plannedAmount = 'Số tiền dự tính';
  static const String goalName = 'Tên mục tiêu';
  static const String deadline = 'Thời hạn';
  static const String selectCategory = 'Chọn danh mục';
  static const String selectWallet = 'Chọn ví';
  static const String selectGoal = 'Chọn mục tiêu';
  static const String pleaseEnterAmount = 'Vui lòng nhập số tiền lớn hơn 0';
  static const String transactionSaved = 'Đã lưu giao dịch';
  static const String transactionDeleted = 'Đã xóa giao dịch';
}
