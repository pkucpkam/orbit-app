import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';

/// Widget hiển thị trạng thái Trống (Empty State) theo đặc tả MVP.
/// Bao gồm icon tròn, câu thông điệp rõ ràng và nút hành động.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

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
                color: AppTokens.dustTaupe.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36.0, color: AppTokens.slateGray),
            ),
            const SizedBox(height: AppTokens.space16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 15.0,
                color: AppTokens.slateGray,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppTokens.space20),
              PillButton(
                label: actionLabel!,
                icon: const Icon(Icons.add, size: 16.0),
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
