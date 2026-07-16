import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/wrong_note_screen.dart';
import 'screens/compiled_note_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const GamyeongExamApp());
}

class GamyeongExamApp extends StatelessWidget {
  const GamyeongExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '가맹거래사 문제은행',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
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
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_tabIndex])),
      body: _tabs[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school_outlined), label: '학습'),
          NavigationDestination(icon: Icon(Icons.error_outline), label: '오답노트'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), label: '단권화'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: '통계'),
        ],
      ),
    );
  }
}
