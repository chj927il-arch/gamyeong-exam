/// 문제(또는 개념)별 숙련도 추적 — 정답/오답 모두 유사문제를 반복 노출하기 위한 상태
class MasteryRecord {
  final String questionId;
  int correctStreak;
  int totalAttempts;
  int wrongCount;
  DateTime? nextReviewAt;

  MasteryRecord({
    required this.questionId,
    this.correctStreak = 0,
    this.totalAttempts = 0,
    this.wrongCount = 0,
    this.nextReviewAt,
  });

  /// 오답이든 정답이든 계속 유사문제로 반복 노출하는 정책이라
  /// "다시 봐야 하는가"는 correctStreak 기준으로 판단
  bool get isMastered => correctStreak >= 3;
}
