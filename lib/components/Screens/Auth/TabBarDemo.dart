//import 'package:diamnow/app/app.export.dart';
//import 'package:flutter/material.dart';
//
//class TabBarDemo extends StatefulWidget {
//  static const route = "TabBarDemo";
//
//  @override
//  _TabBarDemoState createState() => _TabBarDemoState();
//}
//
//class _TabBarDemoState extends State<TabBarDemo>
//    with SingleTickerProviderStateMixin {
//  TabController _tabController;
//
//  @override
//  void initState() {
//    _tabController = new TabController(length: 3, vsync: this);
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return AppBackground(
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          TabBar(
//            unselectedLabelColor: Colors.white,
//            labelColor: Colors.amber,
//            tabs: [
//              Tab(text: "images",),
//              Tab(icon: Icon(Icons.chat)),
//              Tab(icon: Icon(Icons.notifications))
//            ],
//            controller: _tabController,
//            indicatorColor: Colors.white,
//            indicatorSize: TabBarIndicatorSize.tab,
//          ),
//          TabBarView(
//            children: [
//              Text("This is call Tab View"),
//              Text("This is chat Tab View"),
//              Text("This is notification Tab View"),
//            ],
//            controller: _tabController,
//          ),
//        ],
//      ),
//    );
//  }
//}


import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';
import 'package:diamnow/app/constant/ColorConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:rxbus/rxbus.dart';
import 'package:webview_flutter/webview_flutter.dart';


class TabBarDemo extends StatefulWidget {
  static const route = "tabBar";

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with SingleTickerProviderStateMixin {
  TabController _controller;
  int _currentIndex = 0;
  FocusNode _focus = new FocusNode();
  final GlobalKey _menuKey = new GlobalKey();
  bool isShowImage = true;
  bool isShowVideo = true;
  bool isShowCertificate = true;
  bool isShowSecondImage = true;
  int totalCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if(isShowImage) {
      totalCount ++;
    }
    if(isShowVideo) {
      totalCount ++;
    }
    if(isShowCertificate) {
      totalCount ++;
    }
    if(isShowSecondImage) {
      totalCount ++;
    }
    _controller = TabController(
      vsync: this,
      length: totalCount,
      initialIndex: 0,
    );
    _controller.addListener(_handleTabSelection);
  }



  _handleTabSelection() {
    setState(() {
      _currentIndex = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
////        flexibleSpace: Container(
////          decoration: BoxDecoration(
//////            borderRadius: BorderRadius.only(
//////                bottomLeft: Radius.circular(getSize(20.0)),
//////                bottomRight: Radius.circular(getSize(20.0))),
////            gradient: LinearGradient(
////              begin: Alignment.topCenter,
////              end: Alignment.bottomCenter,
////              colors: [
////                ColorConstants.colorPrimary,
////                ColorConstants.black
////              ],
////            ),
////          ),
////        ),
////        title: Center(
////          child: DefaultTabController(
////            length: totalCount,
////            child: Column(
////              children: <Widget>[
////                Container(
////                  padding: EdgeInsets.only(
////                    left: getSize(14),
////                  ),
////                  child: TabBar(
////                    isScrollable: true,
////                    controller: _controller,
////                    tabs: <Widget>[
////                      Tab(
////                        child: Text(
////                          "Dictionary",
////                          style: Theme.of(context).textTheme.body1.copyWith(
////                            fontSize: getFontSize(18),
////                            color: ColorConstants.white,
////                          ),
////                        ),
////                      ),
////                      Tab(
////                        child: Text(
////                          "Questions",
////                          style: Theme.of(context).textTheme.body1.copyWith(
////                            fontSize: getFontSize(18),
////                            color: ColorConstants.white,
////                          ),
////                        ),
////                      ),
////                    ],
////                    indicatorColor: ColorConstants.white,
////                    indicatorSize: TabBarIndicatorSize.tab,
////                  ),
////                ),
////              ],
////            ),
////          ),
////        ),
////        bottom: PreferredSize(
////            preferredSize: Size(
////              0,
////              getSize(90.5),
////            ),
////            child: Container(
////              margin: EdgeInsets.only(
////                left: getSize(20.0),
////                right: getSize(20.0),
////                bottom: getSize(20),
////              ),
////              height: getSize(50.0),
////              //width: getSize(335.0),
////              decoration: BoxDecoration(
////                  boxShadow: [
////                    BoxShadow(
////                      color: ColorConstants.white.withOpacity(0.3),
////                      spreadRadius: getSize(5),
////                      blurRadius: getSize(10),
//////                                    offset: Offset(0, 2), // changes position of shadow
////                    ),
////                  ],
//////                        color: Colors.white,
////                  borderRadius:
////                      BorderRadius.all(Radius.circular(getSize(11.0)))),
////              child: Container(
////                //margin: EdgeInsets.only(left: getSize(20.0)),
////                child: CupertinoTextField(
////                  focusNode: _focus,
////                  controller: _searchController,
//////                onChanged: _onChangeHandler,
////                  keyboardType: TextInputType.text,
////                  placeholder: searchLabel,
////                  placeholderStyle: Theme.of(context).textTheme.title.copyWith(
////                        fontSize: getFontSize(16),
////                        color: ColorConstants.colorPrimary,
////                      ),
////                  prefix: Padding(
////                      padding: EdgeInsets.only(left: getSize(16)),
////                      child: Image.asset(
////                        ImageConstant.searchIcon,
////                        color: ColorConstants.colorPrimary,
////                        width: getSize(20),
////                        height: getSize(20),
////                      )),
////                  suffix: Padding(
////                      padding: EdgeInsets.only(right: getSize(18)),
////                      child: InkWell(
////                        onTap: () {
//////                        _searchFocusNode.unfocus();
//////                        _searchController.clear();
//////                        RxBus.post(ChangeUserSearchTextEvent(""),
//////                            tag: Constants.BUS_SEARCH_USER);
////                        },
////                        child: Icon(
////                          Icons.close,
////                          size: getSize(25),
////                          color: ColorConstants.textBlack,
////                        ),
////                      )),
////                ),
////              ),
////            )),
////        shape: RoundedRectangleBorder(
////          borderRadius: BorderRadius.vertical(
////            bottom: Radius.circular(getSize(20)),
////          ),
////        ),
//      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(getSize(20.0)),
                bottomRight: Radius.circular(getSize(20.0))),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorConstants.colorPrimary,
                      ColorConstants.black
                    ],
                  ),
                ),
                child: Center(
                  child: DefaultTabController(
                    length: totalCount,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: getSize(14),
                          ),
                          child: TabBar(
                            isScrollable: true,
                            controller: _controller,
                            tabs: <Widget>[
                             isShowImage ?  Tab(
                                child: Text(
                                  "Image",
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: getFontSize(18),
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ) : SizedBox(),
                             isShowVideo ? Tab(
                                child: Text(
                                  "Questions",
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: getFontSize(18),
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ) : SizedBox(),
                              isShowCertificate ? Tab(
                                child: Text(
                                  "Certificate",
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: getFontSize(18),
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ) : SizedBox(),
                              isShowSecondImage ? Tab(
                                child: Text(
                                  "Images",
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: getFontSize(18),
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ) : SizedBox(),
                            ],
                            indicatorColor: ColorConstants.white,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getSize(18.0),
              ),
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528_960_720.jpg",
                        height: getSize(130),
                        width: getSize(140),
                      ),
                    ),
                    Container(
                      child: FutureBuilder<Widget>(
                          future: getPDFView(context,
                          "http://www.pdf995.com/samples/pdf.pdf",
                            height: getSize(100),
                            width: getSize(100),
                          ),
                          builder: (BuildContext context,
                              AsyncSnapshot<Widget> snapshot) {
                            if (snapshot.hasData)
                              return snapshot.data;

                            return Container(
                              //decoration: decoration,
                              height: getSize(100),
                              width: getSize(100),
                              child: SpinKitFadingCircle(
                                color: ColorConstants.colorPrimary,
                                size: getSize(50),
                              ),
                            );
                          }),
                    ),
                    Container(
                      child: LoginScreen(),
                    ),
                    Container(
                      child: Image.network(
                        "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528_960_720.jpg",
                        height: getSize(130),
                        width: getSize(140),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<WebView> getPDFView(BuildContext context, String url,
      {height = 100.0,
        width = 100.0,
        placeHolderImage,
        fit: BoxFit.contain,
        BoxShape shape}) async {
    String pdfUrl = (url == null || url.length == 0)
        ? ""
        : ((url.startsWith("images") || url.startsWith("/"))
        ? (ApiConstants.imageBaseURL + url)
        : url);

    return WebView(
      initialUrl: googleDocViewURL + pdfUrl,
      onPageStarted: (url) {
        app.resolve<CustomDialogs>().showProgressDialog(context, "");
      },

      onPageFinished: (finish) {
        app.resolve<CustomDialogs>().hideProgressDialog();

      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

}


//http://www.pdf995.com/samples/pdf.pdf