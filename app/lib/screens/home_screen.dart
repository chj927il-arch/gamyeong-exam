import 'package:flutter/material.dart';
import '../data/study_stats.dart';
import '../models/exam_subject.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/glass_card.dart';
import '../widgets/launch_banner.dart';
import '../widgets/rolling_banner.dart';
import 'quiz_screen.dart';
import 'subject_chapters_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SubjectMenu(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              const LaunchBanner(),
              const SizedBox(height: 12),
              const RollingBanner(),
              const SizedBox(height: 20),
              const _TodayHeader(),
              const SizedBox(height: 16),
              const _StudyReportCard(),
              const SizedBox(height: 16),
              const _StatsGrid(),
              const SizedBox(height: 16),
              const _WeeklyActivityCard(),
              const SizedBox(height: 28),
              const Text(
                '과목별 학습 현황',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              const Text(
                '탭해서 챕터별로 집중공략해보세요',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              ...examSubjects.map(
                (subject) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SubjectCard(subject: subject),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 상단 과목 메뉴 (경제법 · 민법 · 경영학) — 화면 폭에 딱 맞는 3분할, 여백 없음.
/// 탭하면 해당 과목의 챕터(출제유형)별 집중공략 화면으로 이동한다.
class _SubjectMenu extends StatelessWidget {
  const _SubjectMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.7)),
          bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.7)),
        ),
      ),
      child: Row(
        children: List.generate(examSubjects.length, (i) {
          final subject = examSubjects[i];
          final style = subjectStyleOf(subject.id);
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SubjectChaptersScreen(subjectId: subject.id, subjectName: subject.name),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    subject.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: style.color, fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ink, Color(0xFF2A2D35)],
        ),
        boxShadow: [
          BoxShadow(color: AppColors.ink.withValues(alpha: 0.22), blurRadius: 22, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  '오늘도 한 문제 더\n풀어볼까요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              const _StreakBadge(days: StudyStats.streakDays),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: StudyStats.todaySolved / StudyStats.todayGoal,
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.14),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '오늘 목표 ${StudyStats.todaySolved} / ${StudyStats.todayGoal}문제 · ${StudyStats.todayMinutes}분 학습',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int days;
  const _StreakBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 4),
          Text('$days일', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
        ],
      ),
    );
  }
}

/// 학습 리포트 — 과목별로 가장 취약한 챕터와 보강 제안을 보여준다.
class _StudyReportCard extends StatelessWidget {
  const _StudyReportCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.insights_rounded, size: 19, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '학습 리포트',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Padding(
            padding: EdgeInsets.only(left: 46),
            child: Text(
              '정답률이 낮은 챕터부터 먼저 보강해보세요',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(weakChapters.length, (i) {
            final w = weakChapters[i];
            final style = subjectStyleOf(w.subjectId);
            final isLast = i == weakChapters.length - 1;
            return _WeakChapterRow(chapter: w, color: style.color, showDivider: !isLast);
          }),
        ],
      ),
    );
  }
}

class _WeakChapterRow extends StatelessWidget {
  final WeakChapter chapter;
  final Color color;
  final bool showDivider;

  const _WeakChapterRow({required this.chapter, required this.color, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            subjectId: chapter.subjectId,
            subjectName: chapter.subjectName,
            category: chapter.chapterName,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      children: [
                        TextSpan(text: '${chapter.subjectName} · '),
                        TextSpan(text: chapter.chapterName, style: TextStyle(color: color)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.wrong.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '정답률 ${(chapter.accuracy * 100).round()}%',
                    style: const TextStyle(color: AppColors.wrong, fontWeight: FontWeight.w800, fontSize: 13.5),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                chapter.advice,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w400, height: 1.45),
              ),
            ),
            if (showDivider) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

/// 학습 이력 요약 (총 학습시간 · 연속학습일 · 총 푼 문제 · 정답률)
class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    final stats = [
      (icon: Icons.schedule_rounded, label: '누적 학습시간', value: StudyStats.totalHoursLabel),
      (icon: Icons.local_fire_department_rounded, label: '연속 학습일', value: '${StudyStats.streakDays}일'),
      (icon: Icons.task_alt_rounded, label: '누적 푼 문제', value: '${StudyStats.totalSolved}문제'),
      (icon: Icons.percent_rounded, label: '전체 정답률', value: '${(StudyStats.totalAccuracy * 100).toStringAsFixed(0)}%'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: stats
          .map((s) => GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(s.icon, size: 20, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s.value,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          Text(
                            s.label,
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// 최근 7일 학습 활동 미니 바 차트
class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard();

  @override
  Widget build(BuildContext context) {
    final data = StudyStats.weeklyActivity;
    final maxMinutes = data.map((d) => d.minutes).reduce((a, b) => a > b ? a : b).clamp(1, 999);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 7일 학습 활동',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 116,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final isToday = d == data.last;
                final barHeight = d.minutes == 0 ? 4.0 : 8 + (d.minutes / maxMinutes) * 46;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          d.minutes == 0 ? '' : '${d.minutes}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              gradient: isToday
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [AppColors.primary, Color(0xFF3E6FB0)],
                                    )
                                  : null,
                              color: isToday ? null : AppColors.trackBg,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          d.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final ExamSubject subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(subject.id);
    final progress = mockSubjectProgress[subject.id] ?? 0;
    final todaySolved = mockSubjectTodaySolved[subject.id] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: style.color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.045), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SubjectChaptersScreen(subjectId: subject.id, subjectName: subject.name),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProgressRing(progress: progress, color: style.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                            child: Icon(style.icon, size: 15, color: style.color),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subject.name,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (subject.categories.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: subject.categories
                              .map((c) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: style.color.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      c,
                                      style: TextStyle(color: style.color, fontSize: 11.5, fontWeight: FontWeight.w700),
                                    ),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.edit_note_rounded, size: 15, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '오늘 $todaySolved문제 풀이',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 과목 학습 진행률을 보여주는 작은 링(도넛) 게이지.
class _ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  const _ProgressRing({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation(color.withValues(alpha: 0.14)),
            ),
          ),
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}
