import 'dart:collection';
import 'dart:convert';

import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/widgets/shared/buttons.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BidTerms extends StatefulWidget {
  static const route = "BidTerms";
  bool isFromDrawer = false;
  BidTerms(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    isFromDrawer = arguments[ArgumentConstant.IsFromDrawer] ?? false;
  }

  @override
  _BidTermsState createState() => _BidTermsState();
}

class _BidTermsState extends State<BidTerms> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        R.string.authStrings.termsAndCondition,
        bgColor: appTheme.whiteColor,
        leadingButton: widget.isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
        centerTitle: false,
      ),
      //bottomNavigationBar: getBottomButton(),
      body: Padding(
        padding: EdgeInsets.all(getSize(16)),
        child: WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
        ),
      ),
      bottomNavigationBar: getBottomButton(),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/Json/bidTerms.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  getBottomButton() {
    return Padding(
      padding: EdgeInsets.only(bottom:getSize(16),left: getSize(16),right: getSize(16)),
      child: Container(
        margin: EdgeInsets.only(top: getSize(0)),
        decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
        child: AppButton.flat(
          onTap: () {
            Navigator.pop(context);
          },
          borderRadius: getSize(5),
          fitWidth: true,
          text: "Go to 'Bid it'",
          //isButtonEnabled: enableDisableSigninButton(),
        ),
      ),
    );
  }
}
