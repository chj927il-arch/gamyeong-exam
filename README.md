# 가맹거래사 시험 대비 문제은행 앱 (가칭)

가맹거래사 1차 시험(경제법·민법·경영학) 준비생을 위한 AI 기반 문제은행 모바일 앱.
큐넷 기출문제를 AI로 분석(출제의도·핵심·최근 이슈)해 유사문제를 무한 생성하고,
사용자가 정답/오답을 반복해서 풀며 자연스럽게 개념을 익히는 듀오링고식 학습 구조.
추후 앱스토어/플레이스토어 정식 출시, 유료 판매 예정.

## 기술 스택 (초기 결정, 변경 가능)
- **모바일 앱**: Flutter (iOS/Android 단일 코드베이스)
- **백엔드/인프라**: Firebase (Auth·Firestore·Functions·인앱결제 연동)
- **AI 문제 생성/분석**: Google Gemini API

## 개발 환경 준비 상태
- Git: 설치됨
- Flutter SDK: **미설치** (설치 필요)
- GitHub CLI: **미설치**

## 여러 PC에서 이어작업하기
1. 이 저장소를 GitHub 비공개 저장소로 push
2. 다른 PC에서 `git clone <저장소 주소>`
3. 각 PC에 Flutter SDK, Android Studio(또는 Xcode) 설치
4. API 키 등 비밀값(`.env`, `firebase_options.dart` 등)은 git에 올리지 않으므로 PC마다 별도로 옮겨야 함
