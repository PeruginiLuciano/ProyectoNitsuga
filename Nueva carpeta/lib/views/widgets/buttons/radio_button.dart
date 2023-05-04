import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class RadioButton extends StatefulWidget {
  final Color color;
  final Function() onTapDown;
  final Function() onTapUp;
  final bool active;
  final bool enabled;

  const RadioButton({
    Key? key,
    required this.color,
    required this.onTapDown,
    required this.onTapUp,
    this.active = false,
    this.enabled = true
  }) : super(key: key);

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_){
        setState(() { tapped = true; });
        widget.onTapDown();
      },
      onTapUp: (_){
        setState(() { tapped = false; });
        widget.onTapUp();
      },
      child: Container(
        width: 90,
        height: 90,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.enabled ? (widget.active || tapped ? MHColors.green : MHColors.blueLight) : MHColors.greyDisabled,
            width: 3
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50.0))
        ),
        child: Container(
          margin: EdgeInsets.all(tapped ? 10 : 5),
          decoration: BoxDecoration(
            color: widget.enabled ? widget.color : MHColors.greyDisabled,
            borderRadius: const BorderRadius.all(Radius.circular(50.0))
          ),
        )
      ),
    );
  }
}
