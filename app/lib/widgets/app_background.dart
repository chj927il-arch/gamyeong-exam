import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 전 화면 공통 배경 — 다크 네이비 베이스 + 은은하게 퍼지는 컬러 글로우.
/// 글래스 카드(GlassCard)가 블러로 비출 대상이 있어야 유리 느낌이 살기 때문에 필요.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: AppColors.bgBase)),
        Positioned(
          top: -60,
          left: -70,
          child: _glowOrb(color: AppColors.gold, size: 260, opacity: 0.30),
        ),
        Positioned(
          top: 160,
          right: -90,
          child: _glowOrb(color: const Color(0xFF7C93FF), size: 220, opacity: 0.22),
        ),
        Positioned(
          bottom: -100,
          left: -60,
          child: _glowOrb(color: const Color(0xFFC084FC), size: 240, opacity: 0.20),
        ),
        child,
      ],
    );
  }

  static Widget _glowOrb({required Color color, required double size, required double opacity}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: opacity)),
      ),
    );
  }
}
