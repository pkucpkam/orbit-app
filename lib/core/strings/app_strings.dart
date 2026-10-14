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

  // ---------------------------------------------------------------------------
  // Hướng dẫn sử dụng & Step Tutorial
  // ---------------------------------------------------------------------------
  static const String userGuide = 'Hướng dẫn sử dụng';
  static const String tutorialSteps = 'Hành trình từng bước';
  static const String featureHandbook = 'Cẩm nang tính năng';
  static const String skipGuide = 'Bỏ qua';
  static const String previousStep = 'Quay lại';
  static const String nextStep = 'Tiếp tục';
  static const String getStarted = 'Bắt đầu ngay';
  static const String bannerGuideTitle = 'Khám phá Quỹ Đạo';
  static const String bannerGuideSubtitle =
      'Tìm hiểu cách vận hành vòng quỹ đạo, ngân sách & tích lũy';
  static const String viewGuide = 'Xem hướng dẫn';

  // Bước 1: Triết lý Quỹ Đạo
  static const String guideStep1Badge = '1. Triết lý Quỹ Đạo';
  static const String guideStep1Title = 'Vòng Quỹ Đạo Tài Chính';
  static const String guideStep1Desc =
      'Quỹ Đạo giúp bạn trực quan hóa tốc độ chi tiêu so với thời gian trong tháng. Vòng màu cam biểu thị tiến độ ngân sách, giúp bạn luôn chủ động trước khi tiền kịp cạn.';
  static const String guideStep1Tip =
      'Mẹo: Quan sát chỉ số "Chi được mỗi ngày" để biết hôm nay bạn có thể tiêu tối đa bao nhiêu mà vẫn an toàn.';

  // Bước 2: Ghi chép Thu & Chi
  static const String guideStep2Badge = '2. Ghi chép tức thì';
  static const String guideStep2Title = 'Thêm Giao Dịch Trong 5 Giây';
  static const String guideStep2Desc =
      'Chỉ một chạm vào nút (+) để ghi nhận Chi tiêu, Thu nhập, Chuyển ví hoặc Gửi tiết kiệm. Hỗ trợ đa dạng nguồn tiền: Tiền mặt, Ngân hàng, Ví điện tử.';
  static const String guideStep2Tip =
      'Mẹo: Đặt thói quen ghi nhận ngay sau khi thanh toán hoặc tổng kết nhanh vào 21:00 mỗi tối.';

  // Bước 3: Ngân Sách Dự Tính
  static const String guideStep3Badge = '3. Kế hoạch ngân sách';
  static const String guideStep3Title = 'Dự Tính & Hạn Mức Ngày';
  static const String guideStep3Desc =
      'Phân bổ hạn mức chi cho từng danh mục thiết yếu như Ăn uống, Mua sắm, Di chuyển. Đầu tháng mới, bạn có thể sao chép toàn bộ kế hoạch từ tháng trước chỉ với 1 chạm.';
  static const String guideStep3Tip =
      'Mẹo: Khi đạt 80% ngân sách, hệ thống sẽ gửi nhắc nhở trung tính, tôn trọng để bạn chủ động cân đối.';

  // Bước 4: Tích Lũy Cột Mốc
  static const String guideStep4Badge = '4. Tích lũy thông minh';
  static const String guideStep4Title = '4 Cột Mốc Quỹ Đạo';
  static const String guideStep4Desc =
      'Chia nhỏ mục tiêu lớn thành 4 trạm: 25%, 50%, 75% và 100%. Mỗi khi nạp thêm tiền và cán mốc, Quỹ Đạo sẽ chúc mừng và tạo thêm động lực.';
  static const String guideStep4Tip =
      'Mẹo: Thiết lập ngày hết hạn để Quỹ Đạo tự động tính số tiền cần gom mỗi tháng.';

  // Bước 5: Báo Cáo & Phân Tích
  static const String guideStep5Badge = '5. Báo cáo trực quan';
  static const String guideStep5Title = 'Báo Cáo & Phân Tích Dòng Tiền';
  static const String guideStep5Desc =
      'Theo dõi cơ cấu chi tiêu qua biểu đồ hình tròn và phân tích dòng tiền Thu - Chi theo Tháng, Quý, Năm để nhìn rõ bức tranh tài chính toàn diện.';
  static const String guideStep5Tip =
      'Mẹo: Bấm biểu tượng biểu đồ tròn ở góc trên màn hình Tổng quan để xem báo cáo chi tiết mọi lúc.';

  // FAQ Section
  static const String faqSectionTitle = 'Câu hỏi thường gặp (FAQ)';
  static const String faq1Question =
      'Chỉ số "Chi được mỗi ngày" được tính như thế nào?';
  static const String faq1Answer =
      'Bằng tổng ngân sách còn lại trong tháng chia cho số ngày còn lại của chu kỳ. Chi tiêu ít hơn con số này sẽ giúp bạn đảm bảo số dư vào cuối tháng.';
  static const String faq2Question =
      'Ứng dụng có dùng được khi mất kết nối mạng (offline) không?';
  static const String faq2Answer =
      'Hoàn toàn được. Mọi giao dịch được lưu cục bộ tức thì và tự động đồng bộ lên đám mây khi điện thoại có kết nối trở lại.';
  static const String faq3Question =
      'Làm sao để sao chép ngân sách sang tháng mới?';
  static const String faq3Answer =
      'Tại tab Ngân sách, chuyển sang tháng mới và nhấn nút "Sao chép từ tháng trước" để giữ nguyên kế hoạch chi tiêu nhanh chóng.';
  static const String faq4Question =
      'Các cột mốc tích lũy 25%, 50%, 75% hoạt động ra sao?';
  static const String faq4Answer =
      'Khi bạn nạp tiền vào mục tiêu tiết kiệm, hệ thống tính toán tỷ lệ hoàn thành và kích hoạt lời chúc mừng khích lệ khi vượt qua từng cột mốc.';
}
