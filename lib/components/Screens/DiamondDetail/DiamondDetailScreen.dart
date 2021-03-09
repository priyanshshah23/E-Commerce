import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDeepDetailScreen.dart';
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
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
  String type;

  List<DiamondDetailImagePagerModel> arr = List<DiamondDetailImagePagerModel>();

  DiamondDetailImagePagerModel({
    this.title,
    this.url,
    this.isSelected = false,
    this.isImage = false,
    this.isVideo = false,
    this.subIndex = 0,
    this.arr,
    this.type,
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
  bool isErroWhileLoading = false;
  DiamondConfig diamondConfig;
  int moduleType;

  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  List<DiamondDetailUIModel> arrDiamondDetailUIModel =
      List<DiamondDetailUIModel>();

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
  bool imageFlag_hA = false;
  bool imageFlag_ploty = false;
  bool imageFlag_proportion = false;
  bool videoFlag_nature = false;
  ScreenshotCallback screenshotCallback = ScreenshotCallback();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems(isDetail: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupData();
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
    arrImages.forEach((element) {
      element.arr.forEach((element1) {
        checkUrlUsingDio(element, element1);
      });

      // checkUrlUsingDio(element);
    });
  }

  checkUrlUsingDio(DiamondDetailImagePagerModel mainModel,
      DiamondDetailImagePagerModel model) async {
    print("---mainModel.title---${mainModel.title}");
    print("-mainModel.url-----${mainModel.url}");
    print("--model.url----${model.url}");
    await dio.get(model.url).then((value) {
      if (imageFlag == false) {
        if (mainModel.title.toLowerCase() == "image") {
          setState(() {
            imageFlag = true;
          });
        }
      }
      print(
          "----------hello---------------${mainModel.title}--------------------------------");
      if (videoFlag == false) {
        if (mainModel.title.toLowerCase() == "movie") {
          setState(() {
            videoFlag = true;
          });
        }
      }
      if (imageFlag_hA == false) {
        if (mainModel.title.toLowerCase() == "heart&arrow") {
          setState(() {
            imageFlag_hA = true;
          });
        }
      }
      if (imageFlag_ploty == false) {
        if (mainModel.title.toLowerCase() == "ploty") {
          setState(() {
            imageFlag_ploty = true;
          });
        }
      }
      if (imageFlag_proportion == false) {
        if (mainModel.title.toLowerCase() == "proportion") {
          setState(() {
            imageFlag_proportion = true;
          });
        }
      }
      if (videoFlag_nature == false) {
        if (mainModel.title.toLowerCase() == "natural") {
          setState(() {
            videoFlag_nature = true;
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
        title: "AssetImage",
        url: (DiamondUrls.image + (diamondModel.vStnId) + ".jpg"),
        // url: (DiamondUrls.image +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "still.jpg"),
//        url: "${DiamondUrls.image}${diamondModel.mfgStnId}/still.jpg",
        isSelected: true,
        isImage: true,
        type: "Image",
      ),
    );
    // }

    // print(DiamondUrls.image + diamondModel.vStnId + "/" + "still.jpg");
    // if (diamondModel.arrowFile) {
    /*  arrOfImages.add(
      DiamondDetailImagePagerModel(
        title: "ArrowImage",
        url: DiamondUrls.arroImage +
            diamondModel.mfgStnId +
            "/" +
            "Arrow_Black_BG.jpg",
        isSelected: false,
        isImage: true,
      ),
    );*/
    // }

    // if (diamondModel.assetFile) {
    // arrOfImages.add(
    //   DiamondDetailImagePagerModel(
    //     title: "AssetImage",
    //     url: (DiamondUrls.image + (diamondModel.vStnId) + ".jpg"),
    //     // url: DiamondUrls.image +
    //     //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
    //     //     "/" +
    //     //     "Office_Light_Black_BG.jpg",
    //     isSelected: false,
    //     type: "AssetImage",
    //     isImage: true,
    //   ),
    // );
    // }

    // if (diamondModel.img) {
    arrImages.add(
      DiamondDetailImagePagerModel(
          title: "Image",
          url: (DiamondUrls.image + (diamondModel.vStnId) + ".jpg"),
          // url: DiamondUrls.image +
          //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
          //     "/" +
          //     "still.jpg",
          isSelected: true,
          isImage: true,
          type: "Image",
          arr: arrOfImages),
    );
    // }

    //list of videofile
    List<DiamondDetailImagePagerModel> arrOfVideos =
        List<DiamondDetailImagePagerModel>();

    // if (diamondModel.videoFile) {
    arrOfVideos.add(
      DiamondDetailImagePagerModel(
        title: "Movie",
        url: DiamondUrls.video + "Vision360.html" + "?d=" + diamondModel.vStnId,
        // url: (DiamondUrls.video +
        // (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        // "/" +
        // (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        // ".html"),
        type: "Video",
        isSelected: true,
        isImage: false,
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

    //print((DiamondUrls.video + "Vision360.html?d=" + (diamondModel.vStnId)));

    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Movie",
        url: (DiamondUrls.video + "Vision360.html?d=" + (diamondModel.vStnId)),
        // (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        // "/" +
        // (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        // ".html",
        type: "Video",
        isSelected: false,
        isImage: false,
        isVideo: true,
        arr: arrOfVideos,
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
            diamondModel.vStnId +
            ".pdf",
        type: "Certificate",
        isSelected: true,
        isVideo: true,
        isImage: false,
      ),
    );
    // }
    // print(ApiConstants.googleDocUrl +
    //     DiamondUrls.certificate +
    //     diamondModel.rptNo +
    //     ".pdf");
    // if (diamondModel.certFile) {
    arrImages.add(
      DiamondDetailImagePagerModel(
          title: "Certificate",
          url: ApiConstants.googleDocUrl +
              DiamondUrls.certificate +
              diamondModel.vStnId +
              ".pdf",
          isSelected: false,
          isImage: false,
          type: "Certificate",
          arr: arrOfCertificates),
    );
    // }

    //List of H&A
    List<DiamondDetailImagePagerModel> arrOfHA =
        List<DiamondDetailImagePagerModel>();

    // if (diamondModel.hAFile) {
    arrOfHA.add(
      DiamondDetailImagePagerModel(
        title: "Heart&Arrow",
        url: (DiamondUrls.heartImage +
            (diamondModel.vStnId) +
            "/" +
            (diamondModel.vStnId) +
            "-Arrows-01.jpg"),
        // url: DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "Arrow_Black_BG.jpg",
        type: "Image_hA",
        isSelected: true,
        isImage: true,
      ),
    );
    arrOfHA.add(
      DiamondDetailImagePagerModel(
        title: "Heart&Arrow",
        url: (DiamondUrls.heartImage +
            (diamondModel.vStnId) +
            "/" +
            (diamondModel.vStnId) +
            "-ASET%20white-01.jpg"),
        // url: DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "Arrow_Black_BG.jpg",
        type: "Image_hA",
        isSelected: true,
        isImage: true,
      ),
    );
    arrOfHA.add(
      DiamondDetailImagePagerModel(
        title: "Heart&Arrow",
        url: (DiamondUrls.heartImage +
            (diamondModel.vStnId) +
            "/" +
            (diamondModel.vStnId) +
            "-IdealScope-01.jpg"),
        // url: DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "Arrow_Black_BG.jpg",
        type: "Image_hA",
        isSelected: true,
        isImage: true,
      ),
    );
    arrOfHA.add(
      DiamondDetailImagePagerModel(
        title: "Heart&Arrow",
        url: (DiamondUrls.heartImage +
            (diamondModel.vStnId) +
            "/" +
            (diamondModel.vStnId) +
            "-Hearts-01.jpg"),
        // url: (DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "Heart_Black_BG.jpg"),
//        url: "",
        type: "Image_hA",
        isSelected: true,
        isImage: true,
      ),
    );
    // }

    // arrOfHA.add(
    //   DiamondDetailImagePagerModel(
    //     title: "Heart&Arrow",
    //     url: (DiamondUrls.heartImage +
    //         (diamondModel.vStnId) +
    //         "/" +
    //         (diamondModel.vStnId) +
    //         "-Arrows-01.jpg"),
    //     // url: DiamondUrls.heartImage +
    //     //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
    //     //     "/" +
    //     //     "Arrow_Black_BG.jpg",
    //     type: "Image_hA",
    //     isSelected: true,
    //     isImage: true,
    //   ),
    // );
    // if (diamondModel.hAFile) {
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Heart&Arrow",
        url: (DiamondUrls.heartImage +
            (diamondModel.vStnId) +
            "/" +
            (diamondModel.vStnId) +
            "-Hearts-01.jpg"),
        type: "Image_hA",
        isSelected: false,
        isImage: true,
        arr: arrOfHA,
      ),
    );
    // }
    List<DiamondDetailImagePagerModel> arrOfPloty =
        List<DiamondDetailImagePagerModel>();

    // if (diamondModel.PlotyFile) {
    arrOfPloty.add(
      DiamondDetailImagePagerModel(
        title: "Ploty",
        url: (DiamondUrls.plotting + (diamondModel.vStnId) + ".png"),
        //(diamondModel.mfgStnId ?? diamondModel.vStnId) +
//        url: "",
        type: "Image_ploty",
        isSelected: true,
        isImage: true,
      ),
    );
    // }

    // arrOfPloty.add(
    //   DiamondDetailImagePagerModel(
    //     title: "Ploty",
    //     url: DiamondUrls.plotting +
    //         (diamondModel.vStnId) +".png",
    //         //(diamondModel.mfgStnId ?? diamondModel.vStnId) +
    //     type: "AssetImage",
    //     isSelected: true,
    //     isImage: true,
    //   ),
    // );
    // print(DiamondUrls.plotting +
    //     (diamondModel.vStnId) +
    //     //(diamondModel.mfgStnId ?? diamondModel.vStnId) +
    //     ".png");
    // if (diamondModel.PlotyFile) {
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Ploty",
        url: DiamondUrls.plotting + (diamondModel.vStnId) + ".png",
        //(diamondModel.mfgStnId ?? diamondModel.vStnId) +
        type: "Image_ploty",
        isSelected: false,
        isImage: true,
        arr: arrOfPloty,
      ),
    );
    //}

    List<DiamondDetailImagePagerModel> arrOfProportion =
        List<DiamondDetailImagePagerModel>();

    // if (diamondModel.ProportionFile) {
    arrOfProportion.add(
      DiamondDetailImagePagerModel(
        title: "Proportion",
        url: (DiamondUrls.proportion + diamondModel.vStnId + ".png"),
        // (diamondModel.mfgStnId ?? diamondModel.vStnId) +
//        url: "",
        type: "Image_proportion",
        isSelected: true,
        isImage: true,
      ),
    );
    // }

    // arrOfProportion.add(
    //   DiamondDetailImagePagerModel(
    //     title: "Proportion",
    //     url: DiamondUrls.heartImage +
    //         (diamondModel.mfgStnId ?? diamondModel.vStnId) +
    //         "/" +
    //         "Arrow_Black_BG.jpg",
    //     type: "AssetImage",
    //     isSelected: true,
    //     isImage: true,
    //   ),
    // );
    // if (diamondModel.ProportionFile) {
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Proportion",
        url: (DiamondUrls.proportion + diamondModel.vStnId + ".png"),
        // url: DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "Heart_Black_BG.jpg",
        type: "Image_proportion",
        isSelected: false,
        isImage: true,
        arr: arrOfProportion,
      ),
    );
    //}

    List<DiamondDetailImagePagerModel> arrOfNatural =
        List<DiamondDetailImagePagerModel>();

    // if (diamondModel.NaturalFile) {
    arrOfNatural.add(
      DiamondDetailImagePagerModel(
        title: "Natural",
        url: (DiamondUrls.natural + diamondModel.vStnId + ".mp4"),
        // url: (DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        // "/" +
        // "Heart_Black_BG.jpg"),
//        url: "",
        type: "Video_natural",
        isSelected: true,
        isImage: false,
        isVideo: true,
      ),
    );
    // }

    // arrOfProportion.add(
    //   DiamondDetailImagePagerModel(
    //     title: "Natural",
    //     url: DiamondUrls.heartImage +
    //         (diamondModel.mfgStnId ?? diamondModel.vStnId) +
    //         "/" +
    //         "Arrow_Black_BG.jpg",
    //     type: "AssetImage",
    //     isSelected: true,
    //     isImage: true,
    //   ),
    // );
    // if (diamondModel.NaturalFile) {
    arrImages.add(
      DiamondDetailImagePagerModel(
        title: "Natural",
        url: (DiamondUrls.natural + diamondModel.vStnId + ".mp4"),
        // url: DiamondUrls.heartImage +
        //     (diamondModel.mfgStnId ?? diamondModel.vStnId) +
        //     "/" +
        //     "Heart_Black_BG.jpg",
        type: "Video_natural",
        isSelected: false,
        isImage: false,
        isVideo: true,
        arr: arrOfNatural,
      ),
    );
    //}
    //  print("--------length---------${arrImages.length}");
    setState(() {
      //
    });

    Config().getDiamonDetailUIJson().then((result) {
      setupDiamonDetail(result);
      getPrefixSum();
      setState(() {});
    });
  }

  setupDiamonDetail(List<DiamondDetailUIModel> arrModel) {
    for (int i = 0; i < arrModel.length; i++) {
      var diamondDetailItem = arrModel[i];
      //print("-----title---------${arrModel[i].title}");
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
          body: getDiamondDetailComponents(),
        ),
        (app
                    .resolve<PrefUtils>()
                    .isDisplayedTour(PrefUtils().keyDiamondDetailTour) ==
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

  getRowItem(String type, String img, int index) {
    var list = arrImages.where((element) => element.type == type).toList();
    var listHAndA =
        arrImages.where((element) => element.title == "Heart & Arrow").toList();
    int num = 0;
    for (var model in arrImages) {
      if (model.type == type) {
        if (model.type == "Image") {
          if (imageFlag) {
            num = (num + model.arr.length);
          } else {
            num = num;
          }
        } else if (model.type == "Movie") {
          if (videoFlag) {
            num = (num + model.arr.length);
          } else {
            num = num;
          }
        } else if (model.type == "Image_hA") {
          if (imageFlag_hA) {
            num = (num + model.arr.length);
          } else {
            num = num;
          }
        } else if (model.type == "Image_ploty") {
          if (imageFlag_ploty) {
            num = (num + model.arr.length);
          } else {
            num = num;
          }
        } else if (model.type == "Image_proportion") {
          if (imageFlag_proportion) {
            num = (num + model.arr.length);
          } else {
            num = num;
          }
        } else if (model.type == "Video_natural") {
          if (videoFlag_nature) {
            num = (num + model.arr.length);
          } else {
            num = num;
          }
        } else {
          num = (num + model.arr.length);
          if (!isNullEmptyOrFalse(listHAndA) && imageFlag && videoFlag) {
            index++;
          }
        }
      } else {
        num = num;
      }
    }

//      model.type == type
//          ? model.type == "Image"
//              ? imageFlag
//                  ? num = (num + model.arr.length)
//                  : num = num
//              : model.type == "Video"
//                  ? videoFlag
//                      ? num = (num + model.arr.length)
//                      : num = num
//                  : num = (num + model.arr.length)
//          : num = num;
    return !isNullEmptyOrFalse(list)
        ? InkWell(
            onTap: () {
              NavigationUtilities.push(
                DiamondDeepDetailScreen(
                  arrImages: arrImages,
                  index: index,
                  diamondModel: diamondModel,
                ),
              );
            },
            child: Container(
              height: getSize(40),
              width: getSize(40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(10)),
                  border: Border.all(color: appTheme.borderColorr),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: Center(
                  child:
                      Image.asset(img, height: getSize(25), width: getSize(25)),
                  // SizedBox(
                  //   width: getSize(10),
                  // ),
                  // Text(
                  //   num != 0 ? num.toString() : "0",
                  //   style: appTheme.primaryColor14TextStyle,
                  // )
//                    for (var model in arrImages)
//                      model.title == type
//                          ? model.title == "Image"
//                              ? Text(
//                                  imageFlag ? list.length.toString() : "0",
//                                  style: appTheme.primaryColor14TextStyle,
//                                )
//                              : model.title == "Video"
//                                  ? Text(
//                                      videoFlag
//                                          ? model.arr.length.toString()
//                                          : "0",
//                                      style: appTheme.primaryColor14TextStyle,
//                                    )
//                                  : Text(
//                                      model.arr.length.toString(),
//                                      style: appTheme.primaryColor14TextStyle,
//                                    )
//                          : SizedBox(),
                ),
              ),
            ),
          )
        : SizedBox();
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
            context, selectedList, tabModel, () {});
        break;
      case BottomCodeConstant.TBClock:
        break;
      case BottomCodeConstant.TBDownloadView:
        if ((app.resolve<PrefUtils>().getUserDetails().account?.isApproved ??
                KYCStatus.pending) ==
            KYCStatus.approved) {
          BottomTabModel tabModel = BottomTabModel();
          tabModel.type = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
          List<DiamondModel> selectedList = [diamondModel];

          diamondConfig.manageDiamondAction(
              context, selectedList, tabModel, () {});
        }
        break;
    }
  }

  getImage() {
    for (var model in arrImages) {
      if (model.title == "Image" && imageFlag) {
        return getImageView(
          model.url,
          height: getSize(286),
          width: MathUtilities.screenWidth(context),
          fit: BoxFit.fitHeight,
        );
      } else if (model.title == "Certificate" ||
          (model.title == "Movie" && videoFlag)) {
        return Stack(
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
                  color: appTheme.whiteColor,
                  size: getSize(30),
                ),
              ),
          ],
        );
      }
    }
  }

  Widget getDiamondDetailComponents() {
    // print("-------345--------${arrImages.length}");
    return !isNullEmptyOrFalse((arrDiamondDetailUIModel))
        ? Stack(
            children: <Widget>[
              ListView.builder(
                controller: _scrollController1,
                padding: EdgeInsets.only(
                  bottom: getSize(20),
                ),
                itemCount: arrDiamondDetailUIModel.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0)
                    return !isNullEmptyOrFalse(arrImages)
                        ? Column(
                            // fit: StackFit.loose,
                            // overflow: Overflow.visible,
                            children: [
                              InkWell(
                                onTap: () {
                                  NavigationUtilities.push(
                                      DiamondDeepDetailScreen(
                                    arrImages: arrImages,
                                    diamondModel: diamondModel,
                                  ));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: getSize(286),
                                  child: getImage(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: getSize(25)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getSize(20),
                                          right: getSize(20),
                                          top: getSize(0),
                                          bottom: getSize(0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          imageFlag
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: getSize(10)),
                                                  child: getRowItem(
                                                    "Image",
                                                    gallary,
                                                    0,
                                                  ),
                                                )
                                              : SizedBox(),
                                          videoFlag
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: getSize(10)),
                                                  child: getRowItem(
                                                    "Movie",
                                                    playButton,
                                                    1,
                                                  ))
                                              : SizedBox(),
                                          // getRowItem("Video", playButton),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  right: getSize(10)),
                                              child: getRowItem(
                                                "Certificate",
                                                certi,
                                                3,
                                              )),

                                          imageFlag_hA
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: getSize(10)),
                                                  child: getRowItem(
                                                    "Image_hA",
                                                    hA,
                                                    4,
                                                  ))
                                              : SizedBox(),
                                          imageFlag_ploty
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: getSize(10)),
                                                  child: getRowItem(
                                                    "Image_ploty",
                                                    ploty,
                                                    5,
                                                  ))
                                              : SizedBox(),
                                          imageFlag_proportion
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: getSize(10)),
                                                  child: getRowItem(
                                                    "Image_proportion",
                                                    proportion,
                                                    6,
                                                  ))
                                              : SizedBox(),
                                          videoFlag_nature
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: getSize(10)),
                                                  child: getRowItem(
                                                    "Video_natural",
                                                    nature,
                                                    7,
                                                  ))
                                              : SizedBox(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : SizedBox();
                  return Padding(
                    padding: !isNullEmptyOrFalse(arrImages)
                        ? EdgeInsets.only(
                            left: getSize(20),
                            right: getSize(20),
                            top: getSize(20),
                            bottom: getSize(0))
                        : EdgeInsets.only(
                            left: getSize(20),
                            right: getSize(20),
                            top: getSize(0),
                            bottom: getSize(0)),
                    child: InkWell(
                      onTap: () {
                        //
                        setState(() {
                          arrDiamondDetailUIModel[index - 1].isExpand =
                              !arrDiamondDetailUIModel[index - 1].isExpand;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(getSize(5)),
                          // color: appTheme.lightBGColor
                          border: Border.all(color: appTheme.borderColor),
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
                                  getSection(arrDiamondDetailUIModel[index - 1]
                                          ?.title ??
                                      ""),
                                  Spacer(),
                                  Icon(
                                    arrDiamondDetailUIModel[index - 1]
                                                .isExpand ==
                                            true
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: appTheme.textColor,
                                  ),
                                ],
                              ),
                            ),
                            arrDiamondDetailUIModel[index - 1].isExpand
                                ? getDiamondDetailUIComponent(
                                    arrDiamondDetailUIModel[index - 1],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              _scrollController1.hasClients
                  ? offSetForTab >= getSize(302.0)
                      ? Container(
                          color: appTheme.whiteColor,
                          margin: EdgeInsets.only(
                              left: getSize(20),
                              right: getSize(20),
                              top: getSize(0),
                              bottom: getSize(0)),
                          height: getSize(52),
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _sc,
                            scrollDirection: Axis.horizontal,
                            itemCount: arrDiamondDetailUIModel.length,
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
                                        arrDiamondDetailUIModel[index].title,
                                        style: appTheme
                                            .blackNormal18TitleColorblack,
                                      ),
                                      index == currTab
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: getSize(8)),
                                              child: Container(
                                                width: getSize(50),
                                                height: getSize(3),
                                                decoration: BoxDecoration(
                                                  color: appTheme.colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(3),
                                                          topRight:
                                                              Radius.circular(
                                                                  3)),
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
                        )
                      : SizedBox()
                  : SizedBox(),
            ],
          )
        : Center(
            child: SpinKitFadingCircle(
              color: appTheme.colorPrimary,
              size: getSize(30),
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
                      child: Text(diamondDetailUIModel.parameters[j].title,
                          style: appTheme.grey14HintTextStyle),
                    ),
                    // Spacer(),
                    Expanded(
                      flex: 7,
                      child: Text(diamondDetailUIModel.parameters[j].value,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTheme.blackNormal14TitleColorblack),
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
