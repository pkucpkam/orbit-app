import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/utils/money_format.dart';

enum AmountDisplayType { neutral, income, expense }

class AmountText extends StatelessWidget {
  const AmountText({
    super.key,
    required this.amount,
    this.type = AmountDisplayType.neutral,
    this.fontSize = 18.0,
    this.fontWeight = AppTokens.weightMedium,
    this.color,
  });

  final int amount;
  final AmountDisplayType type;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color effectiveColor;
    bool showPlusSign = false;

    if (color != null) {
      effectiveColor = color!;
    } else {
      switch (type) {
        case AmountDisplayType.income:
          effectiveColor = AppTokens.semanticIncome;
          showPlusSign = true;
          break;
        case AmountDisplayType.expense:
          effectiveColor = AppTokens.inkBlack;
          break;
        case AmountDisplayType.neutral:
          effectiveColor = AppTokens.inkBlack;
          break;
      }
    }

    final formattedText = formatMoneyVnd(
      amount,
      showPositiveSign: showPlusSign,
    );

    return Text(
      formattedText,
      style: TextStyle(
        fontFamily: AppTokens.fontFamilyPrimary,
        fontFamilyFallback: AppTokens.fontFamilyFallbacks,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: effectiveColor,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ),
    );
  }
}
