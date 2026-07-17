/// 문제 1개 (기출 원본 또는 AI 생성 유사문제)
class Question {
  final String id;
  final String subjectId;
  final String category;
  final String stem;
  final List<String> choices;
  final int correctIndex;

  /// 핵심만 요약한 해설 (길게 쓰지 않음)
  final String summaryExplanation;

  /// summaryExplanation 중 하이라이트 처리할 핵심 문구(정확히 일치하는 부분 문자열)
  final List<String> highlightPhrases;

  /// 출제의도·핵심 개념·최근 이슈 태그
  final List<String> keyPoints;

  /// 기출 원본인 경우 시행 연도 (예: '2025')
  final String? sourceYear;

  /// AI가 이 문제를 파생시킨 원본 문제 id (원본이면 null)
  final String? originQuestionId;

  final bool isAiGenerated;

  const Question({
    required this.id,
    required this.subjectId,
    required this.category,
    required this.stem,
    required this.choices,
    required this.correctIndex,
    required this.summaryExplanation,
    this.highlightPhrases = const [],
    this.keyPoints = const [],
    this.sourceYear,
    this.originQuestionId,
    this.isAiGenerated = false,
  });
}
