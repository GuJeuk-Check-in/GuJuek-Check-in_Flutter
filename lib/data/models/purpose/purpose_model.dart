import 'package:json_annotation/json_annotation.dart';

part 'purpose_model.g.dart';

@JsonSerializable()
class PurposeModel {
  final int id;
  final String purpose;

  PurposeModel({required this.id, required this.purpose});

  factory PurposeModel.fromJson(Map<String, dynamic> json) => _$PurposeModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurposeModelToJson(this);
}