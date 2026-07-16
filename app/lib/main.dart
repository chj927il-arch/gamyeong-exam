import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/wrong_note_screen.dart';
import 'screens/compiled_note_screen.dart';
import 'screens/stats_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/app_background.dart';

void main() {
  runApp(const GamyeongExamApp());
}

class GamyeongExamApp extends StatelessWidget {
  const GamyeongExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '가맹거래사 1차 시험대비',
      theme: AppTheme.light(),
      home: const RootScreen(),
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
    return Scaffold(
      appBar: AppBar(
        title: _tabIndex == 0
            ? const Text('가맹거래사 1차 시험대비', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22))
            : Text(_titles[_tabIndex]),
        centerTitle: _tabIndex == 0,
      ),
      body: AppBackground(child: SafeArea(child: _tabs[_tabIndex])),
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
