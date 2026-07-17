import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

const double _kLaunchBannerAspectRatio = 1774 / 887;

/// 앱 상단 프로모션 배너 — 실제 론칭 이미지와 STUDY BOX 홍보 슬라이드,
/// 총 2개 화면을 자동으로 롤링하는 풀블리드 배너.
class LaunchBanner extends StatefulWidget {
  const LaunchBanner({super.key});

  @override
  State<LaunchBanner> createState() => _LaunchBannerState();
}

class _LaunchBannerState extends State<LaunchBanner> {
  late final PageController _controller;
  int _page = 0;
  Timer? _timer;
  static const _slideCount = 2;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_page + 1) % _slideCount;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 좌우 여백 없이 화면 폭 전체를 채우는 풀블리드 배너 — 라운드 처리하지 않는다.
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _kLaunchBannerAspectRatio,
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            children: const [
              Image(
                image: AssetImage('assets/images/launch_banner.png'),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              _StudyBoxPromoSlide(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slideCount, (i) {
            final active = i == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.trackBg,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// STUDY BOX 홍보 슬라이드 — 큰 타이포그래피 타이틀이 도드라지는 브랜드 배너.
class _StudyBoxPromoSlide extends StatelessWidget {
  const _StudyBoxPromoSlide();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF20416B), AppColors.primary, Color(0xFF0F2138)],
        ),
      ),
      child: Stack(
        children: [
          // 대각선 골드 액센트 글로우
          Positioned(
            right: -40,
            top: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGold.withValues(alpha: 0.18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STUDY BOX',
                  style: GoogleFonts.blackHanSans(
                    color: Colors.white,
                    fontSize: 44,
                    letterSpacing: 0.5,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '바쁜 일상, 가장 스마트하게, 가장 콤팩트하게.',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
