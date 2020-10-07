import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConstants {
  static Color colorPrimary = fromHex("#2D0DB2");
  static Color lightPrimary = fromHex("#ADEFEF");
  static Color textGray = fromHex("#7B7E84");
  static Color borderColor = fromHex("#F2F2F2");
  static Color placeholderColor = fromHex("#7B7E84");
  static Color bgColor = fromHex("#F2F5F7");
  static Color introgrey = fromHex("#999999");
  static Color black = fromHex("#000000");

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

class ThemeHelper {
  static StreamController<String> controller = StreamController<String>();

  static BaseTheme theme() => _getDefaultTheme();

  static String _appTheme;

  static Stream<String> appthemeString = controller.stream;

  static Map<String, BaseTheme> _supportedThemes = {
    "light": LightTheme(),
    "dark": DarkTheme(),
    "orange": OrangeTheme()
  };

  static BaseTheme _getDefaultTheme() {
    //return default strings if locale is not set

    if (_appTheme == null) return BaseTheme();

    //throw exception to notify given local is not found or not generated by the generator

    if (!_supportedThemes.containsKey(_appTheme))
      throw Exception(
          "$_appTheme is not found.\n Make sure you have added this locale in JSON file\n Try running flutter pub run build_runner");

    //return locale from map

    return _supportedThemes[_appTheme];
  }

  static void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
    controller.add(_newTheme);
  }
}

class BaseTheme {
  Color get colorPrimary => Colors.blue;
  Color get textColor => Colors.blue;
  Color get bgColor => Colors.blue;
  Color get dividerColor => Colors.grey[100];

  TextStyle get titleText {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, color: textColor);
  }
}

class LightTheme extends BaseTheme {
  @override
  Color get colorPrimary => Colors.black;

  @override
  Color get textColor => Colors.white;
  @override
  Color get bgColor => Colors.black;

  @override
  TextStyle get titleText =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: textColor);
}

class DarkTheme extends BaseTheme {
  @override
  Color get colorPrimary => Colors.white;

  @override
  Color get textColor => Colors.black;

  @override
  Color get bgColor => Colors.white;
  @override
  TextStyle get titleText =>
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: textColor);
}

class OrangeTheme extends BaseTheme {
  @override
  Color get colorPrimary => Colors.orange;

  @override
  Color get textColor => Colors.blue;

  @override
  Color get bgColor => Colors.orange;

  @override
  TextStyle get titleText =>
      TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: textColor);
}

BaseTheme get colorConstants => ThemeHelper.theme();
