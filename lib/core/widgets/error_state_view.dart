import 'package:flutter/material.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';

/// Widget hiển thị trạng thái Lỗi (Error State) theo đặc tả MVP.
/// Bao gồm icon cảnh báo, câu thông báo lỗi ngắn gọn và nút Thử lại.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    this.message = AppStrings.errorGeneral,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 72.0,
              height: 72.0,
              decoration: BoxDecoration(
                color: AppTokens.signalOrange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36.0,
                color: AppTokens.signalOrange,
              ),
            ),
            const SizedBox(height: AppTokens.space16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 15.0,
                color: AppTokens.charcoal,
                height: 1.4,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTokens.space20),
              PillButton(
                label: AppStrings.retry,
                variant: PillButtonVariant.secondary,
                icon: const Icon(Icons.refresh_rounded, size: 16.0),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
