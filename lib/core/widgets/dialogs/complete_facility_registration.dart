import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

import '../../../features/home/presentation/ui/home_screen.dart';

class CompleteFacilityRegistration extends StatefulWidget {
  final String text;

  const CompleteFacilityRegistration({super.key, required this.text});

  @override
  State<CompleteFacilityRegistration> createState() =>
      _CompleteFacilityRegistrationState();
}

class _CompleteFacilityRegistrationState
    extends State<CompleteFacilityRegistration> {
  Timer? _timer;
  int checkTimer = 3;
  bool _navigator = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        checkTimer--;
      });
      if (checkTimer <= 0) {
        return _navigateToHome();
      }
    });
  }

  void _navigateToHome() async {
    if (_navigator || !mounted) return;
    _navigator = true;

    _timer?.cancel();
    _timer = null;

  await Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 시설 이용 신청 완료 안내 다이얼로그
    return Dialog(
      child: Container(
        width: 440.w,
        height: 298.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.completeIcon, width: 45.w, height: 45.h),
            SizedBox(height: 23.h),
            Text('시설 이용 신청이 완료되었습니다.', style: GuJuekTextStyle.dialogBigText),
            SizedBox(height: 4.h),
            Text(widget.text, style: GuJuekTextStyle.dialogText),
            SizedBox(height: 20.h),
            Text('$checkTimer', style: GuJuekTextStyle.labelText),
            TextButton(
              onPressed: _navigateToHome,
              child: Text(
                '처음으로',
                style: GuJuekTextStyle.labelText.copyWith(
                  color: GuJuekColor.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
