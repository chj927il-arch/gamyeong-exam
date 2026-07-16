import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 전 화면 공통 배경 — 상단에서 은은하게 퍼지는 다크 네이비 글로우
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.7, -1.0),
                radius: 1.5,
                colors: [AppColors.bgGlow, AppColors.bgBase],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
