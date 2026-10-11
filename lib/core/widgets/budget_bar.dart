import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

class BudgetBar extends StatelessWidget {
  const BudgetBar({
    super.key,
    required this.spentAmount,
    required this.plannedAmount,
    this.height = 8.0,
  });

  final int spentAmount;
  final int plannedAmount;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (plannedAmount <= 0) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTokens.dustTaupe.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
        ),
      );
    }

    final double ratio = spentAmount / plannedAmount;
    final double clampedRatio = ratio.clamp(0.0, 1.0);

    Color barColor;
    if (ratio >= 1.0) {
      barColor = AppTokens.semanticBudgetExceeded;
    } else if (ratio >= 0.8) {
      barColor = AppTokens.semanticBudgetWarning;
    } else {
      barColor = AppTokens.signalOrange;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * clampedRatio;

        return Stack(
          children: <Widget>[
            Container(
              height: height,
              width: totalWidth,
              decoration: BoxDecoration(
                color: AppTokens.dustTaupe.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              height: height,
              width: fillWidth,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              ),
            ),
          ],
        );
      },
    );
  }
}
