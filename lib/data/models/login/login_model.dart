import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final String userId;
  final String purpose;
  final int maleCount;
  final int femaleCount;

  LoginModel({
    required this.userId,
    required this.purpose,
    required this.maleCount,
    required this.femaleCount,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
