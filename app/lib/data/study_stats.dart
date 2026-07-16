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

  /// 합격생 평균 대비 비교 지표 (레퍼런스: "나 vs 상위권" 비교 카드용 목업)
  static const double peerAccuracy = 0.91;
  static const String peerLabel = '합격생 평균';
  static const int peerWeeklyMinutes = 320;
  static const int myWeeklyMinutes = 200;

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
