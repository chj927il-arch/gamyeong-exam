import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          '통계\n\n과목별 정답률, 개념별 숙련도, 학습 진도가 여기에 표시됩니다.\n(데이터 연동 예정)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
