
## 라이브러리 구조
lib/  
├── main.dart  
├── models/  
│   └── task.dart  
├── providers/  
│   └── task_provider.dart  
├── screens/  
├── widgets/  
│   ├── weekly_calendar.dart  
│   ├── user_info.dart  
│   ├── task_item.dart  
│   ├── task_list_section.dart  
│   └── add_task_dialog.dart  
├── services/  
└── utils/  

- models/: 데이터 모델 정의
- providers/: 상태 관리 로직
- screens/: 주요 화면 위젯
- widgets/: 재사용 가능한 UI 컴포넌트



---

## 라이브러리 별 기능
### 📱 screens/

* `HomeScreen` – 오늘의 포커스와 할일 목록
* `CalendarScreen` – 전체 달력 뷰 + 일별 task 보기
* `SettingsScreen` – 테마 설정, 알림 설정 등
* `TaskDetailScreen` – 태스크 상세 (서브 목표, 메모 등)

> **Tip:** 라우팅은 `go_router` 써도 좋아요. 유지보수가 훨씬 편해짐.


### 📦 models/

* `task_model.dart`: 제목, 완료 여부, 날짜, 카테고리, 메모 등
* `category_model.dart`: 태스크 카테고리 (예: Work, Personal)
* `user_preferences.dart`: 설정 데이터 저장용


### 🧱 widgets/

* `TaskItem`, `TaskList`, `CalendarDay`, `SectionTitle`, `CustomDialog` 등 UI 구성 재사용 가능 컴포넌트
* 스크롤 가능한 달력, 주간 뷰 등도 위젯화


### 🛠 services/

* `task_service.dart`: 태스크 추가/삭제/수정/불러오기
* `storage_service.dart`: 로컬 저장 (예: SharedPreferences, Hive, SQLite)
* `notification_service.dart`: 하루 시작 알림 등 푸시
* `theme_service.dart`: 다크모드, 테마 상태 저장


### 🧮 utils/

* `date_utils.dart`: 오늘 날짜 확인, 요일 포맷팅 등
* `id_generator.dart`: task 고유 ID 부여
* `extensions.dart`: String이나 DateTime에 대한 extension methods


## 추가 아이디어

| 기능                       | 이유                         |
| ------------------------ | -------------------------- |
| ✅ 오늘 할 일 리마인더 알림         | 매일 아침 8시 리마인드              |
| ✅ 반복 태스크 (ex: 매주 월요일 운동) | 생산성 앱에 필수                  |
| ✅ 목표 기반 태스크 그룹           | "이직 준비" 같은 큰 목표 안에 작은 할 일들 |
| ✅ 완료율 통계                 | 지난주/이번주 얼마나 했는지 시각화        |
| ✅ 다크모드 지원                | 사용자 취향 고려                  |
| ✅ 백업 & 복구                | 기기 바뀌어도 데이터 유지             |
| ✅ 검색 & 필터                | 태스크 수 많아질 때 필수             |

---


## 🎯 앱 목적 정리

핵심 기능은:

1. **오늘 할 일 추가 및 체크**
2. **간단한 날짜 선택(또는 오늘로 고정)**
3. **태스크 저장/유지**

---

## 🚀 추천 구현 순서 (단계별 MVP)

### ✅ 1단계: 기본 태스크 관리 MVP (핵심만 먼저!)

* [x] 태스크 모델 (`Task`)
* [x] 태스크 추가 / 완료 처리
* [x] 태스크 리스트 UI
* [x] 하루 단위 저장 (예: `DateTime.now()` 기준)
* [x] 로컬 저장 (SharedPreferences or Hive)

> 👉 `screens/`, `models/`, `widgets/`, `services/storage_service.dart` 만으로 완성 가능
> 📦 저장은 Hive 

---

### ✅ 2단계: 날짜별 태스크 정리 (캘린더)

* [ ] 캘린더 뷰 추가 (`CalendarScreen`)
* [ ] 특정 날짜 클릭 → 해당 날짜의 태스크 목록 보기
* [ ] 날짜별 태스크 필터링 처리 (`task_service.dart`)

---

### ✅ 3단계: 반복 태스크 / 태그 / 카테고리

* [ ] 반복 주기 설정 (매주/매일/매월)
* [ ] 태스크에 카테고리 태그 (Work, Study 등)
* [ ] 통계(예: 일/주/월 단위 완료율)

---

### ✅ 4단계: 리마인더 알림

* [ ] 로컬 푸시 알림 (`flutter_local_notifications`)
* [ ] 하루 한 번 알림 or 특정 시간 알림
* [ ] 완료 안 된 태스크 알림

---

### ✅ 5단계: UX 개선 & 설정

* [ ] 다크모드 토글
* [ ] 앱 설정화면 (`SettingsScreen`)
* [ ] 태스크 편집, 삭제 기능