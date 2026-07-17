import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 지정된 phrases 부분을 형광펜처럼 하이라이트 처리해서 보여주는 텍스트.
class HighlightedText extends StatelessWidget {
  final String text;
  final List<String> phrases;
  final TextStyle style;
  final Color highlightColor;

  const HighlightedText({
    super.key,
    required this.text,
    required this.phrases,
    required this.style,
    this.highlightColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (phrases.isEmpty) {
      return Text(text, style: style);
    }

    final spans = <InlineSpan>[];
    var cursor = 0;

    while (cursor < text.length) {
      int matchStart = -1;
      int matchLength = 0;

      for (final phrase in phrases) {
        if (phrase.isEmpty) continue;
        final idx = text.indexOf(phrase, cursor);
        if (idx != -1 && (matchStart == -1 || idx < matchStart)) {
          matchStart = idx;
          matchLength = phrase.length;
        }
      }

      if (matchStart == -1) {
        spans.add(TextSpan(text: text.substring(cursor)));
        break;
      }

      if (matchStart > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, matchStart)));
      }

      spans.add(TextSpan(
        text: text.substring(matchStart, matchStart + matchLength),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: highlightColor,
          backgroundColor: highlightColor.withValues(alpha: 0.12),
        ),
      ));

      cursor = matchStart + matchLength;
    }

    return Text.rich(TextSpan(style: style, children: spans));
  }
}
