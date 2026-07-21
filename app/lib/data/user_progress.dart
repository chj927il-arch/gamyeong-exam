import 'package:flutter/foundation.dart';

/// 챕터(카테고리)별 정답률 집계 결과 — 학습 리포트의 취약 챕터 계산에 쓰인다.
class WeakCategoryStat {
  final String subjectId;
  final String subjectName;
  final String category;
  final double accuracy;

  const WeakCategoryStat({
    required this.subjectId,
    required this.subjectName,
    required this.category,
    required this.accuracy,
  });
}

/// 오답노트 / 단권화 / 학습 통계(시간·정답수·취약챕터)를 앱 세션 동안 기억하는 저장소.
/// (현재는 메모리에만 저장됨 — 앱을 재시작하면 초기화됩니다. 추후 로컬 저장소 연동 예정)
class UserProgress extends ChangeNotifier {
  UserProgress._();
  static final UserProgress instance = UserProgress._();

  final Set<String> _wrongQuestionIds = {};
  final Set<String> _compiledQuestionIds = {};

  int totalSolved = 0;
  int totalCorrect = 0;
  int totalStudySeconds = 0;

  int _todaySolved = 0;
  int _todayStudySeconds = 0;
  DateTime? _today;

  final Map<String, int> _categoryAttempts = {};
  final Map<String, int> _categoryWrong = {};
  final Map<String, String> _categorySubjectId = {};
  final Map<String, String> _categorySubjectName = {};

  List<String> get wrongQuestionIds => _wrongQuestionIds.toList(growable: false);
  List<String> get compiledQuestionIds => _compiledQuestionIds.toList(growable: false);

  bool isWrong(String questionId) => _wrongQuestionIds.contains(questionId);
  bool isCompiled(String questionId) => _compiledQuestionIds.contains(questionId);

  void markWrong(String questionId) {
    if (_wrongQuestionIds.add(questionId)) notifyListeners();
  }

  /// 오답노트에서 다시 맞히면 목록에서 제거한다.
  void markCorrect(String questionId) {
    if (_wrongQuestionIds.remove(questionId)) notifyListeners();
  }

  void removeWrong(String questionId) {
    if (_wrongQuestionIds.remove(questionId)) notifyListeners();
  }

  void toggleCompiled(String questionId) {
    if (!_compiledQuestionIds.remove(questionId)) {
      _compiledQuestionIds.add(questionId);
    }
    notifyListeners();
  }

  void removeCompiled(String questionId) {
    if (_compiledQuestionIds.remove(questionId)) notifyListeners();
  }

  void _rolloverIfNeeded() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_today == null || _today != today) {
      _today = today;
      _todaySolved = 0;
      _todayStudySeconds = 0;
    }
  }

  int get todaySolved {
    _rolloverIfNeeded();
    return _todaySolved;
  }

  int get todayStudySeconds {
    _rolloverIfNeeded();
    return _todayStudySeconds;
  }

  double get totalAccuracy => totalSolved == 0 ? 0 : totalCorrect / totalSolved;

  /// 문제 1개를 채점할 때마다 호출 — 누적/오늘 통계와 챕터별 정답률 집계에 반영한다.
  void recordAnswer({
    required String subjectId,
    required String subjectName,
    required String category,
    required bool correct,
  }) {
    _rolloverIfNeeded();
    totalSolved++;
    _todaySolved++;
    if (correct) totalCorrect++;

    _categoryAttempts[category] = (_categoryAttempts[category] ?? 0) + 1;
    _categorySubjectId[category] = subjectId;
    _categorySubjectName[category] = subjectName;
    if (!correct) {
      _categoryWrong[category] = (_categoryWrong[category] ?? 0) + 1;
    }
    notifyListeners();
  }

  /// 문제풀이 화면에 머문 시간(초)을 학습시간에 누적한다.
  void addStudySeconds(int seconds) {
    if (seconds <= 0) return;
    _rolloverIfNeeded();
    totalStudySeconds += seconds;
    _todayStudySeconds += seconds;
    notifyListeners();
  }

  /// 정답률이 낮은 챕터부터 정렬해서 반환 — 시도 횟수가 [minAttempts] 미만이면 신뢰도가 낮아 제외한다.
  List<WeakCategoryStat> weakestCategories({int limit = 3, int minAttempts = 3}) {
    final stats = _categoryAttempts.entries
        .where((e) => e.value >= minAttempts)
        .map((e) {
          final wrong = _categoryWrong[e.key] ?? 0;
          return WeakCategoryStat(
            subjectId: _categorySubjectId[e.key] ?? '',
            subjectName: _categorySubjectName[e.key] ?? '',
            category: e.key,
            accuracy: 1 - wrong / e.value,
          );
        })
        .toList()
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return stats.take(limit).toList();
  }
}
