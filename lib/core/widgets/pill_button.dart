import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

enum PillButtonVariant { primary, secondary, signal, text }

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final PillButtonVariant variant;
  final Widget? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide side;
    double radius;

    switch (variant) {
      case PillButtonVariant.primary:
        bg = AppTokens.inkBlack;
        fg = AppTokens.canvasCream;
        side = const BorderSide(color: AppTokens.inkBlack, width: 1.5);
        radius = AppTokens.radiusButton;
        break;
      case PillButtonVariant.secondary:
        bg = AppTokens.white;
        fg = AppTokens.inkBlack;
        side = const BorderSide(color: AppTokens.inkBlack, width: 1.5);
        radius = AppTokens.radiusButton;
        break;
      case PillButtonVariant.signal:
        bg = AppTokens.signalOrange;
        fg = AppTokens.white;
        side = BorderSide.none;
        radius = AppTokens.radiusConsentButton;
        break;
      case PillButtonVariant.text:
        bg = Colors.transparent;
        fg = AppTokens.inkBlack;
        side = BorderSide.none;
        radius = AppTokens.radiusButton;
        break;
    }

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
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
            fontSize: 15.0,
            fontWeight: AppTokens.weightMedium,
            color: fg,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 44.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: AppTokens.elevationFlat,
          shadowColor: Colors.transparent,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space24,
            vertical: 10.0,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
