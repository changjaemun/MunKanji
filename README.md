# MunKanji (문칸지)

일본 상용한자 2136자를 간격 반복(Spaced Repetition) 방식으로 학습하는 iOS 앱.

- 현재 버전: **2.0.1**
- 지원 OS: iOS 17.0+

---

## 주요 기능

- **두 가지 학습 모드** — 한자모드(한자 → 음훈 4지선다), 음훈모드(예시 단어 → 일본어 발음 4지선다). 두 모드는 학습 진행도를 독립적으로 추적한다.
- **간격 반복 복습** — 정답을 맞힐수록 다음 출제까지의 간격이 길어지고, 틀리면 즉시 복습 대상으로 돌아온다.
- **원형 프로그레스** — 메인 화면에서 전체 2136자 대비 학습 진도를 시각화.
- **학습 히스토리** — 외운 한자를 그리드로 표시하고, 터치 시 상세 카드와 예시 단어를 확인.

---

## 기술 스택

| 분류 | 사용 기술 |
|---|---|
| 언어 | Swift 5 |
| UI | SwiftUI |
| 영속 저장소 | SwiftData |
| 차트 | Swift Charts |
| 아키텍처 | MVVM |
| 폰트 | Pretendard |
| 최소 지원 | iOS 17.0+ |

---

## 데이터 모델

```
Kanji (2136개, JSON → SwiftData 시딩)
├── StudyLog         (한자모드 진행도, kanjiID 1:1 매칭)
├── EumHunStudyLog   (음훈모드 진행도, kanjiID 1:1 매칭)
└── KanjiWithExampleWords  (한자별 예시 단어, ~5개씩)
```

- 학습 기록(`StudyLog`, `EumHunStudyLog`)은 사용자 자산이며 데이터 마이그레이션 시에도 보존된다.
- 한자 JSON 갱신 시 `DataInitializer`의 `dataVersion` 키만 갱신하면, 학습 기록을 유지한 채 `Kanji` 테이블만 재시딩된다.

---

## 간격 반복 알고리즘

| 연속 정답 | 다음 복습 | 상태 |
|:---:|:---:|:---:|
| 0회 | 즉시 | unseen / incorrect |
| 1회 | +1일 | correct |
| 2회 | +3일 | correct |
| 3회 | +7일 | correct |
| 4회+ | — | **mastered** |

**학습 우선순위**: `incorrect` → `복습 도래(nextReviewDate ≤ today)` → `unseen`

**채점 규칙**:
- 한자모드: 1문제 정답 → `correct`, 오답 → `incorrect`
- 음훈모드: 한자당 최대 3문제, **모두 정답 시에만** `correct` (하나라도 틀리면 `incorrect` + reviewCount 리셋)

---

## 프로젝트 구조

```
MunKanji/
├── App/          # 앱 진입점, 네비게이션, ModelContainer 초기화
├── Models/       # Kanji, StudyLog, EumHunStudyLog, KanjiWithExampleWords
├── UI/           # View + ViewModel (화면별 2단 구조)
├── Util/         # JSON 로딩, 데이터 시딩/마이그레이션, 사용자 설정
├── Json/         # kanji_2136.json, Kanji_Examples.json
└── Resource/     # Assets, Pretendard 폰트
```

---

## 빌드

Xcode 프로젝트(`MunKanji.xcodeproj`)이며 외부 의존성은 없다.

```bash
# 시뮬레이터 빌드
xcodebuild -project MunKanji.xcodeproj -scheme MunKanji \
  -destination 'platform=iOS Simulator,name=iPhone 15' build

# 테스트 실행
xcodebuild -project MunKanji.xcodeproj -scheme MunKanji \
  -destination 'platform=iOS Simulator,name=iPhone 15' test
```

또는 Xcode에서 `MunKanji.xcodeproj`를 열고 ⌘R.
