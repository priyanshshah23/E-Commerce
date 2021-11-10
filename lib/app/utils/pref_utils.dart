import 'dart:convert';

import 'package:diamnow/app/Helper/EncryptionHelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/NotificationRedirection.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/models/Dashboard/DashboardModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/ExclusiveModel/ExclusiveModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String get keyToSetBiometricenabled => "keyToSetBiometricenabled";

  String get keyToSetMpinenabled => "keyToSetMpinenabled";

  String get FILE_DEVIDE_INFO => "deviceDetail";

  String get keyMasterSyncDate => "keyMasterSyncDate";

  String get keyForLocalization => "keyGetLocalization";

  String get keyUser => "keyUser";
  //collection
  String get keyExclusiveCollection => "keyExclusiveCollection";


  String get keyCompany => "keyCompany";
  String get KeyLoc => "KeyLoc";

  String get keyUserPermission => "keyUserPermission";
  String get keyMasterPermission => "keyMasterPermission";

  String get keyIsUserLogin => "keyIsUserLogin";

  String get keyToken => "keyToken";

  String get skipUpdate => 'skipUpdate';

  String get keyUserNotification => "keyUserNotification";

  String get keySyncPlayerId => "keySyncPlayerId";

  String get keyLanguage => "keyLanguage";

  //Take A Tour
  String get keyHomeTour => "keyHomeTour";

  String get keyMyAccountTour => "keyMyAccountTour";

  String get keySearchTour => "keySearchTour";

  String get keySearchResultTour => "keySearchResultTour";

  String get keyDiamondDetailTour => "keyDiamondDetailTour";

  String get keyCompareStoneTour => "keyCompareStoneTour";

  String get keyOfferTour => "keyOfferTour";

  // Dashboard
  String get keyDashboard => "keyDashboard";

  //Store filter
  String get keyFilter => "keyFilter";

  bool isHomeVisible;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  void saveNotification(NotificationDetail user) async {
    _preferences.setString(keyUserNotification, json.encode(user));
  }

  clearNotification() {
    _preferences.setString(keyUserNotification, null);
  }

  setPlayerID(String value, String key) async {
    init();
    _preferences.setString(key, value);
  }

  String getPlayerId() {
    return getString(keyPlayerID);
  }

  void saveSyncPlayerId(bool val) {
    _preferences.setBool(keySyncPlayerId, val);
  }

  bool getSyncPlayerId() {
    return getBool(keySyncPlayerId);
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

  bool isDisplayedTour(String key) {
    return true;
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

  void setBiometrcisUsage(bool value) {
    _preferences.setBool(keyToSetBiometricenabled, value);
  }

  void setMpinisUsage(bool value) {
    _preferences.setBool(keyToSetMpinenabled, value);
  }

  void saveSkipUpdate(bool val) {
    _preferences.setBool(skipUpdate, val);
  }


  bool getSkipUpdate() {
    return getBool(skipUpdate);
  }

  bool getBiometrcis() {
    return getBool(keyToSetBiometricenabled);
  }

  bool getMpin() {
    return getBool(keyToSetMpinenabled);
  }

  String getMasterSyncDate() {
    if (isStringEmpty(getString(keyMasterSyncDate)) == false) {
      return getString(keyMasterSyncDate);
    } else {
      return "1970-01-01T00:00:00+00:00";
    }
  }

  setLocalization(String value) async {
    init();
    _preferences.setString(keyLanguage, value);
  }

  String getLocalization() {
    return getString(keyLanguage) ?? "";
  }

  void saveFilterOffline(Map<String, dynamic> dictFilter) {
    _preferences.setString(keyFilter, json.encode(dictFilter));
  }

  Map<String, dynamic> getFilterOffline() {
    var data = _preferences.getString(keyFilter);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

  void saveMasterSyncDate(String masterSyncDate) {
    _preferences.setString(keyMasterSyncDate, masterSyncDate);
  }

  Future<void> saveLocalization(String languageCode) async {
    await _preferences.setString(keyForLocalization, languageCode);
  }

  String getLocalizationLanguage() {
    String str = getString(keyForLocalization);
    if (!isNullEmptyOrFalse(str)) {
      return str;
    } else {
      return LocalizationConstant.ENGLISH;
    }
  }

  // Store Dashboard Data
  Future<void> saveDashboardDetails(DashboardModel dashboardModel) async {
    await _preferences.setString(
        keyDashboard, json.encode(dashboardModel.toJson()));
  }

  DashboardModel getDashboardDetails() {
    if (_preferences?.getString(keyCompany) != null) {
      var data = _preferences.getString(keyDashboard);
      if (data != null) {
        var dashboardJson = json.decode(data);
        return dashboardJson != null
            ? new DashboardModel.fromJson(dashboardJson)
            : null;
      }
    }
    return null;
  }

  Future<void> saveExclusiveCollectionDetails(
      ExclusiveCollectionModel exclusiveCollectionModel) async {
    await _preferences.setString(
        keyExclusiveCollection, json.encode(exclusiveCollectionModel.toJson()));
  }

  ExclusiveCollectionModel getExclusiveCollectionDetails() {
    if (_preferences.getString(keyExclusiveCollection) != null) {
      var data = _preferences.getString(keyExclusiveCollection);
      if (data != null) {
        var ExclusiveCollectionJson = json.decode(data);
        return ExclusiveCollectionJson != null
            ? new ExclusiveCollectionModel.fromJson(ExclusiveCollectionJson)
            : null;
      }
    }
    return null;
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

  Future<void> saveMaster(MastersResp user) async {
    await _preferences.setBool(keyIsUserLogin, true);
    _preferences.setString(keyMasterPermission, json.encode(user));
  }

  MastersResp getMasterDetails() {
    var userJson = json.decode(_preferences.getString(keyMasterPermission));
    return userJson != null ? new MastersResp.fromJson(userJson) : null;
  }

  isUserCustomer() {
    if (getUserDetails().type == UserConstant.CUSTOMER ||
        getUserDetails().type == UserConstant.PRIMARY ||
        getUserDetails().type == UserConstant.API_USER ||
        getUserDetails().type == UserConstant.SECONDARY) {
      return true;
    } else {
      return false;
    }
  }

  // Company detail Getter setter
  Future<void> saveCompany(SelectionPopupModel company) {
    _preferences.setString(keyCompany, json.encode(company));
  }

  SelectionPopupModel getCompanyDetails() {
    if (_preferences.getString(keyCompany) != null &&
        _preferences.getString(keyCompany).length > 0) {
      var companyJson = json.decode(_preferences.getString(keyCompany));
      return companyJson != null
          ? new SelectionPopupModel.fromJson(companyJson)
          : null;
    }
  }

  void saveLocData(List<String> dict) {
    _preferences.setString(KeyLoc, json.encode(dict));
    print(KeyLoc);
  }

  List<dynamic> getLoc() {
    var data = _preferences.getString(KeyLoc);
    if (data != null) {
      print(data);
      return json.decode(data);
    }
    return null;
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
        if (element.module == module.toUpperCase()) {
          element.view = element.permissions?.view ?? true;
          element.insert = element.permissions?.insert ?? true;
          element.update = element.permissions?.update ?? true;
          element.delete = element.permissions?.delete ?? true;
          element.downloadExcel = element.permissions?.downloadExcel ?? true;
          if (permissions != null && (element.permissions?.all ?? true)) {
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

    // if (module == ModulePermissionConstant.permission_searchDiamond ||
    //     module == ModulePermissionConstant.permission_quickSearch ||
    //     module == ModulePermissionConstant.permission_searchResult ||
    //     module == ModulePermissionConstant.permission_watchlist ||
    //     module == ModulePermissionConstant.permission_cart ||
    //     module == ModulePermissionConstant.permission_myDemand ) {
    //   data = UserPermissionsData(module: module);
    //   data.insert = true;
    //   data.view = true;
    //   data.update = true;
    //   data.delete = true;
    //   data.downloadExcel = true;
    // }else{
    //   data = UserPermissionsData(module: module);
    //   data.insert = false;
    //   data.view = false;
    //   data.update = false;
    //   data.delete = false;
    //   data.downloadExcel = false;
    // }
    /*  if (app.resolve<PrefUtils>().getUserDetails() == UserConstant.CUSTOMER &&
        (app.resolve<PrefUtils>().getUserDetails().account?.isApproved ??
                KYCStatus.pending) !=
            KYCStatus.approved) {*/
    // if (module == ModulePermissionConstant.permission_searchDiamond ||
    //     module == ModulePermissionConstant.permission_searchupcoming ||
    //     module == ModulePermissionConstant.permission_searchnewarrival ||
    //     module == ModulePermissionConstant.permission_searchResult ||
    //     module == ModulePermissionConstant.permission_dashboard ||
    //     module == ModulePermissionConstant.permission_matchPair ||
    //     module == ModulePermissionConstant.permission_layout ||
    //     module == ModulePermissionConstant.permission_quickSearch ||
    //     module == ModulePermissionConstant.permission_newGoods ||
    //     module == ModulePermissionConstant.permission_exclusive ||
    //     module == ModulePermissionConstant.permission_auction ||
    //     module == ModulePermissionConstant.permission_upcomingDiamonds ||
    //     module == ModulePermissionConstant.permission_myDemand ||
    //     module == ModulePermissionConstant.permission_mySavedSearch ||
    //     module == ModulePermissionConstant.permission_watchlist ||
    //     module == ModulePermissionConstant.permission_cart ||
    //     module == ModulePermissionConstant.permission_bid ||
    //     module == ModulePermissionConstant.permission_enquiry ||
    //     module == ModulePermissionConstant.permission_appointment ||
    //     module == ModulePermissionConstant.permission_offer ||
    //     module == ModulePermissionConstant.permission_order ||
    //     module == ModulePermissionConstant.permission_comment ||
    //     module == ModulePermissionConstant.permission_compare ||
    //     module == ModulePermissionConstant.permission_notification ||
    //     module == ModulePermissionConstant.permission_purchase ||
    //     module == ModulePermissionConstant.permission_download ||
    //     module == ModulePermissionConstant.permission_hideGridColumns ||
    //     module == ModulePermissionConstant.permission_searchLayout ||
    //     module == ModulePermissionConstant.permission_searchMatchPair) {
    //   data = UserPermissionsData(module: module);
    //   data.view = true;
    //   data.insert = true;
    //   data.update = true;
    //   data.delete = true;
    //   data.downloadExcel = true;
    // } else {
    //   data = UserPermissionsData(module: module);
    //   data.view = false;
    //   data.insert = false;
    //   data.update = false;
    //   data.delete = false;
    //   data.downloadExcel = false;
    // }
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
    String playerId = app.resolve<PrefUtils>().getPlayerId();
    bool rememberMe = app.resolve<PrefUtils>().getBool("rememberMe");
    String userName = app.resolve<PrefUtils>().getString("userName");
    String passWord = app.resolve<PrefUtils>().getString("passWord");
    bool homeTakeATour = app.resolve<PrefUtils>().getBool(keyHomeTour);
    bool myAccountTour = app.resolve<PrefUtils>().getBool(keyMyAccountTour);
    bool searchTour = app.resolve<PrefUtils>().getBool(keySearchTour);
    bool searchResultTour =
        app.resolve<PrefUtils>().getBool(keySearchResultTour);
    bool diamondDetailTour =
        app.resolve<PrefUtils>().getBool(keyDiamondDetailTour);
    bool compareStoneTour =
        app.resolve<PrefUtils>().getBool(keyCompareStoneTour);
    bool offerTour = app.resolve<PrefUtils>().getBool(keyOfferTour);
    String language = app.resolve<PrefUtils>().getLocalization();

    app.resolve<PrefUtils>().clearPreferenceAndDB();

    if (rememberMe) {
      app.resolve<PrefUtils>().saveBoolean("rememberMe", rememberMe);
      app.resolve<PrefUtils>().saveString("userName", userName);
      app.resolve<PrefUtils>().saveString("passWord", passWord);
    }

    app.resolve<PrefUtils>().saveBoolean(keyHomeTour, homeTakeATour);
    app.resolve<PrefUtils>().saveBoolean(keyMyAccountTour, myAccountTour);
    app.resolve<PrefUtils>().saveBoolean(keySearchTour, searchTour);
    app.resolve<PrefUtils>().saveBoolean(keySearchResultTour, searchResultTour);
    app
        .resolve<PrefUtils>()
        .saveBoolean(keyDiamondDetailTour, diamondDetailTour);
    app.resolve<PrefUtils>().saveBoolean(keyCompareStoneTour, compareStoneTour);
    app.resolve<PrefUtils>().saveString(keyLanguage, language);
    app.resolve<PrefUtils>().saveBoolean(keyOfferTour, offerTour);
    app
        .resolve<PrefUtils>()
        .setPlayerID(playerId, app.resolve<PrefUtils>().keyPlayerID);
    Navigator.of(context).pushNamed(LoginScreen.route);
  }

  Future<void> clearPreferenceAndDB() async {
    _preferences.clear();
    await AppDatabase.instance.masterDao.deleteAllMasterItems();
    await AppDatabase.instance.sizeMasterDao.deleteAllMasterItems();
    await AppDatabase.instance.diamondDao.deleteAlldiamondModelItems();
    await AppDatabase.instance.offlineSearchHistoryDao
        .deleteAlldiamondModelItems();
    await AppDatabase.instance.offlineStockTracklDao
        .deleteAlldiamondModelItems();
    DefaultLoc.clear();
  }
}

logoutFromApp(BuildContext context) {
  app.resolve<CustomDialogs>().confirmDialog(context,
      title: R.string.commonString.lbllogout,
      desc: R.string.authStrings.logoutConfirmationMsg,
      positiveBtnTitle: R.string.commonString.yes,
      negativeBtnTitle: R.string.commonString.no,
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
