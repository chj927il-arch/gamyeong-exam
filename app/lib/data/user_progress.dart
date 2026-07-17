import 'package:flutter/foundation.dart';

/// 오답노트 / 단권화 상태를 앱 세션 동안 기억하는 간단한 저장소.
/// (현재는 메모리에만 저장됨 — 앱을 재시작하면 초기화됩니다. 추후 로컬 저장소 연동 예정)
class UserProgress extends ChangeNotifier {
  UserProgress._();
  static final UserProgress instance = UserProgress._();

  final Set<String> _wrongQuestionIds = {};
  final Set<String> _compiledQuestionIds = {};

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
}
