import 'package:flutter/material.dart';

class SubjectStyle {
  final IconData icon;
  final Color color;

  const SubjectStyle({required this.icon, required this.color});
}

// 브랜드 오렌지 + 차분한 보조색 2가지(네이비, 세이지)로 구성.
const Map<String, SubjectStyle> _subjectStyles = {
  'economic_law': SubjectStyle(icon: Icons.balance_outlined, color: Color(0xFFFF6B1A)), // 브랜드 오렌지
  'civil_law': SubjectStyle(icon: Icons.gavel_outlined, color: Color(0xFF2F4374)), // 딥 네이비
  'business_admin': SubjectStyle(icon: Icons.insights_outlined, color: Color(0xFF6E8F6B)), // 세이지 그린
};

const SubjectStyle _fallback = SubjectStyle(icon: Icons.menu_book_outlined, color: Color(0xFF6B7280));

SubjectStyle subjectStyleOf(String subjectId) => _subjectStyles[subjectId] ?? _fallback;
