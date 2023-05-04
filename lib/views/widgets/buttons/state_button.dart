import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class StateButton extends StatefulWidget {
  final String title;
  final Function() onTap;
  final bool active;
  final Widget? icon;
  final double width;
  final bool enabled;

  const StateButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.active,
    this.icon,
    this.width = double.infinity,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<StateButton> createState() => _StateButtonState();
}

class _StateButtonState extends State<StateButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.enabled) {
          widget.onTap();
        }
      },
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: !widget.enabled ? MHColors.greyDisabled : widget.active ? MHColors.green : MHColors.blueLight,
            width: 3
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50.0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon == null
            ?
              Container()
            :
              Container(
                margin: const EdgeInsets.only(right: 25.0),
                child: widget.icon!
              ),

            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: MHTextStyles.h1.copyWith(
                fontSize: 30,
                color: !widget.enabled ? MHColors.greyDisabled : widget.active ? MHColors.green : MHColors.blueLight,
              )
            ),
          ],
        )
      ),
    );
  }
}
