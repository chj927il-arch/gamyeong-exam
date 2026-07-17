import 'package:flutter/material.dart';

/// 진행률/정답률을 보여주는 작은 링(도넛) 게이지. 여러 화면에서 재사용된다.
class ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;
  final TextStyle? labelStyle;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    this.size = 56,
    this.strokeWidth = 6,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(color.withValues(alpha: 0.14)),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: labelStyle ?? TextStyle(fontSize: size * 0.23, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}
