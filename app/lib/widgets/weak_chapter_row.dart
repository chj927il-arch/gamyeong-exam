import 'package:flutter/material.dart';
import '../data/study_stats.dart';
import '../screens/quiz_screen.dart';
import '../theme/app_theme.dart';
import '../theme/subject_style.dart';
import 'progress_ring.dart';

/// 학습 리포트의 취약 챕터 카드 — 정답률 링 + 과목 배지 + 보강 제안으로 구성된 카드형 항목.
class WeakChapterRow extends StatelessWidget {
  final WeakChapter chapter;

  const WeakChapterRow({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final style = subjectStyleOf(chapter.subjectId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: style.color.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QuizScreen(
                subjectId: chapter.subjectId,
                subjectName: chapter.subjectName,
                category: chapter.chapterName,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressRing(
                  progress: chapter.accuracy,
                  color: AppColors.wrong,
                  size: 48,
                  strokeWidth: 5.5,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.wrong),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(7)),
                            child: Icon(style.icon, size: 13, color: style.color),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              '${chapter.subjectName} · ${chapter.chapterName}',
                              style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.wrong.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '취약 챕터',
                          style: TextStyle(color: AppColors.wrong, fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapter.advice,
                        style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, fontWeight: FontWeight.w400, height: 1.45),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
