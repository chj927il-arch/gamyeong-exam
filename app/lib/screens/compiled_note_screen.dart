import 'package:flutter/material.dart';
import '../data/sample_questions.dart';
import '../data/user_progress.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/empty_state.dart';
import '../widgets/glass_card.dart';

class CompiledNoteScreen extends StatelessWidget {
  const CompiledNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserProgress.instance,
      builder: (context, _) {
        final ids = UserProgress.instance.compiledQuestionIds;
        final questions = sampleQuestions.where((q) => ids.contains(q.id)).toList();

        if (questions.isEmpty) {
          return const EmptyState(
            icon: Icons.bookmark_outline,
            title: '단권화 노트가 비어있어요',
            description: '문제 풀이 중 마음에 든 핵심 요약 해설을 저장하면\n나만의 단권화 노트로 모아볼 수 있어요.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: questions.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            if (i == 0) {
              return Text(
                '저장한 노트 ${questions.length}개',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              );
            }
            return _CompiledCard(question: questions[i - 1]);
          },
        );
      },
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
