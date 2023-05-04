import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class ModalButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final bool filled;
  final Function() onTap;
  final double? width;

  const ModalButton({
    Key? key,
    required this.text,
    required this.enabled,
    required this.filled,
    required this.onTap,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: filled ? Colors.transparent : MHColors.blueDark,
            width: 3
          ),
          color: enabled
          ?
            (filled ? MHColors.blueDark : Colors.transparent)
          :
            (filled ? MHColors.greyDisabled : MHColors.blueDark),
          borderRadius: const BorderRadius.all(Radius.circular(50.0))
        ),
        child: Center(
          child: Text(
            text,
            style: MHTextStyles.h1.copyWith(
              fontSize: 22,
              color: filled
              ?
                Colors.white
              :
                MHColors.blueDark
            )
          )
        )
      ),
    );
  }
}