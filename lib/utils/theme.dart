import 'package:flutter/material.dart';

class MHColors {
  static const blueLightSlide = Color(0xff6F748E);
  static const blueLight = Color(0xff29ABE2);
  static const blue = Color(0xff005CA9);
  static const grey = Color(0xff333333);
  static const greyLight = Color(0xff808080);
  static const greyDark = Color(0xff141414);
  static const greyBox = Color(0xff232537);
  static const greyDisabled = Color(0xffCECFD4);
  static const blueDark = Color(0xff131338);
  static const green = Color(0xff00FF00);
  static const white = Color(0xffFFFFFF);
  static const red = Color(0xffFF0000);
  static const blackFonts = Colors.black87;
  static const black = Colors.black;

  static const modalBackground = Color(0xFFF2F2F2);
}

class MHTextStyles {
  static const h = TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontSize: 35.0
  );

  static const big = TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontSize: 28.0
  );

  static const h1 = TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontSize: 24.0
  );

  static TextStyle h1Bold = h1.copyWith(fontWeight: FontWeight.bold);

  static const h2 = TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontSize: 15.0
  );

  static const button = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 24.0
  );

  static const adjustmentTitle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30.0
  );

  static const adjustmentRow = TextStyle(
    color: Colors.white,
    fontSize: 22.0
  );
}

class MHIcons {
  // icons
  static const String _icons = "assets/icons";
  static const String _buttons = "assets/buttons";

  static const String lightning = "$_icons/lightning.svg";
  static const String engine = "$_icons/engine.svg";
  static const String music = "$_icons/music.svg";
  static const String home = "$_icons/home.svg";
  static const String bulb = "$_icons/bulb.svg";
  static const String sliders = "$_icons/sliders.svg";
  static const String thermometer = "$_icons/thermometer.svg";
  static const String sliderBulb = "$_icons/slider_bulb.svg";
  static const String alert = "$_icons/alert.svg";
  static const String lock = "$_icons/lock.svg";
  static const String unlock = "$_icons/unlock.svg";
  static const String flash = "$_icons/flash.svg";
  static const String ac = "$_icons/ac.svg";
  static const String dc = "$_icons/dc.svg";
  static const String leaf = "$_icons/leaf.svg";
  static const String volume = "$_icons/volume.svg";
  static const String moon = "$_icons/moon.svg";
  static const String sun = "$_icons/sun.svg";
  static const String acCold = "$_icons/accold.svg";
  static const String acHeat = "$_icons/acheat.svg";
  static const String heaterStatic = "$_icons/heaterstatic.svg";
  static const String heaterWind = "$_icons/heaterwind.svg";
  static const String bedroom = "$_icons/bedroom.svg";
  static const String dinningRoom = "$_icons/dinningroom.svg";
  static const String radio = "$_icons/radio.svg";
  static const String tv = "$_icons/tv.svg";
  static const String auxiliary = "$_icons/auxiliary.svg";
  
  static const String icon1 = "$_icons/1.svg";
  static const String icon2 = "$_icons/2.svg";
  static const String icon3 = "$_icons/3.svg";
  static const String icon4 = "$_icons/4.svg";
  static const String leveler = "$_icons/leveler.svg";
  static const String levelerEye = "$_icons/leveler_eye.svg";
  static const String levelerEyePin = "$_icons/leveler_eye_pin.svg";
  
  // Buttons
  static const String pick = "$_buttons/pick.svg";
  static const String gear = "$_buttons/gear.svg";
  static const String m = "$_buttons/m.svg";
  static const String a = "$_buttons/a.svg";
  static const String arrowDown = "$_buttons/arrow_down.svg";
  static const String arrowUp = "$_buttons/arrow_up.svg";
  static const String arrowRight = "$_buttons/arrow_right.svg";
  static const String arrowLeft = "$_buttons/arrow_left.svg";
  static const String checkOutline = "$_buttons/check_outline.svg";
  static const String checkFilled = "$_buttons/check_filled.svg";
}

class MHAnimations {
  static const String _baseAnimated = "assets/animated";

  static const String slider = "$_baseAnimated/slider.json";
  static const String table = "$_baseAnimated/table.json";
  static const String awning = "$_baseAnimated/awning.json";
}
