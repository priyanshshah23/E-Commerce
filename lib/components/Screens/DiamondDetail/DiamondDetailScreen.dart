import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
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

class _DiamondDetailScreenState extends State<DiamondDetailScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DiamondDetailScreen> {
  final DiamondModel diamondModel;

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
    List<DiamondDetailImagePagerModel> arrOfImages =
        List<DiamondDetailImagePagerModel>();

    if (diamondModel.pltFile) {
      arrOfImages.add(
        DiamondDetailImagePagerModel(
          title: "Plotting",
          url: DiamondUrls.plotting + diamondModel.vStnId + ".jpg",
          isSelected: false,
          isImage: true,
        ),
      );
    }

    if (diamondModel.img) {
      arrOfImages.add(
        DiamondDetailImagePagerModel(
          title: "Image",
          url: DiamondUrls.image + diamondModel.vStnId + ".jpg",
          isSelected: true,
          isImage: true,
        ),
      );
    }

    if (diamondModel.arrowFile) {
      arrOfImages.add(
        DiamondDetailImagePagerModel(
          title: "ArrowImage",
          url: DiamondUrls.arroImage + diamondModel.vStnId + ".jpg",
          isSelected: false,
          isImage: true,
        ),
      );
    }

    print("ArrowImage     " +
        DiamondUrls.arroImage +
        diamondModel.vStnId +
        ".jpg");

    if (diamondModel.img) {
      arrImages.add(
        DiamondDetailImagePagerModel(
            title: "Image",
            url: DiamondUrls.image + diamondModel.vStnId + ".jpg",
            isSelected: true,
            isImage: true,
            arr: arrOfImages),
      );
    }
    print("Image    " + DiamondUrls.image + diamondModel.vStnId + ".jpg");

    if (diamondModel.videoFile) {
      arrImages.add(
        DiamondDetailImagePagerModel(
          title: "Video",
          url: DiamondUrls.video + diamondModel.vStnId + ".html",
          isSelected: false,
          isVideo: true,
        ),
      );
    }

    print("Video    " + DiamondUrls.video + diamondModel.vStnId + ".html");

    if (diamondModel.hAFile) {
      arrImages.add(
        DiamondDetailImagePagerModel(
          title: "H&A",
          url: DiamondUrls.heartImage + diamondModel.vStnId + ".jpg",
          isSelected: false,
          isImage: true,
        ),
      );
    }
    print("H&A    " + DiamondUrls.heartImage + diamondModel.vStnId + ".jpg");

    if (diamondModel.certFile) {
      arrImages.add(
        DiamondDetailImagePagerModel(
          title: "Certificate",
          url: DiamondUrls.certificate + diamondModel.vStnId + ".jpg",
          isSelected: false,
          isImage: true,
        ),
      );
    }

    print("Certificate    " +
        DiamondUrls.certificate +
        diamondModel.vStnId +
        ".jpg");

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

      setState(() {
        setupDiamonDetail(result);
      });
    });
  }

  setupDiamonDetail(List<DiamondDetailUIModel> arrModel) {
    for (int i = 0; i < arrModel.length; i++) {
      var diamondDetailItem = arrModel[i];
      var diamondDetailUIModel = DiamondDetailUIModel(
          title: diamondDetailItem.title,
          sequence: diamondDetailItem.sequence,
          isExpand: diamondDetailItem.isExpand,
          columns: diamondDetailItem.columns,
          orientation: diamondDetailItem.orientation);

      diamondDetailUIModel.parameters = List<DiamondDetailUIComponentModel>();

      for (DiamondDetailUIComponentModel element
          in diamondDetailItem.parameters) {
        //
        if (element.isActive) {
          var diamonDetailComponent = DiamondDetailUIComponentModel(
            title: element.title,
            apiKey: element.apiKey,
            sequence: element.sequence,
            isPercentage: element.isPercentage,
            isActive: element.isActive,
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
      }

      //sort list according to sequence.
      // diamondDetailUIModel.parameters.sort((model1, model2) {
      //   return model1.sequence.compareTo(model2.sequence);
      // });

      arrDiamondDetailUIModel.add(diamondDetailUIModel);
    }
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
    super.build(context);
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
                    // color: Colors.yellow,
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
                  SizedBox(
                    height: getSize(20),
                  ),
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
                height: getSize(16),
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
                          ),
                        ),
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
                    )),
            ],
          );
  }

  //will show all tabs.
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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: getSize(20),
                        bottom: getSize(20),
                        left: getSize(8),
                        right: getSize(8),
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
                        ? getDiamondDetailUIComponent(
                            arrDiamondDetailUIModel[i])
                        : SizedBox(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget getDiamondDetailUIComponent(
      DiamondDetailUIModel diamondDetailUIModel) {
    if (diamondDetailUIModel.columns == 1) {
      return Column(
        children: [
          for (int j = 0; j < diamondDetailUIModel.parameters.length; j++)
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                  top: getSize(12),
                  bottom: getSize(12),
                ),
                child: Row(
                  children: [
                    Text(
                      diamondDetailUIModel.parameters[j].title,
                      style: appTheme.grey14HintTextStyle.copyWith(
                        fontSize: getFontSize(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Text(
                      diamondDetailUIModel.parameters[j].value,
                      style: appTheme.black14TextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    } else {
      num spacing = 0;
      if (diamondDetailUIModel.orientation == "horizontal" &&
          diamondDetailUIModel.columns == 2) {
        spacing = 500;
      } else if (diamondDetailUIModel.orientation == "vertical" &&
          diamondDetailUIModel.columns == 2) {
        spacing = 470;
      } else {
        spacing = 400;
      }

      var size = MediaQuery.of(context).size;
      final double itemHeight = (size.height - kToolbarHeight - spacing) / 2;
      final double itemWidth = size.width / 2;

      return GridView.count(
        shrinkWrap: true,
        primary: false,
        childAspectRatio: (itemWidth / itemHeight),
        // padding: EdgeInsets.all(getSize(2)),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: diamondDetailUIModel.columns,
        children: List.generate(
          diamondDetailUIModel.parameters.length,
          (index) {
            return Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(color: appTheme.borderColor),
                  color: appTheme.unSelectedBgColor,
                ),
                child: diamondDetailUIModel.orientation == "horizontal" &&
                        diamondDetailUIModel.columns == 2
                    ? Padding(
                        padding: EdgeInsets.all(getSize(8)),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                diamondDetailUIModel.parameters[index].title,
                                textAlign: TextAlign.left,
                                style: appTheme.grey14HintTextStyle,
                              ),
                            ),
                            SizedBox(width: getSize(8)),
                            Text(
                              diamondDetailUIModel.parameters[index].value,
                              textAlign: TextAlign.right,
                              style: appTheme.blackNormal12TitleColorblack,
                            )
                          ],
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            diamondDetailUIModel.parameters[index].title,
                            textAlign: TextAlign.center,
                            style: appTheme.grey12TextStyle,
                          ),
                          SizedBox(
                            height: getSize(8),
                          ),
                          Text(
                            diamondDetailUIModel.parameters[index].value,
                            textAlign: TextAlign.center,
                            style: appTheme.blackNormal14TitleColorblack,
                          )
                        ],
                      ));
          },
        ),
      );
    }
    // else if (diamondDetailUIModel.columns == 3) {
    //   return Wrap(
    //     spacing: 8,
    //     runSpacing: 8,
    //     children: List.generate(
    //       diamondDetailUIModel.parameters.length,
    //       (index) {
    //         return Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(3.0),
    //             border: Border.all(color: appTheme.borderColor),
    //             color: appTheme.unSelectedBgColor,
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(12.0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 Text(
    //                   diamondDetailUIModel.parameters[index].title,
    //                   textAlign: TextAlign.center,
    //                   style: appTheme.grey14HintTextStyle,
    //                 ),
    //                 SizedBox(
    //                   height: getSize(2),
    //                 ),
    //                 Text(
    //                   diamondDetailUIModel.parameters[index].value,
    //                   textAlign: TextAlign.center,
    //                   style: appTheme.blackNormal12TitleColorblack,
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   );
    // }
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
    diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel);
  }
}
