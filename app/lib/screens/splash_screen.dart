import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'root_screen.dart';

/// 앱 실행 시 처음 보여주는 표지(스플래시) 화면.
/// 실제 수험서 표지 같은 느낌으로 잠시 보여준 뒤 메인 화면으로 자동 전환된다.
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
    _rise = Tween<double>(begin: 18, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondary) => FadeTransition(opacity: animation, child: const RootScreen()),
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
      backgroundColor: AppColors.ink,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B1D23), AppColors.ink, Color(0xFF0F1013)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fade.value,
                child: Transform.translate(offset: Offset(0, _rise.value), child: child),
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _BookCover(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 실제 수험서 표지를 연상시키는 카드형 디자인.
class _BookCover extends StatelessWidget {
  const _BookCover();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 40, offset: const Offset(0, 24)),
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.18), blurRadius: 60, offset: const Offset(0, 0)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999)),
                    child: const Text(
                      '2026 최신판',
                      style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: 0.2),
                    ),
                  ),
                  const Icon(Icons.workspace_premium_rounded, color: AppColors.primary, size: 22),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                '가맹거래사',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, height: 1.05, letterSpacing: -0.5),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '1차 시험대비',
                    style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(height: 1, color: AppColors.glassBorder),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _SubjectTag(label: '경제법'),
                  _SubjectTag(label: '민법'),
                  _SubjectTag(label: '경영학'),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                '11개년 기출 직접 분석 · 출제비중 순 챕터 학습',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          '합격까지, 오늘도 한 문제씩',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation(AppColors.primary.withValues(alpha: 0.9)),
          ),
        ),
      ],
    );
  }
}

class _SubjectTag extends StatelessWidget {
  final String label;
  const _SubjectTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.trackBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}
