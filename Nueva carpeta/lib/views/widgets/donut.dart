import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Donut extends StatelessWidget {
  final String? title;
  final Widget? center;
  final double percent;
  final Color color;
  final double? size;

  const Donut({
    Key? key,
    this.title,
    this.center,
    required this.percent,
    required this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      footer: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: (title != null)
        ?
          Text(title!, style: MHTextStyles.h2)
        :
          Container()
      ),
      radius: size ?? 40,
      lineWidth: size == null ? 8.0 : size! / 6,
      percent: percent / 100,
      backgroundColor: MHColors.grey,
      animation: true,
      animateFromLastPercent: true,
      progressColor: color,
      center: (center == null)
      ?
        Text("${percent.toStringAsFixed(0)}%", style: MHTextStyles.h1)
      :
        center
    );
  }
}
