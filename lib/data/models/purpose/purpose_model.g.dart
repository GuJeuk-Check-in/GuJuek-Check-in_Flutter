// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purpose_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurposeModel _$PurposeModelFromJson(Map<String, dynamic> json) => PurposeModel(
  id: (json['id'] as num).toInt(),
  purpose: json['purpose'] as String,
);

Map<String, dynamic> _$PurposeModelToJson(PurposeModel instance) =>
    <String, dynamic>{'id': instance.id, 'purpose': instance.purpose};
