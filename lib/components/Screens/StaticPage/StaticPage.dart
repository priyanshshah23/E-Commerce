import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/StaticPage/StaticPageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as xmlWebview;


class StaticPageScreen extends StatefulScreenWidget {
  static const route = "StaticPageScreen";
  String strUrl;
  String screenType;
  String screenTitle;
  bool showExcel;
  bool isFromDrawer;
  String filePath;

  StaticPageScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    this.screenType = arguments["type"];
    this.strUrl = arguments["strUrl"];
    this.showExcel = arguments["isForExcel"] ?? false;
    this.screenTitle = arguments["screenTitle"];
    this.isFromDrawer = arguments[ArgumentConstant.IsFromDrawer] ?? false;
    this.filePath = arguments['filePath'];
  }

  @override
  _StaticPageScreenState createState() => _StaticPageScreenState(
      strUrl: this.strUrl,
      screenType: this.screenType,
      screenTitle: this.screenTitle,
      showExcel: this.showExcel,
      isFromDrawer: this.isFromDrawer,
      filePath: this.filePath);
}

class _StaticPageScreenState extends StatefulScreenWidgetState {

  xmlWebview.InAppWebViewController webView;
  double progress = 0;

  String strUrl;
  String screenType;
  String screenTitle;
  bool showExcel;
  bool isFromDrawer;
  String filePath;

  _StaticPageScreenState({
    this.strUrl,
    this.screenTitle,
    this.screenType,
    this.showExcel,
    this.isFromDrawer,
    this.data,
    this.filePath,
  });
  StaticPageRespData data;
//  WebViewController _controller;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void callApi() {
    NetworkCall<StaticPageResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .staticPage(screenType),
            context,
            isProgress: true)
        .then((staticPageResp) {
      setState(() {
        data = staticPageResp.data;
      });
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: "${screenType} Error",
            desc: onError.message,
            positiveBtnTitle: "Try Again",
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    //callApi();
    return Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: getAppBar(
          context,
          screenTitle ?? getScreenTitle(),
          bgColor: appTheme.whiteColor,
          leadingButton: isFromDrawer
              ? getDrawerButton(context, true)
              : getBackButton(context),
          centerTitle: false,
          actionItems: showExcel
              ? [
                  InkWell(
                    onTap: () async {
                      await Share.shareFiles([filePath],
                          text: screenTitle ?? "");
                    },
                    child: Container(
                      margin: EdgeInsets.all(getSize(16)),
                      child: Image.asset(
                        share,
                        width: getSize(24),
                        height: getSize(24),
                      ),
                    ),
                  )
                ]
              : null,
        ),
        body:Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            decoration:
            BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: xmlWebview.InAppWebView(
              initialUrl: strUrl ?? "http://pn`develop.democ.in/",
              initialHeaders: {},
              initialOptions: xmlWebview.InAppWebViewGroupOptions(
                  crossPlatform: xmlWebview.InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onWebViewCreated: (xmlWebview.InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (xmlWebview.InAppWebViewController controller, String url) {
                setState(() {
                  this.strUrl = url;
                });
              },
              onLoadStop: (xmlWebview.InAppWebViewController controller, String url) async {
                setState(() {
                  this.strUrl = url;
                });
              },
              onProgressChanged: (xmlWebview.InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
        ),
       /* body: Container(
          height: MathUtilities.screenHeight(context),
          color: ColorConstants.white,
          padding: EdgeInsets.only(
            top: getSize(15),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
              child: WebView(
                initialUrl:
                    // "http://pndevelop.democ.in/",
                    // "/storage/emulated/0/Download/test.pdf",
                    strUrl ?? "http://pn`develop.democ.in/",
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
                onWebResourceError: (error) {
                  print(error.toString());
                },
                gestureNavigationEnabled: true,

              ),
            ),
          ),
        )*/
        );
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
    if (screenType == StaticPageConstant.TERMS_CONDITION) {
      return R.string.screenTitle.termsAndCondition;
    } else if (screenType == StaticPageConstant.PRIVACY_POLICY) {
      return R.string.screenTitle.privacyPolicy;
    } else if (screenType == StaticPageConstant.ABOUT_US) {
      return R.string.screenTitle.aboutUS;
    } else if (screenType == StaticPageConstant.CONTACT_US) {
      return R.string.screenTitle.contactUs;
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
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:diamnow/app/app.export.dart';
// import 'package:diamnow/app/localization/app_locales.dart';
// import 'package:diamnow/app/network/NetworkCall.dart';
// import 'package:diamnow/app/network/ServiceModule.dart';
// import 'package:diamnow/app/utils/CustomDialog.dart';
// import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
// import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
// import 'package:diamnow/models/StaticPage/StaticPageModel.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:html/parser.dart' show parse;
// import 'package:share/share.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class StaticPageScreen extends StatefulScreenWidget {
//   static const route = "StaticPageScreen";
//   String strUrl;
//   String screenType;
//   String screenTitle;
//   bool showExcel;
//   bool isFromDrawer;
//   String filePath;

//   StaticPageScreen(Map<String, dynamic> arguments) {
//     this.screenType = arguments["type"];
//     this.strUrl = arguments["strUrl"];
//     this.showExcel = arguments["isForExcel"] ?? false;
//     this.screenTitle = arguments["screenTitle"];
//     this.isFromDrawer = arguments[ArgumentConstant.IsFromDrawer] ?? false;
//     this.filePath = arguments['filePath'];
//   }

//   @override
//   _StaticPageScreenState createState() => _StaticPageScreenState();
// }

// class _StaticPageScreenState extends StatefulScreenWidgetState {
//   String strUrl;
//   String screenType;
//   String screenTitle;
//   bool showExcel;
//   bool isFromDrawer;
//   String filePath;

//   _StaticPageScreenState({
//     this.strUrl,
//     this.screenTitle,
//     this.screenType,
//     this.showExcel,
//     this.isFromDrawer,
//     this.data,
//     this.filePath,
//   });
//   StaticPageRespData data;
// //  WebViewController _controller;
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   @override
//   void initState() {
//     super.initState();
//     // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   void callApi() {
//     NetworkCall<StaticPageResp>()
//         .makeCall(
//             () => app
//                 .resolve<ServiceModule>()
//                 .networkService()
//                 .staticPage(widget.screenType),
//             context,
//             isProgress: true)
//         .then((staticPageResp) {
//       setState(() {
//         data = staticPageResp.data;
//       });
//     }).catchError((onError) {
//       app.resolve<CustomDialogs>().confirmDialog(
//             context,
//             title: "${widget.screenType} Error",
//             desc: onError.message,
//             positiveBtnTitle: "Try Again",
//           );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     //callApi();
//     return Scaffold(
//         backgroundColor: appTheme.whiteColor,
//         appBar: getAppBar(
//           context,
//           widget.screenTitle ?? getScreenTitle(),
//           leadingButton: widget.isFromDrawer
//               ? getDrawerButton(context, true)
//               : getBackButton(context),
//           actionItems: widget.showExcel
//               ? [
//                   InkWell(
//                     onTap: () async {
//                       await Share.shareFiles([widget.filePath],
//                           text: widget.screenTitle ?? "");
//                     },
//                     child: Container(
//                       margin: EdgeInsets.all(getSize(16)),
//                       child: Image.asset(
//                         share,
//                         width: getSize(24),
//                         height: getSize(24),
//                       ),
//                     ),
//                   )
//                 ]
//               : null,
//         ),
//         body: Container(
//           height: MathUtilities.screenHeight(context),
//           color: ColorConstants.white,
//           padding: EdgeInsets.only(
//             top: getSize(15),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
//               child: WebView(
//                 initialUrl:
//                     // "http://pndevelop.democ.in/",
//                     // "/storage/emulated/0/Download/test.pdf",
//                     widget.strUrl ?? "http://pn`develop.democ.in/",
//                 javascriptMode: JavascriptMode.unrestricted,
//                 onWebViewCreated: (WebViewController webViewController) {
//                   _controller.complete(webViewController);
//                 },
//                 onPageStarted: (String url) {
//                   app.resolve<CustomDialogs>().showProgressDialog(context, "");
//                 },
//                 onPageFinished: (String url) {
//                   print('Page finished loading: $url');
//                   app.resolve<CustomDialogs>().hideProgressDialog();
//                 },
//                 onWebResourceError: (error) {
//                   print(error.toString());
//                 },
//                 gestureNavigationEnabled: true,
//               ),
//             ),
//           ),
//         ));
//   }

// //  _loadHtmlFromAssets(String desc) async {
// //    _controller.loadUrl(Uri.dataFromString(desc,
// //            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
// //        .toString());
// //  }

//   Future<void> loadHtmlFromAssets(String filename, controller) async {
//     String fileText = await rootBundle.loadString(filename);
//     controller.loadUrl(Uri.dataFromString(fileText,
//             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString());
//   }

//   String getScreenTitle() {
//     if (widget.screenType == StaticPageConstant.TERMS_CONDITION) {
//       return R.string.screenTitle.termsAndCondition;
//     } else if (widget.screenType == StaticPageConstant.PRIVACY_POLICY) {
//       return R.string.screenTitle.privacyPolicy;
//     } else if (widget.screenType == StaticPageConstant.ABOUT_US) {
//       return R.string.screenTitle.aboutUS;
//     }
//     /*else if (screenType == StaticPageConstant.CANCELLAION_POLICY) {
//       return "Order Cancel Policy";
//     } else if (screenType == StaticPageConstant.SHIPPING_POLICY) {
//       return "Order Shipping Policy";
//     } else if (screenType == StaticPageConstant.REFUND_POLICY) {
//       return "Order Refund Policy";
//     } else if (screenType == StaticPageConstant.REPAIR_POLICY) {
//       return "Order Repair Policy";
//     } else if (screenType == StaticPageConstant.REPLACEMENT_POLICY) {
//       return "Order Replacement Policy";
//     }*/
//     return "";
//   }
// }
