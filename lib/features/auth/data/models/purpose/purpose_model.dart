import 'package:json_annotation/json_annotation.dart';

part 'purpose_model.g.dart';

@JsonSerializable()
// 방문 목적 목록을 위한 모델
class PurposeModel {
  final int id;
  final String purpose;

  PurposeModel({required this.id, required this.purpose});

  factory PurposeModel.fromJson(Map<String, dynamic> json) => _$PurposeModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurposeModelToJson(this);
}
