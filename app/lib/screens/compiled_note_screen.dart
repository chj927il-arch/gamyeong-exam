import 'package:flutter/material.dart';
import '../widgets/empty_state.dart';

class CompiledNoteScreen extends StatelessWidget {
  const CompiledNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.bookmark_outline,
      title: '단권화 노트가 비어있어요',
      description: '문제 풀이 중 마음에 든 핵심 요약 해설을 저장하면\n나만의 단권화 노트로 모아볼 수 있어요.',
    );
  }
}
