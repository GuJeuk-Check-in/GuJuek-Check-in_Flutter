// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  userId: json['userId'] as String,
  purpose: json['purpose'] as String,
  maleCount: (json['maleCount'] as num).toInt(),
  femaleCount: (json['femaleCount'] as num).toInt(),
);

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'purpose': instance.purpose,
      'maleCount': instance.maleCount,
      'femaleCount': instance.femaleCount,
    };
