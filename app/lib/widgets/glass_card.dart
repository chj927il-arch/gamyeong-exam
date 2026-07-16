import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 반투명 블러 카드 (글래스모피즘). tint를 주면 색이 있는 유리처럼 보임.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;
  final Color? tint;
  final double tintOpacity;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = const BorderRadius.all(Radius.circular(20)),
    this.tint,
    this.tintOpacity = 0.14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor = tint == null ? AppColors.glassFill : tint!.withValues(alpha: tintOpacity);
    final borderColor = tint == null ? AppColors.glassBorder : tint!.withValues(alpha: 0.35);

    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: radius,
              border: Border.all(color: borderColor),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
