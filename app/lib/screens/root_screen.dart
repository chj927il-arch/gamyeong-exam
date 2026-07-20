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
const double _kTopNavHeight = 46;
const int _kTabCount = 5;

const double _kBottomBarHeight = 44;
const double _kStudyButtonSize = 56;
const int _kStudyTabIndex = 3;

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int tabIndex;
  const _NavItem(this.icon, this.selectedIcon, this.label, this.tabIndex);
}

/// 상단 메뉴 — 학습하기는 하단 중앙의 볼록 버튼으로 뺐으므로 나머지 4개만 노출한다.
const _navItems = [
  _NavItem(Icons.home_outlined, Icons.home, '홈', 0),
  _NavItem(Icons.info_outline_rounded, Icons.info_rounded, '시험소개', 1),
  _NavItem(Icons.menu_book_outlined, Icons.menu_book_rounded, '시험과목', 2),
  _NavItem(Icons.person_outline_rounded, Icons.person_rounded, '마이페이지', 4),
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
    const titleBarHeight = 84.0;
    final showEncourage = _tabIndex == 0;
    final showTitle = _tabIndex == 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (showEncourage ? _kEncourageBarHeight : 0) + (showTitle ? titleBarHeight : 0),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showEncourage) const _EncourageBar(),
              if (showTitle)
                AppBar(
                  toolbarHeight: titleBarHeight,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'STUDY BOX',
                        style: GoogleFonts.blackHanSans(
                          fontSize: 34,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                          height: 0.95,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -6),
                        child: const Text(
                          '바쁜 일상, 가장 스마트하게, 가장 콤팩트하게.',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                    ),
                  ),
                  centerTitle: true,
                ),
            ],
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          bottom: false,
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
      bottomNavigationBar: _BottomStudyBar(
        selected: _tabIndex == _kStudyTabIndex,
        onTap: () => _onDestinationSelected(_kStudyTabIndex),
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
          final selected = item.tabIndex == selectedIndex;
          final color = selected ? AppColors.primary : AppColors.textMuted;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(item.tabIndex),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(selected ? item.selectedIcon : item.icon, size: 17, color: color),
                    const SizedBox(height: 1),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
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
      color: const Color(0xFFFFC72C),
      child: MarqueeText(
        text: '스터디박스를 켜는 순간 합격이 가까워집니다.',
        style: GoogleFonts.blackHanSans(color: Colors.black, fontSize: 13, letterSpacing: -0.2),
        height: _kEncourageBarHeight,
        gap: 24,
      ),
    );
  }
}

/// 하단 바 — 가운데에 "학습하기" 버튼이 오락기처럼 볼록 튀어나온 형태.
class _BottomStudyBar extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  const _BottomStudyBar({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kBottomBarHeight + _kStudyButtonSize / 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: _kBottomBarHeight,
            decoration: BoxDecoration(
              color: AppColors.bgBase,
              border: Border(top: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.8))),
            ),
          ),
          Positioned(
            bottom: _kBottomBarHeight - _kStudyButtonSize / 2 - 4,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: _kStudyButtonSize,
                height: _kStudyButtonSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: selected
                        ? [AppColors.accentGold, const Color(0xFFDBA53F)]
                        : [AppColors.primary, const Color(0xFF3E6FB0)],
                  ),
                  border: Border.all(color: AppColors.bgBase, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 14, offset: const Offset(0, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                    Text(
                      '학습하기',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
