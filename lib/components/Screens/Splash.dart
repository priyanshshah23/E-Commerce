import 'dart:async';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      AppNavigation().movetoHome(isPopAndSwitch: true);
    } else {
      AppNavigation().movetoLogin(isPopAndSwitch: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    //callUpdateVehicleApi(context);
    return Container(
      color: appTheme.colorPrimary,
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
