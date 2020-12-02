import 'dart:async';
import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Profile.dart';
import 'package:diamnow/components/Screens/Auth/ProfileList.dart';
import 'package:diamnow/components/Screens/Auth/UploadKYC.dart';
import 'package:diamnow/components/Screens/Auth/Widget/MyAccountScreen.dart';
import 'package:diamnow/components/Screens/DashBoard/Dashboard.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/MyDemand/MyDemandScreen.dart';
import 'package:diamnow/components/Screens/Order/OrderListScreen.dart';
import 'package:diamnow/components/Screens/QuickSearch/QuickSearch.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/components/Screens/StaticPage/StaticPage.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/LoginModel.dart';
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
    User user = app.resolve<PrefUtils>().getUserDetails();
    if (user.account.isKycUploaded == false) {
      if (user.kycRequired) {
        openKYCUpload(DiamondModuleConstant.MODULE_TYPE_UPLOAD_KYC);
      } else {
        openDashboard(DiamondModuleConstant.MODULE_TYPE_HOME);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (user.account.isKycUploaded == false) {
        if (!user.kycRequired) {
          Timer(
            Duration(seconds: 2),
            () => (app.resolve<CustomDialogs>().confirmDialog(context,
                dismissPopup: false,
                title: R.string().authStrings.uploadKYC,
                desc: R.string().authStrings.uploadKycDesc,
                positiveBtnTitle: R.string().commonString.upload,
                negativeBtnTitle:
                    user.kycRequired ? null : R.string().commonString.btnSkip,
                onClickCallback: (click) {
              if (click == ButtonType.PositveButtonClick) {
                NavigationUtilities.pushRoute(
                  UploadKYCScreen.route,
                );
              }
            })),
          );
        }
      } else {
        openDashboard(DiamondModuleConstant.MODULE_TYPE_HOME);
      }
      RxBus.register<DrawerEvent>(tag: eventBusTag).listen((event) {
        if (event.index == DiamondModuleConstant.MODULE_TYPE_OPEN_DRAWER) {
          _scaffoldKey?.currentState?.openDrawer();
        } else {
          manageDrawerClick(context, event.index, event.isPop);
        }
      });
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

  openKYCUpload(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = UploadKYCScreen(
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

  openDiamondOrderList(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = OrderListScreen(
      dict,
      key: Key(moduleType.toString()),
    );
  }

//  openProfile(int moduleType) {
//    selectedType = moduleType;
////    selectedType = DiamondModuleConstant.MODULE_TYPE_PROFILE;
//    Map<String, dynamic> dict = new HashMap();
//    dict[ArgumentConstant.ModuleType] =
//        DiamondModuleConstant.MODULE_TYPE_PROFILE;
//    dict[ArgumentConstant.IsFromDrawer] = true;
//    currentWidget = Profile();
//  }

  openAboutUs(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_ABOUT_US;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.ABOUT_US;
    dict["strUrl"] = ApiConstants.aboutUs;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  openContactUS(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.CONTACT_US;
    dict["strUrl"] = ApiConstants.contactUs;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  openTermsAndCondition(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.TERMS_CONDITION;
    dict["strUrl"] = ApiConstants.termsCondition;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  openPrivacyPolicy(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.PRIVACY_POLICY;
    dict["strUrl"] = ApiConstants.privacyPolicy;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(dict);
  }

  openSavedSearch(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] =
        DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
    dict[ArgumentConstant.IsFromDrawer] = true;
    // currentWidget = SavedSearchScreen(dict);
    currentWidget = SavedSearchScreen(dict);
  }

  openMyDemand(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] =
        DiamondModuleConstant.MODULE_TYPE_MY_DEMAND;
    dict[ArgumentConstant.IsFromDrawer] = true;
    // currentWidget = SavedSearchScreen(dict);
    currentWidget = MyDemandScreen(dict);
  }

  openProfile(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] =
        DiamondModuleConstant.MODULE_TYPE_PROFILE;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = MyAccountScreen(dict);
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
        case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
          openDiamondList(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
        case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
          openDiamondList(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_PROFILE:
          openProfile(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
        case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
          openDiamondOrderList(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH:
          openSavedSearch(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_ABOUT_US:
          openAboutUs(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY:
          openPrivacyPolicy(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION:
          openTermsAndCondition(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_CONTACT_US:
          openContactUS(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_LOGOUT:
          logoutFromApp(context);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
          openMyDemand(type);
          break;
      }
      if (type != DiamondModuleConstant.MODULE_TYPE_LOGOUT) {
        setState(() {});
      }
    }
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
