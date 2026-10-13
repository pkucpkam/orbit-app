import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  static Future<void> showAsModal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTokens.canvasCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.radiusSheet),
        ),
      ),
      builder: (context) =>
          const FractionallySizedBox(heightFactor: 0.92, child: GuideScreen()),
    );
  }

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _selectedTabIndex = 0; // 0: Step Tutorial, 1: Handbook & FAQ
  int _currentPage = 0;
  late final PageController _pageController;
  final Set<int> _expandedFaqIndices = <int>{0}; // Default expand first FAQ

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextStep() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/overview');
      }
    }
  }

  void _onPreviousStep() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTokens.canvasCream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          AppStrings.userGuide,
          style: TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontSize: 18.0,
            fontWeight: AppTokens.weightMedium,
            color: AppTokens.inkBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppTokens.inkBlack),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/overview');
            }
          },
        ),
        actions: <Widget>[
          if (_selectedTabIndex == 0 && _currentPage < 4)
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/overview');
                }
              },
              child: const Text(
                AppStrings.skipGuide,
                style: TextStyle(
                  fontFamily: AppTokens.fontFamilyPrimary,
                  fontSize: 14.0,
                  fontWeight: AppTokens.weightMedium,
                  color: AppTokens.slateGray,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Tab Selector: Hành trình từng bước vs Cẩm nang tính năng
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space16,
                vertical: AppTokens.space8,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppTokens.space4),
                decoration: BoxDecoration(
                  color: AppTokens.liftedCream,
                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildTabButton(
                        title: AppStrings.tutorialSteps,
                        index: 0,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space4),
                    Expanded(
                      child: _buildTabButton(
                        title: AppStrings.featureHandbook,
                        index: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab View Body
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildStepTutorialView()
                  : _buildHandbookAndFaqView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppTokens.space8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTokens.inkBlack : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontSize: 13.5,
            fontWeight: isSelected
                ? AppTokens.weightMedium
                : AppTokens.weightRegular,
            color: isSelected ? AppTokens.white : AppTokens.slateGray,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // View 1: Step-by-Step Interactive Tutorial
  // ---------------------------------------------------------------------------
  Widget _buildStepTutorialView() {
    return Column(
      children: <Widget>[
        // PageView chứa 5 bước
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              _buildStepSlide(
                badge: AppStrings.guideStep1Badge,
                title: AppStrings.guideStep1Title,
                description: AppStrings.guideStep1Desc,
                tip: AppStrings.guideStep1Tip,
                visual: _buildStep1Visual(),
              ),
              _buildStepSlide(
                badge: AppStrings.guideStep2Badge,
                title: AppStrings.guideStep2Title,
                description: AppStrings.guideStep2Desc,
                tip: AppStrings.guideStep2Tip,
                visual: _buildStep2Visual(),
              ),
              _buildStepSlide(
                badge: AppStrings.guideStep3Badge,
                title: AppStrings.guideStep3Title,
                description: AppStrings.guideStep3Desc,
                tip: AppStrings.guideStep3Tip,
                visual: _buildStep3Visual(),
              ),
              _buildStepSlide(
                badge: AppStrings.guideStep4Badge,
                title: AppStrings.guideStep4Title,
                description: AppStrings.guideStep4Desc,
                tip: AppStrings.guideStep4Tip,
                visual: _buildStep4Visual(),
              ),
              _buildStepSlide(
                badge: AppStrings.guideStep5Badge,
                title: AppStrings.guideStep5Title,
                description: AppStrings.guideStep5Desc,
                tip: AppStrings.guideStep5Tip,
                visual: _buildStep5Visual(),
              ),
            ],
          ),
        ),

        // Bottom Controls: Indicator Dots + Nút hành động
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTokens.space24,
            AppTokens.space12,
            AppTokens.space24,
            AppTokens.space20,
          ),
          child: Column(
            children: <Widget>[
              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final isActive = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: isActive ? 24.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTokens.orbitOrange
                          : AppTokens.dustTaupe,
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusButton,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppTokens.space16),

              // Action Buttons Row
              Row(
                children: <Widget>[
                  if (_currentPage > 0) ...<Widget>[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _onPreviousStep,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48.0),
                          side: const BorderSide(
                            color: AppTokens.dustTaupe,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTokens.radiusButton,
                            ),
                          ),
                        ),
                        child: const Text(
                          AppStrings.previousStep,
                          style: TextStyle(
                            fontFamily: AppTokens.fontFamilyPrimary,
                            fontWeight: AppTokens.weightMedium,
                            color: AppTokens.inkBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTokens.space12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onNextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTokens.inkBlack,
                        foregroundColor: AppTokens.white,
                        minimumSize: const Size.fromHeight(48.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTokens.radiusButton,
                          ),
                        ),
                      ),
                      child: Text(
                        _currentPage == 4
                            ? AppStrings.getStarted
                            : AppStrings.nextStep,
                        style: const TextStyle(
                          fontFamily: AppTokens.fontFamilyPrimary,
                          fontWeight: AppTokens.weightMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepSlide({
    required String badge,
    required String title,
    required String description,
    required String tip,
    required Widget visual,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: AppTokens.space12),

          // Illustration Box
          Container(
            width: double.infinity,
            height: 190.0,
            padding: const EdgeInsets.all(AppTokens.space16),
            decoration: BoxDecoration(
              color: AppTokens.white,
              borderRadius: BorderRadius.circular(AppTokens.radiusCard),
              border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
              boxShadow: AppTokens.shadowLevel1,
            ),
            child: visual,
          ),
          const SizedBox(height: AppTokens.space20),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.space12,
              vertical: AppTokens.space4,
            ),
            decoration: BoxDecoration(
              color: AppTokens.lightSignalOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTokens.radiusButton),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 12.0,
                fontWeight: AppTokens.weightMedium,
                color: AppTokens.orbitOrange,
              ),
            ),
          ),
          const SizedBox(height: AppTokens.space8),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontSize: 22.0,
              fontWeight: AppTokens.weightMedium,
              color: AppTokens.inkBlack,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: AppTokens.space8),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontSize: 14.5,
              height: 1.5,
              color: AppTokens.charcoal,
            ),
          ),
          const SizedBox(height: AppTokens.space16),

          // Tip Box
          Container(
            padding: const EdgeInsets.all(AppTokens.space12),
            decoration: BoxDecoration(
              color: AppTokens.liftedCream,
              borderRadius: BorderRadius.circular(AppTokens.radiusCard),
              border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 20.0,
                  color: AppTokens.brandYellow,
                ),
                const SizedBox(width: AppTokens.space8),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontSize: 13.0,
                      height: 1.4,
                      color: AppTokens.slateGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTokens.space16),
        ],
      ),
    );
  }

  // --- Step Visual Illustrations (Custom, No 3rd Party Asset needed) ---

  Widget _buildStep1Visual() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTokens.orbitOrange, width: 5.0),
            ),
            child: const Center(
              child: Icon(
                Icons.radar_rounded,
                size: 38.0,
                color: AppTokens.orbitOrange,
              ),
            ),
          ),
          const SizedBox(height: AppTokens.space12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.space12,
              vertical: AppTokens.space4,
            ),
            decoration: BoxDecoration(
              color: AppTokens.liftedCream,
              borderRadius: BorderRadius.circular(AppTokens.radiusButton),
              border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
            ),
            child: const Text(
              'Chi được mỗi ngày: 250.000 đ',
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 12.5,
                fontWeight: AppTokens.weightMedium,
                color: AppTokens.inkBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Visual() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildMiniActionChip(
                icon: Icons.arrow_outward_rounded,
                label: AppStrings.expense,
                color: AppTokens.orbitOrange,
              ),
              const SizedBox(width: AppTokens.space8),
              _buildMiniActionChip(
                icon: Icons.arrow_downward_rounded,
                label: AppStrings.income,
                color: AppTokens.semanticIncome,
              ),
              const SizedBox(width: AppTokens.space8),
              _buildMiniActionChip(
                icon: Icons.swap_horiz_rounded,
                label: AppStrings.transfer,
                color: AppTokens.linkBlue,
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.space16,
              vertical: AppTokens.space8,
            ),
            decoration: BoxDecoration(
              color: AppTokens.inkBlack,
              borderRadius: BorderRadius.circular(AppTokens.radiusButton),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add_rounded, color: AppTokens.white, size: 18.0),
                SizedBox(width: AppTokens.space4),
                Text(
                  'Thêm trong 5 giây',
                  style: TextStyle(
                    fontFamily: AppTokens.fontFamilyPrimary,
                    fontSize: 12.0,
                    fontWeight: AppTokens.weightMedium,
                    color: AppTokens.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniActionChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space12,
        vertical: AppTokens.space8,
      ),
      decoration: BoxDecoration(
        color: AppTokens.liftedCream,
        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14.0, color: color),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontSize: 12.0,
              fontWeight: AppTokens.weightMedium,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Visual() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildMiniBudgetBar(
            name: 'Ăn uống',
            percent: 0.65,
            color: AppTokens.orbitOrange,
          ),
          const SizedBox(height: AppTokens.space12),
          _buildMiniBudgetBar(
            name: 'Di chuyển',
            percent: 0.35,
            color: AppTokens.linkBlue,
          ),
          const SizedBox(height: AppTokens.space12),
          _buildMiniBudgetBar(
            name: 'Mua sắm',
            percent: 0.82,
            color: AppTokens.semanticBudgetWarning,
            isWarning: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBudgetBar({
    required String name,
    required double percent,
    required Color color,
    bool isWarning = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 12.0,
                color: AppTokens.charcoal,
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 12.0,
                fontWeight: AppTokens.weightMedium,
                color: isWarning ? AppTokens.semanticBudgetWarning : color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8.0,
            backgroundColor: AppTokens.canvasCream,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4Visual() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildMilestoneNode('25%', isReached: true),
          _buildMilestoneConnector(isActive: true),
          _buildMilestoneNode('50%', isReached: true),
          _buildMilestoneConnector(isActive: true),
          _buildMilestoneNode('75%', isReached: false),
          _buildMilestoneConnector(isActive: false),
          _buildMilestoneNode('100%', isReached: false, isTarget: true),
        ],
      ),
    );
  }

  Widget _buildMilestoneNode(
    String label, {
    required bool isReached,
    bool isTarget = false,
  }) {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        color: isReached
            ? AppTokens.orbitOrange
            : (isTarget ? AppTokens.inkBlack : AppTokens.liftedCream),
        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        border: Border.all(
          color: isReached ? AppTokens.orbitOrange : AppTokens.dustTaupe,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTokens.fontFamilyPrimary,
          fontSize: 11.0,
          fontWeight: AppTokens.weightMedium,
          color: (isReached || isTarget)
              ? AppTokens.white
              : AppTokens.slateGray,
        ),
      ),
    );
  }

  Widget _buildMilestoneConnector({required bool isActive}) {
    return Container(
      width: 16.0,
      height: 3.0,
      color: isActive ? AppTokens.orbitOrange : AppTokens.dustTaupe,
    );
  }

  Widget _buildStep5Visual() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 74.0,
            height: 74.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTokens.orbitOrange, width: 8.0),
            ),
            child: const Center(
              child: Icon(
                Icons.donut_small_rounded,
                size: 28.0,
                color: AppTokens.inkBlack,
              ),
            ),
          ),
          const SizedBox(width: AppTokens.space24),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.trending_up_rounded,
                    size: 16.0,
                    color: AppTokens.semanticIncome,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    'Thu nhập: 15.000.000 đ',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontSize: 11.5,
                      fontWeight: AppTokens.weightMedium,
                      color: AppTokens.charcoal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.trending_down_rounded,
                    size: 16.0,
                    color: AppTokens.orbitOrange,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    'Chi tiêu: 8.500.000 đ',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontSize: 11.5,
                      fontWeight: AppTokens.weightMedium,
                      color: AppTokens.charcoal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // View 2: Feature Handbook & FAQs
  // ---------------------------------------------------------------------------
  Widget _buildHandbookAndFaqView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space16,
        vertical: AppTokens.space8,
      ),
      children: <Widget>[
        // Feature Cards Section
        _buildHandbookCard(
          icon: Icons.radar_rounded,
          iconColor: AppTokens.orbitOrange,
          title: 'Vòng Quỹ Đạo & Hạn mức ngày',
          content:
              'Vòng quỹ đạo đối chiếu thời gian đã trôi qua với tiến độ chi tiêu thực tế. Bạn luôn biết được số tiền chi tiêu an toàn cho mỗi ngày còn lại.',
        ),
        const SizedBox(height: AppTokens.space12),

        _buildHandbookCard(
          icon: Icons.add_circle_outline_rounded,
          iconColor: AppTokens.semanticIncome,
          title: 'Ghi chép Thu - Chi - Chuyển ví',
          content:
              'Phân loại nguồn tiền rõ ràng giữa Tiền mặt, Ngân hàng, Ví điện tử. Mọi giao dịch được ghi nhận trong 1 batch đồng nhất đảm bảo số dư luôn chuẩn xác.',
        ),
        const SizedBox(height: AppTokens.space12),

        _buildHandbookCard(
          icon: Icons.pie_chart_outline_rounded,
          iconColor: AppTokens.linkBlue,
          title: 'Ngân sách & Sao chép nhanh',
          content:
              'Lập kế hoạch chi tiêu theo danh mục đầu tháng. Sử dụng tính năng "Sao chép từ tháng trước" để tiết kiệm thời gian lên ngân sách định kỳ.',
        ),
        const SizedBox(height: AppTokens.space12),

        _buildHandbookCard(
          icon: Icons.savings_outlined,
          iconColor: AppTokens.brandYellow,
          title: 'Tích lũy & 4 Cột mốc Quỹ đạo',
          content:
              'Theo dõi hành trình hoàn thành mục tiêu tài chính tại các mốc 25%, 50%, 75% và 100%. Ứng dụng tự tính số tiền cần tích lũy mỗi tháng.',
        ),
        const SizedBox(height: AppTokens.space12),

        _buildHandbookCard(
          icon: Icons.analytics_outlined,
          iconColor: AppTokens.inkBlack,
          title: 'Báo cáo & Xu hướng chi tiêu',
          content:
              'Trực quan hóa tỷ trọng các danh mục chi nhiều nhất và dòng tiền thuần theo chu kỳ Tháng, Quý, Năm để tối ưu tài chính cá nhân.',
        ),
        const SizedBox(height: AppTokens.space24),

        // FAQ Section Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTokens.space8),
          child: Text(
            AppStrings.faqSectionTitle,
            style: TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontSize: 16.0,
              fontWeight: AppTokens.weightMedium,
              color: AppTokens.inkBlack,
            ),
          ),
        ),
        const SizedBox(height: AppTokens.space12),

        // FAQs
        _buildFaqItem(
          index: 0,
          question: AppStrings.faq1Question,
          answer: AppStrings.faq1Answer,
        ),
        const SizedBox(height: AppTokens.space8),

        _buildFaqItem(
          index: 1,
          question: AppStrings.faq2Question,
          answer: AppStrings.faq2Answer,
        ),
        const SizedBox(height: AppTokens.space8),

        _buildFaqItem(
          index: 2,
          question: AppStrings.faq3Question,
          answer: AppStrings.faq3Answer,
        ),
        const SizedBox(height: AppTokens.space8),

        _buildFaqItem(
          index: 3,
          question: AppStrings.faq4Question,
          answer: AppStrings.faq4Answer,
        ),
        const SizedBox(height: AppTokens.space24),

        // Bottom Dismiss Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8),
          child: ElevatedButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/overview');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTokens.inkBlack,
              foregroundColor: AppTokens.white,
              minimumSize: const Size.fromHeight(48.0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.radiusButton),
              ),
            ),
            child: const Text(
              AppStrings.getStarted,
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontWeight: AppTokens.weightMedium,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTokens.space24),
      ],
    );
  }

  Widget _buildHandbookCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space16),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
        boxShadow: AppTokens.shadowLevel1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTokens.radiusButton),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22.0, color: iconColor),
          ),
          const SizedBox(width: AppTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTokens.fontFamilyPrimary,
                    fontSize: 15.0,
                    fontWeight: AppTokens.weightMedium,
                    color: AppTokens.inkBlack,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: AppTokens.fontFamilyPrimary,
                    fontSize: 13.0,
                    height: 1.45,
                    color: AppTokens.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
  }) {
    final isExpanded = _expandedFaqIndices.contains(index);

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusCard),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusCard),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedFaqIndices.add(index);
              } else {
                _expandedFaqIndices.remove(index);
              }
            });
          },
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space16,
            vertical: AppTokens.space4,
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontSize: 14.0,
              fontWeight: AppTokens.weightMedium,
              color: AppTokens.inkBlack,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppTokens.space16,
            0,
            AppTokens.space16,
            AppTokens.space16,
          ),
          children: <Widget>[
            Text(
              answer,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 13.0,
                height: 1.45,
                color: AppTokens.slateGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
