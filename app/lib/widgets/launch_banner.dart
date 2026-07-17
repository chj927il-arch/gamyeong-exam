import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 앱 론칭 안내 배너 — 롤링배너 위에 고정으로 표시되는 프로모션 배너.
class LaunchBanner extends StatelessWidget {
  const LaunchBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1786 / 896,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2138), AppColors.primary],
          ),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 상단 배지 2개
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: const Text(
                        '가맹거래사 1차 시험대비',
                        style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E6FB0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'NEW APP 론칭!',
                        style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                // 타이틀
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '11년치 기출분석 기반',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.3),
                    ),
                    Text.rich(
                      const TextSpan(
                        children: [
                          TextSpan(text: '스마트 ', style: TextStyle(color: Color(0xFF5FD0E8))),
                          TextSpan(text: '문제은행 ', style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'APP', style: TextStyle(color: Color(0xFF5FD0E8))),
                        ],
                      ),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.3),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      const TextSpan(
                        children: [
                          TextSpan(text: '개념은 ', style: TextStyle(color: Colors.white)),
                          TextSpan(text: '자연스럽게', style: TextStyle(color: Color(0xFFFFD84D))),
                          TextSpan(text: ', 성적은 ', style: TextStyle(color: Colors.white)),
                          TextSpan(text: '확실하게', style: TextStyle(color: Color(0xFFFFD84D))),
                          TextSpan(text: '!', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                // 4개 특징
                Row(
                  children: const [
                    Expanded(child: _FeatureItem(icon: Icons.query_stats_rounded, line1: '11년치 기출분석', line2: '빈출유형 파악')),
                    _FeatureDivider(),
                    Expanded(child: _FeatureItem(icon: Icons.track_changes_rounded, line1: '빈출유형 기반', line2: '유사문제 생성')),
                    _FeatureDivider(),
                    Expanded(child: _FeatureItem(icon: Icons.autorenew_rounded, line1: '유사문제 반복학습', line2: '개념 완벽 이해')),
                    _FeatureDivider(),
                    Expanded(child: _FeatureItem(icon: Icons.assignment_outlined, line1: '나만의 학습리포트', line2: '약점 분석 & 관리')),
                  ],
                ),
                // CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD84D),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '가장 스마트한 공부, 지금 시작하세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF1B3358), fontSize: 12.5, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeatureDivider extends StatelessWidget {
  const _FeatureDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.15), margin: const EdgeInsets.symmetric(horizontal: 2));
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String line1;
  final String line2;
  const _FeatureItem({required this.icon, required this.line1, required this.line2});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF5FD0E8), size: 18),
        const SizedBox(height: 4),
        Text(
          line1,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(color: Color(0xFF5FD0E8), fontSize: 9, fontWeight: FontWeight.w700),
        ),
        Text(
          line2,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
