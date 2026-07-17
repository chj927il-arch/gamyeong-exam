import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/marquee_text.dart';
import 'exam_intro_screen.dart';
import 'exam_subjects_screen.dart';
import 'home_screen.dart';
import 'mypage_screen.dart';
import 'study_screen.dart';

const double _kEncourageBarHeight = 24;
const double _kTopNavHeight = 56;
const int _kTabCount = 5;

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}

const _navItems = [
  _NavItem(Icons.home_outlined, Icons.home, '홈'),
  _NavItem(Icons.info_outline_rounded, Icons.info_rounded, '시험소개'),
  _NavItem(Icons.menu_book_outlined, Icons.menu_book_rounded, '시험과목'),
  _NavItem(Icons.edit_note_outlined, Icons.edit_note_rounded, '학습하기'),
  _NavItem(Icons.person_outline_rounded, Icons.person_rounded, '마이페이지'),
];

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _tabIndex = 0;

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
    const titleBarHeight = 102.0;
    final showEncourage = _tabIndex == 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((showEncourage ? _kEncourageBarHeight : 0) + titleBarHeight),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showEncourage) const _EncourageBar(),
              AppBar(
                toolbarHeight: titleBarHeight,
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'STUDY BOX',
                      style: GoogleFonts.blackHanSans(
                        fontSize: 46,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                        height: 0.95,
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      '바쁜 일상, 가장 스마트하게, 가장 콤팩트하게.',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ],
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _TopNavBar(selectedIndex: _tabIndex, onSelected: _onDestinationSelected),
              Expanded(
                child: IndexedStack(
                  index: _tabIndex,
                  children: List.generate(_kTabCount, _buildTabNavigator),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상단 탭 메뉴 — 타이틀/응원바로 아래, 배너 바로 위에 고정된다.
class _TopNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  const _TopNavBar({required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kTopNavHeight,
      decoration: BoxDecoration(
        color: AppColors.bgBase,
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.8))),
      ),
      child: Row(
        children: List.generate(_navItems.length, (i) {
          final item = _navItems[i];
          final selected = i == selectedIndex;
          final color = selected ? AppColors.primary : AppColors.textMuted;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(selected ? item.selectedIcon : item.icon, size: 19, color: color),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2.5,
                      width: 28,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
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
