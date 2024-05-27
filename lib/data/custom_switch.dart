import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../values/colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double thumbSize;

  CustomSwitch({
    required this.value,
    required this.onChanged,
    this.thumbSize = 30.0,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: widget.thumbSize * 1.9,
        height: widget.thumbSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.thumbSize * 0.5),
          color: widget.value ? Clr().primaryColor : Color(0xffDCDCDC),
        ),
        child: Align(
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: widget.thumbSize,
              height: widget.thumbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Clr().white),
                color: widget.value ? Clr().primaryColor : Color(0xffDCDCDC),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
