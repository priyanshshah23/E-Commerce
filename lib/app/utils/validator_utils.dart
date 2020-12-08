import 'package:diamnow/app/localization/app_locales.dart';

import '../app.export.dart';

/// Wraps the [SharedPreferences].
class ValidationUtils {
  static bool isStingEmpty(String string) {
    return string == null || string.trim().isEmpty ? true : false;
  }

  static bool validateMobile(context, String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = new RegExp(patttern);
    if (isStingEmpty(value)) {
      View.showMessage(context, R.string.errorString.enterPhone,
          title: R.string.commonString.error, mode: DisplayMode.ERROR);
      return false;
    } else if (!regExp.hasMatch(value)) {
      View.showMessage(context, R.string.errorString.enterValidPhone,
          title: R.string.commonString.error, mode: DisplayMode.ERROR);
      return false;
    }
    return true;
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return (!RegExp(pattern).hasMatch(value)) ? false : true;
  }
}
