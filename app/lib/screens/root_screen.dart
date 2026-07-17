import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/marquee_text.dart';
import 'exam_intro_screen.dart';
import 'exam_subjects_screen.dart';
import 'home_screen.dart';
import 'mypage_screen.dart';
import 'study_screen.dart';

const double _kEncourageBarHeight = 24;
const int _kTabCount = 5;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _tabIndex = 0;

  static const _titles = ['홈', '시험소개', '시험과목', '학습하기', '마이페이지'];

  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(_kTabCount, (_) => GlobalKey<NavigatorState>());

  static const _tabScreens = [
    HomeScreen(),
    ExamIntroScreen(),
    ExamSubjectsScreen(),
    StudyScreen(),
    MyPageScreen(),
  ];

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navKeys[index],
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => _tabScreens[index]),
    );
  }

  void _onDestinationSelected(int i) {
    if (i == _tabIndex) {
      _navKeys[i].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _tabIndex = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleBarHeight = _tabIndex == 0 ? 70.0 : kToolbarHeight;

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
                          Text('가맹거래사 1차 시험대비', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
                          SizedBox(height: 3),
                          Text(
                            '가장 스마트하게, 가장 콤팩트하게.',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5, color: AppColors.textSecondary),
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
      body: AppBackground(
        child: SafeArea(
          child: IndexedStack(
            index: _tabIndex,
            children: List.generate(_kTabCount, _buildTabNavigator),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline_rounded),
            selectedIcon: Icon(Icons.info_rounded),
            label: '시험소개',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: '시험과목',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note_rounded),
            label: '학습하기',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}

/// 상단 타이틀 위에 표시되는 얇은 응원 문구 바 — 증권 시세바처럼 계속 흘러간다.
class _EncourageBar extends StatelessWidget {
  const _EncourageBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _kEncourageBarHeight,
      color: AppColors.primary,
      child: const MarqueeText(
        text: '여러분의 합격을 응원합니다.',
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
        height: _kEncourageBarHeight,
      ),
    );
  }
}
