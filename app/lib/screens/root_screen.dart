import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/marquee_text.dart';
import 'home_screen.dart';
import 'learning_report_screen.dart';
import 'wrong_note_screen.dart';

const double _kEncourageBarHeight = 24;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _tabIndex = 0;

  static const _titles = ['홈', '오답노트', '학습리포트'];

  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(3, (_) => GlobalKey<NavigatorState>());

  static const _tabScreens = [
    HomeScreen(),
    WrongNoteScreen(),
    LearningReportScreen(),
  ];

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navKeys[index],
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => _tabScreens[index]),
    );
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
            children: List.generate(3, _buildTabNavigator),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.error_outline),
            selectedIcon: Icon(Icons.error),
            label: '오답노트',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: '학습리포트',
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
