import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

const _defaultBanners = [
  BannerItem(
    title: '이번 주 신규 유사문제 업데이트',
    subtitle: '출제 비중 1위 약관법 문제가 추가됐어요',
    icon: Icons.auto_awesome_outlined,
    gradient: [Color(0xFFFF7A1E), Color(0xFFFF9A56)],
  ),
  BannerItem(
    title: '오늘의 추천 챕터',
    subtitle: '공정위 조직·절차, 최근 10년간 두 번째로 많이 출제',
    icon: Icons.local_fire_department_outlined,
    gradient: [Color(0xFFFF9142), Color(0xFFFFC069)],
  ),
  BannerItem(
    title: '프리미엄 전환하고 전 과목 무제한 풀기',
    subtitle: '경제법·민법·경영학 전 챕터 잠금 해제',
    icon: Icons.workspace_premium_outlined,
    gradient: [Color(0xFFE85D04), Color(0xFFFF7A1E)],
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
          height: 104,
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item.gradient,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w800, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 13.5, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
            child: Icon(item.icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
