import 'package:flutter/material.dart';
import '../data/board_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

/// 공지사항 — 서비스 업데이트/안내 목록 (모의 데이터).
class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항'), centerTitle: false),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: notices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notices[index];
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
