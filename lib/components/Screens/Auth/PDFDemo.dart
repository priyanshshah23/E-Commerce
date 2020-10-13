//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:url_launcher/url_launcher.dart';
//
//
//
//class MyHomePage extends StatefulWidget {
//  static const route = "MyHomePage";
//
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  NewWeb createState() => NewWeb();
//}
//
//class NewWeb extends State<MyHomePage> {
//  String selectedUrl;
//
//  //String url = 'http://listeningpostdelhilg.in/AuPages/DashBoard/PendencyAgeWiseMobileApp.aspx?Q_usertype=4&Q_repoffid=0&Q_mpmlaid=&Q_Deptcode=92&Q_UserTypeCat=&Q_divid=&Q_chk_checked=&Q_minid=0&Q_userid=hodrev&Q_Secretkey=QXl1c2hQcmF2ZWVuTWFuaW5kcmFOaWNAMTIz';
//  final webview = FlutterWebviewPlugin();
//  StreamSubscription<String> _onWebViewUrlChanged;
//
//
//  @override
//  void dispose() {
//// TODO: implement dispose
//    webview.dispose();
//    super.dispose();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _getUserPreferenceData();
//    _onWebViewUrlChanged = FlutterWebviewPlugin().onUrlChanged.listen((String url) {
//      if (url.contains('.pdf')) {
//        launchURL(url);
//      }
//    });
//    // webview.close();
//// TODO: implement initState
//
//  }
//  Future _getUserPreferenceData() async {
//
//    setState(() {
//      selectedUrl = 'http://www.pdf995.com/samples/pdf.pdf';
//    });
//
//  }
//// selected URL : http://listeningpostdelhilg.in/lgservice.asmx/PendencyAgeWiseMobileApp?
//  @override
//  Widget build(BuildContext context) {
//// TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(" Dashboard"),
//      ),
//
//      body: Container(
//        child: selectedUrl == ""
//            ? Center(
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation(Colors.blue),
//                  strokeWidth: 5.0)
//            ],
//          ),
//        )
//            : WebviewScaffold(
//          url: selectedUrl,
//// url: 'http://listeningpostdelhilg.in/AuPages/DashBoard/PendencyAgeWiseMobileApp.aspx?Q_usertype=4&Q_repoffid=0&Q_mpmlaid=&Q_Deptcode=92&Q_UserTypeCat=&Q_divid=&Q_chk_checked=&Q_minid=0&Q_userid=hodrev&Q_Secretkey=QXl1c2hQcmF2ZWVuTWFuaW5kcmFOaWNAMTIz',
//          withJavascript: true,
//          withLocalStorage: true,
//          withZoom: true,
//          appCacheEnabled: true,
//          clearCookies: true,
//          clearCache: true,
//          allowFileURLs: true,
//          initialChild: Container(
//            color: Colors.white,
//            child: const Center(
//              child: Text(
//                'Loading......',
//                style: TextStyle(color: Colors.black),
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//    return null;
//  }
//  void launchURL(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
//}