// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidenceModel _$ResidenceModelFromJson(Map<String, dynamic> json) =>
    ResidenceModel(
      id: (json['id'] as num).toInt(),
      residence: json['residence'] as String,
    );

Map<String, dynamic> _$ResidenceModelToJson(ResidenceModel instance) =>
    <String, dynamic>{'id': instance.id, 'residence': instance.residence};
