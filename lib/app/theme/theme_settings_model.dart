import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:diamnow/app/app.export.dart';

/// The [ThemeSettingsModel] sits above the [MaterialApp] and rebuilds the
/// app whenever the [Theme] changes.
class ThemeSettingsModel extends ChangeNotifier {
  final PrefUtils appPrefs = app.resolve<PrefUtils>();

  static ThemeSettingsModel of(BuildContext context) {
    return Provider.of<ThemeSettingsModel>(context);
  }

  static final Logger _log = Logger("ThemeSettingsModel");

  /// The selected theme used by the app.
  AppTheme appTheme = PredefinedThemes.themes.first;

  List<AppThemeData> customThemes = [];

  /// The id of the selected theme.
  int get selectedThemeId => appPrefs.getInt(appPrefs.keySelectedThemeId);

  AppThemeData getDataFromId(int id) {
    return PredefinedThemes.data.followedBy(customThemes).elementAt(id);
  }

  /// Changes the selected theme and rebuilds the app which listens to this
  /// [ThemeSettingsModel].
  Future<void> changeSelectedTheme(AppTheme theme, int id) async {
    _log.fine("changing selected theme to id: $id");

    appTheme = theme;
    updateSystemUi();

    appPrefs.saveInt(appPrefs.keySelectedThemeId, id);
    notifyListeners();
  }

  /// Updates the color of the navigation bar.
  void updateSystemUi({bool isLogin = true}) {
    //(ColorConstants.textGray);
    if (isLogin) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: ColorConstants.black,
          statusBarColor: ColorConstants.introgrey));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: ColorConstants.black,
          statusBarColor: darken(appTheme.accentColor, 0.2)));
    }
  }

  /// Loads all custom themes from the shared preferences and saves them in
  /// [customThemes].
  void loadCustomThemes() {
    _log.fine("loading custom themes");
    customThemes = _getCustomThemes();
    _log.fine("found ${customThemes.length} themes");
  }

  /// Adds a new custom theme into the [customThemes] and changes the selected
  /// theme to it.
  void saveNewCustomTheme(AppThemeData themeData) {
    _log.fine("saving new custom theme");
    customThemes.add(themeData);
    _saveCustomThemes();

    int id = customThemes.indexOf(themeData);
    id += PredefinedThemes.themes.length;

    changeSelectedTheme(AppTheme.fromData(themeData), id);

    notifyListeners();
  }

  /// Updates an existing custom theme with the [id].
  void updateCustomTheme(AppThemeData themeData, int id) {
    _log.fine("updating custom theme ${themeData.name} with id: $id");

    // subtract the length of predefined themes
    id -= PredefinedThemes.themes.length;

    if (id >= 0 && id < customThemes.length) {
      customThemes[id] = themeData;
      _saveCustomThemes();
      initTheme();
      notifyListeners();
    } else {
      _log.severe("unable to update custom theme, not in list");
    }
  }

  void deleteCustomTheme(int id) {
    _log.fine("deleting custom theme with id: $id");

    try {
      customThemes.removeAt(id);
      _saveCustomThemes();
      notifyListeners();
    } catch (e) {
      _log.severe("unable to delete theme at id: $id", e);
    }
  }

  /// Initializes the [HarpyTheme] with the theme set in [HarpyPrefs].
  ///
  /// Defaults to the first theme set in [PredefinedThemes].
  void initTheme() {
    final int id = selectedThemeId;

    _log.fine("initializing harpy theme with id $id");

    final predefinedThemes = PredefinedThemes.themes;

    if (id < predefinedThemes.length) {
      appTheme = predefinedThemes[id];
    } else {
      // load data from custom theme
      final AppThemeData customThemeData = _getCustomTheme(id);

      if (customThemeData != null) {
        appTheme = AppTheme.fromData(customThemeData);
      } else {
        _log.warning("unable to load custom theme for id: $id");
        appTheme = predefinedThemes.first;
      }
    }

    updateSystemUi();

    notifyListeners();
  }

  /// Resets the [appTheme] to the default theme.
  void resetHarpyTheme() {
    appTheme = PredefinedThemes.themes.first;
    updateSystemUi();
    notifyListeners();
  }

  /// Returns the [HarpyThemeData] for the [id] of the custom themes list.
  ///
  /// Returns `null` if the id is not in the list.
  AppThemeData _getCustomTheme(int id) {
    _log.fine("getting custom harpy theme for id: $id");

    try {
      // subtract the length of predefined themes
      id -= PredefinedThemes.themes.length;

      return _getCustomThemes()[id];
    } catch (e) {
      return null;
    }
  }

  /// Returns the list of all saved custom [HarpyThemeData].
  List<AppThemeData> _getCustomThemes() {
    _log.fine("getting custom themes");

    return appPrefs
            .getStringList("customThemes")
            ?.map(_decodeCustomTheme)
            ?.where((data) => data != null)
            ?.toList() ??
        [];
  }

  /// Saves the list of [customThemes] into the shared preferences.
  void _saveCustomThemes() {
    _log.fine("saving custom themes: $customThemes");

    appPrefs.saveStringList(
      "customThemes",
      customThemes.map((data) {
        return jsonEncode(data.toJson());
      }).toList(),
    );
  }

  /// Returns the [HarpyThemeData] from the [json] string or `null` if it can't
  /// be parsed.
  AppThemeData _decodeCustomTheme(String json) {
    try {
      // try to parse the custom theme
      return AppThemeData.fromJson(jsonDecode(json));
    } catch (e) {
      _log.warning("unable to parse theme: $json");
      return null;
    }
  }
}
