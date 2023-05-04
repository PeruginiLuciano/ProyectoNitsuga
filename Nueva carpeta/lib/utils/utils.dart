import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

double screenHeight = Get.height;
double screenWidth = Get.width;
double aspectRatio = Get.mediaQuery.devicePixelRatio;
Locale? currentLocale = Get.locale;
double safePadding = Get.mediaQuery.padding.top;
double headerHeight = 56.0;
List masterPattern = [6, 3, 0, 1, 2, 5, 4];

closeKeyboard() => FocusManager.instance.primaryFocus!.unfocus();

Widget svgIcon(String asset, {double size = 30, Color? color}) => 
  SvgPicture.asset(asset, width: size, height: size, color: color);

Future delay(int milliseconds) async => Future.delayed(Duration(milliseconds: milliseconds));
