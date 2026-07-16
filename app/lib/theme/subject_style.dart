import 'package:flutter/material.dart';

class SubjectStyle {
  final IconData icon;
  final Color color;

  const SubjectStyle({required this.icon, required this.color});
}

const Map<String, SubjectStyle> _subjectStyles = {
  'economic_law': SubjectStyle(icon: Icons.balance_outlined, color: Color(0xFF3B5BDB)),
  'civil_law': SubjectStyle(icon: Icons.gavel_outlined, color: Color(0xFF8B3FC9)),
  'business_admin': SubjectStyle(icon: Icons.insights_outlined, color: Color(0xFF0E9F82)),
};

const SubjectStyle _fallback = SubjectStyle(icon: Icons.menu_book_outlined, color: Color(0xFF6B7280));

SubjectStyle subjectStyleOf(String subjectId) => _subjectStyles[subjectId] ?? _fallback;
