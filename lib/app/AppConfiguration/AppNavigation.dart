import 'dart:collection';

import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:flutter/services.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';

import '../app.export.dart';

// AppConfiguration Constant string
const CONFIG_LOGIN = "LOGIN";
const CONFIG_MOBILE_VERIFICATION = "MOBILE_VERIFICATION";
const CONFIG_BANK_DETAIL = "BANK_DETAIL";
const CONFIG_DOC_VERIFICATION = "DOC_VERIFICATION";

class AppNavigation {
  static final AppNavigation shared = AppNavigation();

  // Configuration _configuration;

  Future<void> init() async {
    // code
    // _configuration = AppConfiguration.shared.configuration;
  }

// Move To Home Scree
  void movetoHome({bool isPopAndSwitch = false}) {
    // move to Homprint('home');
    if (isPopAndSwitch) {
      NavigationUtilities.pushReplacementNamed(HomeScreen.route,
          type: RouteType.fade);
      // NavigationUtilities.pushReplacementNamed(DiamondListScreen.route,
      // type: RouteType.fade);
    } else {
      NavigationUtilities.pushRoute(HomeScreen.route, type: RouteType.fade);
    }
  }

  void movetoLogin({bool isPopAndSwitch = false}) {
    if (isPopAndSwitch) {
      NavigationUtilities.pushReplacementNamed(LoginScreen.route);
    } else {
      NavigationUtilities.pushRoute(LoginScreen.route);
    }
  }
}
