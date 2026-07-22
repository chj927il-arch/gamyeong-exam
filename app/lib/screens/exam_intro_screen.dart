import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

/// 시험소개 탭 — 가맹거래사 자격 소개 및 시험 안내(큐넷 공고 기준 일반 정보).
class ExamIntroScreen extends StatelessWidget {
  const ExamIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시험소개'), centerTitle: false),
      body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, Color(0xFF2E4E7C)],
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('국가전문자격', style: TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text(
                '가맹거래사란?',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Text(
                '가맹사업(프랜차이즈) 분야의 전문 지식을 바탕으로 가맹계약 체결·이행 과정에서 발생하는 분쟁을 예방·해결하고, '
                '가맹본부와 가맹점사업자에게 경영·법률 자문을 제공하는 공정거래위원회 소관 국가전문자격사입니다.',
                style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const _SectionTitle('주요 업무'),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: const [
              _InfoRow(icon: Icons.description_outlined, text: '가맹사업 관련 진단·자문 및 정보공개서 등록 지원'),
              _Divider(),
              _InfoRow(icon: Icons.balance_outlined, text: '가맹계약 체결·이행 과정에서의 분쟁 조정 및 해결'),
              _Divider(),
              _InfoRow(icon: Icons.school_outlined, text: '가맹거래에 관한 교육 및 컨설팅'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionTitle('시험 절차'),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: const [
              _StepRow(step: '1차 시험', desc: '객관식(5지선다) · 경제법·민법·경영학 3과목', icon: Icons.edit_note_rounded),
              _Divider(),
              _StepRow(step: '2차 시험', desc: '논술형 · 가맹계약 및 정보공개서 실무 사례형', icon: Icons.description_outlined),
              _Divider(),
              _StepRow(step: '자격 등록', desc: '최종 합격 후 실무수습 및 공정거래위원회 등록', icon: Icons.verified_outlined),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionTitle('1차 시험 안내'),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _LabelValue(label: '응시자격', value: '제한 없음 (연령·학력·경력 무관)'),
              SizedBox(height: 12),
              _LabelValue(label: '시험 과목', value: '경제법 · 민법 · 경영학 (과목당 40문항, 5지선다 객관식)'),
              SizedBox(height: 12),
              _LabelValue(label: '시험 시간', value: '과목당 약 40분 내외 (총 120문항)'),
              SizedBox(height: 12),
              _LabelValue(label: '합격 기준', value: '매 과목 100점 만점 40점 이상 & 전 과목 평균 60점 이상'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.trackBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textMuted),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '위 내용은 일반적인 시험 정보를 요약한 것으로, 정확한 공고 사항(접수 일정·수수료·시행처 변경 등)은 반드시 큐넷(Q-Net) 공식 공고를 확인하세요.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary));
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(height: 1),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.primaryDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4)),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final String desc;
  final IconData icon;
  const _StepRow({required this.step, required this.desc, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 20, color: AppColors.primaryDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(step, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4)),
        ),
      ],
    );
  }
}
