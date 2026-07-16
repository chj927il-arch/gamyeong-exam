import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/wrong_note_screen.dart';
import 'screens/compiled_note_screen.dart';
import 'screens/stats_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GamyeongExamApp());
}

class GamyeongExamApp extends StatelessWidget {
  const GamyeongExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '가맹거래사 문제은행',
      theme: AppTheme.light(),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _tabIndex = 0;

  static const _titles = ['학습', '오답노트', '단권화', '통계'];
  static const _tabs = [
    HomeScreen(),
    WrongNoteScreen(),
    CompiledNoteScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // 학습(홈) 탭은 자체 커스텀 헤더를 쓰므로 공용 AppBar를 숨김
    final showAppBar = _tabIndex != 0;
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(_titles[_tabIndex])) : null,
      body: SafeArea(child: _tabs[_tabIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: '학습',
          ),
          NavigationDestination(
            icon: Icon(Icons.error_outline),
            selectedIcon: Icon(Icons.error),
            label: '오답노트',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: '단권화',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '통계',
          ),
        ],
      ),
    );
  }
}
