import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diamnow/app/app.export.dart';

import 'package:unique_identifier/unique_identifier.dart';

/// Wraps the [SharedPreferences].
class PrefUtils {
  static final Logger _log = Logger("Prefs");

  String deviceId;

  SharedPreferences _preferences;

  /// The [prefix] is used in keys for user specific preferences. You can use unique user-id for multi_user
  // String get prefix => "my_app";
  String get keySelectedThemeId => "my_app_SelectedThemeId";

  String get keyPlayerID => "playerId";

  String get keyIsShowThemeSelection => "keyIsShowThemeSelection";

  String get FILE_DEVIDE_INFO => "deviceDetail";

  String get keyMasterSyncDate => "keyMasterSyncDate";

  bool isHomeVisible;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Gets the int value for the [key] if it exists.
  int getInt(String key, {int defaultValue = 0}) {
    try {
      init();
      return _preferences.getInt(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the bool value for the [key] if it exists.
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      init();
      return _preferences.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the String value for the [key] if it exists.
  String getString(String key, {String defaultValue = ""}) {
    try {
      init();
      return _preferences.getString(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  List<String> getStringList(String key) {
    try {
      init();
      return _preferences.getStringList(key) ?? <String>[];
    } catch (e) {
      return <String>[];
    }
  }

  /// Gets the int value for the [key] if it exists.
  void saveInt(String key, int value) {
    init();
    _preferences.setInt(key, value);
  }

  Future<void> saveDeviceId() async {
    try {
      deviceId = await UniqueIdentifier.serial;
    } catch (e) {}
  }

  /// Gets the int value for the [key] if it exists.
  void saveBoolean(String key, bool value) {
    init();
    _preferences.setBool(key, value);
  }

  /// Gets the int value for the [key] if it exists.
  void saveString(String key, String value) {
    init();
    _preferences.setString(key, value);
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  void saveStringList(String key, List<String> value) {
    init();
    _preferences.setStringList(key, value);
  }

  void saveShowThemeSelection(bool showThemeSelection) {
    _preferences.setBool(keyIsShowThemeSelection, showThemeSelection);
  }

  String getMasterSyncDate() {
    if (isStringEmpty(getString(keyMasterSyncDate)) == false) {
      return getString(keyMasterSyncDate);
    } else {
      return "1970-01-01T00:00:00+00:00";
    }
  }

  void saveMasterSyncDate(String masterSyncDate) {
    _preferences.setString(keyMasterSyncDate, masterSyncDate);
  }
}
