import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import 'compiled_note_screen.dart';
import 'home_screen.dart';
import 'wrong_note_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _tabIndex = 0;

  static const _titles = ['학습', '오답노트', '단권화'];
  static const _tabs = [
    HomeScreen(),
    WrongNoteScreen(),
    CompiledNoteScreen(),
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
        ],
      ),
    );
  }
}
