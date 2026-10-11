import 'package:flutter/material.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/orbit_progress_ring.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/data/models/saving_goal.dart';

/// Kiểm tra xem khoản nạp [addedAmount] có giúp [goal] chạm thêm cột mốc mới nào không (25, 50, 75, 100).
/// Trả về danh sách mốc mới đạt được, sắp xếp tăng dần.
List<int> calculateNewMilestonesReached({
  required SavingGoal goal,
  required int addedAmount,
}) {
  if (goal.targetAmount <= 0 || addedAmount <= 0) return const [];

  final oldPercent = (goal.savedAmount * 100) ~/ goal.targetAmount;
  final newSaved = goal.savedAmount + addedAmount;
  final newPercent = (newSaved * 100) ~/ goal.targetAmount;

  const possibleMilestones = [25, 50, 75, 100];
  final newlyReached = <int>[];

  for (final m in possibleMilestones) {
    final notYetRecorded = !goal.milestonesReached.contains(m);
    if (newPercent >= m && notYetRecorded && oldPercent < m) {
      newlyReached.add(m);
    }
  }

  return newlyReached;
}

/// Dialog chúc mừng khi chạm các cột mốc tiết kiệm 25%, 50%, 75%, 100% (SAV-4).
class MilestoneCelebrationDialog extends StatelessWidget {
  const MilestoneCelebrationDialog({
    super.key,
    required this.goal,
    required this.milestone,
  });

  final SavingGoal goal;
  final int milestone;

  /// Hiển thị dialog chúc mừng với hiệu ứng mượt mà.
  static Future<void> show(
    BuildContext context, {
    required SavingGoal goal,
    required int milestone,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'MilestoneCelebration',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return MilestoneCelebrationDialog(goal: goal, milestone: milestone);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remainingDays = goal.targetDate.difference(now).inDays;
    final remainingMonths = (remainingDays / 30).ceil();

    final message = AppStrings.milestoneMessage(
      milestone: milestone,
      goalName: goal.name,
      remainingMonths: remainingMonths > 0 ? remainingMonths : 0,
      remainingDays: remainingDays > 0 ? remainingDays : 0,
    );

    final title = AppStrings.milestoneTitle(milestone);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppTokens.space24),
      child: Container(
        padding: const EdgeInsets.all(AppTokens.space24),
        decoration: BoxDecoration(
          color: AppTokens.liftedCream,
          borderRadius: BorderRadius.circular(AppTokens.radiusStadium),
          border: Border.all(
            color: AppTokens.orbitOrange.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTokens.orbitOrange.withValues(alpha: 0.12),
              blurRadius: 32.0,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Vòng hào quang quỹ đạo với icon mục tiêu
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Hiệu ứng phát sáng nhẹ
                Container(
                  width: 130.0,
                  height: 130.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTokens.orbitOrange.withValues(alpha: 0.08),
                  ),
                ),
                OrbitProgressRing(
                  progress: milestone / 100.0,
                  size: 110.0,
                  strokeWidth: 8.0,
                  child: CategoryAvatar(
                    iconName: milestone >= 100 ? 'trophy' : goal.icon,
                    size: 54.0,
                    backgroundColor: AppTokens.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space20),

            // Badge Pill cột mốc
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space16,
                vertical: AppTokens.space8,
              ),
              decoration: BoxDecoration(
                color: AppTokens.orbitOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    milestone >= 100 ? Icons.stars : Icons.flag_rounded,
                    size: 16.0,
                    color: AppTokens.orbitOrange,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    milestone >= 100
                        ? 'HOÀN THÀNH 100%'
                        : 'CỘT MỐC $milestone%',
                    style: const TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontWeight: AppTokens.weightBold,
                      fontSize: 12.0,
                      color: AppTokens.orbitOrange,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Tiêu đề
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 20.0,
                fontWeight: AppTokens.weightBold,
                color: AppTokens.inkBlack,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: AppTokens.space8),

            // Lời nhắn động lực
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 14.0,
                color: AppTokens.charcoal,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppTokens.space24),

            // Nút hành động
            SizedBox(
              width: double.infinity,
              child: PillButton(
                label: AppStrings.milestoneKeepGoing,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16.0),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
