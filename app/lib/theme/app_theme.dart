import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // 배경 (다크 네이비 그라데이션)
  static const bgGlow = Color(0xFF1E2438);
  static const bgBase = Color(0xFF0A0C12);
  static const surfaceRaised = Color(0xFF12151F);

  // 포인트 컬러 (골드 — 프리미엄 자격증 시험 톤)
  static const gold = Color(0xFFE3B563);
  static const goldBright = Color(0xFFF3CB82);

  // 유리(글래스) 표면
  static const glassBorder = Color(0x1FFFFFFF); // white 12%
  static const glassFill = Color(0x0FFFFFFF); // white 6%

  // 텍스트
  static const textPrimary = Color(0xFFF5F6FA);
  static const textSecondary = Color(0xFFA0A6B8);
  static const textMuted = Color(0xFF6B7180);

  // 상태
  static const correct = Color(0xFF34D399);
  static const wrong = Color(0xFFFF6B6B);
}

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gold,
        brightness: Brightness.dark,
      ),
    );
    final textTheme = GoogleFonts.notoSansKrTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgBase,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.gold.withValues(alpha: 0.14),
        labelStyle: textTheme.labelMedium?.copyWith(color: AppColors.goldBright, fontWeight: FontWeight.w700),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceRaised,
        indicatorColor: AppColors.gold.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppColors.goldBright : AppColors.textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.goldBright : AppColors.textSecondary,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: const Color(0xFF241A05),
          disabledBackgroundColor: AppColors.gold.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
        linearTrackColor: AppColors.glassFill,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.glassBorder, space: 1),
    );
  }
}
