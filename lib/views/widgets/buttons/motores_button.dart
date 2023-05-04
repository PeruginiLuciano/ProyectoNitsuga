import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class MotorsButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool active;
  final double marginBottom;

  const MotorsButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.active,
    this.marginBottom = 0.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
        margin: EdgeInsets.only(bottom: marginBottom),
        decoration: BoxDecoration(
          border: Border.all(
            color: active ? MHColors.green : MHColors.black,
            width: 3
          ),
          
          color: active ? MHColors.greyBox : MHColors.black,
          borderRadius: const BorderRadius.all(Radius.circular(22.0))
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: MHTextStyles.h1.copyWith(
            fontSize: 25,
            color: active ? MHColors.green : MHColors.white,
          )
        )
      ),
    );
  }
}
