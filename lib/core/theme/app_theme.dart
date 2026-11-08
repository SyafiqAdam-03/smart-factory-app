import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';

/// 8px grid, 12px radius, 1px borders, 48px minimum touch target (gloves).
class AppSpacing {
  AppSpacing._();
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;

  static const double radius = 12;
  static const double border = 1;
  static const double minTouch = 48;
  static const double primaryButtonHeight = 56;
}

/// Inter for text, RobotoMono for batch / serial numbers.
class AppTextStyles {
  AppTextStyles._();

  /// Small uppercase field label. Use via SectionLabel, which uppercases.
  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColors.slate500,
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.slate900,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.slate900,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.slate900,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.slate500,
  );

  /// Big, readable numbers (tiles, stock totals).
  static const TextStyle bigNumber = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.slate900,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Batch numbers, serial numbers, SKUs.
  static const TextStyle mono = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.slate700,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.navy,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.slate900,
      error: AppColors.failed,
      onError: AppColors.white,
      outline: AppColors.slate300,
      outlineVariant: AppColors.slate200,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );
    const buttonText = TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    OutlineInputBorder inputBorder(Color c, [double w = AppSpacing.border]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.slate100,
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          side: const BorderSide(color: AppColors.slate200, width: AppSpacing.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.slate300,
          minimumSize: const Size(64, AppSpacing.minTouch),
          elevation: 0,
          shape: shape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(64, AppSpacing.minTouch),
          side: const BorderSide(color: AppColors.slate300, width: AppSpacing.border),
          shape: shape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          minimumSize: const Size(64, AppSpacing.minTouch),
          shape: shape,
          textStyle: buttonText,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouch, AppSpacing.minTouch),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouch),
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 15),
        border: inputBorder(AppColors.slate300),
        enabledBorder: inputBorder(AppColors.slate300),
        focusedBorder: inputBorder(AppColors.accent, 2),
        errorBorder: inputBorder(AppColors.failed),
        focusedErrorBorder: inputBorder(AppColors.failed, 2),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.navy,
        checkmarkColor: AppColors.white,
        side: const BorderSide(color: AppColors.slate300),
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.slate700,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.accentSoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              size: 26,
              color: states.contains(WidgetState.selected)
                  ? AppColors.accent
                  : AppColors.slate500,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: states.contains(WidgetState.selected)
                  ? AppColors.accent
                  : AppColors.slate500,
            )),
      ),
    );
  }
}
