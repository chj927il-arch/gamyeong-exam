import 'package:flutter/material.dart';
import '../data/sample_questions.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';

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
        body: const Center(child: Text('아직 이 과목의 샘플 문제가 없습니다.')),
      );
    }

    final question = _questions[_current];
    final isCorrect = _selectedIndex == question.correctIndex;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.subjectName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: style.softColor, borderRadius: BorderRadius.circular(999)),
                child: Text(
                  '이번 회차 $_solvedInSession문제',
                  style: TextStyle(color: style.color, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(question.category),
              backgroundColor: style.softColor,
              labelStyle: TextStyle(color: style.color, fontWeight: FontWeight.w700),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                question.stem,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.4),
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
                      accent: style.color,
                      onNext: _next,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
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
    Color bg = Colors.white;
    Color border = AppColors.cardBorder;
    Color badgeBg = AppColors.surface;
    Color badgeFg = AppColors.textSecondary;
    Widget? trailing;

    switch (state) {
      case _OptionState.selected:
        border = AppColors.primary;
        badgeBg = AppColors.primarySoft;
        badgeFg = AppColors.primary;
        break;
      case _OptionState.correct:
        bg = AppColors.accentSoft;
        border = AppColors.accent;
        badgeBg = AppColors.accent;
        badgeFg = Colors.white;
        trailing = const Icon(Icons.check_circle, color: AppColors.accent);
        break;
      case _OptionState.wrong:
        bg = AppColors.dangerSoft;
        border = AppColors.danger;
        badgeBg = AppColors.danger;
        badgeFg = Colors.white;
        trailing = const Icon(Icons.cancel, color: AppColors.danger);
        break;
      case _OptionState.disabled:
        bg = Colors.white;
        border = AppColors.cardBorder;
        break;
      case _OptionState.idle:
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: state == _OptionState.idle ? 1 : 1.6),
          ),
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
              Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.3))),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final Question question;
  final Color accent;
  final VoidCallback onNext;

  const _FeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.question,
    required this.accent,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppColors.accent : AppColors.danger;
    final softColor = isCorrect ? AppColors.accentSoft : AppColors.dangerSoft;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: softColor, borderRadius: BorderRadius.circular(18)),
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
                              backgroundColor: Colors.white,
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
