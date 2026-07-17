import 'package:flutter/material.dart';

/// 앱 론칭 안내 배너 — 롤링배너 위에 고정으로 표시되는 프로모션 이미지 배너.
class LaunchBanner extends StatelessWidget {
  const LaunchBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // 좌우 여백 없이 화면 폭 전체를 채우는 풀블리드 배너 — 라운드 처리하지 않는다.
    return AspectRatio(
      aspectRatio: 1774 / 887,
      child: Image.asset(
        'assets/images/launch_banner.png',
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
