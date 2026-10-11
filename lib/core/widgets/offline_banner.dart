import 'package:flutter/material.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

/// Dải banner nhỏ hiển thị trạng thái Offline theo đặc tả MVP.
/// "Đang offline, dữ liệu sẽ đồng bộ khi có mạng"
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space16,
        vertical: AppTokens.space8,
      ),
      decoration: BoxDecoration(
        color: AppTokens.dustTaupe.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(
            color: AppTokens.dustTaupe.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.cloud_off_rounded, size: 15.0, color: AppTokens.slateGray),
          SizedBox(width: AppTokens.space8),
          Text(
            AppStrings.offlineBanner,
            style: TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontSize: 12.0,
              fontWeight: AppTokens.weightMedium,
              color: AppTokens.slateGray,
            ),
          ),
        ],
      ),
    );
  }
}
