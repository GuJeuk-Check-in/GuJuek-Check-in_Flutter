import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// 성별을 API enum 값으로 매핑
enum Gender {
  @JsonValue('MAN')
  MAN,
  @JsonValue('WOMAN')
  WOMAN,
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
  final String visitTime;

  UserModel({
    required this.name,
    required this.gender,
    required this.phone,
    required this.birthYMD,
    required this.privacyAgreed,
    required this.purpose,
    required this.residence,
    required this.maleCount,
    required this.femaleCount,
    required this.visitTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}