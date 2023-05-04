import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motorhome/utils/constants.dart';
import 'package:motorhome/utils/theme.dart';

class CircleButton extends StatefulWidget {
  final Widget icon;
  final Function() onTap;
  final int? longTapMilliseconds;
  final Function()? onLongTap;

  CircleButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.longTapMilliseconds,
    this.onLongTap
  }) : super(key: key);

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  Timer? _timer;

  void _tappedCallback(Timer timer) {
    widget.onLongTap?.call();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (widget.onLongTap != null) {
          _timer = Timer.periodic(Duration(milliseconds: (widget.longTapMilliseconds ?? MHConstants.hiddenConfigTappedTime)), _tappedCallback);
        } else {
          widget.onTap();
        }
      },
      onTapUp: (details) {
        widget.onTap();
        _timer?.cancel();
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: MHColors.blueLight,
            width: 3
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50.0))
        ),
        child: Center(child: widget.icon)
      ),
    );
  }
}