// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  phone: json['phone'] as String,
  birthYMD: json['birthYMD'] as String,
  privacyAgreed: json['privacyAgreed'] as bool,
  purpose: json['purpose'] as String,
  residence: json['residence'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'gender': _$GenderEnumMap[instance.gender]!,
  'phone': instance.phone,
  'birthYMD': instance.birthYMD,
  'privacyAgreed': instance.privacyAgreed,
  'purpose': instance.purpose,
  'residence': instance.residence,
};

const _$GenderEnumMap = {Gender.MAN: 'MAN', Gender.WOMAN: 'WOMAN'};
