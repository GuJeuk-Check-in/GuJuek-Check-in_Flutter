import 'package:json_annotation/json_annotation.dart';

part 'resident_model.g.dart';

@JsonSerializable()
class ResidentModel {
  final int id;
  final String residence;

  ResidentModel({
    required this.id,
    required this.residence,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json)
  => _$ResidentModelFromJson(json);

  Map<String, dynamic> toJson()
  => _$ResidentModelToJson(this);
}