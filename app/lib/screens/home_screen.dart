import 'package:flutter/material.dart';
import '../data/board_data.dart';
import '../data/exam_schedule.dart';
import '../data/topic_stats.dart';
import '../models/exam_subject.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import '../widgets/launch_banner.dart';
import '../widgets/marquee_row.dart';
import '../widgets/rolling_banner.dart';
import 'daily_ox_list_screen.dart';
import 'faq_screen.dart';
import 'notice_screen.dart';
import 'review_screen.dart';
import 'subject_info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const _DdayBar(),
        ),
        const SizedBox(height: 14),
        // 배너는 좌우 여백 없이 화면 폭 전체를 채운다.
        const LaunchBanner(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const _TrustBadgeCard(),
        ),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SectionTitle(prefix: '과목 ', highlight: '안내', color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        const _SubjectGuideCarousel(),
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

/// 시험일까지 남은 일수를 보여주는 얇은 D-day 바 — 홈 화면 맨 위에서 가장 먼저 보이도록 배치.
class _DdayBar extends StatelessWidget {
  const _DdayBar();

  @override
  Widget build(BuildContext context) {
    final d = ExamSchedule.daysRemaining;
    final label = d >= 0 ? 'D-$d' : 'D+${-d}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.accentGold, borderRadius: BorderRadius.circular(999)),
            child: Text(
              label,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '가맹거래사 1차 시험일까지',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// 기출 분석 신뢰도를 보여주는 배지 카드 — 실제 topic_stats 데이터를 그대로 계산해서 표시.
class _TrustBadgeCard extends StatelessWidget {
  const _TrustBadgeCard();

  @override
  Widget build(BuildContext context) {
    final totalQuestions = economicLawTopicStats.fold<int>(0, (sum, t) => sum + t.questionCount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.correct.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.verified_rounded, color: AppColors.correct, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '경제법 11개년 $totalQuestions문항 전수분석 완료',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                const Text(
                  '민법·경영학은 순차적으로 분석·업데이트할 예정이에요',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
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

/// 과목 안내 — 경제법·민법·경영학 3개 과목을 표지(교재 커버) 느낌으로 보여준다.
/// 수강후기 카드보다 훨씬 큰, A4 비율(210:297)을 모바일에 맞게 줄인 세로형 카드.
/// 자동으로 흘러가지 않고, 손가락으로 옆으로 넘겨서 보는 정지형 스크롤.
class _SubjectGuideCarousel extends StatelessWidget {
  const _SubjectGuideCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 268,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: examSubjects.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) => _SubjectCoverCard(subject: examSubjects[index]),
      ),
    );
  }
}

/// 과목별 표지 이미지 — 아직 없는 과목은 null(기존 색상 그라데이션으로 대체).
String? _subjectCoverImage(String subjectId) {
  switch (subjectId) {
    case 'economic_law':
      return 'assets/images/subject_cover_economic_law.png';
    default:
      return null;
  }
}

class _SubjectCoverCard extends StatelessWidget {
  final ExamSubject subject;
  const _SubjectCoverCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(subject.id);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SubjectInfoScreen(subjectId: subject.id, subjectName: subject.name)),
      ),
      child: Container(
        width: 190,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_subjectCoverImage(subject.id) != null)
                    Image.asset(_subjectCoverImage(subject.id)!, fit: BoxFit.cover)
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [style.color, style.color.withValues(alpha: 0.78)],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(style.icon, color: Colors.white, size: 30),
                        Text(
                          subject.name,
                          style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (subject.categories.isNotEmpty)
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: subject.categories
                            .map((c) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: style.color.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    c,
                                    style: TextStyle(color: style.color, fontSize: 10.5, fontWeight: FontWeight.w700),
                                  ),
                                ))
                            .toList(),
                      ),
                    Row(
                      children: [
                        Text(
                          '과목 안내 보기',
                          style: TextStyle(color: style.color, fontSize: 12.5, fontWeight: FontWeight.w700),
                        ),
                        Icon(Icons.chevron_right_rounded, size: 16, color: style.color),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
