import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? AppTokens.inkBlack : AppTokens.white;
    final fgColor = isSelected ? AppTokens.canvasCream : AppTokens.inkBlack;
    final borderColor = isSelected ? AppTokens.inkBlack : AppTokens.dustTaupe;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.space16,
          vertical: AppTokens.space8,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              icon!,
              const SizedBox(width: AppTokens.space8),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontFamilyFallback: AppTokens.fontFamilyFallbacks,
                fontSize: 14.0,
                fontWeight: AppTokens.weightMedium,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
