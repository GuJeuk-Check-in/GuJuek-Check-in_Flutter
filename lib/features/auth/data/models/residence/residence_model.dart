import 'package:json_annotation/json_annotation.dart';

part 'residence_model.g.dart';

@JsonSerializable()
// 거주지 목록을 위한 모델
class ResidenceModel {
  final int id;
  final String residence;

  ResidenceModel({required this.id, required this.residence});

  factory ResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResidenceModelToJson(this);
}
