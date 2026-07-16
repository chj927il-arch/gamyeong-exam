import '../models/question.dart';

/// 실제 큐넷 기출 분석/Gemini 연동 전, 화면 확인용 샘플 데이터
const List<Question> sampleQuestions = [
  Question(
    id: 'q1',
    subjectId: 'economic_law',
    category: '공정거래법',
    stem: '공정거래법상 시장지배적 지위 남용행위에 해당하지 않는 것은?',
    choices: ['가격의 부당한 결정·유지·변경', '출고조절', '정당한 이유 없는 신규 진입 방해', '통상적인 거래조건 제시'],
    correctIndex: 3,
    summaryExplanation: '시장지배적 지위 남용행위는 가격·출고·진입방해·소비자이익 저해 등 유형화되어 있음. 통상적 거래조건 제시는 남용행위로 보지 않음.',
    keyPoints: ['시장지배적지위 남용', '남용행위 유형'],
    sourceYear: '2024',
  ),
  Question(
    id: 'q2',
    subjectId: 'civil_law',
    category: '민법총칙',
    stem: '민법상 법률행위의 무효와 취소에 관한 설명으로 옳지 않은 것은?',
    choices: ['무효인 법률행위는 추인해도 효력이 생기지 않는 것이 원칙', '취소할 수 있는 법률행위는 취소되기 전까지는 유효', '제한능력자의 법률행위는 취소할 수 있다', '무효와 취소는 항상 함께 발생한다'],
    correctIndex: 3,
    summaryExplanation: '무효와 취소는 별개의 제도로 항상 함께 발생하지 않음. 무효는 처음부터 효력 없음, 취소는 취소 전까지 유효.',
    keyPoints: ['법률행위 무효', '법률행위 취소'],
    sourceYear: '2023',
  ),
  Question(
    id: 'q3',
    subjectId: 'business_admin',
    category: '경영학',
    stem: 'SWOT 분석에서 기업 내부 역량에 해당하는 것을 모두 고르면?',
    choices: ['강점(Strength), 약점(Weakness)', '기회(Opportunity), 위협(Threat)', '강점, 기회', '약점, 위협'],
    correctIndex: 0,
    summaryExplanation: 'SWOT 중 강점·약점은 내부 요인, 기회·위협은 외부 요인.',
    keyPoints: ['SWOT 분석', '내부/외부 요인 구분'],
    sourceYear: '2025',
  ),
];
