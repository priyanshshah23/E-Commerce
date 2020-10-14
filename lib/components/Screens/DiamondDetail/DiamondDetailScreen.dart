import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiamondDetailScreen extends StatefulScreenWidget {
  static const route = "Diamond Detail Screen";

  String filterId;

  DiamondDetailScreen({Map<String, dynamic> arguments}) {
    this.filterId = arguments["filterId"];
  }

  @override
  _DiamondDetailScreenState createState() => _DiamondDetailScreenState();
}

class DiamondDetailImagePagerModel {
  String title;
  String url;
  bool isImage;

  DiamondDetailImagePagerModel({
    this.title,
    this.url,
    this.isImage,
  });
}

class _DiamondDetailScreenState extends StatefulScreenWidgetState
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _currentIndex = 0;
  bool isLoading = true;

  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    arrImages.add(DiamondDetailImagePagerModel(
        title: "Image",
        url:
            "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528_960_720.jpg",
        isImage: true));
    arrImages.add(DiamondDetailImagePagerModel(
        title: "Questions",
        url: "http://www.pdf995.com/samples/pdf.pdf",
        isImage: false));
    arrImages.add(DiamondDetailImagePagerModel(
        title: "Certificate",
        url:
            "https://i.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
        isImage: true));
    arrImages.add(DiamondDetailImagePagerModel(
        title: "Image",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRnltfxyRHuEEUE4gIZp9fr77Q8goigP7mQ6Q&usqp=CAU",
        isImage: true));
    arrImages.add(DiamondDetailImagePagerModel(
        title: "Certificate",
        url: "http://www.africau.edu/images/default/sample.pdf",
        isImage: false));

    _controller = TabController(
      vsync: this,
      length: arrImages.length,
      initialIndex: 0,
    );
    _controller.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      isLoading = true;
      _currentIndex = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        body: Padding(
            padding: EdgeInsets.only(top: getSize(20)),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: DefaultTabController(
                        length: 0,
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
                                  for (var i = 0; i < arrImages.length; i++)
                                    Tab(
                                      text: arrImages[i].title,
                                    ),
                                ],
                                indicatorColor: appTheme.colorPrimary,
                                indicatorSize: TabBarIndicatorSize.tab,
                                unselectedLabelColor: appTheme.textColor,
                                labelColor: appTheme.colorPrimary,
                                labelStyle: appTheme.black14TextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getSize(10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getSize(300),
                    child: TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        for (var i = 0; i < arrImages.length; i++)
                          arrImages[i].isImage
                              ? Container(
                                  child: getImageView(
                                    arrImages[i].url,
                                    height: getSize(130),
                                    width: getSize(140),
                                  ),
                                )
                              : Container(
                                  child: Stack(
                                    children: [
                                      FutureBuilder<Widget>(
                                          future: getPDFView(
                                            context,
                                            arrImages[i].url,
                                            height: getSize(100),
                                            width: getSize(100),
                                          ),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<Widget> snapshot) {
                                            if (snapshot.hasData)
                                              return snapshot.data;

                                            return Container(
                                              color: appTheme.whiteColor,
                                            );
                                          }),
                                      isLoading
                                          ? Center(
                                              child: SpinKitFadingCircle(
                                                color: appTheme.colorPrimary,
                                                size: getSize(30),
                                              ),
                                            )
                                          : Stack(),
                                    ],
                                  ),
                                ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
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
        // app.resolve<CustomDialogs>().showProgressDialog(context, "");
        setState(() {
          isLoading = true;
        });
      },
      onPageFinished: (finish) {
        // app.resolve<CustomDialogs>().hideProgressDialog();
        setState(() {
          isLoading = false;
        });
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
