import 'package:flutter/material.dart';

import '../app.export.dart';

class AppTheme {
  AppTheme.fromData(AppThemeData data) {
    name = data.name ?? "";

    backgroundColors = data.backgroundColors?.map(_colorFromValue)?.toList();

    if (backgroundColors == null || backgroundColors.length < 2) {
      backgroundColors = [Colors.black, const Color(0xff17233d)];
    }

    accentColor = _colorFromValue(data.accentColor) ?? const Color(0xff2D0DB2);
  }

  /// Returns the currently selected [AppTheme].
  static AppTheme of(BuildContext context) {
    return ThemeSettingsModel.of(context).appTheme;
  }

  /// The name of the theme that is used in the [ThemeCard].
  String name;

  /// A list of colors that define the background gradient.
  /// The [AppBackground] uses these colors to build the background gradient.
  List<Color> backgroundColors;

  Color get primaryColor => backgroundColors.last;

  /// The accent color should compliment the background color.
  Color accentColor;

  /// Gets the brightness by averaging the relative luminance of each
  /// background color.
  /// Similar to [ThemeData.estimateBrightnessForColor] for multiple colors.
  Brightness get brightness {
    final double relativeLuminance = backgroundColors
            .map((color) => color.computeLuminance())
            .reduce((a, b) => a + b) /
        backgroundColors.length;

    const double kThreshold = 0.15;

    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) >
            kThreshold)
        ? Brightness.light
        : Brightness.dark;
  }

  bool get isDarkMode {
    return brightness == Brightness.dark;
  }

  /// The opposite of [brightness].
  Brightness get complimentaryBrightness =>
      brightness == Brightness.light ? Brightness.dark : Brightness.light;

  /// Returns the [primaryColor] if it is not the same brightness as the button
  /// color, otherwise a complimentary color (white / black).
  Color get buttonTextColor {
    final primaryColorBrightness =
        ThemeData.estimateBrightnessForColor(primaryColor);

    if (brightness == Brightness.dark) {
      // button color is light
      return primaryColorBrightness == Brightness.light
          ? Colors.black
          : primaryColor;
    } else {
      // button color is dark
      return primaryColorBrightness == Brightness.dark
          ? Colors.white
          : primaryColor;
    }
  }

  /// Either [Colors.black] or [Colors.white] depending on the background
  /// brightness.
  ///
  /// This is the color that the text that is written on the background should
  /// have.
  ///
  static Color titleTextColor = fromHex("#22242A");
  static Color bodyTextColor = fromHex("#999999");

  Color get backgroundComplimentaryColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  Color get backgroundOffComplimentaryColor =>
      brightness == Brightness.light ? Color(0xffF9F9F9) : Colors.grey[800];

  Color get successColor => Color(0xff52C07C);

  Color get errorColor => Color(0xffFE304C);

  TextTheme get _textTheme {
    const displayFont = "CerebriSans";

    return Typography.englishLike2018.apply(fontFamily: displayFont).copyWith(
          // title
          title: TextStyle(
            fontSize: getFontSize(46),
            fontFamily: displayFont,
            fontWeight: FontWeight.w600,
            color: titleTextColor,
          ),

          subtitle: TextStyle(
            fontSize: getFontSize(30),
            fontFamily: displayFont,
            fontWeight: FontWeight.w600,
            color: titleTextColor,
          ),
          subhead: TextStyle(
            fontSize: getFontSize(20),
            fontFamily: displayFont,
            fontWeight: FontWeight.w600,
            color: titleTextColor,
          ),

          // body
          body1: TextStyle(
            fontSize: getFontSize(20),
            fontWeight: FontWeight.w500,
            fontFamily: displayFont,
            color: bodyTextColor,
          ),

          body2: TextStyle(
            fontSize: getFontSize(18),
            fontFamily: displayFont,
            fontWeight: FontWeight.w500,
            color: bodyTextColor,
          ),

          button: TextStyle(
            fontSize: getFontSize(18),
            fontFamily: displayFont,
            fontWeight: FontWeight.w600,
            color: bodyTextColor,
          ),

          display1: TextStyle(
            fontSize: getFontSize(16),
            fontFamily: displayFont,
            fontWeight: FontWeight.w400,
            color: titleTextColor,
          ),
          display2: TextStyle(
            fontSize: getFontSize(14),
            fontFamily: displayFont,
            fontWeight: FontWeight.w400,
            color: bodyTextColor,
          ),
          display3: TextStyle(
            fontSize: getFontSize(12),
            fontFamily: displayFont,
            fontWeight: FontWeight.w400,
            color: titleTextColor,
          ),
          // display
          display4: TextStyle(
            fontSize: getFontSize(12),
            fontFamily: displayFont,
            fontWeight: FontWeight.w400,
            color: bodyTextColor,
          ),

        );
  }

  ThemeData get theme {
    final complimentaryColor = backgroundComplimentaryColor;

    return ThemeData(
      brightness: brightness,
      textTheme: _textTheme,
      primaryColor: primaryColor,
      accentColor: accentColor,
      buttonColor: complimentaryColor,
      primaryColorBrightness: brightness,
      cardColor: primaryColor,
      canvasColor: primaryColor,
      toggleableActiveColor: accentColor,
      textSelectionHandleColor: accentColor,
    );
  }

  Color _colorFromValue(int value) {
    return value != null ? Color(value) : null;
  }
}

/// The [PredefinedThemes] define [AppTheme]s that can be used as the theme
/// for the app.
///
/// These themes are able to be selected in the [SetupScreen] when a user logs
/// in for the first time and in the [ThemeSettingsScreen].
///
/// Unlike custom themes, the [PredefinedThemes] cannot be deleted.
class PredefinedThemes {
  static List<AppTheme> get themes {
    if (_themes.isEmpty) {
      _themes.addAll(data.map((themeData) => AppTheme.fromData(themeData)));
    }

    return _themes;
  }

  static final List<AppTheme> _themes = [];

  static List<AppThemeData> get data => [light];

  static AppThemeData get light {
    return AppThemeData()
      ..name = "light"
      ..backgroundColors = [Colors.white.value, Colors.white.value]
      ..accentColor = 0xff2D0DB2;
  }
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
