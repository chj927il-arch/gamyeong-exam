import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BannerItem {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final List<Color>? gradient;
  final String? imageAsset;

  const BannerItem({
    this.title,
    this.subtitle,
    this.icon,
    this.gradient,
    this.imageAsset,
  });
}

const _defaultBanners = [
  BannerItem(
    title: '이번 주 신규\n유사문제 업데이트',
    subtitle: '출제 비중 1위 약관법 문제가 추가됐어요',
    icon: Icons.auto_awesome_outlined,
    gradient: [Color(0xFFE8562F), Color(0xFFF4854A)],
  ),
  BannerItem(imageAsset: 'assets/images/rolling_banner_chapter.png'),
  BannerItem(
    title: '프리미엄 전환하고\n전 과목 무제한 풀기',
    subtitle: '경제법·민법·경영학 전 챕터 잠금 해제',
    icon: Icons.workspace_premium_outlined,
    gradient: [Color(0xFF3E4FA8), Color(0xFF6C7CD6)],
  ),
];

/// 홈 상단 프로모션/광고 영역 — 3개 배너를 자동으로 롤링하는 캐러셀.
class RollingBanner extends StatefulWidget {
  final List<BannerItem> banners;

  const RollingBanner({super.key, this.banners = _defaultBanners});

  @override
  State<RollingBanner> createState() => _RollingBannerState();
}

class _RollingBannerState extends State<RollingBanner> {
  late final PageController _controller;
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_page + 1) % widget.banners.length;
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
    return Column(
      children: [
        SizedBox(
          height: 126,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => _BannerCard(item: widget.banners[i]),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (i) {
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

class _BannerCard extends StatelessWidget {
  final BannerItem item;
  const _BannerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.imageAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(item.imageAsset!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item.gradient!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title!,
                  style: GoogleFonts.blackHanSans(color: Colors.white, fontSize: 22, height: 1.15, letterSpacing: 0.2),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.subtitle!,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 13, fontWeight: FontWeight.w600, height: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
            child: Icon(item.icon!, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
