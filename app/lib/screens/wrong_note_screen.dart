import 'package:flutter/material.dart';
import '../widgets/empty_state.dart';

class WrongNoteScreen extends StatelessWidget {
  const WrongNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.error_outline,
      title: '아직 틀린 문제가 없어요',
      description: '문제를 풀다 틀리면 여기에 자동으로 모이고,\n같은 개념의 유사문제가 반복해서 제시돼요.',
    );
  }
}
