import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

/// 앱 실행 시 처음 보여주는 표지(스플래시) 화면.
/// 실제 수험서(에듀윌·공단기·이투스북 스타일) 표지처럼 화면 전체를 채우는 커버 디자인.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _rise;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rise = Tween<double>(begin: 22, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondary) => FadeTransition(opacity: animation, child: const LoginScreen()),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 그라데이션 + 표지 장식 요소
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF20416B), AppColors.primary, Color(0xFF0F2138)],
              ),
            ),
          ),
          // 거대한 워터마크 연도 숫자 (표지 특유의 장식 그래픽)
          Positioned(
            right: -30,
            top: 60,
            child: Text(
              '2026',
              style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.06),
                height: 1,
              ),
            ),
          ),
          // 대각선 골드 리본 장식
          Positioned(
            top: 46,
            right: -64,
            child: Transform.rotate(
              angle: 0.785398, // 45deg
              child: Container(
                width: 220,
                padding: const EdgeInsets.symmetric(vertical: 7),
                color: AppColors.accentGold,
                alignment: Alignment.center,
                child: const Text(
                  'BEST SELLER',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                ),
              ),
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fade.value,
                  child: Transform.translate(offset: Offset(0, _rise.value), child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '2026 최신판 · 11개년 기출분석',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                      ),
                    ),
                    const Spacer(flex: 3),
                    const Text(
                      '스터디박스',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(width: 28, height: 4, color: AppColors.accentGold),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            '가맹거래사 1차 시험대비',
                            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, letterSpacing: -0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '바쁜 일상, 가장 스마트하게, 가장 콤팩트하게.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 15.5, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(flex: 2),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _CoverTag(label: '경제법'),
                        _CoverTag(label: '민법'),
                        _CoverTag(label: '경영학'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(height: 1, color: Colors.white.withValues(alpha: 0.18)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STUDY BOX',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4),
                        ),
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.7)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverTag extends StatelessWidget {
  final String label;
  const _CoverTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }
}
