import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Faq {
  final String question;
  final String answer;
  const _Faq({required this.question, required this.answer});
}

const _faqs = [
  _Faq(
    question: '유사문제는 어떤 기준으로 만들어지나요?',
    answer: '최근 11개년(제15회~제24회) 기출 440문항을 직접 분석해 출제비중이 높은 챕터부터 순서대로 유사문제를 구성했습니다.',
  ),
  _Faq(
    question: '오답노트는 어떻게 이용하나요?',
    answer: '문제를 틀리면 자동으로 오답노트에 담깁니다. 마이페이지 > 오답노트에서 언제든 다시 풀어보고, 필요 없으면 목록에서 삭제할 수 있습니다.',
  ),
  _Faq(
    question: '학습 기록이 저장되나요?',
    answer: '현재 버전은 데모용으로, 학습 기록은 앱을 새로고침하면 초기화됩니다. 정식 버전에서는 계정별로 기록이 저장될 예정입니다.',
  ),
  _Faq(
    question: '비밀번호를 잊어버렸어요.',
    answer: '로그인 화면의 \'아이디/비밀번호 찾기\' 메뉴를 이용해주세요.',
  ),
];

/// FAQ — 자주 묻는 질문 (모의 데이터).
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자주 묻는 질문'), centerTitle: false),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: _faqs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.glassBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                iconColor: AppColors.primary,
                collapsedIconColor: AppColors.textMuted,
                title: Row(
                  children: [
                    const Text('Q', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(faq.question, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ),
                  ],
                ),
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('A', style: TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w900, fontSize: 15)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(faq.answer, style: const TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
