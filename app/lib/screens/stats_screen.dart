import 'package:flutter/material.dart';
import '../data/topic_stats.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          '경제법 기출 유형 분석',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          '2016~2026년 (제15회~제24회) 기출 440문항 직접 분석',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              for (final stat in economicLawTopicStats) ...[
                _TopicBar(stat: stat),
                if (stat != economicLawTopicStats.last) const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicBar extends StatelessWidget {
  final TopicStat stat;
  const _TopicBar({required this.stat});

  @override
  Widget build(BuildContext context) {
    final percent = (stat.ratio * 100).toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                stat.topic,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${stat.questionCount}문항 · $percent%',
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: stat.ratio,
            minHeight: 8,
            backgroundColor: AppColors.trackBg,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
