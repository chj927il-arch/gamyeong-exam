import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 전 화면 공통 배경 — 심플한 화이트 배경.
/// 상단에 아주 은은한 그레이 그라데이션만 주어 답답하지 않게 함.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: AppColors.bgBase)),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 220,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.bgGlow, AppColors.bgBase],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
