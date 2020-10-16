import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiamondDetailScreen extends StatefulScreenWidget {
  static const route = "Diamond Detail Screen";

  String filterId;
  DiamondModel diamondModel;
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;

  DiamondDetailScreen({Map<String, dynamic> arguments}) {
    this.filterId = arguments["filterId"];
    this.diamondModel = arguments["diamondModel"];
    if (arguments[ArgumentConstant.ModuleType] != null) {
      moduleType = arguments[ArgumentConstant.ModuleType];
    }
  }

  @override
  _DiamondDetailScreenState createState() =>
      _DiamondDetailScreenState(this.diamondModel);
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
  final DiamondModel diamondModel;

  TabController _controller;
  int _currentIndex = 0;
  bool isLoading = true;
  List<BottomTabModel> arrBottomTab;

  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  List<DiamondDetailUIModel> arrDiamondDetailUIModel =
      List<DiamondDetailUIModel>();

  _DiamondDetailScreenState(this.diamondModel);

  //DiamondDetailUIModel

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

    arrBottomTab = BottomTabBar.getDiamondDetailScreenBottomTabs();
    setState(() {
      //
    });

    Config().getDiamonDetailUIJson().then((result) {
      // arrDiamondDetailUIModel = result;
      setupDiamonDetail(result);
    });
  }

  setupDiamonDetail(List<DiamondDetailUIModel> arrModel) {
    // var diamondModel = DiamondModel();
    for (int i = 0; i < arrModel.length; i++) {
      var diamondDetailItem = arrModel[i];
      var diamondDetailUIModel = DiamondDetailUIModel(
          title: diamondDetailItem.title,
          sequence: diamondDetailItem.sequence,
          isExpand: diamondDetailItem.isExpand);

      diamondDetailUIModel.parameters = List<DiamondDetailUIComponentModel>();

      for (DiamondDetailUIComponentModel element
          in diamondDetailItem.parameters) {
        //
        var diamonDetailComponent = DiamondDetailUIComponentModel(
          title: element.title,
          apiKey: element.apiKey,
          sequence: element.sequence,
          isPercentage: element.isPercentage,
        );

        if (isStringEmpty(element.apiKey) == false) {
          dynamic valueElement = diamondModel.toJson()[element.apiKey];
          if (valueElement != null) {
            if (element.apiKey == DiamondDetailUIAPIKeys.pricePerCarat) {
              //
              diamonDetailComponent.value = diamondModel.getPricePerCarat();
            } else if (element.apiKey == DiamondDetailUIAPIKeys.amount) {
              //
              diamonDetailComponent.value = diamondModel.getAmount();
            } else if (valueElement is String) {
              diamonDetailComponent.value = valueElement;
            } else if (valueElement is num) {
              diamonDetailComponent.value = valueElement.toString();
            }
            if (element.isPercentage) {
              diamonDetailComponent.value = "${diamonDetailComponent.value}%";
            }
            diamondDetailUIModel.parameters.add(diamonDetailComponent);
          }
        }
      }
      arrDiamondDetailUIModel.add(diamondDetailUIModel);
    }

    setState(() {
      //
    });
  }

  _handleTabSelection() {
    setState(() {
      isLoading = true;
      _currentIndex = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        R.string().screenTitle.diamondDetail,
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
        actionItems: [
          Padding(
            padding: EdgeInsets.only(right: getSize(20)),
            child: Image.asset(
              share,
              height: getSize(20),
              width: getSize(20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: getSize(20)),
            child: Image.asset(
              notification,
              height: getSize(20),
              width: getSize(20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: getSize(20)),
            child: Image.asset(
              download,
              height: getSize(20),
              width: getSize(20),
            ),
          ),
        ],
      ),
      bottomNavigationBar: getBottomTab(),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                top: getSize(20), left: getSize(20), right: getSize(20)),
            child: Container(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                  //
                  getDiamondDetailComponents(),
                  // getSection("Basic Details"),
                  // SizedBox(
                  //   height: getSize(20),
                  // ),
                  // getGridView(18),
                  // SizedBox(
                  //   height: getSize(38),
                  // ),
                  // getSection("Measurements"),
                  // SizedBox(
                  //   height: getSize(20),
                  // ),
                  // getGridView(15),
                  // SizedBox(
                  //   height: getSize(38),
                  // ),
                  // getSection("Inclusion Details"),
                  // SizedBox(
                  //   height: getSize(20),
                  // ),
                  // getGridView(6),
                  // SizedBox(
                  //   height: getSize(38),
                  // ),
                  // getSection("Other"),
                  // SizedBox(
                  //   height: getSize(20),
                  // ),
                  // getGridView(3),
                  // SizedBox(
                  //   height: getSize(20),
                  // ),
                ],
              ),
            )),
      ),
    );
  }

  Widget getDiamondDetailComponents() {
    //
    return Container(
      child: Column(
        children: [
          for (int i = 0; i < arrDiamondDetailUIModel.length; i++)
            InkWell(
              onTap: () {
                //
                setState(() {
                  arrDiamondDetailUIModel[i].isExpand =
                      !arrDiamondDetailUIModel[i].isExpand;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    // borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(color: appTheme.lightBGColor)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: getSize(20),
                    right: getSize(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: getSize(20),
                          bottom: getSize(20),
                        ),
                        child: Row(
                          children: [
                            getSection(arrDiamondDetailUIModel[i].title),
                            Spacer(),
                            Icon(
                                arrDiamondDetailUIModel[i].isExpand == true
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: appTheme.textColor),
                          ],
                        ),
                      ),
                      arrDiamondDetailUIModel[i].isExpand
                          ? Column(
                              children: [
                                for (int j = 0;
                                    j <
                                        arrDiamondDetailUIModel[i]
                                            .parameters
                                            .length;
                                    j++)
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: getSize(12),
                                        bottom: getSize(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            arrDiamondDetailUIModel[i]
                                                .parameters[j]
                                                .title,
                                            style: appTheme.grey14HintTextStyle
                                                .copyWith(
                                              fontSize: getFontSize(12),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            arrDiamondDetailUIModel[i]
                                                .parameters[j]
                                                .value,
                                            style: appTheme.black14TextStyle
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget getSection(String title) {
    return Text(
      title,
      style: appTheme.blackNormal18TitleColorblack
          .copyWith(fontWeight: FontWeight.w500),
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

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: arrBottomTab,
      onClickCallback: (obj) {
        //
        if (obj.code == BottomCodeConstant.dDEnquiry) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dDAddToCart) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dDAddToWatchlist) {
          //
          print(obj.code);
          // callApiForGetFilterId();
        } else if (obj.code == BottomCodeConstant.dDPlaceOrder) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dDComment) {
          //
          print(obj.code);
        }
      },
    );
  }
}
