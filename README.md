# MunKanji (문칸지)

> 일본 상용한자 2136자를 가볍게, 자주, 재밌게 외우는 iOS 앱

## 목차

- [프로젝트 소개](#프로젝트-소개)
- [기술 스택](#기술-스택)
- [데이터 구조](#데이터-구조)
- [앱 구조](#앱-구조)
- [주요 기능](#주요-기능)
- [간격 반복 알고리즘](#간격-반복-알고리즘)
- [화면 흐름](#화면-흐름)

---

## 프로젝트 소개

### 기획 배경

- 일본어 학습자에게 한자는 가장 큰 진입 장벽
- 기존 한자 앱은 단순 암기 위주로 지루하고, 복습 시스템이 부재
- 한번 맞혔다고 끝이 아니라 **자주 보여주면서 자연스럽게 익히는** 방식이 필요

### 핵심 컨셉

| 원칙 | 설명 |
|------|------|
| **가볍게** | 5~30개 단위로 학습량 조절, 3분이면 한 세션 완료 |
| **자주** | 간격 반복(Spaced Repetition)으로 잊을 만하면 다시 출제 |
| **재밌게** | 4지선다 퀴즈로 게임처럼 학습, 진행도를 시각적으로 확인 |

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| **언어** | Swift 5 |
| **UI** | SwiftUI |
| **데이터** | SwiftData |
| **차트** | Swift Charts |
| **최소 지원** | iOS 17.0+ |
| **아키텍처** | MVVM |
| **폰트** | Pretendard (9 weights) |
| **데이터 소스** | JSON (2136자 한자 + 10,600개 예시단어) |

---

## 데이터 구조

### 모델 관계도

```
┌─────────────────┐
│     Kanji       │ ← 2136개 상용한자 (JSON → SwiftData)
│─────────────────│
│ id: Int (PK)    │
│ grade: String   │──────────────────────────────────────┐
│ kanji: String   │                                      │
│ korean: String  │                                      │
│ sound: String   │                                      │
│ meaning: String │                                      │
│ memoryTip: Str? │                                      │
└────────┬────────┘                                      │
         │ 1:1                                           │ 1:1
         │                                               │
┌────────┴────────┐    ┌──────────────────┐    ┌────────┴─────────────┐
│    StudyLog     │    │ EumHunStudyLog   │    │KanjiWithExampleWords │
│─────────────────│    │──────────────────│    │──────────────────────│
│ kanjiID: Int(PK)│    │ kanjiID: Int(PK) │    │ kanjiID: Int (PK)    │
│ status: Enum    │    │ status: Enum     │    │ kanji: String        │
│ reviewCount: Int│    │ reviewCount: Int │    │ examples: [Example]  │
│ lastStudied: Dt?│    │ lastStudied: Dt? │    │  ├ word: String      │
│ nextReview: Dt? │    │ nextReview: Dt?  │    │  ├ sound: String     │
│ (computed)      │    │ (computed)       │    │  └ meaning: String   │
└─────────────────┘    └──────────────────┘    └──────────────────────┘
   한자모드 진행도          음훈모드 진행도          예시단어 (~5개/한자)
```

### StudyStatus (학습 상태)

```
unseen ──→ correct ──→ correct ──→ correct ──→ correct ──→ mastered
  │           │           │           │           │         (졸업!)
  │           ↓           ↓           ↓           ↓
  └──→ incorrect (틀리면 reviewCount 리셋)
```

### JSON 데이터

**kanji_2136.json** — 상용한자 원본
```json
{
  "grade": "소학교 1학년",
  "kanji": "車",
  "korean": "수레 거, 수레 차",
  "sound": "しゃ",
  "meaning": "くるま",
  "memoryTip": "위에서 내려다본 수레의 바퀴와 축..."
}
```

**Kanji_Examples.json** — 한자별 예시단어
```json
{
  "kanji": "車",
  "examples": [
    { "word": "車輪", "sound": "しゃりん", "meaning": "차륜" },
    { "word": "車庫", "sound": "しゃこ", "meaning": "차고" }
  ]
}
```

---

## 앱 구조

```
MunKanji/
├── App/
│   └── MunKanjiApp.swift              # 앱 진입점, 네비게이션, 데이터 초기화
├── Models/
│   ├── Kanji.swift                    # 한자 모델 (2136자)
│   ├── StudyLog.swift                 # 한자모드 학습 기록
│   ├── EumHunStudyLog.swift           # 음훈모드 학습 기록
│   ├── KanjiWithExampleWords.swift    # 예시단어 모델
│   ├── Word.swift                     # JSON 파싱용 구조체
│   └── Dummy.swift                    # 프리뷰 테스트 데이터
├── UI/
│   ├── MainView/                      # 홈 화면 + 프로그레스 링 + 모드 선택
│   ├── StudyIntroView/                # 학습 설정 (스테퍼 + 차트)
│   │   ├── View/
│   │   └── ViewModel/
│   ├── LearningView/                  # 카드 학습 화면
│   │   ├── View/
│   │   └── ViewModel/
│   ├── QuizView/                      # 4지선다 퀴즈
│   │   ├── View/                      # QuizView + EumHunQuizView
│   │   └── ViewModel/                 # QuizViewModel + EumHunQuizViewModel
│   ├── ResultView/                    # 학습 결과
│   ├── HistoryView/                   # 학습 기록 조회
│   └── Components/                    # 공용 컴포넌트
├── Util/
│   ├── JsonManager.swift              # JSON 로딩
│   ├── KanjiExampleLoader.swift       # 예시단어 로딩
│   ├── DataInitializer.swift          # DB 초기화 + 마이그레이션
│   └── UserInfo.swift                 # 모드 설정 + 학습 개수 설정
├── Json/
│   ├── kanji_2136.json                # 상용한자 데이터
│   └── Kanji_Examples.json            # 예시단어 데이터
└── Resource/
    ├── Font/                          # Pretendard 폰트
    └── Assets.xcassets/               # 컬러 에셋
```

---

## 주요 기능

### 1. 두 가지 학습 모드

| | 한자모드 | 음훈모드 |
|---|---|---|
| **학습** | 한자 + 한글 음훈 카드 | 한자 + 예시단어 5개 카드 |
| **퀴즈** | 한자 보고 → 한글 음훈 4지선다 | 예시단어 보고 → 일본어 발음 4지선다 |
| **채점** | 한자당 1문제 | 한자당 최대 3문제 (전부 맞혀야 correct) |
| **진행도** | StudyLog로 독립 추적 | EumHunStudyLog로 독립 추적 |

### 2. 메인 화면 — 프로그레스 링

- 외운 한자 수 / 2136 을 원형 차트로 시각화
- 앱 진입 시 0에서 현재 진행도까지 애니메이션
- 퀴즈 완료 후 돌아오면 증가분만큼 추가 애니메이션
- 터치하면 학습 기록(HistoryView)으로 이동

### 3. 학습 설정 — 스테퍼 + 차트

- 5개 단위로 학습량 조절 (한자모드: 5~30, 음훈모드: 5~15)
- 막대 차트로 틀림 / 복습 / 신규 한자 비율 시각화
- 학습 가능한 한자가 설정보다 적으면 "남은 한자 N개" 표시

### 4. 카드 학습

- **한자모드**: 가로 스크롤 카드, 상단 색띠로 상태 표시
  - 파랑: 신규 / 초록: 복습 / 코랄: 틀림
- **음훈모드**: 탭 캐러셀 + 예시단어 리스트
  - 한자 + 음/훈 카드 → 아래에 예시단어 5개

### 5. 4지선다 퀴즈

- 상단에 문제 (한자 또는 예시단어)
- 하단에 2x2 선택지 그리드
- 정답: 초록 / 오답: 코랄 즉시 피드백
- 0.5초 후 자동으로 다음 문제

### 6. 학습 결과

- 맞힌 한자 / 틀린 한자 카운트 표시
- 결과에 따라 StudyLog 업데이트
- "완료" 버튼으로 메인 화면 복귀

### 7. 학습 기록 (히스토리)

- 외운 한자를 3열 그리드로 표시 (최근 학습순)
- 터치하면 상세 시트:
  - 한자모드: 한자 카드
  - 음훈모드: 한자 카드 + 예시단어 리스트

### 8. 엣지케이스 처리

- **모든 한자 마스터**: "모든 한자를 마스터했습니다" 메시지
- **오늘 학습할 한자 없음**: "복습 예정일에 다시 방문해주세요" 메시지
- **남은 한자 < 설정 개수**: 실제 남은 수만큼만 출제 + 안내 표시

---

## 간격 반복 알고리즘

시간이 지나면 다시 출제되고, 맞힐수록 간격이 길어집니다. 망각곡선에 기반한 1,3,5,7,14일 주기 반복을 택했습니다.

### 복습 간격

| 연속 정답 횟수 | 다음 복습까지 | 상태 |
|:---:|:---:|:---:|
| 0회 | 즉시 (오늘) | unseen / incorrect |
| 1회 | 1일 후 | correct |
| 2회 | 3일 후 | correct |
| 3회 | 7일 후 | correct |
| 4회 | **졸업 (mastered)** | mastered |

### 학습 우선순위

```
① 틀린 한자 (incorrect)     ← 최우선 복습
② 복습 대상 (nextReviewDate ≤ 오늘) ← 기간 도래한 한자
③ 신규 한자 (unseen)        ← 아직 안 본 한자
```

### 채점 규칙

- **한자모드**: 1문제 정답 → correct, 오답 → incorrect
- **음훈모드**: 한자당 최대 3문제, **전부 맞혀야** correct
  - 1개라도 틀리면 → incorrect, reviewCount 리셋

---

## 화면 흐름

```
메인 화면 (프로그레스 링)
│
├── [프로그레스 링 터치] → 학습 기록
│                          └── [한자 터치] → 상세 시트
│
└── [학습하기] → 학습 설정 (스테퍼 + 차트)
                  │
                  └── [학습시작] → 카드 학습
                                   │
                                   └── [퀴즈풀기] → 4지선다 퀴즈
                                                     │
                                                     └── (자동) → 학습 결과
                                                                    │
                                                                    └── [완료] → 메인 화면
```
