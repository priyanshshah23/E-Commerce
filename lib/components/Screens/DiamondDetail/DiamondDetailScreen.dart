import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiamondDetailScreen extends StatefulScreenWidget {
  static const route = "Diamond Detail Screen";

  String filterId;
  DiamondModel diamondModel;
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;

  DiamondDetailScreen({Map<String, dynamic> arguments}) {
    this.filterId = arguments["filterId"];
    this.diamondModel = arguments[ArgumentConstant.DiamondDetail];
    if (arguments[ArgumentConstant.ModuleType] != null) {
      moduleType = arguments[ArgumentConstant.ModuleType];
    }
  }

  @override
  _DiamondDetailScreenState createState() =>
      _DiamondDetailScreenState(this.diamondModel, this.moduleType);
}

class DiamondDetailImagePagerModel {
  String title;
  String url;
  bool isSelected;
  bool isImage;
  bool isVideo;
  int subIndex = 0;

  List<DiamondDetailImagePagerModel> arr = List<DiamondDetailImagePagerModel>();

  DiamondDetailImagePagerModel({
    this.title,
    this.url,
    this.isSelected = false,
    this.isImage = false,
    this.isVideo = false,
    this.subIndex = 0,
    this.arr,
  });
}

class _DiamondDetailScreenState extends StatefulScreenWidgetState
    with SingleTickerProviderStateMixin {
  DiamondModel diamondModel;

  TabController _controller;
  int _currentIndex = 0;
  bool isLoading = true;
  List<BottomTabModel> arrBottomTab;
  DiamondConfig diamondConfig;
  int moduleType;

  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  List<DiamondDetailUIModel> arrDiamondDetailUIModel =
      List<DiamondDetailUIModel>();

  _DiamondDetailScreenState(this.diamondModel, this.moduleType);

  //DiamondDetailUIModel

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setupData();

    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems(isDetail: true);
  }

  setupData() {
    arrImages.add(DiamondDetailImagePagerModel(
        title: "Video",
        url:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        isSelected: true,
        isVideo: true));

    List<DiamondDetailImagePagerModel> arr =
        List<DiamondDetailImagePagerModel>();
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/859019531.jpg",
        isSelected: true,
        isImage: true));

    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/732147891.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/551134751.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/930064101.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/859019531.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/732147891.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/551134751.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/930064101.jpg",
        isSelected: false,
        isImage: true));
    arr.add(DiamondDetailImagePagerModel(
        title: "",
        url:
            "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/859019531.jpg",
        isSelected: false,
        isImage: true));

    arrImages.add(DiamondDetailImagePagerModel(
        title: "Image",
        url:
            "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528_960_720.jpg",
        isSelected: false,
        isImage: true,
        arr: arr));

    arrImages.add(DiamondDetailImagePagerModel(
        title: "H&A",
        url:
            "https://i.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
        isImage: true));
    arrImages.add(DiamondDetailImagePagerModel(
        title: "Certificate",
        url: "http://www.pdf995.com/samples/pdf.pdf",
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
      arrImages = arrImages.map((e) {
        e.isSelected = false;
        return e;
      }).toList();
      arrImages[_currentIndex].isSelected = true;
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
        actionItems: getToolbarItem(),
      ),
      bottomNavigationBar: getBottomTab(),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                top: getSize(20), left: getSize(20), right: getSize(20)),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Container(
                        height: getSize(36),
                        decoration: BoxDecoration(
                            color: appTheme.whiteColor,
                            borderRadius: BorderRadius.circular(getSize(5)),
                            border: Border.all(color: appTheme.colorPrimary)),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            // scrollDirection: Axis.horizontal,
                            children: [
                              for (var i = 0; i < arrImages.length; i++)
                                InkWell(
                                  onTap: () {
                                    _controller.index = i;
                                    _handleTabSelection();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: arrImages[i].isSelected
                                          ? appTheme.colorPrimary
                                          : Colors.transparent,
                                      border: Border(
                                        left: BorderSide(
                                          color: appTheme.colorPrimary,
                                          width: (i == 0)
                                              ? getSize(0)
                                              : getSize(0.5),
                                        ),
                                        right: BorderSide(
                                          color: appTheme.colorPrimary,
                                          width: (i == arrImages.length - 1)
                                              ? getSize(0)
                                              : getSize(0.5),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: getSize(8),
                                          bottom: getSize(8),
                                          left: getSize(20),
                                          right: getSize(20)),
                                      child: Center(
                                        child: Text(
                                          arrImages[i].title,
                                          style: appTheme.black14TextStyle
                                              .copyWith(
                                                  color: arrImages[i].isSelected
                                                      ? appTheme.whiteColor
                                                      : appTheme.colorPrimary),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getSize(20),
                  ),
                  Container(
                    width: double.infinity,
                    height: getSize(366),
                    child: TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        for (var i = 0; i < arrImages.length; i++)
                          getTabBlock(arrImages[i]),
                      ],
                    ),
                  ),
                  //
                  SizedBox(
                    height: getSize(40),
                  ),
                  getDiamondDetailComponents(),
                ],
              ),
            )),
      ),
    );
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
            child: Stack(
              children: [
                FutureBuilder<Widget>(
                    future: getPDFView(context, model),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) return snapshot.data;

                      return Container(
                        color: appTheme.whiteColor,
                      );
                    }),
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
        : Column(
            children: [
              Container(
                height: getSize(300),
                decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(color: appTheme.lightBGColor)),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: getSize(20),
                      bottom: getSize(20),
                      left: getSize(16),
                      right: getSize(16)),
                  child: getImageView(
                    (model.arr != null &&
                            model.arr.length > 0 &&
                            isStringEmpty(model.url) == false)
                        ? model.arr[model.subIndex].url
                        : model.url,
                    height: getSize(260),
                    width: MathUtilities.screenWidth(context),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              SizedBox(
                height: getSize(30),
              ),
              if (model.arr != null && model.arr.length > 0)
                Container(
                  height: getSize(36),
                  child: Row(
                    children: [
                      // Image.asset(
                      //   filterUnionArrow,
                      //   width: getSize(14),
                      //   height: getSize(14),
                      // ),
                      Icon(Icons.chevron_left),
                      SizedBox(
                        width: getSize(8),
                      ),
                      Expanded(
                          child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var i = 0; i < model.arr.length; i++)
                            Padding(
                              padding: EdgeInsets.only(right: getSize(8)),
                              child: InkWell(
                                onTap: () {
                                  //
                                  model.arr = model.arr.map((e) {
                                    e.isSelected = false;
                                    return e;
                                  }).toList();
                                  model.arr[i].isSelected = true;
                                  model.subIndex = i;
                                  setState(() {
                                    //
                                  });
                                },
                                child: Container(
                                  width: getSize(50),
                                  decoration: BoxDecoration(
                                      color: appTheme.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(getSize(5)),
                                      border: Border.all(
                                          color: model.arr[i].isSelected
                                              ? appTheme.colorPrimary
                                              : appTheme.lightBGColor)),
                                  child: Padding(
                                    padding: EdgeInsets.all(getSize(4)),
                                    child: getImageView(
                                      model.arr[i].url,
                                      height: getSize(50),
                                      width: getSize(36),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      )),
                      SizedBox(
                        width: getSize(8),
                      ),
                      // Image.asset(
                      //   filterRightArrow,
                      //   width: getSize(14),
                      //   height: getSize(14),
                      // ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
            ],
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

  Future<WebView> getPDFView(
    BuildContext context,
    DiamondDetailImagePagerModel model,
  ) async {
    String pdfUrl = (model.url == null || model.url.length == 0)
        ? ""
        : ((model.url.startsWith("images") || model.url.startsWith("/"))
            ? (ApiConstants.imageBaseURL + model.url)
            : model.url);

    return WebView(
      initialUrl: (model.isVideo) ? pdfUrl : googleDocViewURL + pdfUrl,
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
      arrBottomTab: diamondConfig.arrBottomTab,
      onClickCallback: (obj) {        //
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
    diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel);
  }
}
