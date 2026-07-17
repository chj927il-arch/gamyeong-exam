import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 화이트 배경 위의 심플한 서페이스 카드 (옅은 보더 + 아주 은은한 그림자).
/// 이름은 GlassCard로 유지하되(호출부 영향 최소화), 라이트 테마에서는
/// 블러 없는 플랫 카드로 렌더링한다.
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
    this.radius = const BorderRadius.all(Radius.circular(18)),
    this.tint,
    this.tintOpacity = 0.08,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor = tint == null ? AppColors.glassFill : tint!.withValues(alpha: tintOpacity);
    final borderColor = tint == null ? AppColors.glassBorder : tint!.withValues(alpha: 0.28);

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: radius,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 22, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
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
