import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeopleCounterWidget extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;

  const PeopleCounterWidget({
    super.key,
    this.initialValue = 0,
    this.onChanged,
    this.min = 0,
    this.max = 999,
  });

  @override
  State<PeopleCounterWidget> createState() => _PeopleCounterWidgetState();
}

class _PeopleCounterWidgetState extends State<PeopleCounterWidget> {
  late int _value;

  @override
  void initState() {
    super.initState();
    // 초기값이 범위를 넘지 않도록 보정
    _value = widget.initialValue.clamp(widget.min, widget.max);
  }

  void _decrease() {
    if (_value <= widget.min) return;
    setState(() => _value--);
    widget.onChanged?.call(_value);
  }

  void _increase() {
    if (_value >= widget.max) return;
    setState(() => _value++);
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    // 버튼 활성화 여부 계산
    final canMinus = _value > widget.min;
    final canPlus = _value < widget.max;

    return Container(
      width: 280.w,   // 필요하면 조절
      height: 44.h,   // 이미지 느낌이 얇은 편이라 44로
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: Row(
        children: [
          _IconAreaButton(
            icon: Icons.remove,
            enabled: canMinus,
            onTap: _decrease,
          ),
          Expanded(
            child: Center(
              child: Text(
                '$_value명',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          _IconAreaButton(
            icon: Icons.add,
            enabled: canPlus,
            onTap: _increase,
          ),
        ],
      ),
    );
  }
}

class _IconAreaButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _IconAreaButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54.w, // 좌/우 버튼 영역
      height: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: enabled ? onTap : null,
        child: Center(
          child: Icon(
            icon,
            size: 20.sp,
            color: enabled ? Colors.black87 : Colors.black26,
          ),
        ),
      ),
    );
  }
}
