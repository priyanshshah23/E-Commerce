import 'dart:io';

import 'package:diamnow/app/Helper/ConnectionManager.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/localization/LocalizationHelper.dart';
import 'package:diamnow/app/theme/settings_models_provider.dart';
import 'package:diamnow/app/utils/NotificationHandler.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondCompareScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Splash.dart';
import 'package:diamnow/modules/ThemeSetting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'app/Helper/OfflineStockManager.dart';
import 'app/app.export.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/global_models_provider.dart';
import 'app/utils/navigator.dart';
import 'app/utils/route_observer.dart';
import 'components/Screens/Search/Search.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

KiwiContainer app;

TextDirection deviceTextDirection = TextDirection.ltr;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  app = KiwiContainer();
  HttpOverrides.global = new MyHttpOverrides();
  setup();
  runApp(SettingsModelsProvider(
    child: GlobalModelsProvider(
      child: StreamBuilder<String>(
          stream: ThemeHelper.appthemeString,
          builder: (context, snapshot) {
            return StreamBuilder(
                stream: LocalizationHelper.appLanguage,
                builder: (context, snapshot2) {
                  return Base();
                });
          }),
    ),
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  ConnectivityManager _connectivity = ConnectivityManager.instance;
  Map _source = {ConnectivityResult.none: false};

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) async {
      String string;
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.none:
          string = 'offline';
          break;
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          string = 'online';
          OfflineStockManager.shared.callApiForSyncOfflineData(context);
          break;
      }
      print("Internet " + string);
      _source = source;
    });

    await notificationInit();
    await _configureLocalTimeZone();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName =
        await localNotificationPlatform.invokeMethod('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  @override
  Widget build(BuildContext context) {
    app.resolve<PrefUtils>().saveDeviceId();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APPNAME,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: appTheme.colorPrimary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // Define the default font family.
        fontFamily: 'Avenir',
      ),
      navigatorKey: NavigationUtilities.key,
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [routeObserver],
      home: Splash(),
      routes: <String, WidgetBuilder>{
        DiamondCompareScreen.route: (BuildContext context) =>
            DiamondCompareScreen(ModalRoute.of(context).settings.arguments),
        DiamondListScreen.route: (BuildContext context) =>
            DiamondListScreen(ModalRoute.of(context).settings.arguments),
        DiamondActionScreen.route: (BuildContext context) =>
            DiamondActionScreen(ModalRoute.of(context).settings.arguments),
        DiamondDetailScreen.route: (BuildContext context) =>
            DiamondDetailScreen(
                arguments: ModalRoute.of(context).settings.arguments),
        SearchScreen.route: (BuildContext context) =>
            SearchScreen(ModalRoute.of(context).settings.arguments),
      },
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: child,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
