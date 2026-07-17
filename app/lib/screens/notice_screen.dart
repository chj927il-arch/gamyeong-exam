import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class _Notice {
  final String date;
  final String title;
  final String body;
  final bool isNew;
  const _Notice({required this.date, required this.title, required this.body, this.isNew = false});
}

const _notices = [
  _Notice(
    date: '2026.07.15',
    title: '스터디박스 오픈 안내',
    body: '가맹거래사 1차 시험 대비를 위한 스터디박스 서비스를 시작했습니다. 과목별 기출 통계를 기반으로 한 유사문제로 학습해보세요.',
    isNew: true,
  ),
  _Notice(
    date: '2026.07.10',
    title: '경제법 기출 통계 업데이트',
    body: '최근 11개년(제15회~제24회) 기출 440문항을 재분석하여 출제비중 통계를 갱신했습니다.',
  ),
  _Notice(
    date: '2026.06.28',
    title: '오답노트 · 마이페이지 기능 안내',
    body: '틀린 문제를 자동으로 모아보는 오답노트와, 학습 현황을 한눈에 볼 수 있는 마이페이지가 추가되었습니다.',
  ),
];

/// 공지사항 — 서비스 업데이트/안내 목록 (모의 데이터).
class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항'), centerTitle: false),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: _notices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = _notices[index];
          return GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (n.isNew) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.wrong, borderRadius: BorderRadius.circular(999)),
                        child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(n.date, style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(n.title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Text(n.body, style: const TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }
}
