import 'dart:collection';

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
}
