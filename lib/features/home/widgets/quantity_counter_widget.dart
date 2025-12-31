import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityCounter extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int>? onChanged;

  const QuantityCounter({
    super.key,
    this.initialValue = 0,
    this.onChanged,
  });

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant QuantityCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  void _decrease() {
    setState(() {
      if (_value > 0) _value--;
    });
    widget.onChanged?.call(_value);
  }

  void _increase() {
    setState(() {
      _value++;
    });
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    final bool canDecrease = _value > 0;

    return Container(
      width: 146.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48.w,
            height: 48.h,
            child: IconButton(
              onPressed: canDecrease ? _decrease : null,
              icon: const Icon(Icons.remove),
              splashRadius: 20.r,
              color: canDecrease ? Colors.black87 : Colors.black26,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$_value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48.w,
            height: 48.h,
            child: IconButton(
              onPressed: _increase,
              icon: const Icon(Icons.add),
              splashRadius: 20.r,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
