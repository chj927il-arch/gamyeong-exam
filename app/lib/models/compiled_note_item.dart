/// 사용자가 단권화 노트에 저장해둔 해설 항목
class CompiledNoteItem {
  final String questionId;
  final String note;
  final DateTime savedAt;

  const CompiledNoteItem({
    required this.questionId,
    required this.note,
    required this.savedAt,
  });
}
