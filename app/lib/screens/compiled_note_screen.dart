import 'package:flutter/material.dart';

class CompiledNoteScreen extends StatelessWidget {
  const CompiledNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          '단권화 노트\n\n문제를 풀면서 마음에 든 핵심 요약 해설을 골라 저장하면\n나만의 단권화 노트가 됩니다.\n(저장 기능 연동 예정)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
