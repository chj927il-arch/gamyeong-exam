import 'package:flutter/material.dart';

/// 화이트 배경 + 블랙 텍스트 + 오렌지 키컬러의 프리미엄 라이트 테마.
class AppColors {
  AppColors._();

  // 배경
  static const bgBase = Color(0xFFFFFFFF);
  static const bgGlow = Color(0xFFFFF3EA); // 섹션 상단용 아주 옅은 오렌지 톤
  static const surfaceRaised = Color(0xFFFAFAFC);

  // 키 컬러 (오렌지)
  static const primary = Color(0xFFFF6B1A); // 브랜드 오렌지
  static const primaryDark = Color(0xFFC2410C); // 텍스트/아이콘용 짙은 오렌지 (대비 확보)
  static const primarySoft = Color(0xFFFFE7D6); // 옅은 오렌지 배경(탭/배지용)
  static const ink = Color(0xFF15171C); // 보조 강조용 잉크블랙

  // 카드 표면
  static const glassBorder = Color(0xFFEDEDF1); // 헤어라인 보더
  static const glassFill = Color(0xFFFFFFFF);
  static const trackBg = Color(0xFFF0F0F3); // 진행바 트랙(배경)

  // 텍스트
  static const textPrimary = Color(0xFF15171C);
  static const textSecondary = Color(0xFF666B78);
  static const textMuted = Color(0xFF9DA1AC);

  // 상태
  static const correct = Color(0xFF1FA35C);
  static const wrong = Color(0xFFE0473F);
}

class AppTheme {
  AppTheme._();

  static const fontFamily = 'Pretendard';

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );
    final textTheme = base.textTheme.apply(
      fontFamily: fontFamily,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgBase,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgBase,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 21,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        labelStyle: textTheme.labelMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgBase,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppColors.primary : AppColors.textMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textMuted,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          elevation: 0,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.trackBg,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.glassBorder, space: 1),
    );
  }
}
