import 'package:flutter/material.dart';

class WrongNoteScreen extends StatelessWidget {
  const WrongNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          '오답노트\n\n틀린 문제와 그로부터 생성된 유사문제 기록이 여기에 쌓입니다.\n(문제 풀이 데이터 연동 예정)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
