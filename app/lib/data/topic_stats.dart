/// 과목별 출제 유형(챕터) 통계.
/// topic 문자열은 [sample_questions.dart]의 Question.category 값과 동일하게 맞춰
/// 챕터 선택 시 해당 카테고리의 문제만 필터링해서 보여줄 수 있도록 한다.
class TopicStat {
  final String topic;
  final int questionCount;
  final int totalQuestions;

  const TopicStat({
    required this.topic,
    required this.questionCount,
    required this.totalQuestions,
  });

  double get ratio => totalQuestions == 0 ? 0 : questionCount / totalQuestions;
}

/// 경제법 — 2016~2026년(제15회~제24회) 기출 440문항 직접 분석 결과. 비중 큰 순.
const List<TopicStat> economicLawTopicStats = [
  TopicStat(topic: '약관법', questionCount: 111, totalQuestions: 440),
  TopicStat(topic: '공정위 조직·절차', questionCount: 102, totalQuestions: 440),
  TopicStat(topic: '불공정거래행위', questionCount: 59, totalQuestions: 440),
  TopicStat(topic: '부당한 공동행위', questionCount: 46, totalQuestions: 440),
  TopicStat(topic: '시장지배적지위 남용', questionCount: 41, totalQuestions: 440),
  TopicStat(topic: '목적·총칙', questionCount: 33, totalQuestions: 440),
  TopicStat(topic: '사업자단체 금지행위', questionCount: 25, totalQuestions: 440),
  TopicStat(topic: '재판매가격유지행위', questionCount: 16, totalQuestions: 440),
  TopicStat(topic: '특수관계인 부당이익제공', questionCount: 7, totalQuestions: 440),
  TopicStat(topic: '경제력집중 억제', questionCount: 1, totalQuestions: 440),
];

/// 민법 · 경영학은 기출 유형 분석이 아직 진행되지 않아, 과목 구조상의
/// 대분류를 챕터로 우선 노출한다 (추후 기출 분석 완료 시 실제 비중으로 교체 예정).
const List<TopicStat> civilLawTopicStats = [
  TopicStat(topic: '채권법', questionCount: 0, totalQuestions: 0),
  TopicStat(topic: '물권법', questionCount: 0, totalQuestions: 0),
  TopicStat(topic: '민법총칙', questionCount: 0, totalQuestions: 0),
];

const List<TopicStat> businessAdminTopicStats = [
  TopicStat(topic: '재무관리', questionCount: 0, totalQuestions: 0),
  TopicStat(topic: '마케팅', questionCount: 0, totalQuestions: 0),
  TopicStat(topic: '조직행동', questionCount: 0, totalQuestions: 0),
  TopicStat(topic: '생산관리', questionCount: 0, totalQuestions: 0),
];

/// 이 과목의 챕터(유형) 통계가 실제 기출 분석 기반인지 여부.
const Map<String, bool> subjectStatsIsAnalyzed = {
  'economic_law': true,
  'civil_law': false,
  'business_admin': false,
};

List<TopicStat> chapterStatsFor(String subjectId) {
  switch (subjectId) {
    case 'economic_law':
      return economicLawTopicStats;
    case 'civil_law':
      return civilLawTopicStats;
    case 'business_admin':
      return businessAdminTopicStats;
    default:
      return const [];
  }
}
