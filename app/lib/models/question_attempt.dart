/// 사용자가 문제 1개를 풀 때마다의 기록
class QuestionAttempt {
  final String questionId;
  final bool isCorrect;
  final DateTime answeredAt;

  const QuestionAttempt({
    required this.questionId,
    required this.isCorrect,
    required this.answeredAt,
  });
}
