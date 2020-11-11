import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/Profile.dart';
import 'package:diamnow/components/Screens/Auth/ResetPassword.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:diamnow/components/Screens/Notification/Notifications.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'Auth/ForgetPassword.dart';
import 'Version/VersionUpdate.dart';

class Splash extends StatefulWidget {
  static const route = "/splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 1),
      () => (callMasterSync() /*callHandler()*/),
    );
  }

  Future openNextScreen() async {
    if (app.resolve<PrefUtils>().isUserLogin()) {
      // NavigationUtilities.pushRoute(FilterScreen.route);
//        NavigationUtilities.pushRoute(CompanyInformation.route);
//      NavigationUtilities.pushRoute(Notifications.route);
      // callVersionUpdateApi();
      SyncManager().callVersionUpdateApi(context,VersionUpdateApi.splash);
//      AppNavigation.shared.movetoHome(isPopAndSwitch: true);
      //  NavigationUtilities.pushRoute(ForgetPasswordScreen.route);
//      AppNavigation().movetoHome(isPopAndSwitch: true);
    } else {
      AppNavigation.shared.movetoLogin(isPopAndSwitch: true);
    }
  }

  //dont delete
  
  // void callVersionUpdateApi() {
  //   NetworkCall<VersionUpdateResp>()
  //       .makeCall(
  //           () => app
  //               .resolve<ServiceModule>()
  //               .networkService()
  //               .getVersionUpdate(),
  //           context,
  //           isProgress: true)
  //       .then(
  //     (resp) {
  //       if (resp.data != null) {
  //         PackageInfo.fromPlatform().then(
  //           (PackageInfo packageInfo) {
  //             String appName = packageInfo.appName;
  //             String packageName = packageInfo.packageName;
  //             String version = packageInfo.version;
  //             String buildNumber = packageInfo.buildNumber;
  //             if (Platform.isIOS) {
  //               print("iOS");
  //               if (resp.data.ios != null) {
  //                 num respVersion = resp.data.ios.number;

  //                 if (num.parse(version) < respVersion) {
  //                   bool hardUpdate = resp.data.ios.isHardUpdate;

  //                   Map<String, dynamic> dict = new HashMap();
  //                   dict["isHardUpdate"] = hardUpdate;
  //                   dict["oncomplete"] = () {
  //                     AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                   };

  //                   if (hardUpdate == true) {
  //                     app.resolve<PrefUtils>().saveSkipUpdate(false);
  //                     NavigationUtilities.pushReplacementNamed(
  //                         VersionUpdate.route,
  //                         args: dict);
  //                   } else {
  //                     if (app.resolve<PrefUtils>().getSkipUpdate() == false) {
  //                       NavigationUtilities.pushReplacementNamed(
  //                           VersionUpdate.route,
  //                           args: dict);
  //                     } else {
  //                       AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                     }
  //                   }
  //                 } else {
  //                   AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                 }
  //               } else {
  //                 AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //               }
  //             } else {
  //               print("Android");
  //               if (resp.data.android != null) {
  //                 num respVersion = resp.data.android.number;
  //                 if (num.parse(buildNumber) < respVersion) {
  //                   bool hardUpdate = resp.data.android.isHardUpdate;
  //                   Map<String, dynamic> dict = new HashMap();
  //                   dict["isHardUpdate"] = true;
  //                   dict["oncomplete"] = () {
  //                     AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                   };
  //                   if (hardUpdate == true) {
  //                     app.resolve<PrefUtils>().saveSkipUpdate(false);
  //                     NavigationUtilities.pushReplacementNamed(
  //                         VersionUpdate.route,
  //                         args: dict);
  //                   } else {
  //                     if (app.resolve<PrefUtils>().getSkipUpdate() == false) {
  //                       NavigationUtilities.pushReplacementNamed(
  //                           VersionUpdate.route,
  //                           args: dict);
  //                     } else {
  //                       AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                     }
  //                   }
  //                 } else {
  //                   AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                 }
  //               } else {
  //                 AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //               }
  //             }
  //           },
  //         );
  //       }
  //     },
  //   ).catchError(
  //     (onError) => {
  //       app.resolve<CustomDialogs>().confirmDialog(context,
  //           title: R.string().errorString.versionError,
  //           desc: onError.message,
  //           positiveBtnTitle: R.string().commonString.btnTryAgain,
  //           onClickCallback: (PositveButtonClick) {
  //         callVersionUpdateApi();
  //       }),
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //callUpdateVehicleApi(context);
    return Container(
      color: appTheme.whiteColor,
      height: MathUtilities.screenHeight(context),
      width: MathUtilities.screenWidth(context),
      child: Center(
          child: Container(
              width: getSize(125),
              height: getSize(125),
              child: Image.asset(
                splashLogo,
                width: getSize(125),
                height: getSize(125),
              ))),
    );
  }

  bool isFailed = false;

  Future callMasterSync() async {
    SyncManager.instance.callMasterSync(context, () {
      callHandler();
    }, () {
      callHandler();
    }, isNetworkError: false, isProgress: false);
  }

  void callHandler() {
    Timer(
      Duration(seconds: 2),
      () => (openNextScreen()),
    );
  }
}
