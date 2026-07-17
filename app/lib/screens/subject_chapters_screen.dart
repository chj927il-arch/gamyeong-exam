import 'package:flutter/material.dart';
import '../data/topic_stats.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import 'quiz_screen.dart';
import 'stats_screen.dart';

/// 과목 진입 시 보여주는 챕터(유형) 목록 화면.
/// 출제 비중이 큰 순서대로 챕터가 정렬되어, 비중 높은 유형부터 집중 공략할 수 있게 한다.
class SubjectChaptersScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;

  const SubjectChaptersScreen({super.key, required this.subjectId, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(subjectId);
    final chapters = chapterStatsFor(subjectId);
    final isAnalyzed = subjectStatsIsAnalyzed[subjectId] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StatsScreen(subjectId: subjectId, subjectName: subjectName),
              ),
            ),
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: '출제 통계',
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: style.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(style.icon, color: style.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$subjectName 챕터별 집중공략',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        Text(
                          isAnalyzed ? '기출 분석 기반 · 출제 비중 높은 순' : '기출 분석 준비 중 · 과목 대분류 순',
                          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (chapters.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('챕터 준비 중입니다.', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...List.generate(chapters.length, (i) {
                  final chapter = chapters[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ChapterCard(
                      rank: i + 1,
                      chapter: chapter,
                      showRatio: isAnalyzed,
                      color: style.color,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            subjectId: subjectId,
                            subjectName: subjectName,
                            category: chapter.topic,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final int rank;
  final TopicStat chapter;
  final bool showRatio;
  final Color color;
  final VoidCallback onTap;

  const _ChapterCard({
    required this.rank,
    required this.chapter,
    required this.showRatio,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (chapter.ratio * 100).toStringAsFixed(1);

    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank <= 3 ? color.withValues(alpha: 0.14) : AppColors.trackBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: rank <= 3 ? color : AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.topic,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary),
                ),
                if (showRatio) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: chapter.ratio,
                      minHeight: 6,
                      backgroundColor: AppColors.trackBg,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '기출 ${chapter.questionCount}문항 · 출제비중 $percent%',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '유사문제 풀어보기',
                      style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
