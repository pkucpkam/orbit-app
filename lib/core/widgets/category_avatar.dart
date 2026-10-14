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
      case 'food':
        return Icons.restaurant_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'directions_car':
      case 'car':
      case 'transport':
        return Icons.directions_car_outlined;
      case 'shopping_bag':
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'movie':
      case 'entertainment':
        return Icons.movie_outlined;
      case 'favorite':
      case 'health':
        return Icons.favorite_outline;
      case 'payments':
      case 'bill':
      case 'bills':
        return Icons.payments_outlined;
      case 'work':
      case 'salary':
        return Icons.work_outline;
      case 'laptop_mac':
      case 'laptop':
      case 'freelance':
        return Icons.laptop_mac;
      case 'shield':
        return Icons.shield_outlined;
      case 'flight_takeoff':
      case 'travel':
        return Icons.flight_takeoff;
      case 'savings':
        return Icons.savings_outlined;
      case 'tag':
        return Icons.tag;
      default:
        return Icons.category_outlined;
    }
  }

  bool _isEmoji(String str) {
    if (str.isEmpty) return false;
    final runes = str.runes;
    if (runes.length <= 4 && !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(str)) {
      return true;
    }
    return false;
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
      child: _isEmoji(iconName)
          ? Text(iconName, style: TextStyle(fontSize: size * 0.5, height: 1.1))
          : Icon(resolveIcon(iconName), size: size * 0.52, color: fg),
    );
  }
}
