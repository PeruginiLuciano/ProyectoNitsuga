import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: MHColors.greyBox,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: child
    );
  }
}
