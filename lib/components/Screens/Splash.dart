import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Auth/SignInWithMPINScreen.dart';
import 'package:diamnow/app/localization/LocalizationHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';

import 'Auth/ForgetPassword.dart';
import 'Version/VersionUpdate.dart';

class Splash extends StatefulWidget {
  static const route = "/splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics;

  @override
  Future<void> initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      availableBiometrics = await auth.getAvailableBiometrics();
      Timer(
        Duration(seconds: 1),
        () => (callMasterSync() /*callHandler()*/),
      );
    });
  }

  Future openNextScreen() async {
    if (app.resolve<PrefUtils>().isUserLogin()) {
      // NavigationUtilities.pushRoute(FilterScreen.route);
//        NavigationUtilities.pushRoute(CompanyInformation.route);
//      NavigationUtilities.pushRoute(Notifications.route);
      // callVersionUpdateApi();
      SyncManager().callVersionUpdateApi(context, VersionUpdateApi.splash,
          id: app.resolve<PrefUtils>().getUserDetails().id ?? "");
//      AppNavigation.shared.movetoHome(isPopAndSwitch: true);
      //  NavigationUtilities.pushRoute(ForgetPasswordScreen.route);
//      AppNavigation().movetoHome(isPopAndSwitch: true);
    } else {
      AppNavigation.shared.movetoLogin(isPopAndSwitch: true);
    }
  }

  askForBioMetrics() async {
    if (!isNullEmptyOrFalse(availableBiometrics)) {
      try {
        bool isAuthenticated = await auth.authenticateWithBiometrics(
          localizedReason:
              Platform.isIOS && availableBiometrics.contains(BiometricType.face)
                  ? R.string.commonString.unlockWithFaceId
                  : R.string.commonString.unlockWithTouchId,
          useErrorDialogs: false,
          stickyAuth: false,
        );
        print(isAuthenticated);
        if (isAuthenticated) {
          app.resolve<PrefUtils>().setBiometrcisUsage(true);
          callSyncApi();
        } else {
          askForBioMetrics();
        }
      } on PlatformException catch (e) {
        print(e.message);
        callSyncApi();
      }
    } else {
      callSyncApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    //callUpdateVehicleApi(context);
    LocalizationHelper.changeLocale(
        app.resolve<PrefUtils>().getLocalization().isNotEmpty ? app.resolve<PrefUtils>().getLocalization() : English.languageCode);
    return Container(
      color: appTheme.whiteColor,
      height: MathUtilities.screenHeight(context),
      width: MathUtilities.screenWidth(context),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: getSize(260),
          height: getSize(260),
          child: Lottie.asset(
            'assets/pn.json',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  bool isFailed = false;

  Future callMasterSync() async {
    if (app.resolve<PrefUtils>().getBiometrcis()) {
      askForBioMetrics();
    } else if (app.resolve<PrefUtils>().getMpin()) {
      Map<String, dynamic> args = {};
      args["askForVerifyMpin"] = true;
      args["enm"] = Mpin.splash;

      NavigationUtilities.pushRoute(SignInWithMPINScreen.route, args: args);
    } else {
      callSyncApi();
    }
  }

  callSyncApi() {
    SyncManager.instance.callMasterSync(context, () {
      callHandler();
    }, () {
      callHandler();
    },
        isNetworkError: false,
        isProgress: false,
        id: app.resolve<PrefUtils>().isUserLogin()
            ? app.resolve<PrefUtils>().getUserDetails()?.id ?? ""
            : "");
  }

  void callHandler() {
    Timer(
      Duration(seconds: 2),
      () => (openNextScreen()),
    );
  }
}
