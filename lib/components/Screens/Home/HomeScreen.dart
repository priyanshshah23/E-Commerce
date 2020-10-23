import 'dart:async';
import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/Profile.dart';
import 'package:diamnow/components/Screens/Auth/ProfileList.dart';
import 'package:diamnow/components/Screens/DashBoard/Dashboard.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/QuickSearch/QuickSearch.dart';
import 'package:diamnow/components/Screens/StaticPage/StaticPage.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxbus/rxbus.dart';

import 'HomeDrawer.dart';

/// The [HomeScreen] showing after a user has logged in.
///
class DrawerEvent {
  int index;
  bool isPop;

  DrawerEvent(this.index, this.isPop);
}

class HomeScreen extends StatefulWidget {
  static const route = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isExpand = false;
  bool isSwitched = false;
  double bottomPadding = 0;
  Widget currentWidget;
  int selectedType = DiamondModuleConstant.MODULE_TYPE_HOME;

  @override
  void initState() {
    super.initState();
    //SocketManager.instance.connect();

    openDashboard(DiamondModuleConstant.MODULE_TYPE_HOME);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RxBus.register<DrawerEvent>(tag: eventBusTag).listen((event) {
        if (event.index == DiamondModuleConstant.MODULE_TYPE_OPEN_DRAWER) {
          _scaffoldKey?.currentState?.openDrawer();
        } else {
          manageDrawerClick(context, event.index, event.isPop);
        }
      });
      RxBus.register<bool>(tag: eventBusLogout).listen((event) {
        //app.resolve<PrefUtils>().resetAndLogout(context);
      });

      /*Timer(
        Duration(seconds: 2),
        () => (checkVersionUpdate(context)),
      );*/
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      if (selectedType == DiamondModuleConstant.MODULE_TYPE_HOME) {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: APPNAME,
            desc: R.string().commonString.lblAppExit,
            positiveBtnTitle: R.string().commonString.lblExit,
            negativeBtnTitle: R.string().commonString.cancel,
            onClickCallback: (btnType) {
          if (btnType == ButtonType.PositveButtonClick) {
            //  Navigator.pop(context);
            SystemNavigator.pop();
          }
        });
      } else {
        manageDrawerClick(
            context, DiamondModuleConstant.MODULE_TYPE_HOME, false);
      }
    } else {
      return Future.value(true);
    }
  }

  openDashboard(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = Dashboard(
      dict,
      key: Key(moduleType.toString()),
    );
  }

  openSearch(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = FilterScreen(dict);
  }

  openQuickSearch(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = QuickSearchScreen(dict);
  }

  openDiamondList(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = DiamondListScreen(
      dict,
      key: Key(moduleType.toString()),
    );
  }

  openProfile() {
    selectedType = DiamondModuleConstant.MODULE_TYPE_PROFILE;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] =
        DiamondModuleConstant.MODULE_TYPE_PROFILE;
    dict[ArgumentConstant.IsFromDrawer] = true;
//    currentWidget = Profile();
    currentWidget = ProfileList();
  }

  openAboutUs() {
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.ABOUT_US;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  openTermsAndCondition() {
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.TERMS_CONDITION;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  openPrivacyPolicy() {
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.PRIVACY_POLICY;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  manageDrawerClick(BuildContext context, int type, bool isPop) {
    if (context != null) {
      if (isPop) Navigator.pop(context);
      if (selectedType == type) {
        return;
      }

      switch (type) {
        case DiamondModuleConstant.MODULE_TYPE_HOME:
          openDashboard(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_SEARCH:
          openSearch(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
          openQuickSearch(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_CART:
        case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
        case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
        case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
        case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        case DiamondModuleConstant.MODULE_TYPE_ABOUT_US:
          openAboutUs();
          break;
        case DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY:
          openPrivacyPolicy();
          break;
        case DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION:
          openTermsAndCondition();
          break;
        case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
          openDiamondList(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_PROFILE:
          openProfile();
          break;
        case DiamondModuleConstant.MODULE_TYPE_LOGOUT:
          logout(context);
          break;
      }
      if (type != DiamondModuleConstant.MODULE_TYPE_LOGOUT) {
        setState(() {});
      }
    }
  }

  logout(BuildContext context) {
    app.resolve<CustomDialogs>().confirmDialog(context,
        title: R.string().commonString.lbllogout,
        desc: R.string().authStrings.logoutConfirmationMsg,
        positiveBtnTitle: R.string().commonString.yes,
        negativeBtnTitle: R.string().commonString.no,
        onClickCallback: (buttonType) {
      if (buttonType == ButtonType.PositveButtonClick) {
        calllogout(context);
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        ThemeSettingsModel.of(context).updateSystemUi(isLogin: true);
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoginScreen.route,
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  calllogout(BuildContext context) {
    app.resolve<PrefUtils>().clearPreferenceAndDB();

    /*NetworkCall<BaseApiResp>()
        .makeCall(() => app.resolve<ServiceModule>().networkService().logout(),
            context,
            isProgress: true)
        .then((response) {
      app.resolve<PrefUtils>().resetAndLogout(context);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        showToast(onError.message);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    ThemeSettingsModel.of(context).updateSystemUi(isLogin: false);
    return AppBackground(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            drawer: HomeDrawer(),
            key: _scaffoldKey,
            body: currentWidget,
            // bottomNavigationBar: getBottomViewForHome(),
          ),
        ),
      ),
    );
  }




}
