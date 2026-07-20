import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  // 폰트가 늦게 로드되면 마키(ticker) 위젯들이 초기 측정 이후 폭이 달라져
  // 텍스트가 겹쳐 보이는 문제가 있어, 첫 프레임 전에 폰트를 미리 받아둔다.
  WidgetsFlutterBinding.ensureInitialized();
  // 실제로 쓰는 폰트를 한 번 참조해야 로딩이 트리거된다.
  GoogleFonts.blackHanSans();
  GoogleFonts.ibmPlexSansKr();
  await GoogleFonts.pendingFonts();
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
