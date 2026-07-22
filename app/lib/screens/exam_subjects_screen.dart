import 'package:flutter/material.dart';
import '../models/exam_subject.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/glass_card.dart';
import 'subject_info_screen.dart';

/// 시험과목 탭 — 과목 목록. 탭하면 과목소개·출제경향·통계·학습방법을 보여준다.
class ExamSubjectsScreen extends StatelessWidget {
  const ExamSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시험과목'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            '1차 시험 과목',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            '과목을 눌러 출제경향과 학습방법을 확인해보세요',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...examSubjects.map(
            (subject) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SubjectListCard(subject: subject),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectListCard extends StatelessWidget {
  final ExamSubject subject;
  const _SubjectListCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(subject.id);
    return GlassCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SubjectInfoScreen(subjectId: subject.id, subjectName: subject.name)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(style.icon, color: style.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary)),
                if (subject.categories.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subject.categories.join(' · '),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
