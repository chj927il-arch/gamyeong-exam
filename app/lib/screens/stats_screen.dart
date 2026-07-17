import 'package:flutter/material.dart';
import '../data/topic_stats.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';

/// 과목별 출제 통계 및 경향 분석 화면. 과목 챕터 화면 상단의 통계 아이콘에서 진입한다.
class StatsScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;

  const StatsScreen({super.key, required this.subjectId, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final stats = chapterStatsFor(subjectId);
    final isAnalyzed = subjectStatsIsAnalyzed[subjectId] ?? false;
    final top3 = stats.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: Text('$subjectName 출제 통계'), centerTitle: false),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(
                '$subjectName 기출 유형 분석',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                isAnalyzed ? '2016~2026년 (제15회~제24회) 기출 440문항 직접 분석' : '기출 분석 준비 중 · 과목 대분류 기준',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
              if (isAnalyzed && top3.isNotEmpty) ...[
                const SizedBox(height: 16),
                GlassCard(
                  tint: AppColors.primary,
                  tintOpacity: 0.05,
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primaryDark, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '출제 비중 1~3위: ${top3.map((s) => s.topic).join(' · ')}. 이 세 챕터가 전체의 '
                          '${(top3.fold<int>(0, (sum, s) => sum + s.questionCount) / stats.first.totalQuestions * 100).toStringAsFixed(0)}%를 차지해요.',
                          style: const TextStyle(fontSize: 13.5, height: 1.5, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  children: [
                    for (final stat in stats) ...[
                      _TopicBar(stat: stat, showRatio: isAnalyzed),
                      if (stat != stats.last) const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicBar extends StatelessWidget {
  final TopicStat stat;
  final bool showRatio;
  const _TopicBar({required this.stat, required this.showRatio});

  @override
  Widget build(BuildContext context) {
    if (!showRatio) {
      return Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            stat.topic,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ],
      );
    }

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
