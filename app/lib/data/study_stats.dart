import 'user_progress.dart';

/// 학습 이력 목업 데이터 (실 학습 데이터 연동 전, 홈 대시보드 확인용)
class DailyActivity {
  final String label; // 요일
  final int minutes;

  const DailyActivity({required this.label, required this.minutes});
}

class StudyStats {
  // 연속 학습일·주간활동 그래프는 날짜별 이력 저장이 필요해 아직 목업 유지.
  static const int streakDays = 3;
  static const int todayGoal = 20;

  static int get todaySolved => UserProgress.instance.todaySolved;
  static int get todayMinutes => UserProgress.instance.todayStudySeconds ~/ 60;

  static int get totalSolved => UserProgress.instance.totalSolved;
  static int get totalMinutes => UserProgress.instance.totalStudySeconds ~/ 60;
  static double get totalAccuracy => UserProgress.instance.totalAccuracy;

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

/// 학습 리포트용 — 과목별 가장 취약한 챕터.
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

String _adviceFor(double accuracy) {
  if (accuracy < 0.5) return '정답률이 낮은 편이에요. 관련 개념부터 차근차근 다시 정리해보세요.';
  if (accuracy < 0.7) return '조금 더 반복하면 확실히 잡을 수 있어요. 틀린 문제 위주로 복습해보세요.';
  return '거의 다 왔어요! 헷갈렸던 부분만 한 번 더 짚어보세요.';
}

/// 실제 풀이 기록 기반 취약 챕터 — 시도 횟수가 충분히 쌓인 챕터가 없으면 빈 목록을 반환한다.
List<WeakChapter> computeWeakChapters({int limit = 3, int minAttempts = 3}) {
  return UserProgress.instance
      .weakestCategories(limit: limit, minAttempts: minAttempts)
      .map((s) => WeakChapter(
            subjectId: s.subjectId,
            subjectName: s.subjectName,
            chapterName: s.category,
            accuracy: s.accuracy,
            advice: _adviceFor(s.accuracy),
          ))
      .toList();
}
