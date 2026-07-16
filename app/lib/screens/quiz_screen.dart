import 'package:flutter/material.dart';
import '../data/sample_questions.dart';
import '../models/question.dart';

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
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.subjectName)),
        body: const Center(child: Text('아직 이 과목의 샘플 문제가 없습니다.')),
      );
    }

    final question = _questions[_current];
    final isCorrect = _selectedIndex == question.correctIndex;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.subjectName} · ${question.category}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.stem, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(question.choices.length, (i) {
              final selected = _selectedIndex == i;
              Color? color;
              if (_answered) {
                if (i == question.correctIndex) {
                  color = Colors.green.shade100;
                } else if (selected) {
                  color = Colors.red.shade100;
                }
              }
              return Card(
                color: color,
                child: ListTile(
                  title: Text(question.choices[i]),
                  onTap: () => _select(i),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 12),
              Text(
                isCorrect ? '정답입니다' : '오답입니다',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text('핵심 요약: ${question.summaryExplanation}'),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: question.keyPoints
                    .map((k) => Chip(label: Text(k)))
                    .toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _next,
                // 정답/오답 관계없이 유사문제를 계속 반복 노출하는 구조 (추후 AI 생성 연결)
                child: const Text('다음 유사문제'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
