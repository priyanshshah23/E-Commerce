import 'dart:convert';
import 'dart:math';

import 'package:diamnow/app/Helper/EncryptionHelper.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diamnow/app/app.export.dart';

import 'package:unique_identifier/unique_identifier.dart';

import 'BaseDialog.dart';
import 'CustomDialog.dart';

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

  String get keyUser => "keyUser";

  String get keyUserPermission => "keyUserPermission";

  String get keyIsUserLogin => "keyIsUserLogin";

  String get keyToken => "keyToken";

  String get skipUpdate => 'skipUpdate';

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

  void saveSkipUpdate(bool val) {
    _preferences.setBool(skipUpdate, val);
  }

  bool getSkipUpdate() {
    return getBool(skipUpdate);
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

// User Getter setter
  Future<void> saveUser(User user) async {
    await _preferences.setBool(keyIsUserLogin, true);
    _preferences.setString(keyUser, json.encode(user));
  }

  User getUserDetails() {
    var userJson = json.decode(_preferences.getString(keyUser));
    return userJson != null ? new User.fromJson(userJson) : null;
  }

  Future<void> saveUserPermission(UserPermissions user) async {
    _preferences.setString(keyUserPermission, json.encode(user));
  }

  UserPermissions getUserPermission() {
    var userPermissionsJson =
        json.decode(_preferences.getString(keyUserPermission));
    return userPermissionsJson != null
        ? new UserPermissions.fromJson(userPermissionsJson)
        : null;
  }

  UserPermissionsData getModulePermission(String module) {
    UserPermissions permissions = getUserPermission();
    UserPermissionsData data;
    if (permissions != null &&
        permissions.data != null &&
        permissions.data.length > 0) {
      permissions.data.forEach((element) {
        if (element.module == module) {
          element.view = element.permissions?.view ?? false;
          element.insert = element.permissions?.insert ?? false;
          element.update = element.permissions?.update ?? false;
          element.delete = element.permissions?.delete ?? false;
          element.downloadExcel = element.permissions?.downloadExcel ?? false;
          if (permissions != null && (element.permissions?.all ?? false)) {
            element.view = true;
            element.insert = true;
            element.update = true;
            element.delete = true;
            element.downloadExcel = true;
          }
          data = element;
        }
      });
    }

    if (module == "order") {
      print(module);
    }
    if (data == null) {
      if (true) {
        data = UserPermissionsData(module: module);
        data.view = false;
        data.insert = false;
        data.update = false;
        data.delete = false;
        data.downloadExcel = false;
      }
    }
    return data;
  }

  bool isUserLogin() {
    return !isStringEmpty(getUserToken());
  }

  String getUserToken() {
    String str = getString(keyToken);
    if (!isStringEmpty(str)) {
      String token = EncryptionHelper.decryptString(getString(keyToken));
      return token;
    } else {
      return null;
    }
  }

  Future<void> saveUserToken(String token) async {
    await _preferences.setString(
        keyToken, EncryptionHelper.encryptString(token));
  }

  resetAndLogout(BuildContext context) {
    bool rememberMe = app.resolve<PrefUtils>().getBool("rememberMe");
    String userName = app.resolve<PrefUtils>().getString("userName");
    String passWord = app.resolve<PrefUtils>().getString("passWord");

    app.resolve<PrefUtils>().clearPreferenceAndDB();

    app.resolve<PrefUtils>().saveBoolean("rememberMe", rememberMe);
    app.resolve<PrefUtils>().saveString("userName", userName);
    app.resolve<PrefUtils>().saveString("passWord", passWord);

    Navigator.of(context).pushNamed(LoginScreen.route);
  }

  Future<void> clearPreferenceAndDB() async {
    _preferences.clear();
    await AppDatabase.instance.masterDao.deleteAllMasterItems();
    await AppDatabase.instance.sizeMasterDao.deleteAllMasterItems();
  }
}

logoutFromApp(BuildContext context) {
  app.resolve<CustomDialogs>().confirmDialog(context,
      title: R.string().commonString.lbllogout,
      desc: R.string().authStrings.logoutConfirmationMsg,
      positiveBtnTitle: R.string().commonString.yes,
      negativeBtnTitle: R.string().commonString.no,
      onClickCallback: (buttonType) {
    if (buttonType == ButtonType.PositveButtonClick) {
      callLogout(context);
    }
  });
}

callLogout(BuildContext context) {
  NetworkCall<BaseApiResp>()
      .makeCall(
          () => app.resolve<ServiceModule>().networkService().logout(), context,
          isProgress: true)
      .then((response) {
    app.resolve<PrefUtils>().resetAndLogout(context);
  }).catchError((onError) {
    if (onError is ErrorResp) {
      app.resolve<PrefUtils>().resetAndLogout(context);
    }
  });
}
