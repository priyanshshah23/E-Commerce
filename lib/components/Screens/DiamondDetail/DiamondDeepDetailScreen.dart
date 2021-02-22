import 'dart:collection';
import 'dart:io';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/AnalyticsModel/AnalyticsModel.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/download.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'DiamondImageBrowserScreen.dart';

class DiamondDeepDetailScreen extends StatefulScreenWidget {
  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();
  DiamondModel diamondModel;
  int index;

  DiamondDeepDetailScreen({this.arrImages, this.diamondModel, this.index});

  @override
  _DiamondDeepDetailScreenState createState() => _DiamondDeepDetailScreenState(
      this.arrImages, this.diamondModel, this.index);
}

class _DiamondDeepDetailScreenState extends State<DiamondDeepDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isErroWhileLoading = false;
  DiamondConfig diamondConfig;
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  int index;
  bool isPageLoading = false;
  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();
  WebView webView = WebView();
  DiamondModel diamondModel;

  //new design
  int currTab = 0;
  ItemScrollController _sc = ItemScrollController();
  ScrollController _scrollController1;
  double offSetForTab = 0.0;
  Map<int, double> mapOfInitialPixels = {};
  final _pageController = PageController(viewportFraction: 0.9);
  Dio dio = Dio();

  _DiamondDeepDetailScreenState(this.arrImages, this.diamondModel, this.index);

  TabController _tabController;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // checkWeatherUrlContainsThingsOrNot();

    // });
    // removeNotContainedImages();

    print("------------${arrImages.toList().toString()}");
    _tabController = TabController(length: arrImages.length, vsync: this)
      ..addListener(_setActiveTabIndex);
    if (index != null) {
      currTab = index;
      _tabController.animateTo(index);
    }
    super.initState();
    getPrefixSum();
    getScrollControllerEventListener();

    isErroWhileLoading = false;
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems(isDetail: true);
  }

  void _setActiveTabIndex() {
    currTab = _tabController.index;
    setState(() {});
  }

  // removeNotContainedImages() {
  //   arrImages.forEach((element) {
  //     if(element.arr.length==0){
  //       arrImages.remove(element);
  //     }
  //   });
  // }

  // checkWeatherUrlContainsThingsOrNot() {
  //   checkUrlUsingDio(DiamondDetailImagePagerModel model) async {
  //     await dio.get(model.url).catchError((onError) {
  //       print("=====> ${onError}");
  //       arrImages.remove(model);
  //     });
  //   }

  //   arrImages.forEach((element) {
  //     checkUrlUsingDio(element);
  //   });
  //   setState(() {});
  // }

  //EventListener which listen scroll position, everytime when you scroll.
  getScrollControllerEventListener() {
    _scrollController1 = ScrollController()
      ..addListener(() {
        mapOfInitialPixels.forEach((key, value) {
          if (_scrollController1.position.pixels >= value) {
            currTab = key;
          }
        });
        _sc.scrollTo(index: currTab, duration: Duration(milliseconds: 500));

        setState(() {});
      });
  }

  //sum of prefix pixel for getting scrollposition of each tab.
  getPrefixSum() {
    double value = 0;
    int i, j;
    for (j = 0; j < arrImages.length; j++) {
      value = 0;
      if (j == 0)
        value = 0;
      else {
        for (i = 1; i < arrImages.length; i++) {
          value += getSize(300);

          if (i == j) break;
        }
      }
      mapOfInitialPixels[j] = value;
    }
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        diamondModel.stoneId.toString(),
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
        actionItems: getToolbarItem(),
      ),
      bottomNavigationBar: getBottomTab(),
      body: getDiamondDetailComponents(),
    );
  }

  Widget getDiamondDetailComponents() {
    return Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          controller: _tabController,
          indicatorColor: Colors.transparent,
          onTap: (index) {
            currTab = index;
            setState(() {});
          },
          tabs: getTabs(),
        ),
        SizedBox(
          height: getSize(25),
        ),
        Expanded(
          child: TabBarView(
            children: getChildren(),
            controller: _tabController,
          ),
//          child: ListView.builder(
//            shrinkWrap: true,
//            controller: _scrollController1,
//            itemCount: arrImages.length,
//            itemBuilder: (context, index) {
//              return Padding(
//                padding: EdgeInsets.only(
//                  left: getSize(20),
//                  right: getSize(20),
//                  top: getSize(0),
//                  bottom: getSize(25),
//                ),
//                child: getListViewItem(index),
//              );
//            },
//          ),
        ),
      ],
    );
  }

  getListViewItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              // physics: New,
              // shrinkWrap: true,
              controller: _pageController,
              itemCount: arrImages[index].arr.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    Map<String, dynamic> dict = new HashMap();
                    dict["imageData"] = arrImages[index].arr;
                    NavigationUtilities.pushRoute(
                      DiamondImageBrowserScreen.route,
                      args: dict,
                    );
                  },
                  child: getTabBlock(
                    arrImages[index].arr[i],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  jumpToAnyTabFromTabBarClick(int index) {
    double value = 0;
    int i;
    if (index > 0) {
      for (i = 1; i < arrImages.length; i++) {
        value += getSize(300);

        if (i == index) break;
      }
    }
    _scrollController1.jumpTo(value.toDouble());
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    for (int i = 0; i < diamondConfig.toolbarList.length; i++) {
      var element = diamondConfig.toolbarList[i];
      list.add(InkWell(
        onTap: () {
          manageToolbarClick(element);
        },
        child: Padding(
          padding: EdgeInsets.only(
              right: i == diamondConfig.toolbarList.length - 1
                  ? getSize(Spacing.rightPadding)
                  : getSize(8),
              left: getSize(8.0)),
          child: Image.asset(
            element.image,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
      ));
    }
    return list;
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBShare:
        BottomTabModel tabModel = BottomTabModel();
        tabModel.type = ActionMenuConstant.ACTION_TYPE_SHARE;
        List<DiamondModel> selectedList = [diamondModel];

        diamondConfig.manageDiamondAction(
            context, selectedList, tabModel, () {});
        break;
      case BottomCodeConstant.TBClock:
        break;
      case BottomCodeConstant.TBDownloadView:
        BottomTabModel tabModel = BottomTabModel();
        tabModel.type = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
        List<DiamondModel> selectedList = [diamondModel];

        diamondConfig.manageDiamondAction(
            context, selectedList, tabModel, () {});

        break;
    }
  }

  Widget getTabBlock(DiamondDetailImagePagerModel model) {
    return (model.isImage == false)
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: getSize(354),
                child: FutureBuilder<Widget>(
                    future: getPDFView(context, model),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data;
                      }
                      return Center(
                        child: SpinKitFadingCircle(
                          color: appTheme.colorPrimary,
                          size: getSize(30),
                        ),
                      );
                    }),
              ),
              (isLoading)
                  ? Center(
                      child: SpinKitFadingCircle(
                        color: appTheme.colorPrimary,
                        size: getSize(30),
                      ),
                    )
                  : Container()
            ],
          )
        : Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: getImageView(
                  ((model.arr != null &&
                          model.arr.length > 0 &&
                          isStringEmpty(model.url) == false)
                      ? model.arr[model.subIndex].url
                      : model.url),
                  height: getSize(286),
                  width: MathUtilities.screenWidth(context),
                  fit: BoxFit.fitHeight,
//                  shape: BoxDecoration(
//                    color: appTheme.whiteColor,
//                    // color: Colors.yellow,
//                    borderRadius: BorderRadius.circular(getSize(20)),
//                    border: Border.all(color: appTheme.lightBGColor),
//                  ),
                ),
//                  child: Image.network(
//                    (model.arr != null &&
//                            model.arr.length > 0 &&
//                            isStringEmpty(model.url) == false)
//                        ? model.arr[model.subIndex].url
//                        : model.url,
//                    height: getSize(286),
//                    width: MathUtilities.screenWidth(context),
//                    fit: BoxFit.fitHeight,
//                  ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: getSize(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getImageViewForDownloadAndShare(
                      imageName: share,
                      onTap: () {
                        downloadSingleImage(
                          model.url,
                          model.title +
                              diamondModel.id +
                              "." +
                              getExtensionOfUrl(model.url),
                          isFileShare: true,
                        );
                      },
                    ),
                    SizedBox(
                      width: getSize(10),
                    ),
                    getImageViewForDownloadAndShare(
                      imageName: download,
                      onTap: () {
                        downloadSingleImage(
                          model.url,
                          model.title +
                              diamondModel.id +
                              "." +
                              getExtensionOfUrl(model.url),
                        );
                      },
                    ),
                    SizedBox(
                      width: getSize(10),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget getImageViewForDownloadAndShare({
    @required String imageName,
    @required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getSize(5)),
            border: Border.all(color: appTheme.borderColor),
            color: appTheme.unSelectedBgColor),
        child: Padding(
          padding: EdgeInsets.all(getSize(10)),
          child: Image.asset(
            imageName,
            height: getSize(16),
            width: getSize(16),
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<File> downloadSingleImage(
    String url,
    String filename, {
    bool isFileShare = false,
  }) async {
    final dir = await getDownloadDirectory();
    final savePath = path.join(dir.path, filename);

    Dio dio = Dio();

    dio
        .download(
      url,
      savePath,
      deleteOnError: true,
    )
        .then((value) {
      if (value.statusCode == successStatusCode) {
        if (Platform.isIOS) {
          isImage(savePath)
              ? GallerySaver.saveImage(savePath)
              : GallerySaver.saveVideo(savePath);
        }
        if (isFileShare) {
          Share.shareFiles([savePath], text: 'Great picture');
          AnalyticsReport.shared.sendAnalyticsData(
            buildContext: context,
            page: PageAnalytics.OFFLINE_DOWNLOAD,
            section: SectionAnalytics.SHARE,
            action: ActionAnalytics.OPEN,
          );
        }
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.OFFLINE_DOWNLOAD,
          section: SectionAnalytics.DOWNLOAD,
          action: ActionAnalytics.OPEN,
        );
        showToast(
          "Download complete",
          context: context,
        );
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getExternalStorageDirectory();
  }

  Future<WebView> getPDFView(
    BuildContext context,
    DiamondDetailImagePagerModel model,
  ) async {
    // if (!model.isImage) print(model.url);
    return webView = WebView(
        initialUrl: model.url,
        onPageStarted: (url) {
          isPageLoading = true;
          // app.resolve<CustomDialogs>().showProgressDialog(context, "");
          setState(() {
            isLoading = true;
          });
        },
        onPageFinished: (finish) {
          // app.resolve<CustomDialogs>().hideProgressDialog();
          if (!isPageLoading) {
            webView.onPageStarted(model.url);
          } else {
            isLoading = false;
            setState(() {});
          }
        },
        onWebResourceError: (error) {
          print(error);
          setState(() {
            isErroWhileLoading = true;
          });
        },
        javascriptMode: JavascriptMode.unrestricted);
  }

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: diamondConfig.arrBottomTab,
      onClickCallback: (obj) {
        //
        if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
          showBottomSheetForMenu(context, diamondConfig.arrMoreMenu,
              (manageClick) {
            manageBottomMenuClick(manageClick.bottomTabModel);
          }, R.string.commonString.more, isDisplaySelection: false);
        } else {
          manageBottomMenuClick(obj);
        }
      },
    );
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList = [];
    selectedList.add(diamondModel);
    diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel,
        () {
      Navigator.pop(context, true);
    }, moduleType: moduleType);
  }

  List<Widget> getTabs() {
    List<Widget> list = [];
    for (int i = 0; i < arrImages.length; i++) {
      list.add(Tab(
        child: Column(
          children: [
            Text(
              arrImages[i].title,
              style: appTheme.blackNormal18TitleColorblack,
            ),
            currTab == i
                ? Padding(
                    padding: EdgeInsets.only(top: getSize(8)),
                    child: Container(
                      width: getSize(50),
                      height: getSize(3),
                      decoration: BoxDecoration(
                        color: appTheme.colorPrimary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3)),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ));
    }
    return list;
  }

  getChildren() {
    List<Widget> list = [];
    for (int i = 0; i < arrImages.length; i++) {
      list.add(Padding(
        padding: EdgeInsets.only(
          left: getSize(20),
          right: getSize(20),
          top: getSize(0),
          bottom: getSize(25),
        ),
        child: getListViewItem(i),
      ));
    }
    return list;
  }
}
