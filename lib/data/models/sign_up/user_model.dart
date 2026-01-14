import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// 성별을 API enum 값으로 매핑
enum Gender { 
  @JsonValue('MAN')
  MAN, 
  
  @JsonValue('WOMAN')
  WOMAN 
}

// 거주지 선택 목록(표시용 한글명 포함)
enum ResidenceEnum {
  gwanpyeong('관평동'),
  gujeuk('구즉동'),
  noeun1('노은1동'),
  noeun2('노은2동'),
  noeun3('노은3동'),
  sangdae('상대동'),
  sinseong('신성동'),
  oncheon1('온천1동'),
  oncheon2('온천2동'),
  wonsinheung('원신흥동'),
  jeonmin('전민동'),
  jinjam('진잠동'),
  hakha('학하동');

  final String value;
  const ResidenceEnum(this.value);
}

@JsonSerializable()
// 회원가입 요청에 사용하는 데이터 모델
class UserModel {
  final String name;
  final Gender gender;
  final String phone;
  final String birthYMD;
  final bool privacyAgreed;
  final String purpose;
  final String residence; // String으로 저장
  final int maleCount;
  final int femaleCount;

  UserModel({
    required this.name,
    required this.gender,
    required this.phone,
    required this.birthYMD,
    required this.privacyAgreed,
    required this.purpose,
    required this.residence, required this.maleCount, required this.femaleCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  ResidenceEnum? get residenceEnum {
    // 저장된 문자열을 enum으로 되돌림(없으면 null)
    try {
      return ResidenceEnum.values.firstWhere((e) => e.value == residence);
    } catch (_) {
      return null;
    }
  }

}
