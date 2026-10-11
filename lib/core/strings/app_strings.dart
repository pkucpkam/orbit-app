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
}
