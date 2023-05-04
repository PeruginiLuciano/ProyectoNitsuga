import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

enum DimmerDirection { vertical, horizontal }
typedef ChangeCallback = void Function(double newValue, double oldValue);
typedef StartCallback = void Function(double value);
typedef FinishCallback = void Function(double value);
typedef ChildBuilder = Widget Function(BuildContext context, double value);

class Dimmer extends StatefulWidget {
  /// Initial value of slider  1.0 <= value >= 0.0
  final double initialValue;

  /// Change callback
  final ChangeCallback? onChange;

  /// End of changes callback
  final StartCallback? onStart;
  final FinishCallback? onFinish;
  final DimmerDirection direction;
  final double height;
  final double width;
  final Color color;
  final Color fillColor;
  final ChildBuilder? childBuilder;
  final Widget? child;
  double currentValue;

  Dimmer({
    Key? key,
    this.initialValue = 1.0,
    this.onChange,
    this.onStart,
    this.onFinish,
    this.direction = DimmerDirection.vertical,
    this.color = MHColors.blueLightSlide,
    this.fillColor = MHColors.blueLight,
    this.child,
    this.childBuilder,
    this.width = 80,
    this.height = 200,
    this.currentValue = 0
  }) : super(key: key);

  @override
  State<Dimmer> createState() => _DimmerState();
}

class _DimmerState extends State<Dimmer> {

  @override
  void initState() {
    widget.currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return widget.direction == DimmerDirection.vertical ? _buildVertical() : _buildHorizontal();
  }

  void _updateValue(double position) {
    var size = getMainAxisSize();
    setState(() {
      if (position < 0) {
          widget.currentValue = 0;
      }
      else if (position > size) {
        widget.currentValue = 1;
      }
      else {
        double newValue = position / size;
        widget.currentValue = newValue;
        widget.onChange?.call(newValue, widget.currentValue);
      }
    });
  }

  double getMainAxisSize() {
    return widget.direction == DimmerDirection.horizontal ? widget.width : widget.height;
  }

  Widget _buildHorizontal() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _updateValue(details.localPosition.dx);
      },
      onHorizontalDragEnd: (details) {
        widget.onFinish?.call(widget.currentValue);
      },
      onTapUp: (details) {
        _updateValue(details.localPosition.dx);
        widget.onFinish?.call(widget.currentValue);
      },
      onTapDown: (details) {
        widget.onStart?.call(widget.currentValue);
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  widget.fillColor,
                  widget.color
                ],
                stops: [
                  widget.currentValue,
                  0,
                ]),
            borderRadius: BorderRadiusDirectional.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(left:10)),
            widget.child == null ? Container() : widget.child!,
            widget.childBuilder == null
                ? Container()
                : widget.childBuilder!(context, widget.currentValue),
          ],
        ),
      ),
    );
  }

  Widget _buildVertical() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        _updateValue(details.localPosition.dy);
      },
      onVerticalDragEnd: (details) {
        widget.onFinish?.call(widget.currentValue);
      },
      onTapUp: (details) {
        _updateValue(details.localPosition.dy);
        widget.onFinish?.call(widget.currentValue);
      },
      onTapDown: (details) {
        widget.onStart?.call(widget.currentValue);
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.color,
                  widget.fillColor
                ],
                stops: [
                  1 - widget.currentValue,
                  0,
                ]),
            borderRadius: BorderRadiusDirectional.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.child == null ? Container() : widget.child!,
            widget.childBuilder == null
                ? Container()
                : widget.childBuilder!(context, widget.currentValue),
            const Padding(padding: EdgeInsets.only(bottom: 12))
          ],
        ),
      ),
    );
  }
}
