import 'package:flutter/material.dart';
import '../data/study_stats.dart';
import '../models/exam_subject.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/donut_stat.dart';
import '../widgets/glass_card.dart';
import '../widgets/rolling_banner.dart';
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
              const RollingBanner(),
              const SizedBox(height: 20),
              const _TodayHeader(),
              const SizedBox(height: 16),
              const _StatsGrid(),
              const SizedBox(height: 16),
              const _PeerComparisonCard(),
              const SizedBox(height: 16),
              const _WeeklyActivityCard(),
              const SizedBox(height: 24),
              const Text(
                '과목별 학습 현황',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
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
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: List.generate(examSubjects.length, (i) {
          final subject = examSubjects[i];
          final style = subjectStyleOf(subject.id);
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: i == 0 ? BorderSide.none : const BorderSide(color: AppColors.glassBorder),
                ),
              ),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(style.icon, size: 24, color: style.color),
                        const SizedBox(height: 6),
                        Text(
                          subject.name,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                      ],
                    ),
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
    return GlassCard(
      padding: const EdgeInsets.all(20),
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
                    color: AppColors.textPrimary,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              const _StreakBadge(days: StudyStats.streakDays),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: StudyStats.todaySolved / StudyStats.todayGoal,
              minHeight: 8,
              backgroundColor: AppColors.trackBg,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '오늘 목표 ${StudyStats.todaySolved} / ${StudyStats.todayGoal}문제 · ${StudyStats.todayMinutes}분 학습',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
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
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 4),
          Text('$days일', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w800, fontSize: 14)),
        ],
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
      (icon: Icons.schedule_outlined, label: '누적 학습시간', value: StudyStats.totalHoursLabel),
      (icon: Icons.local_fire_department_outlined, label: '연속 학습일', value: '${StudyStats.streakDays}일'),
      (icon: Icons.task_alt_outlined, label: '누적 푼 문제', value: '${StudyStats.totalSolved}문제'),
      (icon: Icons.percent_outlined, label: '전체 정답률', value: '${(StudyStats.totalAccuracy * 100).toStringAsFixed(0)}%'),
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
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(s.icon, size: 19, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s.value,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          Text(
                            s.label,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
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

/// "나 vs 합격생 평균" 비교 카드 — 도넛 게이지 2개 + 격차 안내 캡션
class _PeerComparisonCard extends StatelessWidget {
  const _PeerComparisonCard();

  @override
  Widget build(BuildContext context) {
    final gap = ((StudyStats.peerAccuracy - StudyStats.totalAccuracy) * 100).round();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '나 vs 합격생 평균',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          const Text(
            '정답률 기준으로 비교한 나의 현재 위치예요',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DonutStat(
                percent: StudyStats.totalAccuracy,
                label: '나',
                sublabel: '전체 정답률',
                color: AppColors.textPrimary,
              ),
              DonutStat(
                percent: StudyStats.peerAccuracy,
                label: StudyStats.peerLabel,
                sublabel: '전체 정답률',
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '합격생 평균보다 정답률이 $gap%p 낮아요. 취약 챕터부터 집중공략해보세요.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
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
          const SizedBox(height: 16),
          SizedBox(
            height: 112,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final isToday = d == data.last;
                final barHeight = d.minutes == 0 ? 4.0 : 8 + (d.minutes / maxMinutes) * 44;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          d.minutes == 0 ? '' : '${d.minutes}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: barHeight,
                            color: isToday ? AppColors.primary : AppColors.trackBg,
                          ),
                        ),
                        const SizedBox(height: 6),
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

    return GlassCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SubjectChaptersScreen(subjectId: subject.id, subjectName: subject.name),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(style.icon, color: style.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      subject.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    Text(
                      '오늘 $todaySolved문제',
                      style: TextStyle(color: style.color, fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ],
                ),
                if (subject.categories.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subject.categories.join(' · '),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: style.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(style.color),
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
