import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class AdjustMenuButton extends StatelessWidget {
  final String title;
  final bool active;
  final Function() onTap;

  const AdjustMenuButton({
    Key? key,
    required this.title,
    required this.active,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: active ? MHColors.blue : MHColors.greyLight
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: MHTextStyles.h2.copyWith(
            color: MHColors.greyDark,
            fontSize: 22
          )
        )
      ),
    );
  }
}
