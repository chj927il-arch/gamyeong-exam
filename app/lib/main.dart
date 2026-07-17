import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GamyeongExamApp());
}

class GamyeongExamApp extends StatelessWidget {
  const GamyeongExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스터디박스',
      theme: AppTheme.light(),
      home: const SplashScreen(),
      // 웹/데스크톱 브라우저처럼 화면이 넓을 때도 폰 앱처럼 보이도록 폭 제한
      builder: (context, child) {
        return ColoredBox(
          color: AppColors.trackBg,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
