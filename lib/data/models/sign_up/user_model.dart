import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum Gender { 
  @JsonValue('MAN')
  MAN, 
  
  @JsonValue('WOMAN')
  WOMAN 
}
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
class UserModel {
  final String name;
  final Gender gender;
  final String phone;
  final String birthYMD;
  final bool privacyAgreed;
  final String purpose;
  final String residence; // String으로 저장

  UserModel({
    required this.name,
    required this.gender,
    required this.phone,
    required this.birthYMD,
    required this.privacyAgreed,
    required this.purpose,
    required this.residence,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  ResidenceEnum? get residenceEnum {
    try {
      return ResidenceEnum.values.firstWhere((e) => e.value == residence);
    } catch (_) {
      return null;
    }
  }

}
