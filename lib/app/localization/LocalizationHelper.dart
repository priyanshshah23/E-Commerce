import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';

class LocalizationHelper {
  static StreamController<String> controller = StreamController<String>();

  static Stream<String> appLanguage = controller.stream;

  static changeLocale(String newLocal) {
    R.changeLocale(newLocal);
    controller.add(newLocal);
  }
}
