class NoticeItem {
  final String date;
  final String title;
  final String body;
  final bool isNew;
  const NoticeItem({required this.date, required this.title, required this.body, this.isNew = false});
}

const notices = [
  NoticeItem(
    date: '2026.07.15',
    title: '스터디박스 오픈 안내',
    body: '가맹거래사 1차 시험 대비를 위한 스터디박스 서비스를 시작했습니다. 과목별 기출 통계를 기반으로 한 유사문제로 학습해보세요.',
    isNew: true,
  ),
  NoticeItem(
    date: '2026.07.10',
    title: '경제법 기출 통계 업데이트',
    body: '최근 11개년(제15회~제24회) 기출 440문항을 재분석하여 출제비중 통계를 갱신했습니다.',
  ),
  NoticeItem(
    date: '2026.06.28',
    title: '오답노트 · 마이페이지 기능 안내',
    body: '틀린 문제를 자동으로 모아보는 오답노트와, 학습 현황을 한눈에 볼 수 있는 마이페이지가 추가되었습니다.',
  ),
];

class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});
}

const faqs = [
  FaqItem(
    question: '유사문제는 어떤 기준으로 만들어지나요?',
    answer: '최근 11개년(제15회~제24회) 기출 440문항을 직접 분석해 출제비중이 높은 챕터부터 순서대로 유사문제를 구성했습니다.',
  ),
  FaqItem(
    question: '오답노트는 어떻게 이용하나요?',
    answer: '문제를 틀리면 자동으로 오답노트에 담깁니다. 마이페이지 > 오답노트에서 언제든 다시 풀어보고, 필요 없으면 목록에서 삭제할 수 있습니다.',
  ),
  FaqItem(
    question: '학습 기록이 저장되나요?',
    answer: '현재 버전은 데모용으로, 학습 기록은 앱을 새로고침하면 초기화됩니다. 정식 버전에서는 계정별로 기록이 저장될 예정입니다.',
  ),
  FaqItem(
    question: '비밀번호를 잊어버렸어요.',
    answer: '로그인 화면의 \'아이디/비밀번호 찾기\' 메뉴를 이용해주세요.',
  ),
];
