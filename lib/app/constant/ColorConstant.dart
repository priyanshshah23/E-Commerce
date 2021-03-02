import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConstants {
  static Color colorPrimary = fromHex("#4EB45E");
  static Color lightPrimary = fromHex("#ADEFEF");
  static Color textGray = fromHex("#7B7E84");
  
  static Color borderColor = fromHex("#DDDDDD");
  static Color placeholderColor = fromHex("#999999");
  static Color bgColor = fromHex("#F2F5F7");
  static Color introgrey = fromHex("#999999");
  static Color black = fromHex("#000000");
  static Color white = fromHex("#FFFFFF");
  static Color countryBgShadow = fromHex("#00000029");
  static Color otpSuccessFillColor = fromHex("#0EAC33");
  static Color otpSuccessBorderColor = fromHex("#0EAC33");
  static Color lightgrey = fromHex("#F6F6F6");
  static Color errorText = fromHex('#D60505');
  static Color compareChangesRowBgColor = fromHex("#F8F8F8");
  static Color backgroundColorForCancleButton = fromHex("#EEF1FC");

  static MaterialColor accentCustomColor =
      MaterialColor(0xFF2B0DB2, accentColor);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(255, 206, 15, .1),
  100: Color.fromRGBO(255, 206, 15, .2),
  200: Color.fromRGBO(255, 206, 15, .3),
  300: Color.fromRGBO(255, 206, 15, .4),
  400: Color.fromRGBO(255, 206, 15, .5),
  500: Color.fromRGBO(255, 206, 15, .6),
  600: Color.fromRGBO(255, 206, 15, .7),
  700: Color.fromRGBO(255, 206, 15, .8),
  800: Color.fromRGBO(255, 206, 15, .9),
  900: Color.fromRGBO(255, 206, 15, 1),
};

Map<int, Color> accentColor = {
  50: Color.fromRGBO(45, 13, 178, .1),
  100: Color.fromRGBO(45, 13, 178, .2),
  200: Color.fromRGBO(45, 13, 178, .3),
  300: Color.fromRGBO(45, 13, 178, .4),
  400: Color.fromRGBO(45, 13, 178, .5),
  500: Color.fromRGBO(45, 13, 178, .6),
  600: Color.fromRGBO(45, 13, 178, .7),
  700: Color.fromRGBO(45, 13, 178, .8),
  800: Color.fromRGBO(45, 13, 178, .9),
  900: Color.fromRGBO(45, 13, 178, 1),
};

MaterialColor colorCustom = MaterialColor(0xffffce0f, color);
