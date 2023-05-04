import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';

class CircleStateButton extends StatefulWidget {
  final String? text;
  final double? size;
  final String icon;
  final Function() onTapDown;
  final Function()? onTapUp;
  final bool active;
  final Color? activeColor;
  final bool enabled;
  final double? radius;

  const CircleStateButton({
    Key? key,
    this.text,
    this.size,
    required this.icon,
    required this.onTapDown,
    this.active = false,
    this.activeColor,
    this.enabled = true,
    this.radius = 50.0,
    this.onTapUp,
  }) : super(key: key);

  @override
  State<CircleStateButton> createState() => _CircleStateButtonState();
}

class _CircleStateButtonState extends State<CircleStateButton> {
  var onTapUpCalled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (!onTapUpCalled && (details.localPosition.dx < 0 || details.localPosition.dx > (widget.size ?? 70) || details.localPosition.dy < 0 || details.localPosition.dy > (widget.size ?? 70))) {
          onTapUpCalled = true;
          widget.onTapUp?.call();
        }
      },
      onTapDown: (details) {
        onTapUpCalled = false;
        widget.onTapDown();
      },
      onTapUp: (_) {
        widget.onTapUp?.call();
      },
      child: Container(
        width: (widget.text != null) ? 60 : null,
        height: (widget.text != null) ? 60 : null,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.enabled ? (widget.active ? (widget.activeColor ?? MHColors.green) : MHColors.blueLight) : MHColors.greyDisabled,
            width: 3
          ),
          borderRadius: BorderRadius.all(Radius.circular(widget.radius!))
        ),
        child: Center(
          child: widget.text != null
          ?
            Text(
              widget.text!,
              textAlign: TextAlign.center,
              style: MHTextStyles.h1.copyWith(
                color: widget.enabled ? (widget.active ? (widget.activeColor ?? MHColors.green) : MHColors.blueLight) : MHColors.greyDisabled,
              )
            )
          :
            svgIcon(widget.icon, size: widget.size ?? 70, color: widget.enabled ? (widget.active ? (widget.activeColor ?? MHColors.green) : MHColors.blueLight) : MHColors.greyDisabled),
        )
      ),
    );
  }
}



