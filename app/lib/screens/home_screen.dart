import 'package:flutter/material.dart';
import '../data/board_data.dart';
import '../theme/app_theme.dart';
import '../widgets/launch_banner.dart';
import '../widgets/marquee_row.dart';
import '../widgets/rolling_banner.dart';
import 'daily_ox_list_screen.dart';
import 'faq_screen.dart';
import 'notice_screen.dart';
import 'review_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        // 배너는 좌우 여백 없이 화면 폭 전체를 채운다.
        const LaunchBanner(),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionTitle(prefix: 'STUDY BOX ', highlight: '콘텐츠', color: AppColors.correct),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const RollingBanner(),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionTitle(prefix: '오늘의 ', highlight: 'OX 퀴즈', color: AppColors.accentPurple),
        ),
        const SizedBox(height: 10),
        const _DailyOxBanner(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '수강후기',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('후기 작성 기능은 준비 중이에요.')),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('작성하기'),
                style: TextButton.styleFrom(foregroundColor: AppColors.correct),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const _ReviewCarousel(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _BoardSection(
            title: '자주 묻는 질문',
            icon: Icons.help_outline_rounded,
            headerColor: AppColors.accentGold,
            onMore: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqScreen())),
            rows: faqs
                .take(3)
                .map((f) => _BoardRow(leading: 'Q. ', title: f.question))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        const _MotivationStrip(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _NoticeBar(
            latest: notices.first,
            onMore: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoticeScreen())),
          ),
        ),
      ],
    );
  }
}

/// 자주 묻는 질문 아래 짧은 동기부여 띠배너 — 첨부 이미지(1536x197 비율) 그대로 표시.
class _MotivationStrip extends StatelessWidget {
  const _MotivationStrip();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1536 / 197,
      child: const Image(
        image: AssetImage('assets/images/motivation_strip.png'),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

/// "STUDY BOX 콘텐츠" 스타일의 섹션 타이틀 — 뒷부분 단어만 색상으로 강조(테두리 박스 없음).
class _SectionTitle extends StatelessWidget {
  final String prefix;
  final String highlight;
  final Color color;
  const _SectionTitle({required this.prefix, required this.highlight, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          prefix,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        Text(
          highlight,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color),
        ),
      ],
    );
  }
}

/// 데일리 OX 퀴즈 배너 — 모바일에 맞춰 여백을 넉넉히 준 와이드 이미지(3936x1088) 비율 그대로 표시.
class _DailyOxBanner extends StatelessWidget {
  const _DailyOxBanner();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3936 / 1088,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DailyOxListScreen())),
          child: const Image(
            image: AssetImage('assets/images/daily_ox_banner.png'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

/// 수강후기 — 5개 카드가 여백 없이 옆으로 계속 흘러가는 롤링 스트립.
class _ReviewCarousel extends StatelessWidget {
  const _ReviewCarousel();

  @override
  Widget build(BuildContext context) {
    return MarqueeRow(
      height: 132,
      pixelsPerSecond: 32,
      itemBuilder: (context) {
        final cards = List.generate(5, (i) => reviews[i % reviews.length]);
        return Row(
          children: [
            for (final review in cards) ...[
              _ReviewMiniCard(review: review),
              const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }
}

class _ReviewMiniCard extends StatelessWidget {
  final ReviewItem review;
  const _ReviewMiniCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewScreen())),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 14,
                  color: AppColors.accentGold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              review.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                review.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500, height: 1.35),
              ),
            ),
            Text(
              review.date,
              style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// 공지사항 — 최신 공지 한 줄만 보여주는 얇은 바.
class _NoticeBar extends StatelessWidget {
  final NoticeItem latest;
  final VoidCallback onMore;
  const _NoticeBar({required this.latest, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onMore,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.campaign_outlined, size: 17, color: AppColors.primary),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999)),
                child: const Text('공지', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  latest.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              const Text('더보기', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardRow {
  final String? leading;
  final String title;
  const _BoardRow({this.leading, required this.title});
}

class _BoardSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color headerColor;
  final VoidCallback onMore;
  final List<_BoardRow> rows;
  const _BoardSection({required this.title, required this.icon, required this.headerColor, required this.onMore, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: headerColor.withValues(alpha: 0.10),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: InkWell(
              onTap: onMore,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: headerColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(title, style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: headerColor)),
                    ),
                    const Text('더보기', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                    Icon(Icons.chevron_right_rounded, size: 18, color: headerColor),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          ...List.generate(rows.length, (i) {
            final row = rows[i];
            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onMore,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  if (row.leading != null)
                                    TextSpan(
                                      text: row.leading,
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
                                    ),
                                  TextSpan(text: row.title),
                                ],
                              ),
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (i != rows.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}
