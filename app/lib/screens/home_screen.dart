import 'package:flutter/material.dart';
import '../data/board_data.dart';
import '../theme/app_theme.dart';
import '../widgets/launch_banner.dart';
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
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const RollingBanner(),
        ),
        const SizedBox(height: 20),
        const _DailyOxBanner(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _BoardSection(
                title: '이용후기',
                icon: Icons.reviews_outlined,
                headerColor: AppColors.correct,
                onMore: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewScreen())),
                rows: reviews
                    .take(3)
                    .map((r) => _BoardRow(
                          leading: r.isNew ? '[NEW] ' : null,
                          title: r.title,
                          trailing: r.date,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              _BoardSection(
                title: '공지사항',
                icon: Icons.campaign_outlined,
                headerColor: AppColors.primary,
                onMore: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoticeScreen())),
                rows: notices
                    .take(3)
                    .map((n) => _BoardRow(
                          leading: n.isNew ? '[NEW] ' : null,
                          title: n.title,
                          trailing: n.date,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              _BoardSection(
                title: '자주 묻는 질문',
                icon: Icons.help_outline_rounded,
                headerColor: AppColors.accentGold,
                onMore: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqScreen())),
                rows: faqs
                    .take(3)
                    .map((f) => _BoardRow(leading: 'Q. ', title: f.question))
                    .toList(),
              ),
            ],
          ),
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

class _BoardRow {
  final String? leading;
  final String title;
  final String? trailing;
  const _BoardRow({this.leading, required this.title, this.trailing});
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
                          if (row.trailing != null) ...[
                            const SizedBox(width: 10),
                            Text(row.trailing!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                          ],
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
