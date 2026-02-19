import 'package:flutter/material.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';

abstract final class GuJuekTextStyle {
  static TextStyle title = defaultTextStyle.copyWith(
    color: GuJuekColor.white,
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );

  static TextStyle hintText = defaultTextStyle.copyWith(
    color: GuJuekColor.gray20,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle labelText = defaultTextStyle.copyWith(
    color: GuJuekColor.gray40,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle check = defaultTextStyle.copyWith(
    color: GuJuekColor.white,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bigIdText = defaultTextStyle.copyWith(
    color: GuJuekColor.gray30,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle smallIdText = defaultTextStyle.copyWith(
    color: GuJuekColor.gray30,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static TextStyle dialogText = defaultTextStyle.copyWith(
    color: GuJuekColor.gray10,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle dialogBigText = defaultTextStyle.copyWith(
    fontSize: 24,
    color: GuJuekColor.gray30,
    fontWeight: FontWeight.w600,
  );
}

const TextStyle defaultTextStyle = TextStyle(
  color: GuJuekColor.white,
  fontFamily: 'Pretendard',
);
