# GuJuek Check-in (Flutter)

구즉 청소년문화의집 체크인/등록 플로우를 위한 Flutter 앱입니다.  
Riverpod 기반 상태관리, Dio 네트워크, json_serializable 모델을 사용합니다.

## 아키텍처 개요

- **feature 기반 폴더 구조**로 기능 단위 분리
- **core**는 공통 인프라(네트워크, 이미지 경로, 공용 위젯)를 담당
- **auth**는 data/domain/presentation으로 레이어를 구분

## 폴더 구조

```
lib/
  core/
    network/
      api_client.dart
      api_client_provider.dart
    widgets/
      dialogs/
  features/
    auth/
      data/
        models/
        sign_up_options.dart
      domain/
        repositories/
      presentation/
        dialogs/
        state/
        widgets/
    facility_safety_training/
      ui/
      widgets/
    home/
      presentation/
        ui/
        widgets/
  main.dart
assets/
  fonts/
  images/
```

## 주요 흐름

- `main.dart`에서 `.env`를 로드하고 `ProviderScope`로 앱 시작
- `HomeScreen`에서 안전교육 플로우와 등록 다이얼로그 진입
- 각 기능별 상태는 `StateNotifier` 기반으로 관리 (`SignUpState`, `FacilityRegistrationState`)

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
