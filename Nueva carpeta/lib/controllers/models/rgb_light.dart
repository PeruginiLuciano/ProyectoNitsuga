
import 'package:flutter/material.dart';

class RgbLight {
  var power = false;
  var red = 0;
  var green = 0;
  var blue = 0;

  RgbLight([this.power = false, this.red = 0, this.green = 0, this.blue = 0]);

  RgbLight copy({
    bool? power,
    int? red,
    int? green,
    int? blue
  }) => RgbLight(
    power ?? this.power,
    red ?? this.red,
    green ?? this.green,
    blue ?? this.blue
  );
  
  Color getColor() => Color.fromARGB(255, red, green, blue);

  void setColor(Color color) {
    red = color.red;
    green = color.green;
    blue = color.blue;
  }

  HSVColor getHSVColor() => HSVColor.fromColor(getColor());

  void setHSVColor(HSVColor hsvColor) => setColor(hsvColor.toColor());

  void dimmer(double value) {
    final hsvColor = getHSVColor();
    final newHsvColor = HSVColor.fromAHSV(hsvColor.alpha, hsvColor.hue, hsvColor.saturation, value);
    setColor(newHsvColor.toColor());
  }
}
