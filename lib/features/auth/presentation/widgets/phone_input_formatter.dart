import 'package:flutter/services.dart';

// 010-1234-5678 형태로 자동 하이픈 입력
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 숫자만 추출
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 최대 11자리까지만 허용
    if (digitsOnly.length > 11) {
      return oldValue;
    }

    // 포맷팅
    String formatted = '';

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 첫 3자리
    if (digitsOnly.length <= 3) {
      formatted = digitsOnly;
    }
    // 4~7자리: 010-xxxx
    else if (digitsOnly.length <= 7) {
      formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
    }
    // 8~11자리: 010-xxxx-xxxx
    else {
      formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
