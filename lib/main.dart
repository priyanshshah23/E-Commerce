import 'dart:io';

import 'package:diamnow/components/Screens/Splash.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'package:diamnow/app/theme/settings_models_provider.dart';
import 'package:diamnow/modules/ThemeSetting.dart';
import 'app/app.export.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/global_models_provider.dart';
import 'app/utils/navigator.dart';
import 'app/utils/route_observer.dart';

KiwiContainer app;

TextDirection deviceTextDirection = TextDirection.ltr;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    rootBundle
        .load('assets/chls.pem')
        .then((value) => {
              if (value != null)
                {
                  SecurityContext.defaultContext
                      .setTrustedCertificatesBytes(value.buffer.asUint8List())
                }
            })
        .catchError((object) => {print(object)});
  }
  app = KiwiContainer();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  setup();
  runApp(SettingsModelsProvider(
    child: GlobalModelsProvider(
      child: StreamBuilder<String>(
          stream: ThemeHelper.appthemeString,
          builder: (context, snapshot) {
            return Base();
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
  ThemeData themeData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        themeData = AppTheme.of(context).theme;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    app.resolve<PrefUtils>().saveDeviceId();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APPNAME,
      theme: themeData,
      navigatorKey: NavigationUtilities.key,
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [routeObserver],
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/ThemeSetting': (BuildContext context) => ThemeSetting(),
      },
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    return Column(
      children: <Widget>[
        Expanded(child: child),
      ],
    );
  }
}

class DemoScreen extends StatefulWidget {
  DemoScreen({Key key}) : super(key: key);

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.theme().bgColor,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              "Working",
              style: ThemeHelper.theme().titleText,
            ),
          ),
          AppButton.flat(
            text: "Continue",
            borderRadius: getSize(14),
            onTap: () {
              Navigator.pushNamed(context, "/ThemeSetting");
            },
          ),
        ]),
      ),
    );
  }
}
