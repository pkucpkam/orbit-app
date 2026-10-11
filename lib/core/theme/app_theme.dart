import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = Typography.material2021().black.apply(
      fontFamily: AppTokens.fontFamilyPrimary,
      fontFamilyFallback: AppTokens.fontFamilyFallbacks,
      bodyColor: AppTokens.inkBlack,
      displayColor: AppTokens.inkBlack,
    );

    final textTheme = baseTextTheme.copyWith(
      displayLarge: const TextStyle(
        fontSize: 64.0,
        fontWeight: AppTokens.weightMedium,
        letterSpacing: -1.28,
        height: 1.0,
        color: AppTokens.inkBlack,
      ),
      headlineMedium: const TextStyle(
        fontSize: 36.0,
        fontWeight: AppTokens.weightMedium,
        letterSpacing: -0.72,
        height: 1.22,
        color: AppTokens.inkBlack,
      ),
      titleLarge: const TextStyle(
        fontSize: 24.0,
        fontWeight: AppTokens.weightMedium,
        letterSpacing: -0.48,
        height: 1.2,
        color: AppTokens.inkBlack,
      ),
      titleMedium: const TextStyle(
        fontSize: 16.0,
        fontWeight: AppTokens.weightMedium,
        letterSpacing: -0.32,
        color: AppTokens.inkBlack,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: AppTokens.weightRegular,
        height: 1.4,
        color: AppTokens.inkBlack,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14.0,
        fontWeight: AppTokens.weightRegular,
        height: 1.4,
        color: AppTokens.charcoal,
      ),
      bodySmall: const TextStyle(
        fontSize: 12.0,
        fontWeight: AppTokens.weightRegular,
        color: AppTokens.slateGray,
      ),
      labelLarge: const TextStyle(
        fontSize: 14.0,
        fontWeight: AppTokens.weightBold,
        letterSpacing: 0.56,
        color: AppTokens.inkBlack,
      ),
      labelMedium: const TextStyle(
        fontSize: 12.0,
        fontWeight: AppTokens.weightBold,
        letterSpacing: 0.48,
        color: AppTokens.slateGray,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppTokens.canvasCream,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppTokens.inkBlack,
        onPrimary: AppTokens.canvasCream,
        secondary: AppTokens.signalOrange,
        onSecondary: AppTokens.white,
        tertiary: AppTokens.lightSignalOrange,
        onTertiary: AppTokens.inkBlack,
        error: AppTokens.semanticBudgetExceeded,
        onError: AppTokens.white,
        surface: AppTokens.canvasCream,
        onSurface: AppTokens.inkBlack,
        surfaceContainerHighest: AppTokens.liftedCream,
        outline: AppTokens.dustTaupe,
        outlineVariant: AppTokens.softBone,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTokens.canvasCream,
        foregroundColor: AppTokens.inkBlack,
        elevation: AppTokens.elevationFlat,
        scrolledUnderElevation: AppTokens.elevationFlat,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTokens.fontFamilyPrimary,
          fontSize: 18.0,
          fontWeight: AppTokens.weightMedium,
          letterSpacing: -0.36,
          color: AppTokens.inkBlack,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppTokens.liftedCream,
        elevation: AppTokens.elevationFlat,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppTokens.radiusStadium),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.inkBlack,
          foregroundColor: AppTokens.canvasCream,
          elevation: AppTokens.elevationFlat,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space24,
            vertical: 14.0,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontWeight: AppTokens.weightMedium,
            fontSize: 16.0,
            letterSpacing: -0.32,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppTokens.white,
          foregroundColor: AppTokens.inkBlack,
          elevation: AppTokens.elevationFlat,
          side: const BorderSide(color: AppTokens.inkBlack, width: 1.5),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space24,
            vertical: 14.0,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontWeight: AppTokens.weightMedium,
            fontSize: 16.0,
            letterSpacing: -0.32,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.inkBlack,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space16,
            vertical: 8.0,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontWeight: AppTokens.weightMedium,
            fontSize: 14.0,
          ),
        ),
      ),
      chipTheme: const ChipThemeData(
        shape: StadiumBorder(),
        backgroundColor: AppTokens.white,
        selectedColor: AppTokens.inkBlack,
        side: BorderSide(color: AppTokens.dustTaupe, width: 1.0),
        padding: EdgeInsets.symmetric(
          horizontal: AppTokens.space16,
          vertical: AppTokens.space8,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTokens.fontFamilyPrimary,
          fontWeight: AppTokens.weightMedium,
          fontSize: 14.0,
          color: AppTokens.inkBlack,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: AppTokens.fontFamilyPrimary,
          fontWeight: AppTokens.weightMedium,
          fontSize: 14.0,
          color: AppTokens.canvasCream,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.space24,
          vertical: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(color: AppTokens.dustTaupe, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(color: AppTokens.dustTaupe, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(color: AppTokens.inkBlack, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(
            color: AppTokens.semanticBudgetExceeded,
            width: 1.5,
          ),
        ),
        hintStyle: const TextStyle(color: AppTokens.slateGray, fontSize: 14.0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppTokens.white,
        elevation: AppTokens.elevationFlat,
        indicatorColor: AppTokens.canvasCream,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppTokens.signalOrange);
          }
          return const IconThemeData(color: AppTokens.slateGray);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: AppTokens.fontFamilyPrimary,
              fontWeight: AppTokens.weightMedium,
              fontSize: 12.0,
              color: AppTokens.inkBlack,
            );
          }
          return const TextStyle(
            fontFamily: AppTokens.fontFamilyPrimary,
            fontWeight: AppTokens.weightRegular,
            fontSize: 12.0,
            color: AppTokens.slateGray,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppTokens.dustTaupe,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
