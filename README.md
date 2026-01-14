# GuJuek Check-in (Flutter)

구즉 청소년문화의집 체크인/등록 플로우를 위한 Flutter 앱입니다.  
Riverpod 기반 상태관리, Dio 네트워크, json_serializable 모델을 사용합니다.

## 아키텍처 개요

- **feature 기반 폴더 구조**로 UI/상태/위젯을 기능 단위로 분리
- **core**는 공통 인프라(네트워크, 이미지 경로 등)를 담당
- **data**는 모델 및 리포지토리(API 호출)를 담당
- **shared**는 공통 위젯/다이얼로그를 담당

## 폴더 구조

```
lib/
  core/
    images.dart
    network/
      api_client.dart
      api_client_provider.dart
  data/
    models/
      login/
      purpose/
      sign_up/
    repositories/
  features/
    facility_safety_training/
    home/
    sign_up/
    shared/
  shared/
    dialogs/
    widgets/
```

## 주요 흐름

- `main.dart`에서 `.env`를 로드하고 `ProviderScope`로 앱 시작
- `HomeScreen` → 안전교육 화면 → 시설 이용 신청/처음 방문 등록 다이얼로그
- 각 기능별 상태는 `StateNotifier` + `SignUpState`, `FacilityRegistrationState`로 관리

## 기술 스택

- **UI**: Flutter, flutter_screenutil
- **상태관리**: flutter_riverpod
- **네트워크**: dio
- **모델 직렬화**: json_serializable, json_annotation
- **환경변수**: flutter_dotenv

## 환경 설정

`.env`에 API 주소를 설정합니다.

```
BASE_URL=https://your-api.example.com
```

## 코드 생성

json_serializable 모델 갱신이 필요할 때 실행합니다.

```
flutter pub run build_runner build --delete-conflicting-outputs
```

## 실행

```
flutter pub get
flutter run
```
