import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class AcSourceMarker extends StatelessWidget {
  final String title;
  final bool active;
  final AcSourceMarkerStyle style;

  const AcSourceMarker({
    Key? key,
    required this.title,
    required this.active,
    required this.style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: active ? MHColors.green : MHColors.blueLight,
          width: 3
        ),
        
        // color: Colors.white,
        borderRadius: corners()
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: MHTextStyles.h2.copyWith(
          fontSize: 16,
          color: active ? MHColors.green : MHColors.blueLight,
        )
      )
    );
  }

  BorderRadius corners(){
    switch(style){
      case AcSourceMarkerStyle.leftRounded:
        return const BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0)
        );
      case AcSourceMarkerStyle.rightRounded:
        return const BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0)
        );
      case AcSourceMarkerStyle.none:
        return const BorderRadius.all(Radius.circular(10.0));
    }
  }
}

enum AcSourceMarkerStyle {
  leftRounded,
  rightRounded,
  none
}