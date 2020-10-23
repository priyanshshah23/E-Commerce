import 'dart:async';
import 'dart:convert';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/StaticPage/StaticPageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:webview_flutter/webview_flutter.dart';

class StaticPageScreen extends StatefulScreenWidget {
  static const route = "StaticPageScreen";
  String screenType;

  StaticPageScreen(Map<String, dynamic> arguments) {
    this.screenType = arguments["type"];

  }

  @override
  _StaticPageScreenState createState() =>
      _StaticPageScreenState();
}

class _StaticPageScreenState extends State<StaticPageScreen> {
  StaticPageRespData data;
//  WebViewController _controller;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();

  }

  void callApi() {
    NetworkCall<StaticPageResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .staticPage(widget.screenType),
            context,
            isProgress: true)
        .then((staticPageResp) {
      setState(() {
        data = staticPageResp.data;
      });
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: "${widget.screenType} Error",
            desc: onError.message,
            positiveBtnTitle: "Try Again",
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    //callApi();
    return Scaffold(
        appBar: getAppBar(
          context,
          getScreenTitle(),
          leadingButton: getDrawerButton(context,true),
        ),
        body: Container(
          height: MathUtilities.screenHeight(context),
          color: ColorConstants.white,
          padding: EdgeInsets.only(
            top: getSize(15),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(left: getSize(20), right: getSize(20)),
              child:  WebView(
              initialUrl: "http://fndevelop.democ.in/",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                app.resolve<CustomDialogs>().showProgressDialog(context, "");
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                app.resolve<CustomDialogs>().hideProgressDialog();
              },
              gestureNavigationEnabled: true,
            ),
//              child: !isNullEmptyOrFalse(data)
//                  ? WebView(
//                      initialUrl: 'http://fndevelop.democ.in/',
//                      onWebViewCreated:
//                          (WebViewController webViewController) {
//                        _controller = webViewController;
//                        _loadHtmlFromAssets(data?.desc ?? "");
//                      },
//                    )
//                  : SizedBox(),
            ),
          ),
        ));
  }

//  _loadHtmlFromAssets(String desc) async {
//    _controller.loadUrl(Uri.dataFromString(desc,
//            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//        .toString());
//  }

  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  String getScreenTitle() {
    if (widget.screenType == StaticPageConstant.TERMS_CONDITION) {
      return R.string().screenTitle.termsAndCondition;
    } else if (widget.screenType == StaticPageConstant.PRIVACY_POLICY) {
      return R.string().screenTitle.privacyPolicy;
    } else if (widget.screenType == StaticPageConstant.ABOUT_US) {
      return R.string().screenTitle.aboutUS;
    }
    /*else if (screenType == StaticPageConstant.CANCELLAION_POLICY) {
      return "Order Cancel Policy";
    } else if (screenType == StaticPageConstant.SHIPPING_POLICY) {
      return "Order Shipping Policy";
    } else if (screenType == StaticPageConstant.REFUND_POLICY) {
      return "Order Refund Policy";
    } else if (screenType == StaticPageConstant.REPAIR_POLICY) {
      return "Order Repair Policy";
    } else if (screenType == StaticPageConstant.REPLACEMENT_POLICY) {
      return "Order Replacement Policy";
    }*/
    return "";
  }
}
