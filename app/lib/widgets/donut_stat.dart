import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 레퍼런스 대시보드의 도넛(링) 게이지 — 중앙에 퍼센트, 아래 라벨/서브라벨.
class DonutStat extends StatelessWidget {
  final double percent; // 0.0 ~ 1.0
  final String label;
  final String? sublabel;
  final Color color;
  final double size;

  const DonutStat({
    super.key,
    required this.percent,
    required this.label,
    this.sublabel,
    required this.color,
    this.size = 92,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
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
                  strokeWidth: 9,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(color.withValues(alpha: 0.12)),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: percent.clamp(0, 1),
                  strokeWidth: 9,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Text(
                '${(percent * 100).round()}%',
                style: TextStyle(fontSize: size * 0.22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        if (sublabel != null) ...[
          const SizedBox(height: 2),
          Text(
            sublabel!,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}
