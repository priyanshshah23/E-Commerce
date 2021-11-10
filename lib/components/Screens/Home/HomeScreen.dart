import 'dart:async';
import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/UploadKYC.dart';
import 'package:diamnow/components/Screens/Auth/Widget/MyAccountScreen.dart';
import 'package:diamnow/components/Screens/DashBoard/Dashboard.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/MyDemand/MyDemandScreen.dart';
import 'package:diamnow/components/Screens/OfflineSearchHistory/OfflineSearchHistory.dart';
import 'package:diamnow/components/Screens/Order/OrderListScreen.dart';
import 'package:diamnow/components/Screens/PriceCalculator/PriceCalculator.dart';
import 'package:diamnow/components/Screens/QuickSearch/QuickSearch.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/components/Screens/StaticPage/StaticPage.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/ExclusiveModel/ExclusiveModel.dart';
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
  String id;
  String titlePage;

  DrawerEvent(this.index, this.isPop, {this.id, this.titlePage});
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
  User user;
  int selectedType = DiamondModuleConstant.MODULE_TYPE_SEARCH;

  @override
  void initState() {
    super.initState();
    user = app.resolve<PrefUtils>().getUserDetails();
    selectedType = getDefaultModuleType();
    if (!app.resolve<PrefUtils>().isUserCustomer()) {
      openSearch(DiamondModuleConstant.MODULE_TYPE_SEARCH);
    } else if (user.isKycUploaded == false) {
      if (user.kycRequired) {
        openKYCUpload(DiamondModuleConstant.MODULE_TYPE_UPLOAD_KYC);
      } else {
        openDashboard(DiamondModuleConstant.MODULE_TYPE_HOME);
      }
    } else {
      openDashboard(DiamondModuleConstant.MODULE_TYPE_HOME);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print(
          "--------------------------kyc-----------------${user
              .isKycUploaded}");
      /* if (app.resolve<PrefUtils>().isUserCustomer()) {
        //Kyc rejected
        if (user.account.isApproved == KYCStatus.rejected &&
            user.account.isKycUploaded == true) {
          Timer(
            Duration(seconds: 2),
            () => (app.resolve<CustomDialogs>().confirmDialog(context,
                dismissPopup: false,
                title: R.string.authStrings.kYCRejected,
                desc: R.string.authStrings.kycRejectedDesc,
                positiveBtnTitle: R.string.commonString.upload,
                negativeBtnTitle: R.string.commonString.btnSkip,
                onClickCallback: (click) {
              if (click == ButtonType.PositveButtonClick) {
                NavigationUtilities.pushRoute(
                  UploadKYCScreen.route,
                );
              }
            })),
          );
        }

        //Documents not uploaded
        if (user.account.isKycUploaded == false) {
          if (!user.kycRequired) {
            Timer(
              Duration(seconds: 2),
              () => (app.resolve<CustomDialogs>().confirmDialog(context,
                  dismissPopup: false,
                  title: R.string.authStrings.uploadKYC,
                  desc: R.string.authStrings.uploadKycDesc,
                  positiveBtnTitle: R.string.commonString.upload,
                  negativeBtnTitle:
                      user.kycRequired ? null : R.string.commonString.btnSkip,
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
      }*/

      callApiForExclusiveSearch(isLoading: false);
      RxBus.register<DrawerEvent>(tag: eventBusTag).listen((event) {
        if (event.index == DiamondModuleConstant.MODULE_TYPE_OPEN_DRAWER) {
          _scaffoldKey?.currentState?.openDrawer();
        } else {
          manageDrawerClick(context, event.index, event.isPop,
              id: event.id, titlePage: event.titlePage);
        }
      });
    });
  }


  callApiForExclusiveSearch({bool isLoading = false}) {
    NetworkCall<ExclusiveCollection>()
        .makeCall(
          () => app.resolve<ServiceModule>().networkService().exclusiveCollection(),
      context,
      isProgress: false,
    )
        .then((resp) async {
      print(resp.data);
      app.resolve<PrefUtils>().saveExclusiveCollectionDetails(resp.data).then(
            (value) => setState(
              () {
            print("Collection are coming................");
          },
        ),
      );
    }).catchError((onError, stack) {
      print("error in collection........");
      // if (onError is ErrorResp) {
      //   app.resolve<CustomDialogs>().confirmDialog(
      //         context,
      //         desc: onError.message,
      //         positiveBtnTitle: R.string.commonString.btnTryAgain,
      //       );
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  openDiamondListForCollection(int moduleType, String id, String titlePage) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    dict["idCollection"] = id;
    dict["titlePage"] = titlePage;
    setState(() {
      currentWidget = DiamondListScreen(
        dict,
        // key: Key(moduleType.toString()),
        key: Key(id),
      );
    });
  }

  int getDefaultModuleType() {
    return app.resolve<PrefUtils>().isUserCustomer()
        ? DiamondModuleConstant.MODULE_TYPE_HOME
        : DiamondModuleConstant.MODULE_TYPE_SEARCH;
  }

  Future<bool> _onWillPop(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      if (selectedType == getDefaultModuleType()) {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: APPNAME,
            desc: R.string.commonString.lblAppExit,
            positiveBtnTitle: R.string.commonString.lblExit,
            negativeBtnTitle: R.string.commonString.cancel,
            onClickCallback: (btnType) {
          if (btnType == ButtonType.PositveButtonClick) {
            //  Navigator.pop(context);
            SystemNavigator.pop();
            app.resolve<PrefUtils>().saveCompany(null);
          }
        });
      } else {
        if (app.resolve<PrefUtils>().isUserCustomer()) {
          manageDrawerClick(
              context, DiamondModuleConstant.MODULE_TYPE_HOME, false);
        } else {
          manageDrawerClick(
              context, DiamondModuleConstant.MODULE_TYPE_SEARCH, false);
        }
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
    currentWidget = FilterScreen(
      dict,
      key: Key(moduleType.toString()),
    );
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

  openOfflineSearchHistory(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = OfflineSearchHistory(
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
    currentWidget = StaticPageScreen(
      dict,
      key: Key(moduleType.toString()),
    );
  }

  openContactUS(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.CONTACT_US;
    dict["strUrl"] = ApiConstants.contactUs;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(
      dict,
      key: Key(moduleType.toString()),
    );
  }

  openTermsAndCondition(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.TERMS_CONDITION;
    dict["strUrl"] = ApiConstants.termsCondition;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(
      dict,
      key: Key(moduleType.toString()),
    );
  }

  openPrivacyPolicy(int moduleType) {
    selectedType = moduleType;
//    selectedType = DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY;
    Map<String, dynamic> dict = new HashMap();
    dict["type"] = StaticPageConstant.PRIVACY_POLICY;
    dict["strUrl"] = ApiConstants.privacyPolicy;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = StaticPageScreen(
      dict,
      key: Key(moduleType.toString()),
    );
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

  openPriceCalculator(int moduleType) {
    selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] =
        DiamondModuleConstant.MODULE_TYPE_PRICE_CALCULATOR;
    dict[ArgumentConstant.IsFromDrawer] = true;
    currentWidget = PriceCalculator(dict);
  }

  manageDrawerClick(BuildContext context, int type, bool isPop, {String id, String titlePage}) {
    if (context != null) {
      if (isPop) Navigator.pop(context);
      if (type != DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_COLLECTION) {
        if (selectedType == type) {
          return;
        }
      }

        switch (type) {
          case DiamondModuleConstant.MODULE_TYPE_HOME:
            openDashboard(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.HOME,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_COLLECTION:
            openDiamondListForCollection(type, id, titlePage);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.OfflineSearchHistory,
              section: SectionAnalytics.OFFLINESEARCH,
              action: ActionAnalytics.CLICK,
            );
            break;

          case DiamondModuleConstant.MODULE_TYPE_SEARCH:
          case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH:
            openSearch(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.OfflineSearchHistory,
              section: SectionAnalytics.OFFLINESEARCH,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
            openQuickSearch(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.QUICK_SERACH,
              section: SectionAnalytics.SEARCH,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_MY_CART:
          case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
          case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
          case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
          case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
          case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
          case DiamondModuleConstant.MODULE_TYPE_DRAWER_NEW_ARRIVAL:
          case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
          case DiamondModuleConstant.MODULE_TYPE_MY_BID:
          case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
          case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
          case DiamondModuleConstant.MODULE_TYPE_DRAWER_UPCOMING:
          case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK:
            openDiamondList(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.OfflineSearchHistory,
              section: SectionAnalytics.OFFLINESEARCH,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
          case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
            openDiamondList(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.STONE_OF_THE_DAY,
              section: SectionAnalytics.FILTER,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_PROFILE:
            openProfile(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.PROFILE,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
          case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
            openDiamondOrderList(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.MY_PURCHASE,
              section: SectionAnalytics.DETAILS,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH:
            openSavedSearch(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.MYSAVED_SEARCH,
              section: SectionAnalytics.SAVED_SEARCH,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_ABOUT_US:
            openAboutUs(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.ABOUT_US,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY:
            openPrivacyPolicy(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.ABOUT_US,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION:
            openTermsAndCondition(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.ABOUT_US,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_CONTACT_US:
            openContactUS(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.CONTACT,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_LOGOUT:
            logoutFromApp(context);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.LOGOUT,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
            openMyDemand(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.MY_DEMAND,
              section: SectionAnalytics.VIEW,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH_HISTORY:
            openOfflineSearchHistory(type);
            AnalyticsReport.shared.sendAnalyticsData(
              buildContext: context,
              page: PageAnalytics.OFFLINE_DOWNLOAD,
              section: SectionAnalytics.OFFLINESEARCH,
              action: ActionAnalytics.CLICK,
            );
            break;
          case DiamondModuleConstant.MODULE_TYPE_PRICE_CALCULATOR:
            openPriceCalculator(type);
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
