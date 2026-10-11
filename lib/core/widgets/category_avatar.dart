import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.iconName,
    this.size = 40.0,
    this.backgroundColor,
    this.iconColor,
  });

  final String iconName;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  static IconData resolveIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'movie':
        return Icons.movie_outlined;
      case 'favorite':
        return Icons.favorite_outline;
      case 'payments':
        return Icons.payments_outlined;
      case 'work':
        return Icons.work_outline;
      case 'laptop_mac':
        return Icons.laptop_mac;
      case 'shield':
        return Icons.shield_outlined;
      case 'flight_takeoff':
        return Icons.flight_takeoff;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppTokens.liftedCream;
    final fg = iconColor ?? AppTokens.inkBlack;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTokens.dustTaupe.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(resolveIcon(iconName), size: size * 0.52, color: fg),
    );
  }
}
