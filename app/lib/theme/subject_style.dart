import 'package:flutter/material.dart';

class SubjectStyle {
  final IconData icon;
  final Color color;

  const SubjectStyle({required this.icon, required this.color});
}

// 브랜드 키컬러(오렌지)와 어울리는 아날로그 색상군으로 구성 — 채도/톤을 맞춰 조화롭게.
const Map<String, SubjectStyle> _subjectStyles = {
  'economic_law': SubjectStyle(icon: Icons.balance_outlined, color: Color(0xFFFF6B1A)), // 브랜드 오렌지
  'civil_law': SubjectStyle(icon: Icons.gavel_outlined, color: Color(0xFFE4572E)), // 버밀리언(레드-오렌지)
  'business_admin': SubjectStyle(icon: Icons.insights_outlined, color: Color(0xFFC98A2B)), // 앰버골드
};

const SubjectStyle _fallback = SubjectStyle(icon: Icons.menu_book_outlined, color: Color(0xFF6B7280));

SubjectStyle subjectStyleOf(String subjectId) => _subjectStyles[subjectId] ?? _fallback;
