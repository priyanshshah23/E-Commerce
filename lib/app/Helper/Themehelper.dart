import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static StreamController<String> controller = StreamController<String>();

  static BaseTheme theme() => _getDefaultTheme();

  static String _appTheme;

  static Stream<String> appthemeString = controller.stream;

  static Map<String, BaseTheme> _supportedThemes = {
    "white": BaseTheme(),
    "dark": DarkTheme(),
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

class DarkTheme extends BaseTheme {
  @override
  Color get colorPrimary => Colors.pink;
}

class BaseTheme {
  Color get colorPrimary => fromHex("#6E8FE7");
  Color get headerBgColor => fromHex("#6E8FE7");
  Color get textColor => fromHex("#262626");
  Color get bgColor => fromHex("#6E8FE7");
  Color get dividerColor => fromHex("#E3E3E3");
  Color get textBlackColor => Colors.black;
  Color get whiteColor => Colors.white;
  Color get textGreyColor => fromHex("#C7C7C7");
  Color get buttonColor => fromHex("#6E8FE7");
  Color get darkBlue => fromHex("#003365");
  Color get errorColor => fromHex("#FF4D4D");
  Color get segmentSelectedColor => Colors.white;
  Color get borderColor => fromHex("#e3e3e3");
  Color get selectedFilterColor => fromHex("#eaeffb");
  Color get unSelectedBgColor => fromHex("#f7f7f7");
  Color get greenColor => fromHex("#0EAC33");
  Color get lightBGColor => fromHex("#F8F8F8");
  Color get textFieldBorderColor => fromHex("#F5F5F5");
  Color get statusHold => fromHex("#DB1C1C");
  Color get statusOnMemo => fromHex("#307BEA");
  Color get statusAvailable => fromHex("#6BC950");
  Color get statusNew => fromHex("#B256E6");
  Color get statusOffer => fromHex("#FF4DB8");
  Color get statusMyHold => fromHex("#F1951E");
  Color get textGray => fromHex("#7B7E84");
  Color get drawerTitleColor => fromHex("#EEF1FC");
  Color get lightColorPrimary => fromHex("#EEF1FC");

  Color get shadowColorWithoutOpacity => fromHex("#7D9EF6").withOpacity(0.1);
  Color get shadowColor => shadowColorWithoutOpacity.withOpacity(0.1);
  // Color get shadowColor => fromHex("#7D9EF61A");

  TextStyle get black24TitleColor {
    return TextStyle(
        fontSize: getFontSize(24),
        fontWeight: FontWeight.bold,
        color: textColor);
  }

  TextStyle get black24TitleColorWhite {
    return TextStyle(
        fontSize: getFontSize(24),
        fontWeight: FontWeight.bold,
        color: whiteColor);
  }

  TextStyle get blackNormal14TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(14),
        fontWeight: FontWeight.normal,
        color: textColor);
  }

  TextStyle get blackNormal12TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(12),
        fontWeight: FontWeight.normal,
        color: textColor);
  }

  TextStyle get primaryNormal12TitleColor {
    return TextStyle(
        fontSize: getFontSize(12),
        fontWeight: FontWeight.normal,
        color: colorPrimary);
  }

  TextStyle get blackNormal16TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(16),
        fontWeight: FontWeight.normal,
        color: textColor);
  }

  TextStyle get blackNormal18TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(18),
        fontWeight: FontWeight.normal,
        color: textColor);
  }

  TextStyle get blackMedium16TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(16),
        fontWeight: FontWeight.w400,
        color: textColor);
  }

  TextStyle get blackNormal18TitleColorPrimary {
    return TextStyle(
        fontSize: getFontSize(18),
        fontWeight: FontWeight.normal,
        color: colorPrimary);
  }

  TextStyle get blackSemiBold18TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(18),
        fontWeight: FontWeight.w500,
        color: textColor);
  }

  TextStyle get blackMedium20TitleColorblack {
    return TextStyle(
        fontSize: getFontSize(20),
        fontWeight: FontWeight.w500,
        color: textColor);
  }

  TextStyle get grey14HintTextStyle {
    return TextStyle(
      fontSize: getFontSize(14),
      color: textGreyColor,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get grey12HintTextStyle {
    return TextStyle(
      fontSize: getFontSize(12),
      color: textGreyColor,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle get black16TextStyle {
    return TextStyle(
        fontSize: getFontSize(16),
        color: textColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get blue16TextStyle {
    return TextStyle(
        fontSize: getFontSize(16),
        color: colorPrimary,
        fontWeight: FontWeight.w500);
  }

  TextStyle get black18TextStyle {
    return TextStyle(
        fontSize: getFontSize(18),
        color: textColor,
        fontWeight: FontWeight.w500);
  }

  TextStyle get primary16TextStyle {
    return TextStyle(
        fontSize: getFontSize(16),
        color: colorPrimary,
        fontWeight: FontWeight.normal);
  }

  TextStyle get black12TextStyle {
    return TextStyle(
        fontSize: getFontSize(12),
        color: textColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get error12TextStyle {
    return TextStyle(
        fontSize: getFontSize(12),
        color: errorColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get black12TextStyleBold {
    return TextStyle(
        fontSize: getFontSize(12),
        color: textColor,
        fontWeight: FontWeight.bold);
  }

  TextStyle get grey12TextStyle {
    return TextStyle(
        fontSize: getFontSize(12),
        color: textGreyColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get white16TextStyle {
    return TextStyle(
        fontSize: getFontSize(16),
        color: whiteColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get black14TextStyle {
    return TextStyle(
        fontSize: getFontSize(14),
        color: textColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get grey16HintTextStyle {
    return TextStyle(
      fontSize: getFontSize(16),
      color: textGreyColor,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get greySemibold18TitleColor {
    return TextStyle(
      fontSize: getFontSize(18),
      color: textGreyColor,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get darkBlue16TextStyle {
    return TextStyle(
        fontSize: getFontSize(16),
        color: darkBlue,
        fontWeight: FontWeight.w500);
  }

  TextStyle get primaryColor14TextStyle {
    return TextStyle(
        fontSize: getFontSize(14),
        color: colorPrimary,
        fontWeight: FontWeight.w500);
  }

  TextStyle get commonAlertDialogueTitleStyle {
    return TextStyle(
        fontSize: getFontSize(18),
        color: textColor,
        fontWeight: FontWeight.w500);
  }

  TextStyle get commonAlertDialogueDescStyle {
    return TextStyle(
        fontSize: getFontSize(16),
        color: textColor,
        fontWeight: FontWeight.w400);
  }

  TextStyle get error16TextStyle {
    return TextStyle(
        fontSize: getFontSize(14),
        color: errorColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle get blue14TextStyle {
    return TextStyle(
        fontSize: getFontSize(14),
        color: colorPrimary,
        fontWeight: FontWeight.normal);
  }

  TextStyle get blue12TextStyle {
    return TextStyle(
        fontSize: getFontSize(12),
        color: colorPrimary,
        fontWeight: FontWeight.normal);
  }

  TextStyle get blue10TextStyle {
    return TextStyle(
        fontSize: getFontSize(10),
        color: colorPrimary,
        fontWeight: FontWeight.normal);
  }

  TextStyle get blue20TextStyle {
    return TextStyle(
        fontSize: getFontSize(20),
        color: colorPrimary,
        fontWeight: FontWeight.w600);
  }

  TextStyle get green10TextStyle {
    return TextStyle(
        fontSize: getFontSize(12),
        color: greenColor,
        fontWeight: FontWeight.normal);
  }

  TextStyle getTabbarTextStyle({Color textColor}) {
    return TextStyle(
        fontSize: getFontSize(10),
        color: textColor ?? whiteColor,
        fontWeight: FontWeight.normal);
  }
}

BaseTheme get appTheme => ThemeHelper.theme();
