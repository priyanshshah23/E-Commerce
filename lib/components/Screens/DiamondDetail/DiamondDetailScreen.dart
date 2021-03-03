import 'dart:async';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/carousel/carousel_pro.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDeepDetailScreen.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/FlutterVideoPlayer/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:diamnow/components/widgets/FlutterVideoPlayer/feed_player/multi_manager/flick_multi_player.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondDetail/DiamondJourney.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widgets/flutter_widgets.dart' as futterWidget;
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiamondDetailScreen extends StatefulScreenWidget {
  static const route = "/DiamondDetailScreen";

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
  _DiamondDetailScreenState createState() => _DiamondDetailScreenState(
        this.diamondModel,
        this.moduleType,
      );
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
  PageController _controller = PageController();
  TabController _tabController;
  int _currentIndex = 0;
  bool isLoading = true;
  bool isErroWhileLoading = false;
  DiamondConfig diamondConfig;
  int moduleType;
  List<DiamondJourneyModel> diamondJourneyModel = [];
  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  List<DiamondDetailImagePagerModel> arrImagesOrCerificate =
      List<DiamondDetailImagePagerModel>();
  final Completer<WebViewController> _webController =
      Completer<WebViewController>();

  List<DiamondDetailUIModel> arrDiamondDetailUIModel =
      List<DiamondDetailUIModel>();
  FlickMultiManager flickMultiManager;

  _DiamondDetailScreenState(this.diamondModel, this.moduleType);

  //new design
  int currTab = 0;
  ItemScrollController _sc = ItemScrollController();
  ScrollController _scrollController1;
  double offSetForTab = 0.0;
  Map<int, double> mapOfInitialPixels = {};
  Dio dio = Dio();
  bool imageFlag = false;
  bool videoFlag = false;
  double height = 100;
  ScreenshotCallback screenshotCallback = ScreenshotCallback();
  List<TabTitle> tabList;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
    diamondJourneyModel = DiamondJourneyModel.getDiamondJourneyData;

    setupData();
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems(isDetail: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkWeatherUrlContainsThingsOrNot();
      getScrollControllerEventListener();

      isErroWhileLoading = false;
      SyncManager.instance.callAnalytics(
        context,
        page: PageAnalytics.DIAMOND_DETAIL,
        section: SectionAnalytics.VIEW,
        action: ActionAnalytics.OPEN,
        dict: {
          "id": this.diamondModel.id ?? "",
          "userId": app.resolve<PrefUtils>().getUserDetails().id ?? ""
        },
      );

      screenshotCallback.addListener(
        () {
          SyncManager.instance.callAnalytics(
            context,
            page: PageAnalytics.DIAMOND_DETAIL,
            section: SectionAnalytics.VIEW,
            action: ActionAnalytics.OPEN,
            dict: {
              "id": this.diamondModel.id ?? "",
              "userId": app.resolve<PrefUtils>().getUserDetails().id ?? "",
              "action": "SCREENSHOT_TAKEN_BY_USER"
            },
          );
        },
      );
    });
    // checkWeatherUrlContainsThingsOrNot();
  }

  checkWeatherUrlContainsThingsOrNot() {
    arrImagesOrCerificate.forEach((element) {
      element.arr.forEach((element1) {
        checkUrlUsingDio(element, element1);
      });

      // checkUrlUsingDio(element);
    });
  }

  checkUrlUsingDio(DiamondDetailImagePagerModel mainModel,
      DiamondDetailImagePagerModel model) async {
    await dio.get(model.url).then((value) {
      if (imageFlag == false) {
        if (mainModel.title.toLowerCase() == "image") {
          setState(() {
            imageFlag = true;
          });
        }
      }
      if (videoFlag == false) {
        if (mainModel.title.toLowerCase() == "video") {
          setState(() {
            videoFlag = true;
          });
        }
      }
    }).catchError((onError) {
      // print("=====> ${onError}");

      mainModel.arr.remove(model);
      if (mainModel.arr.length == 0) {
        arrImages.remove(mainModel);
      }

      // arrImages.remove(model);
    });
  }

  //EventListener which listen scroll position, everytime when you scroll.
  getScrollControllerEventListener() {
    _scrollController1 = ScrollController()
      ..addListener(() {
        offSetForTab = _scrollController1.position.pixels ?? 0.0;
        mapOfInitialPixels.forEach((key, value) {
          if (_scrollController1.position.pixels >= value) {
            currTab = key;
          }
        });
        if (_scrollController1.position.pixels >= getSize(400.0)) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _sc.scrollTo(index: currTab, duration: Duration(milliseconds: 500));
          });
        }

        setState(() {});
      });
  }

  //sum of prefix pixel for getting scrollposition of each tab.
  getPrefixSum() {
    double value = 0;
    int i, j;
    for (j = 0; j < arrDiamondDetailUIModel.length; j++) {
      value = 0;
      for (i = 0; i < arrDiamondDetailUIModel.length; i++) {
        value += i == 0
            ? getSize(302)
            : arrDiamondDetailUIModel[i - 1].columns > 1
                ? ((arrDiamondDetailUIModel[i - 1].parameters.length /
                                arrDiamondDetailUIModel[i - 1].columns)
                            .floor()) *
                        getSize(90) +
                    getSize(175)
                : ((arrDiamondDetailUIModel[i - 1].parameters.length /
                                arrDiamondDetailUIModel[i - 1].columns)
                            .floor()) *
                        getSize(34) +
                    getSize(173);
        if (i == j) break;
      }
      mapOfInitialPixels[j] = value;
    }
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    super.dispose();
  }

  setupData() {
    //List of Images
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.faceUpImg + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.heartImage + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.arroImage + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.assetImage + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: false,
        url: DiamondUrls.plotting + widget.diamondModel.rptNo + ".gif",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.darkFieldImg + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.idealScopeImg + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        isImage: true,
        url: DiamondUrls.flouresenceImg + widget.diamondModel.vStnId + ".jpg",
        isSelected: true,
      ),
    );

    List<DiamondDetailImagePagerModel> arrOfImages =
        List<DiamondDetailImagePagerModel>();

// Dio()
//     .get(
//       DiamondUrls.image + diamondModel.vStnId + "/" + "still.jpg",
//     )
//     .then(
//       (value) => print(value.toString()),
//     ).catchError((error){
//       print(error);
//     });

// if (diamondModel.img) {
    arrOfImages.add(
      DiamondDetailImagePagerModel(
        title: "Image",
        url: DiamondUrls.image + diamondModel.vStnId + ".jpg",
        isSelected: true,
        isImage: true,
      ),
    );
// }

// print(DiamondUrls.image + diamondModel.vStnId + "/" + "still.jpg");
// if (diamondModel.arrowFile) {
    arrOfImages.add(
      DiamondDetailImagePagerModel(
        title: "ArrowImage",
        url: DiamondUrls.arroImage +
            diamondModel.vStnId +
            "/" +
            "Arrow_Black_BG.jpg",
        isSelected: false,
        isImage: true,
      ),
    );
// }

// if (diamondModel.assetFile) {
    arrOfImages.add(
      DiamondDetailImagePagerModel(
        title: "AssetImage",
        url: DiamondUrls.image +
            diamondModel.vStnId +
            "/" +
            "Office_Light_Black_BG.jpg",
        isSelected: false,
        isImage: true,
      ),
    );
// }

// if (diamondModel.img) {
    arrImagesOrCerificate.add(
      DiamondDetailImagePagerModel(
          title: "Image",
          url: DiamondUrls.image + diamondModel.vStnId + ".jpg",
          isSelected: true,
          isImage: true,
          arr: arrOfImages),
    );
// }

//list of videofile
    List<DiamondDetailImagePagerModel> arrOfVideos =
        List<DiamondDetailImagePagerModel>();

// if (diamondModel.videoFile) {
    arrOfVideos.add(
      DiamondDetailImagePagerModel(
        title: "Video",
        url: DiamondUrls.video +
            diamondModel.vStnId +
            "/" +
            diamondModel.vStnId +
            ".html",
        isSelected: true,
        isVideo: true,
      ),
    );
// }

// if (diamondModel.roughVdo) {
//   arrOfVideos.add(
//     DiamondDetailImagePagerModel(
//       title: "RoughVideo",
//       url: DiamondUrls.roughVideo + diamondModel.vStnId + ".html",
//       isSelected: false,
//       isVideo: true,
//     ),
//   );
// }

// if (diamondModel.polVdo) {
//   arrOfVideos.add(
//     DiamondDetailImagePagerModel(
//       title: "PolishVideo",
//       url: DiamondUrls.polVideo + diamondModel.vStnId + ".mp4",
//       isSelected: false,
//       isVideo: true,
//     ),
//   );
// }

// if (diamondModel.videoFile) {
    arrImagesOrCerificate.add(
      DiamondDetailImagePagerModel(
        title: "Video",
        url: DiamondUrls.video +
            diamondModel.vStnId +
            "/" +
            diamondModel.vStnId +
            ".html",
        isSelected: true,
        isVideo: true,
        arr: arrOfVideos,
      ),
    );
// }

//List of H&A
    List<DiamondDetailImagePagerModel> arrOfHA =
        List<DiamondDetailImagePagerModel>();

// if (diamondModel.hAFile) {
    arrOfHA.add(
      DiamondDetailImagePagerModel(
        title: "H&A",
        url: DiamondUrls.heartImage +
            diamondModel.vStnId +
            "/" +
            "Heart_Black_BG.jpg",
        isSelected: true,
        isImage: true,
      ),
    );
// }

// if (diamondModel.hAFile) {
    arrImagesOrCerificate.add(
      DiamondDetailImagePagerModel(
        title: "H&A",
        url: DiamondUrls.heartImage +
            diamondModel.vStnId +
            "/" +
            "Heart_Black_BG.jpg",
        isSelected: false,
        isImage: true,
        arr: arrOfHA,
      ),
    );
// }

//List of certificate
    List<DiamondDetailImagePagerModel> arrOfCertificates =
        List<DiamondDetailImagePagerModel>();

// if (diamondModel.certFile) {
    arrOfCertificates.add(
      DiamondDetailImagePagerModel(
        title: "Certificate",
        url: ApiConstants.googleDocUrl +
            DiamondUrls.certificate +
            diamondModel.rptNo +
            ".pdf",
        isSelected: true,
        isImage: false,
      ),
    );
// }
// print(ApiConstants.googleDocUrl +
//     DiamondUrls.certificate +
//     diamondModel.rptNo +
//     ".pdf");
// if (diamondModel.certFile) {
    arrImagesOrCerificate.add(
      DiamondDetailImagePagerModel(
          title: "Certificate",
          url: ApiConstants.googleDocUrl +
              DiamondUrls.certificate +
              diamondModel.rptNo +
              ".pdf",
          isSelected: false,
          isImage: false,
          arr: arrOfCertificates),
    );
// }
    setState(() {});

    Config().getDiamonDetailUIJson().then((result) {
      setState(() {
        setupDiamonDetail(result);
        getPrefixSum();
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
            } else {
              diamonDetailComponent.value = "-";
            }
            diamondDetailUIModel.parameters.add(diamonDetailComponent);
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

  @override
  Widget build(BuildContext context) {
    setPages();
    super.build(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: appTheme.whiteColor,
          appBar: getAppBar(
            context,
            R.string.screenTitle.diamondDetail,
            bgColor: appTheme.whiteColor,
            leadingButton: getBackButton(context),
            centerTitle: false,
            actionItems: getToolbarItem(),
          ),
          bottomNavigationBar: getBottomTab(),
          body: SingleChildScrollView(child: getDiamondDetailComponents()),
        ),
        (app.resolve<PrefUtils>().isDisplayedTour(PrefUtils().keyDiamondDetailTour) ==
                false)
            ? OverlayScreen(
                DiamondModuleConstant.MODULE_TYPE_DIAMOND_DETAIL,
                finishTakeTour: () {
                  setState(() {});
                },
                scrollIndex: (index) {},
              )
            : SizedBox(),
      ],
    );
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    for (int i = 0; i < diamondConfig.toolbarList.length; i++) {
      var element = diamondConfig.toolbarList[i];
      list.add(
        GestureDetector(
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
        ),
      );
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
            context, selectedList, tabModel, () {},isFromDetailScreen: true);
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

  Widget getImage() {
    for (var model in arrImages) {
      if (model.title == "Image" && imageFlag) {
        return getImageView(
          model.url,
          height: getSize(286),
          width: MathUtilities.screenWidth(context),
          fit: BoxFit.fitHeight,
        );
      } else if (model.title == "Certificate" ||
          (model.title == "Video" && videoFlag)) {
        return Stack(
          children: [
            FutureBuilder<Widget>(
              future: getPDFView(context, model),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) return snapshot.data;
                return Container(
                  color: appTheme.whiteColor,
                  child: Image.asset(splashLogo),
                );
              },
            ),
            // !isErroWhileLoading ?Icon(Icons.title) :SizedBox(),
            if (isLoading)
              Center(
                child: SpinKitFadingCircle(
                  color: appTheme.colorPrimary,
                  size: getSize(30),
                ),
              ),
          ],
        );
      }
    }
  }

  setPages() {
    tabList = [
      new TabTitle(
        'Diamond Details',
        0,
        isSelected: true,
      ),
      new TabTitle(
        'Diamond Journey',
        1,
      ),
    ];
  }

  Widget getDiamondDetailComponents() {
    return !isNullEmptyOrFalse((arrDiamondDetailUIModel))
        ? Column(
            children: [
              /* ListView.builder(
              controller: _scrollController1,
              padding: EdgeInsets.only(
                bottom: getSize(20),
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: arrDiamondDetailUIModel.length,
              itemBuilder: (context, index) {
                if (index == 0)
                  return !isNullEmptyOrFalse(arrImages)
                      ? Column(
                          children: [
                            InkWell(
                              onTap: () {
                                NavigationUtilities.push(
                                  DiamondDeepDetailScreen(
                                    arrImages: arrImages,
                                    diamondModel: diamondModel,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
//                                    color: appTheme.lightColorPrimary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: appTheme.shadowColor,
                                      blurRadius: getSize(25),
                                      spreadRadius: getSize(5),
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                height: getSize(286),
                                child: getSlider(),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: getSize(18),
                                top: getSize(30),
                                bottom: getSize(10),
                                left: getSize(18),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  imageFlag
                                      ? commonImageView(
                                          title: "Image",
                                          imageData: gallary,
                                        )
                                      : SizedBox(),
                                  videoFlag
                                      ? commonImageView(
                                          title: "Video",
                                          imageData: playButton,
                                        )
                                      : SizedBox(),
                                  commonImageView(
                                    title: "Di. Journey",
                                    imageData: diamond,
                                  ),
                                  commonImageView(
                                    title: "Certificate",
                                    imageData: medal,
                                  ),
                                ],
                              ),
                            ),

//                              Padding(
//                                padding: EdgeInsets.only(
//                                    left: getSize(20),
//                                    right: getSize(20),
//                                    top: getSize(0),
//                                    bottom: getSize(0)),
//                                child: Row(
//                                  mainAxisSize: MainAxisSize.min,
//                                  children: <Widget>[
//                                    imageFlag
//                                        ? Padding(
//                                            padding: EdgeInsets.only(
//                                                right: getSize(10)),
//                                            child: getRowItem("Image", gallary))
//                                        : SizedBox(),
//                                    videoFlag
//                                        ? Padding(
//                                            padding: EdgeInsets.only(
//                                                right: getSize(10)),
//                                            child:
//                                                getRowItem("Video", playButton))
//                                        : SizedBox(),
//                                    // getRowItem("Video", playButton),
//
//                                    getRowItem("Certificate", medal),
//                                  ],
//                                ),
//                              )
                          ],
                        )
                      : SizedBox();

                return Container();
              },
            ),*/
              InkWell(
                onTap: () {
                  NavigationUtilities.push(
                    DiamondDeepDetailScreen(
                      arrImages: arrImagesOrCerificate,
                      diamondModel: diamondModel,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
//                                    color: appTheme.lightColorPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.shadowColor,
                        blurRadius: getSize(25),
                        spreadRadius: getSize(5),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: getSize(286),
                  child: getSlider(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  right: getSize(18),
                  top: getSize(30),
                  bottom: getSize(10),
                  left: getSize(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imageFlag
                        ? commonImageView(
                            title: "Image",
                            imageData: gallary,
                          )
                        : SizedBox(),
                    videoFlag
                        ? commonImageView(
                            title: "Video",
                            imageData: playButton,
                          )
                        : SizedBox(),
                    commonImageView(
                      title: "Di. Journey",
                      imageData: diamond,
                    ),
                    commonImageView(
                      title: "Certificate",
                      imageData: medal,
                    ),
                  ],
                ),
              ),
              Container(
                height: getSize(40),
                margin: EdgeInsets.only(
                  left: getSize(20),
                  right: getSize(20),
                ),
//                padding: EdgeInsets.symmetric(vertical: getSize(3)),
                decoration: BoxDecoration(
                  color: appTheme.borderColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    getSize(5),
                  ),
                ),
                child: ListView.builder(
                  itemExtent:
                      (MathUtilities.screenWidth(context) / 2) - getSize(20),
                  itemCount: tabList.length,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: getSize(index == 1 ? 0 : 3),
                          right: getSize(index == 1 ? 3 : 0),
                          top: getSize(3),
                          bottom: getSize(3),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _currentIndex == index
                                  ? appTheme.borderColor
                                  : Colors.transparent,
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, -2),
                            )
                          ],
                          color: _currentIndex == index
                              ? appTheme.whiteColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            getSize(5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            tabList[index].title,
                            style: appTheme.black16TextStyle.copyWith(
                              color: _currentIndex == index
                                  ? appTheme.colorPrimary
                                  : appTheme.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_currentIndex == 0)
                Container(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: getSize(20)),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: arrDiamondDetailUIModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      var diamondItem = arrDiamondDetailUIModel[index];
                      return Padding(
                        padding: !isNullEmptyOrFalse(arrImagesOrCerificate)
                            ? EdgeInsets.only(
                                left: getSize(20),
                                right: getSize(20),
                                top: getSize(15),
                                bottom: getSize(0),
                              )
                            : EdgeInsets.only(
                                left: getSize(20),
                                right: getSize(20),
                                top: getSize(0),
                                bottom: getSize(0),
                              ),
                        child: InkWell(
                          onTap: () {
                            //
                            setState(() {
                              arrDiamondDetailUIModel[index].isExpand =
                                  !arrDiamondDetailUIModel[index].isExpand;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appTheme.whiteColor,
                              borderRadius: BorderRadius.circular(getSize(5)),
                              // color: appTheme.lightBGColor
                              border: Border.all(
                                  color: appTheme.borderColor,
                                  width: getSize(0.7)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: getSize(15),
                                    bottom: getSize(15),
                                    left: getSize(15),
                                    right: getSize(15),
                                  ),
                                  child: Row(
                                    children: [
                                      getSection(
                                          arrDiamondDetailUIModel[index].title),
                                      Spacer(),
                                      Icon(
                                        arrDiamondDetailUIModel[index]
                                                    .isExpand ==
                                                true
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: appTheme.textColor,
                                      ),
                                    ],
                                  ),
                                ),
                                arrDiamondDetailUIModel[index].isExpand
                                    ? getDiamondDetailUIComponent(
                                        arrDiamondDetailUIModel[index],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: getSize(20)),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: diamondJourneyModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      var diamondItem = diamondJourneyModel[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          top: getSize(15),
                          left: getSize(20),
                          right: getSize(20),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  diamondItem.isExpanded =
                                      !diamondItem.isExpanded;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: getSize(15),
                                    bottom: getSize(15),
                                    left: getSize(15),
                                    right: getSize(15)),
                                decoration: BoxDecoration(
                                  color: appTheme.whiteColor,
                                  border: Border.all(
                                    color: appTheme.borderColor,
                                    width: getSize(0.7),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    getSize(5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      diamondItem.title,
                                      style: appTheme
                                          .blackNormal18TitleColorblack
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      diamondItem.isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: appTheme.textColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (diamondItem.isExpanded)
                              Container(
                                height: getSize(200),
                                width: MathUtilities.screenWidth(context),
                                decoration: BoxDecoration(
                                  color: appTheme.whiteColor,
                                  border: Border.all(
                                    color: appTheme.borderColor,
                                    width: getSize(0.7),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    getSize(5),
                                  ),
                                ),
                                child: Container(
                                  height: getSize(200),
                                  width: getSize(200),
                                  child:
                                      getDiamondJourneyViewWidget(diamondItem),
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              /* Padding(
                padding: EdgeInsets.only(
                  left: getSize(30),
                  right: getSize(20),
                ),
                child: Container(
                  height: getSize(400),
                  child: PageView.builder(
                    onPageChanged: (int val) {
                      setState(() {
                        _currentIndex = val;
                      });
                      _controller.jumpToPage(_currentIndex);
                    },
                    //physics: NeverScrollableScrollPhysics(),
//                          controller: _controller,
                    itemCount: 2,
                    itemBuilder: (context, position) {
                      if (position == 0) {
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: arrDiamondDetailUIModel.length,
                            itemBuilder: (BuildContext context, int index) {
                              var diamondItem = arrDiamondDetailUIModel[index];
                              return Padding(
                                padding: !isNullEmptyOrFalse(arrImages)
                                    ? EdgeInsets.only(
                                        left: getSize(20),
                                        right: getSize(20),
                                        top: getSize(30),
                                        bottom: getSize(0),
                                      )
                                    : EdgeInsets.only(
                                        left: getSize(20),
                                        right: getSize(20),
                                        top: getSize(0),
                                        bottom: getSize(0),
                                      ),
                                child: InkWell(
                                  onTap: () {
                                    //
                                    setState(() {
                                      arrDiamondDetailUIModel[index].isExpand =
                                          !arrDiamondDetailUIModel[index]
                                              .isExpand;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: appTheme.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(getSize(5)),
                                      // color: appTheme.lightBGColor
                                      border: Border.all(
                                          color: appTheme.borderColor),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: getSize(20),
                                            bottom: getSize(20),
                                            left: getSize(20),
                                            right: getSize(20),
                                          ),
                                          child: Row(
                                            children: [
                                              getSection(
                                                  arrDiamondDetailUIModel[index]
                                                      .title),
                                              Spacer(),
                                              Icon(
                                                arrDiamondDetailUIModel[index]
                                                            .isExpand ==
                                                        true
                                                    ? Icons.expand_less
                                                    : Icons.expand_more,
                                                color: appTheme.textColor,
                                              ),
                                            ],
                                          ),
                                        ),
//                                          arrDiamondDetailUIModel[index]
//                                                  .isExpand
//                                              ?
                                        getDiamondDetailUIComponent(
                                          arrDiamondDetailUIModel[index],
                                        )
//                                              : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (position == 1) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: diamondJourneyModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            var diamondItem = diamondJourneyModel[index];
                            print(diamondItem.image);
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      diamondItem.isExpanded =
                                          !diamondItem.isExpanded;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(getSize(8)),
                                    margin: EdgeInsets.only(
                                      top: getSize(12),
                                    ),
                                    decoration: BoxDecoration(
                                      color: appTheme.whiteColor,
                                      border: Border.all(
                                        color: appTheme.blackColor,
                                        width: getSize(0.7),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        getSize(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          diamondItem.title,
                                          style: appTheme
                                              .blackMedium14TitleColorblack,
                                        ),
                                        Image.asset(
                                          diamondItem.isExpanded
                                              ? upArrow
                                              : downArrow,
                                          width: getSize(10),
                                          height: getSize(10),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                if (diamondItem.isExpanded)
                                  Container(
                                    height: getSize(200),
                                    child: WebView(
                                      initialUrl:
                                          // "http://pndevelop.democ.in/",
                                          // "/storage/emulated/0/Download/test.pdf",
//                                                          diamondItem?.image  ??
                                          "http://pndevelop.democ.in/",
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebViewCreated: (WebViewController
                                          webViewController) {
                                        _webController
                                            .complete(webViewController);
                                      },
                                      onPageStarted: (String url) {
//                                                      app.resolve<CustomDialogs>().showProgressDialog(context, "");
                                      },
                                      onPageFinished: (String url) {
                                        print('Page finished loading: $url');
//                                                      app.resolve<CustomDialogs>().hideProgressDialog();
                                      },
                                      onWebResourceError: (error) {
                                        print(error.toString());
                                      },
                                      gestureNavigationEnabled: true,
                                    ),
                                  )
                              ],
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),*/
            ],
          )
        : Center(
            child: SpinKitFadingCircle(
              color: appTheme.colorPrimary,
              size: getSize(30),
            ),
          );
  }

  getDiamondJourneyViewWidget(DiamondJourneyModel item) {
    String url = "";
    if (item.type == DiamondDetailImageConstant.RoughImage) {
      url = item.image +
          widget.diamondModel.vStnId
              .substring(0, widget.diamondModel.vStnId.length - 1) +
          "0.jpg";
    } else if (item.type == DiamondDetailImageConstant.RoughVideo) {
      url = item.image +
          widget.diamondModel.vStnId
              .substring(0, widget.diamondModel.vStnId.length - 1) +
          "0.html";
    } else if (item.type == DiamondDetailImageConstant.ThreeDImage) {
      url = item.image + widget.diamondModel.vStnId + ".png";
    } else {
      url = item.image + widget.diamondModel.vStnId + ".jpg";
    }
    if (item.type == DiamondDetailImageConstant.RoughVideo) {
      return WebView(
        initialUrl:
            // "http://pndevelop.democ.in/",
            // "/storage/emulated/0/Download/test.pdf",
            url ?? "",
//                                          "http://pndevelop.democ.in/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webController.complete(webViewController);
        },
        onPageStarted: (String url) {
//                                                      app.resolve<CustomDialogs>().showProgressDialog(context, "");
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
//                                                      app.resolve<CustomDialogs>().hideProgressDialog();
        },
        onWebResourceError: (error) {
          print(error.toString());
        },
        gestureNavigationEnabled: true,
      );
    } else {
      return Image.network(url);
    }
  }

  Carousel getSlider() {
    return Carousel(
      images: [
        for (var i = 0; i < (arrImages ?? []).length; i++)
          Container(
            margin: EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: getVideoOrImage(
                arrImages[i].isImage,
                arrImages[i].url,
              ),
            ),
          ),
      ],
      dotHeight: getSize(4),
      dotWidth: getSize(4),
      dotSpacing: getSize(5),
      dotColor: appTheme.textGray,
      dotIncreasedColor: appTheme.colorPrimary,
      indicatorBgPadding: getSize(5.0),
      dotBgColor: Colors.transparent,
      boxFit: BoxFit.fill,
      dotHorizontalPadding: getSize(10),
      dotVerticalPadding: getSize(10),
      borderRadius: true,
      autoplay: false,
    );
  }

  Widget getVideoOrImage(bool image, String url) {
    bool isImageOrNot = image;
    bool isVideoOrNot = image;
    if (isImageOrNot) {
      return Image.network(
        url,
        width: MathUtilities.screenWidth(context),
        height: null,
      );
    } else {
      return WebView(
        initialUrl: url ?? "",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webController.complete(webViewController);
        },
        onPageStarted: (String url) {
//                                                      app.resolve<CustomDialogs>().showProgressDialog(context, "");
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
//                                                      app.resolve<CustomDialogs>().hideProgressDialog();
        },
        onWebResourceError: (error) {
          print(error.toString());
        },
        gestureNavigationEnabled: true,
      );
    }
  }

  getRowItem(String type, String img) {
    var list = arrImages.where((element) => element.title == type).toList();

    return !isNullEmptyOrFalse(list)
        ? InkWell(
            onTap: () {
              NavigationUtilities.push(DiamondDeepDetailScreen(
                arrImages: arrImages,
                diamondModel: diamondModel,
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(5)),
                  border: Border.all(color: appTheme.borderColor),
                  color: appTheme.unSelectedBgColor),
              child: Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: Row(
                  children: <Widget>[
                    Image.asset(img, height: getSize(30), width: getSize(30)),
                    SizedBox(
                      width: getSize(10),
                    ),
                    for (var model in arrImages)
                      model.title == type
                          ? model.title == "Image"
                              ? Text(
                                  imageFlag ? model.arr.length.toString() : "0",
                                  style: appTheme.primaryColor14TextStyle,
                                )
                              : model.title == "Video"
                                  ? Text(
                                      videoFlag
                                          ? model.arr.length.toString()
                                          : "0",
                                      style: appTheme.primaryColor14TextStyle,
                                    )
                                  : Text(
                                      model.arr.length.toString(),
                                      style: appTheme.primaryColor14TextStyle,
                                    )
                          : SizedBox(),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }

  commonImageView({
    String imageData = "",
    String title = "",
  }) {
    var list = arrImagesOrCerificate
        .where((element) => element.title == imageData)
        .toList();

    return Expanded(
      child: InkWell(
        onTap: () {
          NavigationUtilities.push(DiamondDeepDetailScreen(
            arrImages: arrImagesOrCerificate,
            diamondModel: diamondModel,
          ));
        },
        child: Column(
          children: [
            Container(
              width: getSize(60),
              height: getSize(60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appTheme.lightColorPrimary,
                    appTheme.colorPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.shadowColor,
                    spreadRadius: 3,
                    blurRadius: getSize(20),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  getSize(2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      getSize(4),
                    ),
                    child: Center(
                      child: Image.asset(
                        imageData,
                        height: getSize(20),
                        width: getSize(20),
                        color: appTheme.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: getSize(12),
              ),
              child: Text(
                title,
                style: appTheme.blackMedium14TitleColorblack,
              ),
            )
          ],
        ),
      ),
    );
  }

  jumpToAnyTabFromTabBarClick(int index) {
    double value = 0;
    int i;
    for (i = 0; i < arrDiamondDetailUIModel.length; i++) {
      value += i == 0
          ? getSize(302)
          : arrDiamondDetailUIModel[i - 1].columns > 1
              ? ((arrDiamondDetailUIModel[i - 1].parameters.length /
                              arrDiamondDetailUIModel[i - 1].columns)
                          .floor()) *
                      getSize(90) +
                  getSize(175)
              : ((arrDiamondDetailUIModel[i - 1].parameters.length /
                              arrDiamondDetailUIModel[i - 1].columns)
                          .floor()) *
                      getSize(34) +
                  getSize(173);

      if (i == index) break;
    }

    _scrollController1.animateTo(value.toDouble(),
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
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
                    left: getSize(12),
                    right: getSize(12)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                          diamondDetailUIModel.parameters[j].title+" : ",
                          style: appTheme.grey14HintTextStyle),
                    ),
                    // Spacer(),
                    Expanded(
                      flex: 7,
                      child: Text(diamondDetailUIModel.parameters[j].value,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTheme.blackNormal14TitleColorblack.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    } else {
      num spacing = 0;
      if (diamondDetailUIModel.orientation == "h" &&
          diamondDetailUIModel.columns == 2) {
        spacing = 500;
      } else if (diamondDetailUIModel.orientation == "v" &&
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
                // color: appTheme.borderColor
                border: Border.all(color: appTheme.borderColor),
                color: appTheme.unSelectedBgColor,
              ),
              child:
                  diamondDetailUIModel.orientation == DisplayTypes.horizontal &&
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
                        ),
            );
          },
        ),
      );
    }
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
          // print(error);
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
}

class TabTitle {
  String title;
  bool isSelected;
  int id;

  TabTitle(
    this.title,
    this.id, {
    this.isSelected = false,
  });
}
