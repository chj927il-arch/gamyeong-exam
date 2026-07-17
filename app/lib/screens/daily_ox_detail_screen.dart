import 'package:flutter/material.dart';
import '../data/ox_quiz_data.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/glass_card.dart';

/// 특정 회차의 데일리 OX 퀴즈 — 과목별 1문제씩 O/X로 풀어본다.
class DailyOxDetailScreen extends StatefulWidget {
  final DailyOxQuiz quiz;
  const DailyOxDetailScreen({super.key, required this.quiz});

  @override
  State<DailyOxDetailScreen> createState() => _DailyOxDetailScreenState();
}

class _DailyOxDetailScreenState extends State<DailyOxDetailScreen> {
  final Map<int, bool> _selected = {};

  void _select(int index, bool value) {
    if (_selected.containsKey(index)) return;
    setState(() => _selected[index] = value);
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;
    final answeredCount = _selected.length;
    final correctCount = _selected.entries.where((e) => e.value == questions[e.key].answer).length;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.quiz.date} OX퀴즈'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          if (answeredCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                '$answeredCount / ${questions.length}문제 풀이 · 정답 $correctCount개',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
            ),
          ...List.generate(questions.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _OxQuestionCard(
                index: i,
                question: questions[i],
                selected: _selected[i],
                onSelect: (v) => _select(i, v),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _OxQuestionCard extends StatelessWidget {
  final int index;
  final OxQuestion question;
  final bool? selected;
  final ValueChanged<bool> onSelect;

  const _OxQuestionCard({required this.index, required this.question, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(question.subjectId);
    final answered = selected != null;
    final isCorrect = answered && selected == question.answer;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                child: Text(question.subjectName, style: TextStyle(color: style.color, fontSize: 11.5, fontWeight: FontWeight.w800)),
              ),
              const Spacer(),
              Text('Q${index + 1}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Text(question.statement, style: const TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _OxButton(label: 'O', active: selected == true, correctState: answered ? question.answer == true : null, onTap: () => onSelect(true))),
              const SizedBox(width: 12),
              Expanded(child: _OxButton(label: 'X', active: selected == false, correctState: answered ? question.answer == false : null, onTap: () => onSelect(false))),
            ],
          ),
          if (answered) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isCorrect ? AppColors.correct : AppColors.wrong).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 18, color: isCorrect ? AppColors.correct : AppColors.wrong),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.explanation,
                      style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OxButton extends StatelessWidget {
  final String label;
  final bool active;
  final bool? correctState; // true=이 버튼이 정답, false=이 버튼이 오답, null=아직 안 풀림
  final VoidCallback onTap;

  const _OxButton({required this.label, required this.active, required this.correctState, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.trackBg;
    Color fg = AppColors.textSecondary;
    Color border = Colors.transparent;

    if (correctState == true) {
      bg = AppColors.correct.withValues(alpha: 0.12);
      fg = AppColors.correct;
      border = AppColors.correct.withValues(alpha: 0.4);
    } else if (active && correctState == false) {
      bg = AppColors.wrong.withValues(alpha: 0.12);
      fg = AppColors.wrong;
      border = AppColors.wrong.withValues(alpha: 0.4);
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
          child: Text(label, style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
