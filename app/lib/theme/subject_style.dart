import 'package:flutter/material.dart';

class SubjectStyle {
  final IconData icon;
  final Color color;
  final Color softColor;

  const SubjectStyle({required this.icon, required this.color, required this.softColor});
}

const Map<String, SubjectStyle> _subjectStyles = {
  'economic_law': SubjectStyle(
    icon: Icons.balance_outlined,
    color: Color(0xFF3654F4),
    softColor: Color(0xFFE9EDFF),
  ),
  'civil_law': SubjectStyle(
    icon: Icons.gavel_outlined,
    color: Color(0xFF9C36B5),
    softColor: Color(0xFFF6E8FB),
  ),
  'business_admin': SubjectStyle(
    icon: Icons.insights_outlined,
    color: Color(0xFFE8590C),
    softColor: Color(0xFFFDECDF),
  ),
};

const SubjectStyle _fallback = SubjectStyle(
  icon: Icons.menu_book_outlined,
  color: Color(0xFF495057),
  softColor: Color(0xFFEDEFF2),
);

SubjectStyle subjectStyleOf(String subjectId) => _subjectStyles[subjectId] ?? _fallback;
