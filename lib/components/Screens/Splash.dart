import 'dart:async';
import 'dart:collection';
import 'dart:io' show Platform;

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Auth/DemoScreen.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Auth/PDFDemo.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/widgets/shared/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:rxbus/rxbus.dart';

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
//    NavigationUtilities.pushRoute(LoginScreen.route);

    if (app.resolve<PrefUtils>().isUserLogin()) {
      NavigationUtilities.pushRoute(DiamondListScreen.route);
    } else {
      NavigationUtilities.pushRoute(MyHomePage.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    //callUpdateVehicleApi(context);
    return Container(
      color: Colors.deepPurpleAccent,
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
      //success
      callHandler();
    }, () {
      // failure
      callHandler();
      // setState(() {
      //   // isFailed = true;
      //   callHandler();
      // });
    }, isNetworkError: false, isProgress: false);
    /*Timer(
      Duration(seconds: 2),
      () => (),
    );*/
  }

  void callHandler() {
    Timer(
      Duration(seconds: 2),
      () => (openNextScreen()),
    );
  }
}
