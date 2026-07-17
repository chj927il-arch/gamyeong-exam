import 'package:flutter/material.dart';
import '../data/study_stats.dart';
import '../models/exam_subject.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/glass_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/weak_chapter_row.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'subject_chapters_screen.dart';
import 'wrong_note_screen.dart';

/// 마이페이지 탭 — 학습리포트 전체 + 계정 관리(비밀번호 변경, 오답노트, 로그아웃).
class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const _ProfileHeader(),
        const SizedBox(height: 20),
        const Text(
          '학습 리포트',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 14),
        const _StatsGrid(),
        const SizedBox(height: 16),
        const _WeeklyActivityCard(),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('과목별 취약 챕터', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('정답률이 낮은 챕터부터 먼저 보강해보세요', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ...List.generate(weakChapters.length, (i) {
                final isLast = i == weakChapters.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                  child: WeakChapterRow(chapter: weakChapters[i]),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '과목별 학습 현황',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        ...examSubjects.map(
          (subject) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SubjectProgressCard(subject: subject),
          ),
        ),
        const SizedBox(height: 24),
        const Text('계정 관리', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MenuTile(
                icon: Icons.error_outline_rounded,
                label: '오답노트',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WrongNoteScreen())),
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.lock_outline_rounded,
                label: '비밀번호 변경',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.logout_rounded,
                label: '로그아웃',
                color: AppColors.wrong,
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ink, Color(0xFF2A2D35)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.3), shape: BoxShape.circle),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('수험생님, 환영해요 👋', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('오늘도 목표한 만큼 학습해보세요', style: TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(s.icon, size: 20, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(s.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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
          const Text('최근 7일 학습 활동', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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
                                  ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary, Color(0xFF3E6FB0)])
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

class _SubjectProgressCard extends StatelessWidget {
  final ExamSubject subject;
  const _SubjectProgressCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(subject.id);
    final progress = mockSubjectProgress[subject.id] ?? 0;

    return GlassCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SubjectChaptersScreen(subjectId: subject.id, subjectName: subject.name)),
      ),
      child: Row(
        children: [
          ProgressRing(progress: progress, color: style.color, size: 44, strokeWidth: 5),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: style.color.withValues(alpha: 0.10),
                    valueColor: AlwaysStoppedAnimation(style.color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: tileColor),
      title: Text(label, style: TextStyle(color: tileColor, fontWeight: FontWeight.w700, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
