import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiamondDeepDetailScreen extends StatefulScreenWidget {
  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();
  DiamondModel diamondModel;

  DiamondDeepDetailScreen({this.arrImages, this.diamondModel});

  @override
  _DiamondDeepDetailScreenState createState() =>
      _DiamondDeepDetailScreenState(this.arrImages, this.diamondModel);
}

class _DiamondDeepDetailScreenState extends State<DiamondDeepDetailScreen> {
  bool isLoading = true;
  bool isErroWhileLoading = false;
  DiamondConfig diamondConfig;
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;

  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  DiamondModel diamondModel;

  //new design
  int currTab = 0;
  ItemScrollController _sc = ItemScrollController();
  ScrollController _scrollController1;
  double offSetForTab = 0.0;
  Map<int, double> mapOfInitialPixels = {};
  final _pageController = PageController(viewportFraction: 0.9);

  _DiamondDeepDetailScreenState(this.arrImages, this.diamondModel);

  @override
  void initState() {
    super.initState();
    getPrefixSum();
    getScrollControllerEventListener();

    isErroWhileLoading = false;
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems(isDetail: true);
  }

  //EventListener which listen scroll position, everytime when you scroll.
  getScrollControllerEventListener() {
    _scrollController1 = ScrollController()
      ..addListener(() {
        mapOfInitialPixels.forEach((key, value) {
          if (_scrollController1.position.pixels >= value) {
            currTab = key;
          }
        });
        _sc.jumpTo(index: currTab);

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
    mapOfInitialPixels.forEach((key, value) {
      print("${key} => ${value}");
    });
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
        Container(
          margin: EdgeInsets.only(
              left: getSize(20),
              right: getSize(20),
              top: getSize(0),
              bottom: getSize(0)),
          height: getSize(52),
          child: ScrollablePositionedList.builder(
            itemScrollController: _sc,
            scrollDirection: Axis.horizontal,
            itemCount: arrImages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(right: getSize(30)),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      jumpToAnyTabFromTabBarClick(index);
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        arrImages[index].title,
                        style: appTheme.blackNormal18TitleColorblack,
                      ),
                      index == currTab
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
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: getSize(25),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController1,
            itemCount: arrImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: getSize(20),
                  right: getSize(20),
                  top: getSize(0),
                  bottom: getSize(25),
                ),
                child: getListViewItem(index),
              );
            },
          ),
        ),
      ],
    );
  }

  getListViewItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          arrImages[index].title,
          style: appTheme.blackMedium16TitleColorblack,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(top: getSize(10)),
          height: getSize(245),
          child: PageView.builder(
            // physics: New,
            // shrinkWrap: true,
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: arrImages[index].arr.length,
            itemBuilder: (BuildContext context, int i) {
              return getTabBlock(arrImages[index].arr[i]);
            },
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
    diamondConfig.toolbarList.forEach((element) {
      list.add(GestureDetector(
        onTap: () {
          manageToolbarClick(element);
        },
        child: Padding(
          padding: EdgeInsets.all(getSize(8.0)),
          child: Image.asset(
            element.image,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
      ));
    });
    return list;
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBShare:
        break;
      case BottomCodeConstant.TBClock:
        break;
      case BottomCodeConstant.TBDownloadView:
        break;
    }
  }

  Widget getTabBlock(DiamondDetailImagePagerModel model) {
    return (model.isImage == false)
        ? Container(
            height: getSize(245),
            width: getSize(354),
            child: Stack(
              children: [
                FutureBuilder<Widget>(
                    future: getPDFView(context, model),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) return snapshot.data;

                      return Container(
                        color: appTheme.whiteColor,
                        child: Image.asset(splashLogo),
                      );
                    }),
                // !isErroWhileLoading ?Icon(Icons.title) :SizedBox(),
                if (isLoading)
                  Center(
                    child: SpinKitFadingCircle(
                      color: appTheme.colorPrimary,
                      size: getSize(30),
                    ),
                  ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(right: getSize(10)),
            child: getImageView(
                (model.arr != null &&
                        model.arr.length > 0 &&
                        isStringEmpty(model.url) == false)
                    ? model.arr[model.subIndex].url
                    : model.url,
                height: getSize(245),
                width: getSize(354),
                fit: BoxFit.fill,
                shape: BoxDecoration(
                    color: appTheme.whiteColor,
                    // color: Colors.yellow,
                    borderRadius: BorderRadius.circular(getSize(20)),
                    border: Border.all(color: appTheme.lightBGColor))),
          );
  }

  Future<WebView> getPDFView(
    BuildContext context,
    DiamondDetailImagePagerModel model,
  ) async {
    // if (!model.isImage) print(model.url);
    return WebView(
        initialUrl: model.url,
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
          }, R.string().commonString.more, isDisplaySelection: false);
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
}
