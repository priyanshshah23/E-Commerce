import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/components/Screens/Notification/NotificationManager.dart';
import 'package:kiwi/kiwi.dart';

import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';

import '../app.export.dart';

part "app_module.g.dart";

abstract class AppModule {
  @Register.singleton(ConnectivityService)
  @Register.singleton(PrefUtils)
  @Register.singleton(FlushbarService)
  @Register.singleton(ThemeSettingsModel)
  @Register.singleton(ServiceModule)
  @Register.singleton(CustomDialogs)
  @Register.singleton(NotificationManger)
  void configure();
}

void setup() {
  var appModule = _$AppModule();
  appModule.configure();
}
