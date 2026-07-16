# CLAUDE.md

이 파일은 Claude Code가 이 저장소에서 작업할 때 자동으로 읽는 프로젝트 지침입니다.
새 PC에서 이 저장소를 클론해 Claude Code로 열면 이 파일이 자동으로 컨텍스트에 포함됩니다.

## 프로젝트 한 줄 요약
가맹거래사 1차 시험(경제법·민법·경영학) 준비생을 위한 AI 기반 문제은행 모바일 앱.
큐넷 기출문제를 Gemini로 분석(출제의도·핵심·최근 이슈)해 유사문제를 무한 생성하고,
사용자가 정답/오답을 반복해서 풀며 자연스럽게 개념을 익히는 **듀오링고식 학습 구조**.
오답뿐 아니라 정답 문제도 유사문제를 계속 반복 노출. 해설은 길게 쓰지 않고 핵심만 요약,
사용자가 원하는 해설만 골라 **단권화 노트**를 만들 수 있게 함.
추후 앱스토어/플레이스토어 정식 출시, **유료 판매** 예정.

## 저장소
- **GitHub (비공개)**: https://github.com/chj927il-arch/gamyeong-exam
- 로컬 경로: 회사 PC `C:\gamyeong-exam` (집 PC는 각자 클론 위치)

## 기술 스택 (결정됨)
- **모바일 앱**: Flutter (iOS/Android 단일 코드베이스)
- **백엔드/인프라**: Firebase (Auth·Firestore·Functions·인앱결제 연동 예정)
- **AI 문제 생성/분석**: Google Gemini API (competitor 프로젝트에서 이미 사용 경험 있음)

## 현재까지 진행 상황 (2026-07-16 기준)
- [x] 프로젝트 폴더 생성 + git 초기화 + GitHub 비공개 저장소 push
- [x] Flutter SDK 설치 (회사 PC, `C:\flutter`, PATH 등록, stable 채널 3.44.6)
- [x] GitHub CLI 설치 + 로그인 (`chj927il-arch` 계정)
- [x] `flutter create`로 앱 프로젝트 스캐폴딩 (`app/` 폴더, 프로젝트명 `gamyeong_exam`, org `com.gamyeongexam`)
  - Android SDK/Android Studio 미설치라 Android 빌드는 아직 불가. **Chrome(웹)으로는 실행 가능**(`flutter run -d chrome`).
  - iOS는 Windows에서 빌드 불가(Mac 필요).
- [x] 기본 데이터 모델 작성 (`app/lib/models/`): `ExamSubject`(과목·세부영역), `Question`(문제/해설/키포인트/원본연결), `QuestionAttempt`(풀이기록), `MasteryRecord`(숙련도·반복노출 판단), `CompiledNoteItem`(단권화 항목)
- [x] 기본 화면 뼈대 (`app/lib/screens/`): 학습(과목선택→문제풀이)/오답노트/단권화/통계 4탭 구조, 샘플문제 3개로 화면 확인 가능
- [x] `flutter analyze` 통과, 기본 위젯 테스트 통과
- [ ] Firebase 프로젝트 생성/연동 — **아직 안 함**
- [ ] Gemini API 키 발급/연동, 실제 유사문제 생성 로직 — **아직 안 함**
- [ ] 큐넷 기출문제 확보 방식 결정 — **아직 안 함**
- [ ] 오답노트/단권화/통계 실제 데이터 연동 (현재는 안내 문구만 있는 placeholder) — **아직 안 함**
- [ ] 회원가입/로그인, 인앱결제 — **아직 안 함**

### 코드 구조 참고
```
app/lib/
  main.dart              # 루트 위젯, 하단 4탭 네비게이션
  models/                # Question, ExamSubject, MasteryRecord 등 데이터 모델
  data/sample_questions.dart  # 화면 확인용 샘플 데이터 (실제 데이터로 교체 예정)
  screens/               # home(과목선택), quiz(문제풀이), wrong_note, compiled_note, stats
```
실행 확인: `cd app && flutter run -d chrome`

## 여러 PC에서 이어작업하기
1. `git clone https://github.com/chj927il-arch/gamyeong-exam.git`
2. 해당 PC에 Flutter SDK 설치 필요 (미설치 시 Claude에게 설치 요청 가능)
3. **iOS 빌드/테스트는 Windows에서 불가능** (Xcode는 Mac 전용). Android는 Windows에서 가능.
   나중에 iOS 빌드가 필요하면 Mac 또는 클라우드 빌드 서비스(Codemagic 등) 필요.
4. API 키, `google-services.json`, `firebase_options.dart` 등 비밀값은 git에 올라가지 않음(.gitignore).
   PC마다 별도로 옮겨야 함.

## 절대 지켜야 할 규칙
1. **AI 모델은 Google Gemini만 사용.**
2. **API 키 등 비밀값은 코드/로그/커밋/문서에 절대 노출 금지.** `.env` 등으로만 관리.
3. **한글 파일 작성 시 반드시 UTF-8.**
4. **사용자는 비개발자 + Windows + 한국어.** 명령어는 복붙 가능한 단일 라인, 설명은 쉽게.
