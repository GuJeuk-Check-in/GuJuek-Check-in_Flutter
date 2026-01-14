import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
// 로그인 요청에 사용하는 데이터 모델
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
