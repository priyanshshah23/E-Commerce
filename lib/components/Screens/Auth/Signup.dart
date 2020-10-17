import 'dart:async';
import 'dart:io';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignupScreen extends StatefulWidget {
  static const route = "SignupScreen";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) {
    //   WebView.platform = new SurfaceAndroidWebView();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context,
        R.string().screenTitle.signup,
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: signupURl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            loginCallBacks(context),
            registerCallBacks(context),
          ].toSet(),
          onPageStarted: (String url) {
            app.resolve<CustomDialogs>().showProgressDialog(context, "");
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            app.resolve<CustomDialogs>().hideProgressDialog();
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  JavascriptChannel loginCallBacks(BuildContext context) {
    return JavascriptChannel(
        name: 'LoginCallBack',
        onMessageReceived: (JavascriptMessage message) {
          Navigator.pop(context);
        });
  }

  JavascriptChannel registerCallBacks(BuildContext context) {
    return JavascriptChannel(
        name: 'RegisterCallBack',
        onMessageReceived: (JavascriptMessage message) {
          Navigator.pop(context);
        });
  }
}
