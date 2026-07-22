/// 가맹거래사 1차 시험 일정.
class ExamSchedule {
  /// 2027년 1차 시험 공식 일정은 아직 미발표(2026-07 기준).
  /// 2026년 1차(2/26~27) 패턴을 참고한 추정 날짜 — 공식 일정(보통 전년 12월 공고) 발표되면 반드시 교체할 것.
  static final DateTime estimatedNextExamDate = DateTime(2027, 2, 25);

  static int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return estimatedNextExamDate.difference(today).inDays;
  }
}
