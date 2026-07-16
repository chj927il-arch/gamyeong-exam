import 'package:flutter/material.dart';

class SubjectStyle {
  final IconData icon;
  final Color color;

  const SubjectStyle({required this.icon, required this.color});
}

const Map<String, SubjectStyle> _subjectStyles = {
  'economic_law': SubjectStyle(icon: Icons.balance_outlined, color: Color(0xFF7C93FF)),
  'civil_law': SubjectStyle(icon: Icons.gavel_outlined, color: Color(0xFFC084FC)),
  'business_admin': SubjectStyle(icon: Icons.insights_outlined, color: Color(0xFFF2994A)),
};

const SubjectStyle _fallback = SubjectStyle(icon: Icons.menu_book_outlined, color: Color(0xFF9AA0AE));

SubjectStyle subjectStyleOf(String subjectId) => _subjectStyles[subjectId] ?? _fallback;
