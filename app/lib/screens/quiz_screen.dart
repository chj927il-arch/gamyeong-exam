import 'package:flutter/material.dart';
import '../data/sample_questions.dart';
import '../data/user_progress.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/app_background.dart';
import '../widgets/highlighted_text.dart';

const _optionLabels = ['A', 'B', 'C', 'D', 'E'];

class QuizScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  /// 지정하면 해당 챕터(유형)의 문제만 필터링해서 보여준다.
  final String? category;

  const QuizScreen({super.key, required this.subjectId, required this.subjectName, this.category});

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
    _questions = sampleQuestions
        .where((q) => q.subjectId == widget.subjectId && (widget.category == null || q.category == widget.category))
        .toList();
  }

  void _select(int index) {
    if (_answered) return;
    final question = _questions[_current];
    if (index != question.correctIndex) {
      UserProgress.instance.markWrong(question.id);
    }
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
        appBar: AppBar(title: Text(widget.category ?? widget.subjectName)),
        body: AppBackground(
          child: Center(
            child: Text(
              widget.category == null ? '아직 이 과목의 샘플 문제가 없습니다.' : '이 챕터는 문제 준비 중이에요.\n곧 유사문제가 추가될 예정입니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    final question = _questions[_current];
    final isCorrect = _selectedIndex == question.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category ?? widget.subjectName),
        centerTitle: false,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _ProgressHeader(
                current: _current,
                total: _questions.length,
                solved: _solvedInSession,
                color: style.color,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _QuestionCard(question: question, color: style.color),
                      const SizedBox(height: 20),
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
                                color: style.color,
                                onNext: _next,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

/// 상단 진행 상태 바 — 이번 회차 진행률 + 푼 문제 수
class _ProgressHeader extends StatelessWidget {
  final int current;
  final int total;
  final int solved;
  final Color color;

  const _ProgressHeader({required this.current, required this.total, required this.solved, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (current + 1) / total,
                minHeight: 7,
                backgroundColor: AppColors.trackBg,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${current + 1} / $total',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '이번 회차 $solved문제',
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final Color color;

  const _QuestionCard({required this.question, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
                  child: Text(
                    question.category,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5),
                  ),
                ),
                if (question.sourceYear != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${question.sourceYear}년 기출',
                    style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              question.stem,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
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
    Color borderColor = AppColors.glassBorder;
    Color fillColor = Colors.white;
    Color badgeBg = AppColors.trackBg;
    Color badgeFg = AppColors.textSecondary;
    Widget? trailing;
    double opacity = 1;

    switch (state) {
      case _OptionState.selected:
        borderColor = AppColors.primary;
        fillColor = AppColors.primary.withValues(alpha: 0.06);
        badgeBg = AppColors.primary;
        badgeFg = Colors.white;
        break;
      case _OptionState.correct:
        borderColor = AppColors.correct;
        fillColor = AppColors.correct.withValues(alpha: 0.10);
        badgeBg = AppColors.correct;
        badgeFg = Colors.white;
        trailing = const Icon(Icons.check_circle_rounded, color: AppColors.correct, size: 22);
        break;
      case _OptionState.wrong:
        borderColor = AppColors.wrong;
        fillColor = AppColors.wrong.withValues(alpha: 0.10);
        badgeBg = AppColors.wrong;
        badgeFg = Colors.white;
        trailing = const Icon(Icons.cancel_rounded, color: AppColors.wrong, size: 22);
        break;
      case _OptionState.disabled:
        opacity = 0.5;
        break;
      case _OptionState.idle:
        break;
    }

    return Opacity(
      opacity: opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: state == _OptionState.idle ? 1 : 1.6),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(10)),
                    child: Text(label, style: TextStyle(color: badgeFg, fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 17, height: 1.35, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ),
                  if (trailing != null) ...[const SizedBox(width: 8), trailing],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final Question question;
  final Color color;
  final VoidCallback onNext;

  const _FeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.question,
    required this.color,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final resultColor = isCorrect ? AppColors.correct : AppColors.wrong;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: resultColor.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(color: resultColor.withValues(alpha: 0.10), blurRadius: 18, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: resultColor.withValues(alpha: 0.14), shape: BoxShape.circle),
                      child: Icon(
                        isCorrect ? Icons.check_rounded : Icons.close_rounded,
                        color: resultColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isCorrect ? '정답입니다' : '아쉬워요, 오답입니다',
                        style: TextStyle(color: resultColor, fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                    ),
                    ListenableBuilder(
                      listenable: UserProgress.instance,
                      builder: (context, _) {
                        final compiled = UserProgress.instance.isCompiled(question.id);
                        return IconButton(
                          onPressed: () => UserProgress.instance.toggleCompiled(question.id),
                          icon: Icon(
                            compiled ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: compiled ? AppColors.primary : AppColors.textMuted,
                          ),
                          tooltip: '단권화 노트에 저장',
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '해설',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.4),
                ),
                const SizedBox(height: 6),
                HighlightedText(
                  text: question.summaryExplanation,
                  phrases: question.highlightPhrases,
                  style: const TextStyle(fontSize: 15.5, height: 1.65, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
                if (question.keyPoints.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    '핵심 개념',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: question.keyPoints
                        .map((k) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: color.withValues(alpha: 0.22)),
                              ),
                              child: Text(
                                k,
                                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('다음 유사문제'),
            ),
          ),
        ],
      ),
    );
  }
}
