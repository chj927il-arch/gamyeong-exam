import 'package:flutter/material.dart';
import '../data/sample_questions.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';

const _optionLabels = ['A', 'B', 'C', 'D', 'E'];

class QuizScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const QuizScreen({super.key, required this.subjectId, required this.subjectName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<Question> _questions;
  int _current = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _solvedInSession = 0;

  @override
  void initState() {
    super.initState();
    _questions = sampleQuestions.where((q) => q.subjectId == widget.subjectId).toList();
  }

  void _select(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      _solvedInSession++;
    });
  }

  void _next() {
    setState(() {
      _current = (_current + 1) % _questions.length;
      _selectedIndex = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(widget.subjectId);

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.subjectName)),
        body: AppBackground(
          child: const Center(
            child: Text('아직 이 과목의 샘플 문제가 없습니다.', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ),
      );
    }

    final question = _questions[_current];
    final isCorrect = _selectedIndex == question.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '이번 회차 $_solvedInSession문제',
                  style: TextStyle(color: style.color, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(question.category),
                  backgroundColor: style.color.withValues(alpha: 0.16),
                  labelStyle: TextStyle(color: style.color, fontWeight: FontWeight.w700),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(height: 14),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    question.stem,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(question.choices.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _OptionTile(
                      label: _optionLabels[i],
                      text: question.choices[i],
                      state: _optionState(i, question.correctIndex),
                      onTap: () => _select(i),
                    ),
                  );
                }),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _answered
                      ? _FeedbackPanel(
                          key: ValueKey(_current),
                          isCorrect: isCorrect,
                          question: question,
                          onNext: _next,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _OptionState _optionState(int index, int correctIndex) {
    if (!_answered) {
      return _selectedIndex == index ? _OptionState.selected : _OptionState.idle;
    }
    if (index == correctIndex) return _OptionState.correct;
    if (index == _selectedIndex) return _OptionState.wrong;
    return _OptionState.disabled;
  }
}

enum _OptionState { idle, selected, correct, wrong, disabled }

class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionTile({required this.label, required this.text, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color tint = Colors.white;
    double tintOpacity = 0.06;
    Color badgeBg = Colors.white.withValues(alpha: 0.08);
    Color badgeFg = AppColors.textSecondary;
    Widget? trailing;
    double opacity = 1;

    switch (state) {
      case _OptionState.selected:
        tint = AppColors.gold;
        tintOpacity = 0.12;
        badgeBg = AppColors.gold.withValues(alpha: 0.22);
        badgeFg = AppColors.goldBright;
        break;
      case _OptionState.correct:
        tint = AppColors.correct;
        tintOpacity = 0.16;
        badgeBg = AppColors.correct;
        badgeFg = const Color(0xFF06281C);
        trailing = const Icon(Icons.check_circle, color: AppColors.correct);
        break;
      case _OptionState.wrong:
        tint = AppColors.wrong;
        tintOpacity = 0.16;
        badgeBg = AppColors.wrong;
        badgeFg = const Color(0xFF2E0808);
        trailing = const Icon(Icons.cancel, color: AppColors.wrong);
        break;
      case _OptionState.disabled:
        opacity = 0.55;
        break;
      case _OptionState.idle:
        break;
    }

    return Opacity(
      opacity: opacity,
      child: GlassCard(
        tint: tint,
        tintOpacity: tintOpacity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
              child: Text(label, style: TextStyle(color: badgeFg, fontWeight: FontWeight.w800, fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 15, height: 1.3, color: AppColors.textPrimary),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final Question question;
  final VoidCallback onNext;

  const _FeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.question,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppColors.correct : AppColors.wrong;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            tint: color,
            tintOpacity: 0.12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: color),
                    const SizedBox(width: 8),
                    Text(
                      isCorrect ? '정답입니다' : '아쉬워요, 오답입니다',
                      style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  question.summaryExplanation,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
                ),
                if (question.keyPoints.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: question.keyPoints
                        .map((k) => Chip(
                              label: Text(k),
                              backgroundColor: Colors.white.withValues(alpha: 0.08),
                              labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('다음 유사문제'),
            ),
          ),
        ],
      ),
    );
  }
}
