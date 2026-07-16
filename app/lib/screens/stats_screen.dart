import 'package:flutter/material.dart';
import '../widgets/empty_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.bar_chart_outlined,
      title: '아직 통계가 쌓이지 않았어요',
      description: '문제를 풀수록 과목별 정답률과\n개념별 숙련도가 여기에 표시돼요.',
    );
  }
}
