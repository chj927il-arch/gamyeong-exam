import 'package:flutter/material.dart';
import '../data/sample_questions.dart';
import '../data/study_stats.dart';
import '../data/user_progress.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/glass_card.dart';
import '../widgets/weak_chapter_row.dart';

/// 학습 리포트 탭 — 과목별 취약 챕터 분석 + 저장한 단권화 노트를 한 화면에서 보여준다.
class LearningReportScreen extends StatelessWidget {
  const LearningReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Text(
          '학습 리포트',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          '정답률이 낮은 챕터부터 먼저 보강해보세요',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ...List.generate(weakChapters.length, (i) {
          final isLast = i == weakChapters.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
            child: WeakChapterRow(chapter: weakChapters[i]),
          );
        }),
        const SizedBox(height: 28),
        const Text(
          '저장한 노트',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        const Text(
          '문제 풀이 중 북마크한 핵심 해설 모음',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        ListenableBuilder(
          listenable: UserProgress.instance,
          builder: (context, _) {
            final ids = UserProgress.instance.compiledQuestionIds;
            final questions = sampleQuestions.where((q) => ids.contains(q.id)).toList();

            if (questions.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 28),
                alignment: Alignment.center,
                child: const Text(
                  '아직 저장한 노트가 없어요.\n문제 해설 화면의 북마크 버튼으로 저장해보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5, height: 1.5),
                ),
              );
            }

            return Column(
              children: questions
                  .map((q) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CompiledCard(question: q),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CompiledCard extends StatelessWidget {
  final Question question;
  const _CompiledCard({required this.question});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(question.subjectId);

    return GlassCard(
      tint: style.color,
      tintOpacity: 0.04,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: style.color, borderRadius: BorderRadius.circular(999)),
                child: Text(
                  question.category,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => UserProgress.instance.removeCompiled(question.id),
                icon: const Icon(Icons.bookmark_remove_rounded, size: 20, color: AppColors.textMuted),
                tooltip: '단권화 노트에서 제거',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.stem,
            style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, height: 1.4, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            question.summaryExplanation,
            style: const TextStyle(fontSize: 14, height: 1.55, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          if (question.keyPoints.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.keyPoints
                  .map((k) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: style.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: style.color.withValues(alpha: 0.2)),
                        ),
                        child: Text(k, style: TextStyle(color: style.color, fontWeight: FontWeight.w700, fontSize: 12.5)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
