import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

enum Gender { Man, Woman }
enum Residence { pyeong, yang }

@JsonSerializable()
class UserModel {
  final String name;
  final Gender gender;
  final String phone;
  final String birthYMD;
  final bool privacyAgreed;
  final List<String> purpose;

  UserModel({
    required this.name,
    required this.gender,
    required this.phone,
    required this.birthYMD,
    required this.privacyAgreed,
    required this.purpose,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }
}
