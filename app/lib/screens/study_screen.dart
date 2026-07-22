import 'package:flutter/material.dart';
import '../data/study_stats.dart';
import '../models/exam_subject.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/progress_ring.dart';
import 'subject_chapters_screen.dart';

/// 학습하기 탭 — 과목을 선택해 챕터별 유사문제 풀이로 들어간다.
class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학습하기'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            '무엇을 학습할까요?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            '과목을 선택하면 출제비중이 높은 챕터부터 유사문제를 풀 수 있어요',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          ...examSubjects.map(
            (subject) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SubjectCard(subject: subject),
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
                ProgressRing(progress: progress, color: style.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
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
                          const Icon(Icons.edit_note_rounded, size: 15, color: AppColors.textMuted),
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
