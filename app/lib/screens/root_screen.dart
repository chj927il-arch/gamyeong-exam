import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import 'compiled_note_screen.dart';
import 'home_screen.dart';
import 'wrong_note_screen.dart';

const double _kEncourageBarHeight = 24;

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
    final titleBarHeight = _tabIndex == 0 ? 64.0 : kToolbarHeight;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_kEncourageBarHeight + titleBarHeight),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _EncourageBar(),
              AppBar(
                toolbarHeight: titleBarHeight,
                title: _tabIndex == 0
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('가맹거래사 1차 시험대비', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 21)),
                          SizedBox(height: 2),
                          Text(
                            '가장 스마트하게, 가장 콤팩트하게.',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      )
                    : Text(_titles[_tabIndex]),
                centerTitle: _tabIndex == 0,
              ),
            ],
          ),
        ),
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

/// 상단 타이틀 위에 표시되는 얇은 응원 문구 바 — 텍스트 높이에 딱 맞는 슬림 바.
class _EncourageBar extends StatelessWidget {
  const _EncourageBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _kEncourageBarHeight,
      color: AppColors.primary,
      alignment: Alignment.center,
      child: const Text(
        '여러분의 합격을 응원합니다.',
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
