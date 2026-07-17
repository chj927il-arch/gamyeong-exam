import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/launch_banner.dart';
import '../widgets/rolling_banner.dart';
import 'faq_screen.dart';
import 'notice_screen.dart';

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
          child: Column(
            children: const [
              RollingBanner(),
              SizedBox(height: 20),
              _QuickMenuRow(),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickMenuRow extends StatelessWidget {
  const _QuickMenuRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickMenuCard(
            icon: Icons.campaign_outlined,
            label: '공지사항',
            color: AppColors.primary,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoticeScreen())),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickMenuCard(
            icon: Icons.help_outline_rounded,
            label: 'FAQ',
            color: AppColors.accentGold,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqScreen())),
          ),
        ),
      ],
    );
  }
}

class _QuickMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickMenuCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, size: 21, color: color),
                ),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
