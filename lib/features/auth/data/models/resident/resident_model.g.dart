// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    ResidentModel(
      id: (json['id'] as num).toInt(),
      residence: json['residence'] as String,
    );

Map<String, dynamic> _$ResidentModelToJson(ResidentModel instance) =>
    <String, dynamic>{'id': instance.id, 'residence': instance.residence};
