/// 학습 이력 목업 데이터 (실 학습 데이터 연동 전, 홈 대시보드 확인용)
class DailyActivity {
  final String label; // 요일
  final int minutes;

  const DailyActivity({required this.label, required this.minutes});
}

class StudyStats {
  static const int streakDays = 3;
  static const int todaySolved = 12;
  static const int todayGoal = 20;
  static const int todayMinutes = 34;

  static const int totalSolved = 428;
  static const int totalMinutes = 1260; // 총 누적 학습 시간(분)
  static const double totalAccuracy = 0.78;

  /// 최근 7일 학습 시간(분) — 오늘 포함, 과거 → 오늘 순서
  static const List<DailyActivity> weeklyActivity = [
    DailyActivity(label: '월', minutes: 18),
    DailyActivity(label: '화', minutes: 42),
    DailyActivity(label: '수', minutes: 25),
    DailyActivity(label: '목', minutes: 0),
    DailyActivity(label: '금', minutes: 51),
    DailyActivity(label: '토', minutes: 30),
    DailyActivity(label: '일', minutes: 34),
  ];

  static String get totalHoursLabel {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return m == 0 ? '$h시간' : '$h시간 $m분';
  }
}

/// 과목별 학습 진행률(0.0~1.0) 목업
const Map<String, double> mockSubjectProgress = {
  'economic_law': 0.62,
  'civil_law': 0.35,
  'business_admin': 0.08,
};

/// 과목별 오늘 푼 문제 수 목업
const Map<String, int> mockSubjectTodaySolved = {
  'economic_law': 8,
  'civil_law': 3,
  'business_admin': 1,
};

/// 학습 리포트용 — 과목별 가장 취약한 챕터 목업 (실 채점 데이터 연동 전).
class WeakChapter {
  final String subjectId;
  final String subjectName;
  final String chapterName;
  final double accuracy; // 0.0 ~ 1.0
  final String advice;

  const WeakChapter({
    required this.subjectId,
    required this.subjectName,
    required this.chapterName,
    required this.accuracy,
    required this.advice,
  });
}

const List<WeakChapter> weakChapters = [
  WeakChapter(
    subjectId: 'economic_law',
    subjectName: '경제법',
    chapterName: '공정위 조직·절차',
    accuracy: 0.48,
    advice: '과징금·동의의결·분쟁조정 절차에서 자주 틀리고 있어요. 조문 흐름 위주로 다시 정리해보세요.',
  ),
  WeakChapter(
    subjectId: 'civil_law',
    subjectName: '민법',
    chapterName: '물권법',
    accuracy: 0.41,
    advice: '담보물권 파트의 정답률이 가장 낮아요. 유치권·저당권 판례부터 집중적으로 복습해보세요.',
  ),
  WeakChapter(
    subjectId: 'business_admin',
    subjectName: '경영학',
    chapterName: '재무관리',
    accuracy: 0.33,
    advice: '계산 문제 정답률이 낮은 편이에요. 공식을 직접 써보며 반복 연습을 추천해요.',
  ),
];
