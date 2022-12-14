import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/Helper/LocalNotification.dart';
import 'package:diamnow/app/Helper/OfflineStockManager.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
import 'package:diamnow/components/Screens/Dialogue/SelectionScreen.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondExpandItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondSquareGridItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/FinalCalculation.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/Screens/MyBid/BidTerms.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rxbus/rxbus.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  String filterId = "";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;
  List<FormBaseModel> filterModel;
  bool isCompanySelected = false;
  bool isLayoutSearch = false;
  String downloadDate = "";
  String idCollection = "";
  String titlePage = "";

  DiamondListScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      this.filterId = arguments["filterId"];
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
      if (arguments["idCollection"] != null) {
        idCollection = arguments["idCollection"];
      }
      if (arguments["titlePage"] != null) {
        titlePage = arguments["titlePage"];
      }

      if (arguments["filterModel"] != null) {
        filterModel = arguments["filterModel"];
      }
      if (arguments["downloadDate"] != null) {
        downloadDate = arguments["downloadDate"];
      }
      if (arguments["isCompanySelected"] != null) {
        isCompanySelected = arguments["isCompanySelected"];
      }
      if (arguments["isLayoutSearch"] != null) {
        isLayoutSearch = arguments["isLayoutSearch"];
      }
    }
  }

  @override
  _DiamondListScreenState createState() => _DiamondListScreenState(
      filterId: filterId,
      moduleType: moduleType,
      isFromDrawer: isFromDrawer,
      filterModel: filterModel,
      downloadDate: downloadDate,
      isCompanySelected: isCompanySelected,
      isLayoutSearch: isLayoutSearch,
      idCollection: idCollection,
      titlePage: titlePage);
}

class _DiamondListScreenState extends StatefulScreenWidgetState {
  String filterId;
  int moduleType;
  bool isFromDrawer;
  String sortingKey;
  List<Map<String, dynamic>> sortRequest;
  bool selectAllGroupDiamonds;
  List<FormBaseModel> filterModel;
  String downloadDate = "";
  bool isCompanySelected = false;
  bool isLayoutSearch = false;
  String idCollection;
  String titlePage;

  _DiamondListScreenState({
    this.filterId,
    this.moduleType,
    this.isFromDrawer,
    this.filterModel,
    this.downloadDate,
    this.isCompanySelected,
    this.isLayoutSearch,
    this.idCollection,
    this.titlePage,
  });

  DiamondConfig diamondConfig;
  DiamondItemWidget _itemWidget;
  _DiamondListScreenState screenState;
  BaseList diamondList;
  BaseList diamondListExact;
  List<DiamondModel> arraDiamond = List<DiamondModel>();
  List<DiamondModel> FinalArrDiamond = List<DiamondModel>();
  List<DiamondModel> DiamondNotExact = List<DiamondModel>();
  List<Summary> summaryDiamond = List<Summary>();
  int page = DEFAULT_PAGE;
  DiamondCalculation diamondCalculation = DiamondCalculation();
  DiamondCalculation diamondFinalCalculation = DiamondCalculation();
  List<FilterOptions> optionList = List<FilterOptions>();
  bool isGrid = false;
  bool hasData = false;
  int viewTypeCount = 0;
  ScreenshotCallback screenshotCallback = ScreenshotCallback();
  bool isTermsOpen = false;
  ScrollController _controller;
  ScrollController _controller2;
  bool sort = false;
  bool layout = false;
  bool ExactSearch = false;
  bool hasSimilar = false;
  int similarLength = 0;

  @override
  void initState() {
    super.initState();
    if (app.resolve<PrefUtils>().getCompanyDetails() != null) {
      isCompanySelected = true;
    }
    _controller = ScrollController();
    _controller2 = ScrollController();
    Config().getOptionsJson().then((result) {
      result.forEach((element) {
        if (element.isActive) {
          if (moduleType ==
              DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY) {
            if (element.apiKey == "amt ASC" ||
                element.apiKey == "amt DESC" ||
                element.apiKey == "back ASC" ||
                element.apiKey == "back DESC") {
            } else {
              optionList.add(element);
            }
          } else {
            optionList.add(element);
          }
        }
      });
      setState(() {});
    });

    //ANALYTICS
    sendAnalyticsReport();
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems();
    diamondList = BaseList(BaseListState(
      imagePath: noDataFound,
      noDataMsg: APPNAME,
      noDataDesc: R.string.noDataStrings.noDataFound,
      refreshBtn: R.string.commonString.refresh,
      enablePullDown: true,
      enablePullUp: true,
      onPullToRefress: () {
        callApi(true);
      },
      onRefress: () {
        callApi(true);
      },
      onLoadMore: () {
        callApi(false, isLoading: true);
      },
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("From here");
      callApi(false);

      SyncManager.instance.callAnalytics(context,
          page: PageAnalytics.getPageAnalyticsFromModuleType(moduleType),
          section: SectionAnalytics.LIST,
          action: ActionAnalytics.OPEN);

      screenshotCallback.addListener(
        () {
          SyncManager.instance.callAnalytics(
            context,
            page: PageAnalytics.getPageAnalyticsFromModuleType(moduleType),
            section: SectionAnalytics.LIST,
            action: ActionAnalytics.OPEN,
            dict: {
              "diamondSearchId": this.filterId,
              "userId": app.resolve<PrefUtils>().getUserDetails().id ?? "",
              "action": "SCREENSHOT_TAKEN_BY_USER"
            },
          );
        },
      );
    });

    RxBus.register<void>(tag: eventOfflineDiamond).listen((event) {
      setState(() {
        //
      });
    });

    RxBus.register<void>(tag: eventDiamondRefresh).listen((event) {
      callApi(true);
    });

    RxBus.register<Map<String, dynamic>>(tag: eventSelectAllGroupDiamonds)
        .listen((event) async {
      setState(() {
        DiamondModel diamondModel = event["diamondModel"];

        List<DiamondModel> filter = arraDiamond
            .where((element) => element.memoNo == diamondModel.memoNo)
            .toList();
        if (isNullEmptyOrFalse(filter) == false) {
          filter.forEach((element) {
            element.isSelected = event["isSelected"];
          });
        }
        manageDiamondSelection();
      });
    });
  }

  openTerms() {
    if (moduleType == DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
        !isTermsOpen) {
      /*   Timer(
        Duration(seconds: 1),
            () => (),
      );*/
      isTermsOpen = true;
      NavigationUtilities.pushRoute(BidTerms.route);
    }
  }

  @override
  void dispose() {
    RxBus.destroy(tag: eventSelectAllGroupDiamonds);
    RxBus.destroy(tag: eventOfflineDiamond);
    RxBus.destroy(tag: eventDiamondRefresh);
    super.dispose();
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arraDiamond.clear();
      FinalArrDiamond.clear();
      DiamondNotExact.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_LAYOUT &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_DRAWER_UPCOMING &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_DRAWER_NEW_ARRIVAL &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_INNER_LAYOUT) {
      dict["page"] = page;
      dict["limit"] = DEFAULT_LIMIT;
    }
    if (sortRequest != null) {
      dict["sort"] = sortRequest;
    }

    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
      case DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH:
        dict["filters"] = [
          {"diamondSearchId": this.filterId}
        ];
        break;
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        if (!app.resolve<PrefUtils>().isUserCustomer()) {
          dict["filters"] = [
            {"diamondSearchId": this.filterId}
          ];
        } else {
          dict["filters"] = [
            {"diamondSearchId": this.filterId}
          ];
        }
        break;
      case DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR:
//        dict["filters"] = [
//          {"diamondSearchId": this.filterId}
//        ];
        dict['isPredefinedPair'] = true;
        dict["filter"] = {};
        dict["filter"]["diamondSearchId"] = this.filterId;
        break;
      case DiamondModuleConstant.MODULE_TYPE_LAYOUT:
        dict['isPredefinedPair'] = true;
        dict["filter"] = {};
        dict["filter"]["diamondSearchId"] = this.filterId;
        dict["sendSummary"] = true;
        dict["noDiamondDetails"] = true;
        break;
      case DiamondModuleConstant.MODULE_TYPE_INNER_LAYOUT:
        dict['isPredefinedPair'] = true;
        dict["page"] = page;
        dict["filter"] = {};
        dict["filter"]["layoutNo"] = {
          "in": [this.filterId]
        };
        dict["isLayout"] = true;
        break;
      case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
        dict["filters"] = [
          {"diamondSearchId": this.filterId}
        ];
        dict["viewType"] = 2;
        dict["sort"] = [];
        break;
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_COLLECTION:
        dict["filters"] = [
          {"diamondSearchId": idCollection}
        ];

        dict["isAppendMasters"] = true;
        dict["isSkipSave"] = true;
        //dict["filters"]["or"] = diamondConfig.getExclusiveDiamondReq();

        break;

      case DiamondModuleConstant.MODULE_TYPE_DRAWER_NEW_ARRIVAL:
        dict["filters"] = [{}];
        dict["viewType"] = 2;
        dict["page"] = page;
        dict["sort"] = [];
        break;
      case DiamondModuleConstant.MODULE_TYPE_DRAWER_UPCOMING:
        dict["filters"] = [{}];
        dict["isUpcoming"] = true;
        dict["page"] = page;
        dict["limit"] = 250;
        Map<String, dynamic> dict1 = Map<String, dynamic>();
        dict1["inDt"] = "ASC";
        dict["sort"] = [dict1];
        // dict["sort"] = [];
        break;
      case DiamondModuleConstant.MODULE_TYPE_DRAWER_FEATURED:
        dict["filters"] = [
          {"sectionType": 11}
        ];
        dict["sort"] = [];
        // dict["sort"] = [];
        break;

      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        /* dict["filters"] = [
          {"wSts": DiamondStatus.DIAMOND_STATUS_BID}
        ];*/
        //"[{isFm: {nin: ["CERT", "ELIG"]}}]"
        /*  dict["filters"] = {};
        dict["filters"]["wSts"] = DiamondStatus.DIAMOND_STATUS_BID;*/
        dict["filters"] = {};
        dict["filters"]["isFm"] = {
          "nin": ["CERT", "ELIG"]
        };
        break;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        var date = DateTime.now();
//        dict["filters"] = [
//          {
//            "wSts": DiamondStatus.DIAMOND_STATUS_UPCOMING,
//            "inDt": {
//              "<=": date.add(Duration(days: 7)).toUtc().toIso8601String()
//            }
//          }
//        ];
//        Map<String, dynamic> dict1 = Map<String, dynamic>();
//        dict1["inDt"] = "ASC";
//        dict["sort"] = [dict1];
        // dict["filters"] = {};
        // dict["filters"] = [
        //   {"diamondSearchId": this.filterId}
        // ];
        // dict["isAppendMasters"] = true;
        // dict["isSkipSave"] = true;
        // Map<String, dynamic> dict1 = Map<String, dynamic>();
        // dict1["inDt"] = "ASC";
        // dict["sort"] = [dict1];
        //print("===========>" + this.filterId);
        // dict["filters"] = {};
        // dict["filters"]["wSts"] = DiamondStatus.DIAMOND_STATUS_UPCOMING;
        // dict["filters"]["inDt"] = {};

        // print(date.add(Duration(days: 5, hours: 5, minutes: 30)));
        // dict["filters"]["inDt"]["<="] =
        //     date.add(Duration(days: 7)).toUtc().toIso8601String();
        // Map<String, dynamic> dict1 = Map<String, dynamic>();
        // dict1["inDt"] = "ASC";
        // dict["sort"] = [dict1];
        if (!app.resolve<PrefUtils>().isUserCustomer()) {
          dict["filters"] = [
            {"diamondSearchId": this.filterId}
          ];
        } else {
          dict["filters"] = [
            {
              "wSts": DiamondStatus.DIAMOND_STATUS_UPCOMING,
              "diamondSearchId": this.filterId
            }
          ];
        }

        break;
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        dict["page"] = page;
        dict["filters"] = [
          {"or": diamondConfig.getExclusiveDiamondReq()}
        ];
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        dict["bidType"] = [BidConstant.BID_TYPE_ADD];
        dict["status"] = [BidStatus.BID_STATUS_ACTIVE];
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
        dict["trackType"] = DiamondTrackConstant.TRACK_TYPE_REMINDER;
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_CART:
        dict["trackType"] = DiamondTrackConstant.TRACK_TYPE_CART;
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
        dict["trackType"] = DiamondTrackConstant.TRACK_TYPE_WATCH_LIST;
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
        dict["trackType"] = DiamondTrackConstant.TRACK_TYPE_ENQUIRY;
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        dict["trackType"] = DiamondTrackConstant.TRACK_TYPE_OFFER;
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
        dict["isAppendDiamond"] = 1;
        break;
      case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
        if (!app.resolve<PrefUtils>().isUserCustomer()) {
          dict["filters"] = [
            {"wSts": "D"}
          ];
        } else {
          dict["filters"] = {};
          dict["filters"]["wSts"] = "D";
        }
        break;

      case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK:
      case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH:
        if (isNullEmptyOrFalse(this.downloadDate)) {
          getOfflineStock(dict);
        } else {
          getOfflineStockFromDownloadedDate(dict);
        }
        return;
      case DiamondModuleConstant.MODULE_TYPE_MY_HOLD:
        dict["blockType"] = BlockType.HOLD;
        dict['status'] = HoldListStatus.HOLD;
        Map<String, dynamic> dict1 = Map<String, dynamic>();
        dict1["createdAt"] = "DESC";
        dict["sort"] = [dict1];
        break;
    }
    NetworkCall<DiamondListResp>()
        .makeCall(
      () => diamondConfig.getApiCall(moduleType, dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((diamondListResp) async {
      if (page == DEFAULT_PAGE) {
        hasData = diamondListResp.data.diamonds.length > 0 ||
            diamondListResp.data.list.length > 0;
        openTerms();
      }
      // diamondListResp.data.list.forEach((element) {
      //   if (element.status != 1) print(element.status);
      // });
      switch (moduleType) {
        case DiamondModuleConstant.MODULE_TYPE_MY_CART:
        case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
        case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
        case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
        case DiamondModuleConstant.MODULE_TYPE_MY_BID:
          // case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
          List<DiamondModel> list = [];
          DiamondModel diamondModel;
          TrackDiamonds trackDiamonds;
          diamondListResp.data.list.forEach((element) {
            if (element.diamonds != null) {
              element.diamonds.forEach((diamonds) {
                switch (moduleType) {
                  case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
                    diamonds.memoNo = element.id;
                    element.cabinSlot.forEach((element1) {
                      diamonds.start = element1.start;
                      diamonds.end = element1.end;
                    });
                    diamonds.date = element.date;
                    diamonds.createdAt = element.createdAt;
                    diamonds.purpose = element.purpose;

                    break;
                }
                list.add(diamonds);
              });
            } else {
              diamondModel = element.diamond;
              //diamondModel.status = element.status;
              trackDiamonds = TrackDiamonds(
                  id: diamondModel.id,
                  trackId: element.id,
                  remarks: element.remarks,
                  reminderDate: element.reminderDate);
              switch (moduleType) {
                case DiamondModuleConstant.MODULE_TYPE_MY_CART:
                  diamondModel.trackItemCart = trackDiamonds;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
                  diamondModel.trackItemWatchList = trackDiamonds;
                  diamondModel.newDiscount = element.newDiscount;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
                  diamondModel.trackItemEnquiry = trackDiamonds;
                  diamondModel.remarks = element.remarks;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
                  diamondModel.createdAt = element.createdAt;
                  diamondModel.trackItemOffer = trackDiamonds;
                  diamondModel.memoNo = element.memoNo;
                  diamondModel.layoutNo = element.memoNo;
                  diamondModel.offerValidDate = element.offerValidDate;
                  diamondModel.offerStatus = element.offerStatus;
                  diamondModel.newAmount = element.newAmount;
                  diamondModel.newDiscount = element.newDiscount;
                  diamondModel.bargainTrack = element.bargainTrack;
                  diamondModel.newPricePerCarat = element.newPricePerCarat;
                  diamondModel.remarks = element.remarks;
                  // if (element.bargainTrack.isNotEmpty &&
                  //     element.bargainTrack != null) {
                  // }
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
                  diamondModel.trackItemReminder = trackDiamonds;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
                  diamondModel.trackItemComment = trackDiamonds;
                  diamondModel.remarks = element.remarks;
                  diamondModel.isNotes = true;
                  diamondModel.isNoteEditable = false;
                  break;

                case DiamondModuleConstant.MODULE_TYPE_MY_BID:
                  diamondModel.trackItemBid = trackDiamonds;
                  break;
              }
              list.add(diamondModel);
            }
          });
          arraDiamond.addAll(list);
          FinalArrDiamond.addAll(arraDiamond);
          break;
        case DiamondModuleConstant.MODULE_TYPE_LAYOUT:
          summaryDiamond.addAll(diamondListResp.data.summary);
          break;
        default:
          diamondListResp.data.diamonds.forEach((element) {
            hasSimilar = element.isExactSearch;
            if (element.isExactSearch == true) {
              arraDiamond.add(element);
              ExactSearch = true;
            } else if (ExactSearch == true) {
              DiamondNotExact.add(element);
            } else {
              arraDiamond.add(element);
            }
            FinalArrDiamond.add(element);
          });
          break;
      }

      if (moduleType != DiamondModuleConstant.MODULE_TYPE_LAYOUT) {
        diamondConfig.setMatchPairItem(arraDiamond,
            isLayoutSearch: isLayoutSearch ?? false);
        diamondList.state.listCount = arraDiamond.length;
        diamondList.state.totalCount = diamondListResp.data.count;
        manageDiamondSelection();
        //callBlockApi(isProgress: true);
      } else {
        diamondList.state.listCount = summaryDiamond.length;
        diamondList.state.totalCount = summaryDiamond.length;
        manageDiamondSelection(layout: true);
        //callBlockApi(isProgress: true);
      }
      page = page + 1;

      diamondList.state.setApiCalling(false);
    }).catchError((onError) {
      if (page == DEFAULT_PAGE) {
        arraDiamond.clear();
        diamondList.state.listCount = arraDiamond.length;
        diamondList.state.totalCount = arraDiamond.length;
        manageDiamondSelection();
      }
      diamondList.state.setApiCalling(false);
    });
  }

  getOfflineStock(Map<String, dynamic> dict) {
    AppDatabase.instance.diamondDao
        .getDiamondList(dict, list: this.filterModel)
        .then((diamondListResp) {
      try {
        handleOfflineStockResponse(diamondListResp);
      } catch (error) {
        if (page == DEFAULT_PAGE) {
          arraDiamond.clear();
          diamondList.state.listCount = arraDiamond.length;
          diamondList.state.totalCount = arraDiamond.length;
          manageDiamondSelection();
        }

        diamondList.state.setApiCalling(false);
      }
    });
  }

  getOfflineStockFromDownloadedDate(Map<String, dynamic> dict) {
    AppDatabase.instance.diamondDao
        .getDiamondListBySearchHistory(dict, this.downloadDate)
        .then((diamondListResp) {
      try {
        handleOfflineStockResponse(diamondListResp);
      } catch (error) {
        if (page == DEFAULT_PAGE) {
          arraDiamond.clear();
          diamondList.state.listCount = arraDiamond.length;
          diamondList.state.totalCount = arraDiamond.length;
          manageDiamondSelection();
        }

        diamondList.state.setApiCalling(false);
      }
    });
  }

  handleOfflineStockResponse(DiamondListResp diamondListResp) {
    if (page == DEFAULT_PAGE) {
      hasData = diamondListResp.data.diamonds.length > 0 ||
          diamondListResp.data.list.length > 0;
    }

    arraDiamond.addAll(diamondListResp.data.diamonds);
    diamondConfig.setMatchPairItem(arraDiamond,
        isLayoutSearch: isLayoutSearch ?? false);
    diamondList.state.listCount = arraDiamond.length;
    diamondList.state.totalCount = diamondListResp.data.count;
    manageDiamondSelection();
    //callBlockApi(isProgress: true);
    page = page + 1;
    diamondList.state.setApiCalling(false);
  }

  onRefreshList() {
    arraDiamond.clear();
    page = DEFAULT_PAGE;
    callApi(false);
  }

  fillArrayList({bool isFromSort = false, bool isFromLayout = false}) {
    print('<><><><><>$isFromSort');
    if ((arraDiamond.length == 0) && (isFromLayout == false)) {
      return;
    } else if ((summaryDiamond.length == 0) && (isFromLayout == true)) {
      return;
    }
    similarLength = DiamondNotExact.length;

    SlidableController controller = SlidableController();
    SlidableController controller1 = SlidableController();
    diamondList.state.listItems = viewTypeCount == 0
        ? moduleType != DiamondModuleConstant.MODULE_TYPE_LAYOUT
            ? ListView(children: [
                Container(
                  child: ListView.builder(
                    itemCount: arraDiamond.length,
                    controller: _controller,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return DiamondItemWidget(
                          controller: controller,
                          moduleType: moduleType,
                          item: arraDiamond[index],
                          leftSwipeList: getLeftAction((manageClick) async {
                            if (manageClick.type ==
                                clickConstant.CLICK_TYPE_OFFER_EDIT) {
                              //Update offer
                              List<DiamondModel> selectedList = [];
                              DiamondModel model;

                              model = DiamondModel.fromJson(
                                  arraDiamond[index].toJson());
                              model.isAddToOffer = true;
                              model.isUpdateOffer = true;
                              model.trackItemOffer =
                                  arraDiamond[index].trackItemOffer;
                              selectedList.add(model);

                              var dict = Map<String, dynamic>();
                              dict[ArgumentConstant.DiamondList] = selectedList;
                              dict[ArgumentConstant.ModuleType] = moduleType;
                              dict[ArgumentConstant.ActionType] =
                                  DiamondTrackConstant.TRACK_TYPE_OFFER;
                              dict["isOfferUpdate"] = true;

                              bool isBack = await NavigationUtilities.pushRoute(
                                  DiamondActionScreen.route,
                                  args: dict);
                              if (isBack != null && isBack) {
                                onRefreshList();
                              }
                            } else {
                              //Detail
                              var dict = Map<String, dynamic>();
                              dict[ArgumentConstant.DiamondDetail] =
                                  arraDiamond[index];
                              if (moduleType ==
                                  DiamondModuleConstant
                                      .MODULE_TYPE_INNER_LAYOUT) {
                                dict[ArgumentConstant.ModuleType] =
                                    DiamondModuleConstant
                                        .MODULE_TYPE_DETAIL_LAYOUT;
                              } else {
                                dict[ArgumentConstant.ModuleType] = moduleType;
                              }

                              //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
                              bool isBack = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                settings: RouteSettings(
                                    name: DiamondDetailScreen.route),
                                builder: (context) =>
                                    DiamondDetailScreen(arguments: dict),
                              ));
                              if (isBack != null && isBack) {
                                onRefreshList();
                              }
                            }
                          }),
                          list: getRightAction((manageClick) {
                            manageRowClick(index, manageClick.type);
                          }),
                          actionClick: (manageClick) {
                            manageRowClick(index, manageClick.type);
                            setState(() {
                              if (moduleType ==
                                      DiamondModuleConstant
                                          .MODULE_TYPE_MATCH_PAIR ||
                                  moduleType ==
                                      DiamondModuleConstant
                                          .MODULE_TYPE_INNER_LAYOUT) {
                                List<DiamondModel> filter = arraDiamond
                                    .where((element) =>
                                        element.pairStkNo ==
                                        arraDiamond[index].pairStkNo)
                                    .toList();

                                if (isNullEmptyOrFalse(filter) == false) {
                                  filter.forEach((element) {
                                    if (arraDiamond[index].isSelected) {
                                      element.isSelected = true;
                                    } else {
                                      element.isSelected = false;
                                    }
                                    diamondCalculation
                                        .setAverageCalculation(arraDiamond);
                                  });
                                }
                              }
                              if (moduleType ==
                                      DiamondModuleConstant
                                          .MODULE_TYPE_MY_OFFER ||
                                  moduleType ==
                                      DiamondModuleConstant
                                          .MODULE_TYPE_MY_OFFICE) {
                                List<DiamondModel> filter = arraDiamond
                                    .where((element) =>
                                        element.memoNo ==
                                        arraDiamond[index].memoNo)
                                    .toList();
                                if (isNullEmptyOrFalse(filter) == false) {
                                  List<DiamondModel> filter2 = filter
                                      .where((element) =>
                                          element.isSelected == true)
                                      .toList();

                                  if (filter.length == filter2.length) {
                                    filter.forEach((element) {
                                      element.isGroupSelected = true;
                                    });
                                  } else {
                                    filter.forEach((element) {
                                      element.isGroupSelected = false;
                                    });
                                  }
                                }
                              }
                            });
                          });
                    },
                  ),
                ),
                DiamondNotExact.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                        child: Row(children: [
                          Text(
                            "Similar Stones ($similarLength)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 3,
                            color: Colors.black,
                          ))
                        ]))
                    : SizedBox(),
                DiamondNotExact.isNotEmpty
                    ? Container(
                        child: ListView.builder(
                          itemCount: DiamondNotExact.length,
                          controller: _controller2,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return DiamondSimilarItemWidget(
                                controller: controller1,
                                moduleType: moduleType,
                                item: DiamondNotExact[index],
                                leftSwipeList:
                                    getLeftAction((manageClick) async {
                                  if (manageClick.type ==
                                      clickConstant.CLICK_TYPE_OFFER_EDIT) {
                                    //Update offer
                                    List<DiamondModel> selectedList = [];
                                    DiamondModel model;

                                    model = DiamondModel.fromJson(
                                        DiamondNotExact[index].toJson());
                                    model.isAddToOffer = true;
                                    model.isUpdateOffer = true;
                                    model.trackItemOffer =
                                        DiamondNotExact[index].trackItemOffer;
                                    selectedList.add(model);

                                    var dict = Map<String, dynamic>();
                                    dict[ArgumentConstant.DiamondList] =
                                        selectedList;
                                    dict[ArgumentConstant.ModuleType] =
                                        moduleType;
                                    dict[ArgumentConstant.ActionType] =
                                        DiamondTrackConstant.TRACK_TYPE_OFFER;
                                    dict["isOfferUpdate"] = true;

                                    bool isBack =
                                        await NavigationUtilities.pushRoute(
                                            DiamondActionScreen.route,
                                            args: dict);
                                    if (isBack != null && isBack) {
                                      onRefreshList();
                                    }
                                  } else {
                                    //Detail
                                    var dict = Map<String, dynamic>();
                                    dict[ArgumentConstant.DiamondDetail] =
                                        DiamondNotExact[index];
                                    dict[ArgumentConstant.ModuleType] =
                                        moduleType;

                                    //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
                                    bool isBack = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      settings: RouteSettings(
                                          name: DiamondDetailScreen.route),
                                      builder: (context) =>
                                          DiamondDetailScreen(arguments: dict),
                                    ));
                                    if (isBack != null && isBack) {
                                      onRefreshList();
                                    }
                                  }
                                }),
                                list: getRightAction((manageClick) {
                                  manageRowClick(index, manageClick.type,
                                      similar: true);
                                }),
                                actionClick: (manageClick) {
                                  manageRowClick(index, manageClick.type,
                                      similar: true);
                                  setState(() {
                                    if (moduleType ==
                                            DiamondModuleConstant
                                                .MODULE_TYPE_MATCH_PAIR ||
                                        moduleType ==
                                            DiamondModuleConstant
                                                .MODULE_TYPE_INNER_LAYOUT) {
                                      List<DiamondModel> filter =
                                          DiamondNotExact.where((element) =>
                                              element.pairStkNo ==
                                              DiamondNotExact[index]
                                                  .pairStkNo).toList();

                                      if (isNullEmptyOrFalse(filter) == false) {
                                        filter.forEach((element) {
                                          if (DiamondNotExact[index]
                                              .isSelected) {
                                            element.isSelected = true;
                                          } else {
                                            element.isSelected = false;
                                          }
                                          diamondCalculation
                                              .setAverageCalculation(
                                                  DiamondNotExact);
                                        });
                                      }
                                    }
                                    if (moduleType ==
                                            DiamondModuleConstant
                                                .MODULE_TYPE_MY_OFFER ||
                                        moduleType ==
                                            DiamondModuleConstant
                                                .MODULE_TYPE_MY_OFFICE) {
                                      List<DiamondModel> filter =
                                          DiamondNotExact.where((element) =>
                                                  element.memoNo ==
                                                  DiamondNotExact[index].memoNo)
                                              .toList();
                                      if (isNullEmptyOrFalse(filter) == false) {
                                        List<DiamondModel> filter2 = filter
                                            .where((element) =>
                                                element.isSelected == true)
                                            .toList();

                                        if (filter.length == filter2.length) {
                                          filter.forEach((element) {
                                            element.isGroupSelected = true;
                                          });
                                        } else {
                                          filter.forEach((element) {
                                            element.isGroupSelected = false;
                                          });
                                        }
                                      }
                                    }
                                  });
                                });
                          },
                        ),
                      )
                    : SizedBox()
              ])
            : GridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                childAspectRatio: 1.15,
                mainAxisSpacing: 5,
                crossAxisSpacing: 8,
                padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  bottom: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                ),
                children: List.generate(summaryDiamond.length, (index) {
                  return DiamondSquareGridItem(
                    summary: summaryDiamond[index],
                    moduleType: moduleType,
                  );
                }))

        // : viewTypeCount == 1
        //     ? ListView.builder(
        //         itemCount: arraDiamond.length,
        //         itemBuilder: (context, index) {
        //           return DiamondExpandItemWidget(
        //               item: arraDiamond[index],
        //               leftSwipeList: getLeftAction((manageClick) async {
        //                 //Detail
        //                 var dict = Map<String, dynamic>();
        //                 dict[ArgumentConstant.DiamondDetail] =
        //                     arraDiamond[index];
        //                 dict[ArgumentConstant.ModuleType] = moduleType;
        //
        //                 //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
        //                 bool isBack =
        //                     await Navigator.of(context).push(MaterialPageRoute(
        //                   settings:
        //                       RouteSettings(name: DiamondDetailScreen.route),
        //                   builder: (context) =>
        //                       DiamondDetailScreen(arguments: dict),
        //                 ));
        //                 if (isBack != null && isBack) {
        //                   onRefreshList();
        //                 }
        //               }),
        //               list: getRightAction((manageClick) {
        //                 manageRowClick(index, manageClick.type);
        //               }),
        //               actionClick: (manageClick) {
        //                 manageRowClick(index, manageClick.type);
        //               });
        //         },
        //       )
        : viewTypeCount == 1
            ? ListView(children: [
                Container(
                  child: GridView.count(
                    shrinkWrap: true,
                    controller: _controller,
                    crossAxisCount: 2,
                    childAspectRatio: (166) / (202 + 73),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                    padding: EdgeInsets.only(
                      left: getSize(Spacing.leftPadding),
                      bottom: getSize(Spacing.leftPadding),
                      right: getSize(Spacing.rightPadding),
                    ),
                    children: List.generate(arraDiamond.length, (index) {
                      var item = arraDiamond[index];
                      return DiamondGridItemWidget(
                          item: item,
                          list: getRightAction((manageClick) {
                            manageRowClick(index, manageClick.type);
                          }),
                          actionClick: (manageClick) {
                            manageRowClick(index, manageClick.type);
                            setState(() {
                              if (moduleType ==
                                      DiamondModuleConstant
                                          .MODULE_TYPE_MATCH_PAIR ||
                                  moduleType ==
                                      DiamondModuleConstant
                                          .MODULE_TYPE_INNER_LAYOUT) {
                                List<DiamondModel> filter = arraDiamond
                                    .where((element) =>
                                        element.pairStkNo ==
                                        arraDiamond[index].pairStkNo)
                                    .toList();

                                if (isNullEmptyOrFalse(filter) == false) {
                                  filter.forEach((element) {
                                    if (arraDiamond[index].isSelected) {
                                      element.isSelected = true;
                                    } else {
                                      element.isSelected = false;
                                    }
                                    diamondCalculation
                                        .setAverageCalculation(arraDiamond);
                                  });
                                }
                              }
                            });
                          });
                    }),
                  ),
                ),
                DiamondNotExact.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                        child: Row(
                          children: [
                            Text(
                              "Similar Stones ($similarLength) ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 4,
                              ),
                            )
                          ],
                        ))
                    : SizedBox(),
                DiamondNotExact.isNotEmpty
                    ? Container(
                        child: GridView.count(
                          shrinkWrap: true,
                          controller: _controller,
                          crossAxisCount: 2,
                          childAspectRatio: (166) / (202 + 73),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 8,
                          padding: EdgeInsets.only(
                            left: getSize(Spacing.leftPadding),
                            bottom: getSize(Spacing.leftPadding),
                            right: getSize(Spacing.rightPadding),
                          ),
                          children:
                              List.generate(DiamondNotExact.length, (index) {
                            var item = DiamondNotExact[index];
                            return DiamondGridItemWidget(
                                item: item,
                                list: getRightAction((manageClick) {
                                  manageRowClick(index, manageClick.type,
                                      similar: true);
                                }),
                                actionClick: (manageClick) {
                                  manageRowClick(index, manageClick.type,
                                      similar: true);
                                  setState(() {
                                    if (moduleType ==
                                            DiamondModuleConstant
                                                .MODULE_TYPE_MATCH_PAIR ||
                                        moduleType ==
                                            DiamondModuleConstant
                                                .MODULE_TYPE_INNER_LAYOUT) {
                                      List<DiamondModel> filter =
                                          DiamondNotExact.where((element) =>
                                              element.pairStkNo ==
                                              DiamondNotExact[index]
                                                  .pairStkNo).toList();

                                      if (isNullEmptyOrFalse(filter) == false) {
                                        filter.forEach((element) {
                                          if (DiamondNotExact[index]
                                              .isSelected) {
                                            element.isSelected = true;
                                          } else {
                                            element.isSelected = false;
                                          }
                                          diamondCalculation
                                              .setAverageCalculation(
                                                  DiamondNotExact);
                                        });
                                      }
                                    }
                                  });
                                });
                          }),
                        ),
                      )
                    : SizedBox()
              ])
            : GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 8,
                padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  bottom: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                ),
                children: List.generate(arraDiamond.length, (index) {
                  var item = arraDiamond[index];
                  return DiamondSquareGridItem(
                      item: item,
                      list: getRightAction((manageClick) {
                        manageRowClick(index, manageClick.type);
                      }),
                      actionClick: (manageClick) {
                        manageRowClick(index, manageClick.type);
                      });
                }),
              );

    if (isFromSort) {
      _controller.animateTo(_controller.position.minScrollExtent,
          duration: Duration(milliseconds: 10), curve: Curves.linear);
      //action
      print('ACTION');
    }
  }

  callBlockApi({bool isProgress = false}) {
    if (!app.resolve<PrefUtils>().isUserCustomer()) {
      if (page == DEFAULT_PAGE) {
        diamondConfig.callApiForBlock(context, arraDiamond, (resp) {
          fillArrayList();
        }, isProgress: isProgress);
      } else {
        diamondConfig.setBlockDetail(diamondConfig.trackBlockData, arraDiamond,
            (resp) {
          fillArrayList();
        });
      }
    }
  }

  getRightAction(ActionClick actionClick) {
    List<Widget> list = [];
    if (isDiamondSearchModule(moduleType) ||
        moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      list.add(
        IntrinsicHeight(
          child: IconSlideAction(
            color: Colors.transparent,
            onTap: () {
              actionClick(
                ManageCLick(type: clickConstant.CLICK_TYPE_DETAIL),
              );
              AnalyticsReport.shared.sendAnalyticsData(
                buildContext: context,
                page: PageAnalytics.DIAMOND_DETAIL,
                section: SectionAnalytics.DETAILS,
                action: ActionAnalytics.CLICK,
              );
            },
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    border: Border.all(color: appTheme.colorPrimary),
                    shape: BoxShape.circle,
                  ),
                  height: getSize(40),
                  width: getSize(40),
                  child: Padding(
                    padding: EdgeInsets.all(getSize(10)),
                    child: Image.asset(
                      viewDetail,
                      // height: getSize(20),
                      // width: getSize(20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getSize(8)),
                  child: Text(
                    R.string.commonString.details,
                    style: appTheme.primaryNormal12TitleColor,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    if (isDisplayDelete(moduleType)) {
      list.add(
        IntrinsicHeight(
          child: IconSlideAction(
            color: Colors.transparent,
            onTap: () {
              actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_DELETE));
            },
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: fromHex("#FFE7E7"),
                    border: Border.all(color: fromHex("#FF4D4D")),
                    shape: BoxShape.circle,
                  ),
                  height: getSize(40),
                  width: getSize(40),
                  child: Padding(
                    padding: EdgeInsets.all(getSize(10)),
                    child: Image.asset(
                      home_delete,
                      // height: getSize(20),
                      // width: getSize(20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getSize(8)),
                  child: Text(R.string.commonString.delete,
                      style: appTheme.primaryNormal12TitleColor.copyWith(
                        color: fromHex("#FF4D4D"),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    }

    return list;
  }

  getLeftAction(ActionClick actionClick) {
    List<Widget> leftSwipeList = [];

    if (isDisplayDetail(moduleType) &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      if (!isDiamondSearchModule(moduleType)) {
        leftSwipeList.add(
          IntrinsicHeight(
            child: IconSlideAction(
              color: Colors.transparent,
              onTap: () {
                actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_DELETE));
                AnalyticsReport.shared.sendAnalyticsData(
                  buildContext: context,
                  page: PageAnalytics.DIAMOND_DETAIL,
                  section: SectionAnalytics.DETAILS,
                  action: ActionAnalytics.CLICK,
                );
              },
              iconWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: appTheme.whiteColor,
                      border: Border.all(color: appTheme.colorPrimary),
                      shape: BoxShape.circle,
                    ),
                    height: getSize(40),
                    width: getSize(40),
                    child: Padding(
                      padding: EdgeInsets.all(getSize(10)),
                      child: Image.asset(
                        viewDetail,
                        // height: getSize(20),
                        // width: getSize(20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: getSize(8)),
                    child: Text(
                      R.string.commonString.details,
                      style: appTheme.primaryNormal12TitleColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }

    /*if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      leftSwipeList.add(
        IntrinsicHeight(
          child: IconSlideAction(
            color: Colors.transparent,
            onTap: () {
              actionClick(
                  ManageCLick(type: clickConstant.CLICK_TYPE_OFFER_EDIT));
            },
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appTheme.lightColorPrimary,
                    border: Border.all(color: appTheme.colorPrimary),
                    shape: BoxShape.circle,
                  ),
                  height: getSize(40),
                  width: getSize(40),
                  child: Padding(
                    padding: EdgeInsets.all(getSize(10)),
                    child: Image.asset(
                      editPen,
                      height: getSize(16),
                      width: getSize(16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getSize(8)),
                  child: Text(
                    R.string.commonString.edit,
                    style: appTheme.primaryNormal12TitleColor,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }*/

    return leftSwipeList;
  }

  List<Widget> getToolbarItem() {
    final key = GlobalKey<State<Tooltip>>();
    User userAccount = app.resolve<PrefUtils>().getUserDetails();
    List<Widget> list = [];
    for (int i = 0; i < diamondConfig.toolbarList.length - 1; i++) {
      var element = diamondConfig.toolbarList[i];
      /*if (element.code == BottomCodeConstant.TBDownloadView &&
          OfflineStockManager.shared.isDownloading) {
        list.add(
          GestureDetector(
            onTap: () {
              app.resolve<CustomDialogs>().confirmDialog(context,
                  title: APPNAME,
                  desc:
                      "Are you sure you want to cancel offline stock download?",
                  positiveBtnTitle: R.string.commonString.yes,
                  negativeBtnTitle: R.string.commonString.no,
                  onClickCallback: (btnType) {
                if (btnType == ButtonType.PositveButtonClick) {
                  OfflineStockManager.shared.canelDownload();
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: i == diamondConfig.toolbarList.length - 1
                      ? getSize(Spacing.rightPadding)
                      : getSize(8),
                  left: getSize(8.0)),
              child: SizedBox(
                height: getSize(24),
                width: getSize(24),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: getSize(24),
                        width: getSize(24),
                        child: CircularProgressIndicator(
                          strokeWidth: getSize(3),
                          value: OfflineStockManager.shared.downloadProgress,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(appTheme.textColor),
                          backgroundColor: appTheme.textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        OfflineStockManager.shared.downloadProgressText(),
                        style: appTheme.primaryNormal12TitleColor.copyWith(
                          fontSize: getSize(8),
                          color: appTheme.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }*/
      /*else if (element.code == BottomCodeConstant.TBCompanySelction) {
        GestureDetector(
          onTap: !isNullEmptyOrFalse(arraDiamond)
              ? () {
            manageToolbarClick(element);
          }
              : null,
          child: Padding(
            padding: EdgeInsets.only(
                right: */ /*i == diamondConfig.toolbarList.length - 1
                    ? getSize(Spacing.rightPadding)
                    : */ /*getSize(8),
                left: getSize(8.0)),
            child: Column(
//              alignment: Alignment.topCenter,
              children: [
                Center(
                  child: Image.asset(
                    buildingIcon,
                    height: getSize(20),
                    width: getSize(20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: getSize(10),
                  ),
                  height: getSize(8),
                  width: getSize(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appTheme.colorPrimary,
                  ),
                )
              ],
            ),
          ),
        );
      }*/
      // else {
      list.add(GestureDetector(
        onTap: !isNullEmptyOrFalse(arraDiamond)
            ? () {
                manageToolbarClick(element);
              }
            : null,
        child: Padding(
          padding: EdgeInsets.only(
              right: i == diamondConfig.toolbarList.length - 1
                  ? getSize(Spacing.rightPadding)
                  : getSize(8),
              left: getSize(8.0)),
          child: element.code == BottomCodeConstant.TBCompanySelection
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Center(
                      child: Image.asset(
                        buildingIcon,
                        height: getSize(20),
                        width: getSize(20),
                      ),
                    ),
                    Visibility(
                      visible: isCompanySelected,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: getSize(10),
                        ),
                        height: getSize(8),
                        width: getSize(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.colorPrimary,
                        ),
                      ),
                    )
                  ],
                )
              : (element.code == BottomCodeConstant.TBCreditLimit)
                  ? Tooltip(
                      key: key,
                      message:
                          "Credit Limit:\$${userAccount.account.crdLmt.toString()}",
                      child: InkWell(
                        onTap: () {
                          final dynamic tooltip = key.currentState;
                          tooltip?.ensureTooltipVisible();
                        },
                        child: Image.asset(
                          element.image,
                          height: getSize(20),
                          width: getSize(20),
                        ),
                      ),
                    )
                  : (element.code == BottomCodeConstant.TBContactUs)
                      ? InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    backgroundColor: Colors.white,
                                    children: [
                                      // Text(
                                      //   R.string.screenTitle
                                      //       .salesPersonDetail,
                                      //   key: checkTourIsShown()
                                      //       ? sellerKey
                                      //       : null,
                                      //   style: appTheme
                                      //       .blackNormal18TitleColorblack
                                      //       .copyWith(
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: getSize(16),
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: getSize(0),
                                          right: getSize(0),
                                        ),
                                        child: Material(
                                          // elevation: 10,
                                          // shadowColor: appTheme.shadowColor,
                                          // borderRadius: BorderRadius.circular(
                                          //     getSize(5)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appTheme.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      getSize(5)),
                                              // border: Border.all(
                                              //     width: getSize(1),
                                              //     color:
                                              //         appTheme.borderColor),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: getSize(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Hello, " +
                                                                userAccount
                                                                    .getFullName() ??
                                                            "-",
                                                        style: appTheme
                                                            .black18TextStyle
                                                            .copyWith(
                                                          color: appTheme
                                                              .colorPrimary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Spacer(),

                                                      // Spacer(),
                                                      // InkWell(onTap : (){

                                                      // }, child : Image.asset(CrossAxisAlignment.start))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: getSize(10),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Your Customer representativ is,",
                                                        style: appTheme
                                                            .black16TextStyle
                                                            .copyWith(
                                                          color: appTheme
                                                              .colorPrimary,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      Spacer(),

                                                      // Spacer(),
                                                      // InkWell(onTap : (){

                                                      // }, child : Image.asset(CrossAxisAlignment.start))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: getSize(10),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        app
                                                                .resolve<
                                                                    PrefUtils>()
                                                                .getDashboardDetails()
                                                                .seller
                                                                .firstName +
                                                            " " +
                                                            app
                                                                .resolve<
                                                                    PrefUtils>()
                                                                .getDashboardDetails()
                                                                .seller
                                                                .lastName,
                                                        style: appTheme
                                                            .black18TextStyle
                                                            .copyWith(
                                                          color: appTheme
                                                              .colorPrimary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(" | "),
                                                      InkWell(
                                                        onTap: () {
                                                          if (!isNullEmptyOrFalse(app
                                                              .resolve<
                                                                  PrefUtils>()
                                                              .getDashboardDetails()
                                                              .seller
                                                              .mobile)) {
                                                            openURLWithApp(
                                                                "tel://${PrefUtils().getDashboardDetails().seller.mobile}",
                                                                context);
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            // Image.asset(
                                                            //   phone,
                                                            //   width: getSize(16),
                                                            //   height: getSize(16),
                                                            // ),
                                                            // SizedBox(
                                                            //   width: getSize(10),
                                                            // ),
                                                            Text(
                                                              app
                                                                      .resolve<
                                                                          PrefUtils>()
                                                                      .getDashboardDetails()
                                                                      .seller
                                                                      .mobile ??
                                                                  "-",
                                                              style: appTheme
                                                                  .black16TextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      // Row(
                                                      //   mainAxisSize: MainAxisSize.min,
                                                      //   children: [
                                                      //     InkWell(
                                                      //         onTap: () async {
                                                      //           await whatsAppOpen(
                                                      //               this.dashboardModel.seller.mobile);
                                                      //         },
                                                      //         child: Image.asset(
                                                      //           whatsappIcon,
                                                      //           height: getSize(20),
                                                      //           width: getSize(20),
                                                      //         )),
                                                      //     SizedBox(width: getSize(18)),
                                                      //     InkWell(
                                                      //       onTap: () {
                                                      //         //change firstname to skypeId, when available on server.
                                                      //         openSkype(
                                                      //             this.dashboardModel.seller.firstName);
                                                      //       },
                                                      //       child: Image.asset(
                                                      //         skypeIcon,
                                                      //         height: getSize(20),
                                                      //         width: getSize(20),
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // )
                                                      // Spacer(),
                                                      // InkWell(onTap : (){

                                                      // }, child : Image.asset(CrossAxisAlignment.start))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: getSize(10),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!isNullEmptyOrFalse(app
                                                          .resolve<PrefUtils>()
                                                          .getDashboardDetails()
                                                          .seller
                                                          .email)) {
                                                        openURLWithApp(
                                                            "mailto:?subject=Arjiv&body=Arjiv",
                                                            context);
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        // Image.asset(
                                                        //   email,
                                                        //   width: getSize(16),
                                                        //   height: getSize(16),
                                                        // ),
                                                        Text(
                                                          "Email :",
                                                          style: appTheme
                                                              .black16TextStyle,
                                                        ),
                                                        SizedBox(
                                                          width: getSize(7),
                                                        ),
                                                        Text(
                                                          app
                                                                  .resolve<
                                                                      PrefUtils>()
                                                                  .getDashboardDetails()
                                                                  .seller
                                                                  ?.email ??
                                                              "-",
                                                          style: appTheme
                                                              .black16TextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: getSize(10),
                                                  ),
                                                  (!isNullEmptyOrFalse(app
                                                          .resolve<PrefUtils>()
                                                          .getDashboardDetails()
                                                          .seller
                                                          .skype))
                                                      ? InkWell(
                                                          onTap: () async {
                                                            if (!isNullEmptyOrFalse(app
                                                                .resolve<
                                                                    PrefUtils>()
                                                                .getDashboardDetails()
                                                                .seller
                                                                .skype)) {
                                                              await openSkype(
                                                                  app
                                                                      .resolve<
                                                                          PrefUtils>()
                                                                      .getDashboardDetails()
                                                                      .seller
                                                                      .skype,
                                                                  context);
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              // Image.asset(
                                                              //   email,
                                                              //   width: getSize(16),
                                                              //   height: getSize(16),
                                                              // ),
                                                              Text(
                                                                "Skype :",
                                                                style: appTheme
                                                                    .black16TextStyle,
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    getSize(7),
                                                              ),
                                                              Text(
                                                                app
                                                                        .resolve<
                                                                            PrefUtils>()
                                                                        .getDashboardDetails()
                                                                        .seller
                                                                        ?.skype ??
                                                                    "-",
                                                                style: appTheme
                                                                    .black16TextStyle,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  // SizedBox(
                                                  //   height: getSize(10),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Image.asset(
                            contactUs,
                            height: getSize(20),
                            width: getSize(20),
                          ),
                        )
                      : Image.asset(
                          element.isSelected
                              ? (element.selectedImage != null
                                  ? element.selectedImage
                                  : element.image)
                              : element.image,
                          height: getSize(20),
                          width: getSize(20),
                        ),
        ),
      ));
    }

    ;

    return list;
  }

  callDeleteDiamond(List<DiamondModel> selectedList) {
    diamondConfig.manageDiamondAction(context, selectedList,
        BottomTabModel(type: ActionMenuConstant.ACTION_TYPE_DELETE), () {
      onRefreshList();
    }, moduleType: moduleType);
  }

  manageRowClick(int index, int type, {bool similar = false}) async {
    switch (type) {
      case clickConstant.CLICK_TYPE_DELETE:
        List<DiamondModel> selectedList = [];
        selectedList.add(arraDiamond[index]);
        callDeleteDiamond(selectedList);
        break;
      case clickConstant.CLICK_TYPE_EDIT:
        if (similar == true) {
          List<DiamondModel> selectedList = [];
          DiamondModel model;

          model = DiamondModel.fromJson(DiamondNotExact[index].toJson());
          model.isAddToOffer = true;
          model.isUpdateOffer = true;
          model.trackItemOffer = DiamondNotExact[index].trackItemOffer;
          selectedList.add(model);

          var dict = Map<String, dynamic>();
          dict[ArgumentConstant.DiamondList] = selectedList;
          dict[ArgumentConstant.ModuleType] = moduleType;
          dict[ArgumentConstant.ActionType] =
              DiamondTrackConstant.TRACK_TYPE_OFFER;
          dict["isOfferUpdate"] = true;

          bool isBack = await NavigationUtilities.pushRoute(
              DiamondActionScreen.route,
              args: dict);
          if (isBack != null && isBack) {
            onRefreshList();
          }
        } else {
          List<DiamondModel> selectedList = [];
          DiamondModel model;

          model = DiamondModel.fromJson(arraDiamond[index].toJson());
          model.isAddToOffer = true;
          model.isUpdateOffer = true;
          model.trackItemOffer = arraDiamond[index].trackItemOffer;
          selectedList.add(model);

          var dict = Map<String, dynamic>();
          dict[ArgumentConstant.DiamondList] = selectedList;
          dict[ArgumentConstant.ModuleType] = moduleType;
          dict[ArgumentConstant.ActionType] =
              DiamondTrackConstant.TRACK_TYPE_OFFER;
          dict["isOfferUpdate"] = true;

          bool isBack = await NavigationUtilities.pushRoute(
              DiamondActionScreen.route,
              args: dict);
          if (isBack != null && isBack) {
            onRefreshList();
          }
        }
        break;
      case clickConstant.CLICK_TYPE_SELECTION:
      case clickConstant.CLICK_TYPE_ROW:
        setState(() {
          if (similar == true) {
            DiamondNotExact[index].isSelected =
                !DiamondNotExact[index].isSelected;
            manageDiamondSelection(similar: similar);
          } else {
            arraDiamond[index].isSelected = !arraDiamond[index].isSelected;
            manageDiamondSelection();
            diamondConfig.toolbarList.forEach((element) {
              if (element.code == BottomCodeConstant.TBSelectAll) {
                setAllSelectImage(element);
              }
            });
          }
        });
        break;
      case clickConstant.CLICK_TYPE_DETAIL:
        if (similar == true) {
          var dict = Map<String, dynamic>();
          dict[ArgumentConstant.DiamondDetail] = DiamondNotExact[index];
          dict[ArgumentConstant.ModuleType] = moduleType;

          //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
          bool isBack = await Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: DiamondDetailScreen.route),
            builder: (context) => DiamondDetailScreen(arguments: dict),
          ));
          if (isBack != null && isBack) {
            onRefreshList();
          }
        } else {
          var dict = Map<String, dynamic>();
          dict[ArgumentConstant.DiamondDetail] = arraDiamond[index];
          dict[ArgumentConstant.ModuleType] = moduleType;

          //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
          bool isBack = await Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: DiamondDetailScreen.route),
            builder: (context) => DiamondDetailScreen(arguments: dict),
          ));
          if (isBack != null && isBack) {
            onRefreshList();
          }
        }
        break;
      // case clickConstant.CLICK_TYPE_ROW:
      //   var dict = Map<String, dynamic>();
      //   dict[ArgumentConstant.DiamondDetail] = arraDiamond[index];
      //   dict[ArgumentConstant.ModuleType] = moduleType;

      //   //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
      //   bool isBack = await Navigator.of(context).push(MaterialPageRoute(
      //     settings: RouteSettings(name: DiamondDetailScreen.route),
      //     builder: (context) => DiamondDetailScreen(arguments: dict),
      //   ));
      //   if (isBack != null && isBack) {
      //     onRefreshList();
      //   }
      //   break;
    }
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBCompanySelection:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SelectionScreen(
                title: R.string.screenTitle.selectCompany,
                hintText: R.string.commonString.search,
                positiveButtonTitle: R.string.commonString.apply,
                negativeButtonTitle: R.string.commonString.cancel,
                isSearchEnable: true,
                type: CellType.Company,
                isMultiSelectionEnable: false,
                applyFilterCallBack: (
                    {List<SelectionPopupModel> multiSelectedItem}) {
                  isCompanySelected = true;
                  app.resolve<PrefUtils>().saveCompany(multiSelectedItem.first);
                  setState(() {});
                },
              );
            },
          ),
        );
        break;
      case BottomCodeConstant.TBSelectAll:
        model.isSelected = !model.isSelected;
        if (model.isSelected)
          print("--image------------${model.image}");
        else
          print("--image------------${model.image}");
        setSelectAllDiamond(model);
        break;
      case BottomCodeConstant.TBGrideView:
        if (viewTypeCount == 1) {
          viewTypeCount = 0;
        } else {
          viewTypeCount = 1;
        }
        if (sort == true) {
          fillArrayList(isFromSort: true);
        } else {
          fillArrayList();
        }
        model.isSelected = !model.isSelected;
        setState(() {});
        diamondList.state.setApiCalling(false);
        break;
      case BottomCodeConstant.TBSortView:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          builder: (_) => FilterBy(
            optionList: optionList,
            callBack: (value) {
              sortRequest = value;
              callApi(true);
              if (value != null) {
                sort = true;
                fillArrayList(isFromSort: true);
              }
            },
          ),
        );

        break;
      // case BottomCodeConstant.TBDownloadView:
      //   if (moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
      //     if (Platform.isIOS) {
      //       LocalNotificationManager.instance
      //           .requestPermissions()
      //           .then((value) {
      //         diamondConfig.actionDownloadOffline(
      //           context,
      //           () {
      //             onRefreshList();
      //           },
      //           sortRequest: sortRequest,
      //           filterId: filterId,
      //         );
      //       });
      //     } else {
      //       diamondConfig.actionDownloadOffline(
      //         context,
      //         () {
      //           onRefreshList();
      //         },
      //         sortRequest: sortRequest,
      //         filterId: filterId,
      //       );
      //     }
      //   } else {
      //     List<DiamondModel> selectedList =
      //         arraDiamond.where((element) => element.isSelected).toList();
      //     if (!isNullEmptyOrFalse(selectedList)) {
      //       BottomTabModel tabModel = BottomTabModel();
      //       tabModel.type = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
      //       diamondConfig.manageDiamondAction(context, arraDiamond, tabModel,
      //           () {
      //         onRefreshList();
      //       });
      //     } else {
      //       app.resolve<CustomDialogs>().confirmDialog(
      //             context,
      //             title: "",
      //             desc: R.string.errorString.diamondSelectionError,
      //             positiveBtnTitle: R.string.commonString.ok,
      //           );
      //     }
      //   }
      //   break;
    }
  }

  setSelectAllDiamond(BottomTabModel model) {
    arraDiamond.forEach((element) {
      if ((moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) &&
          ((element.offerStatus == OfferStatus.expired) ||
              (element.offerStatus == OfferStatus.rejected))) {
      } else {
        element.isSelected = model.isSelected;
      }
    });
    setAllSelectImage(model);
    setState(() {});
    manageDiamondSelection();
  }

  setAllSelectImage(BottomTabModel model) {
    List<DiamondModel> list =
        arraDiamond.where((element) => element.isSelected).toList();
    model.isSelected = (list != null && list.length == arraDiamond.length);
  }

  manageDiamondSelection({bool layout = false, bool similar = false}) {
    if (sort == true) {
      fillArrayList(isFromSort: true);
    } else if (layout) {
      fillArrayList(isFromLayout: layout);
    } else {
      fillArrayList();
    }

    diamondCalculation.setAverageCalculation(FinalArrDiamond);
    if (moduleType == DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
      if (similar == true) {
        diamondFinalCalculation.setAverageCalculation(DiamondNotExact,
            isFinalCalculation: true);
      } else {
        diamondFinalCalculation.setAverageCalculation(FinalArrDiamond,
            isFinalCalculation: true);
      }
    }
    diamondList.state.setApiCalling(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = false;
    if (!isNullEmptyOrFalse(arraDiamond)) {
      isVisible =
          arraDiamond.where((element) => element.isSelected).toList().length >
              0;
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: appTheme.whiteColor,
          appBar: getAppBar(
            context,
            moduleType != DiamondModuleConstant.MODULE_TYPE_LAYOUT
                ? diamondConfig.getScreenTitle()
                : diamondConfig.getScreenTitle() +
                    " (" +
                    summaryDiamond.length.toString() +
                    ")",
            bgColor: appTheme.whiteColor,
            leadingButton: isFromDrawer
                ? getDrawerButton(context, true)
                : getBackButton(
                    context, /*ontap: (){
                  Navigator.pop(context);
                  app.resolve<PrefUtils>().saveCompany(null);
            }*/
                  ),
            centerTitle: false,
            textalign: TextAlign.left,
            actionItems: moduleType != DiamondModuleConstant.MODULE_TYPE_LAYOUT
                ? getToolbarItem()
                : null,
          ),
          bottomNavigationBar: getBottomTab(),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                hasData
                    ? DiamondListHeader(
                        diamondCalculation: diamondCalculation,
                        moduleType: moduleType,
                      )
                    : SizedBox(),
                SizedBox(height: getSize(8)),
                if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER)
                  Padding(
                    padding: EdgeInsets.only(
                      left: getSize(16),
                      right: getSize(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: getSize(16),
                              width: getSize(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(getSize(4)),
                                color: appTheme.greenColor,
                              ),
                            ),
                            SizedBox(width: getSize(6)),
                            Text(
                              'Admin Offer',
                              style: appTheme.blackNormal14TitleColorblack,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: getSize(16),
                              width: getSize(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(getSize(4)),
                                color: appTheme.redColor,
                              ),
                            ),
                            SizedBox(width: getSize(6)),
                            Text(
                              'My Offer List',
                              style: appTheme.blackNormal14TitleColorblack,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: getSize(16),
                ),
                Expanded(
                  child: diamondList,
                ),
                /*this.moduleType ==
                        DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION
                    ? AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: isVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: FinalCalculationWidget(
                            arraDiamond, this.diamondFinalCalculation))
                    : SizedBox(),*/
              ],
            ),
          ),
        ),
        showOverlayScreens(),
      ],
    );
  }

  showOverlayScreens() {
    if (this.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      return (app
                      .resolve<PrefUtils>()
                      .isDisplayedTour(PrefUtils().keyOfferTour) ==
                  false &&
              isNullEmptyOrFalse(arraDiamond) == false)
          ? OverlayScreen(
              DiamondModuleConstant.MODULE_TYPE_MY_OFFER,
              finishTakeTour: () {
                setState(() {});
              },
              scrollIndex: (index) {},
            )
          : SizedBox();
    }

    if (this.moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
      return (app
                      .resolve<PrefUtils>()
                      .isDisplayedTour(PrefUtils().keySearchResultTour) ==
                  false &&
              isNullEmptyOrFalse(arraDiamond) == false)
          ? OverlayScreen(
              DiamondModuleConstant.MODULE_TYPE_DIAMOND_SEARCH_RESULT,
              finishTakeTour: () {
                setState(() {});
              },
              scrollIndex: (index) {},
            )
          : SizedBox();
    }

    return SizedBox();
  }

  Widget getBottomTab() {
    return hasData
        ? BottomTabbarWidget(
            arrBottomTab: diamondConfig.arrBottomTab,
            onClickCallback: (obj) {
              if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
                List<DiamondModel> selectedList =
                    arraDiamond.where((element) => element.isSelected).toList();
                List<DiamondModel> selectedList1 =
                    DiamondNotExact.where((element) => element.isSelected)
                        .toList();
                List<DiamondModel> selectedListFinal = new List<DiamondModel>();
                selectedListFinal.addAll(selectedList);
                selectedListFinal.addAll(selectedList1);
                print("ListFinal........................$selectedListFinal");
                print("List........................$selectedList");
                print("List1........................$selectedList1");
                if (!isNullEmptyOrFalse(selectedListFinal)) {
                  showBottomSheetForMenu(
                    context,
                    diamondConfig.arrMoreMenu,
                    (manageClick) {
                      if (manageClick.bottomTabModel.type ==
                          ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
                        clearSelection();
                      } else {
                        manageBottomMenuClick(manageClick.bottomTabModel);
                      }
                    },
                    R.string.commonString.more,
                    isDisplaySelection: false,
                  );
                  // } else {
                  //   app.resolve<CustomDialogs>().errorDialog(
                  //         context,
                  //         "",
                  //         R.string.commonString
                  //             .holdMemoStatusDiamondMoreActions,
                  //         btntitle: R.string.commonString.ok,
                  //       );
                  // }
                } else {
                  app.resolve<CustomDialogs>().confirmDialog(
                        context,
                        title: "",
                        desc: R.string.errorString.diamondSelectionError,
                        positiveBtnTitle: R.string.commonString.ok,
                      );
                }
                // } else if (obj.type == ActionMenuConstant.ACTION_TYPE_STATUS) {
                //   showStatusDialogue();
//          showBottomSheetForMenu(context, diamondConfig.arrStatusMenu,
//              (manageClick) {}, R.string.commonString.status,
//              isDisplaySelection: false);
              } else if (obj.type ==
                  ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
                clearSelection();
              }
              //   else if (){
              //     app.resolve<CustomDialogs>().confirmDialog(
              //       context,
              //       title: "Hello Error",
              //       desc: R.string.errorString.diamondSelectionError,
              //       positiveBtnTitle: R.string.commonString.ok,
              //     );
              // }
              else {
                manageBottomMenuClick(obj);
              }
            },
          )
        : SizedBox();
  }

  showStatusDialogue() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: appTheme.whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(getSize(15)),
                      )),
                  margin: EdgeInsets.only(
                    left: getSize(30),
                    right: getSize(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: getSize(20),
                      ),
                      Text(
                        "Status",
                        style: appTheme.blackSemiBold18TitleColorblack,
                      ),
                      SizedBox(
                        height: getSize(10),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: diamondConfig.arrStatusMenu.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getStatusDialogueRow(
                            title: diamondConfig.arrStatusMenu[index].title,
                            color:
                                diamondConfig.arrStatusMenu[index].imageColor,
                          );
                        },
                      ),
                      SizedBox(
                        height: getSize(30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getStatusDialogueRow({Color color, String title}) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: getSize(10), horizontal: getSize(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: getSize(22),
            width: getSize(22),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(getSize(5)),
            ),
          ),
          SizedBox(
            width: getSize(10),
          ),
          Text(
            title,
            style: appTheme.black14TextStyle
                .copyWith(color: appTheme.textBlackColor),
          ),
        ],
      ),
    );
  }

  clearSelection() {
    arraDiamond.forEach((element) {
      element.isSelected = false;
    });
    diamondConfig.toolbarList.forEach((element) {
      if (element.code == BottomCodeConstant.TBSelectAll)
        element.isSelected = false;
    });
    manageDiamondSelection();
    setState(() {});
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        arraDiamond.where((element) => element.isSelected).toList();
    List<DiamondModel> selectedList1 =
        DiamondNotExact.where((element) => element.isSelected).toList();
    List<DiamondModel> selectedListFinal = List<DiamondModel>();
    selectedListFinal.addAll(selectedList);
    selectedListFinal.addAll(selectedList1);
    if (!isNullEmptyOrFalse(selectedListFinal)) {
      if (bottomTabModel.type == ActionMenuConstant.ACTION_TYPE_DELETE) {
        callDeleteDiamond(selectedListFinal);
      } else {
        diamondConfig.manageDiamondAction(
            context, selectedListFinal, bottomTabModel, () {
          onRefreshList();
        });
      }
    } else {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: "",
            desc: R.string.errorString.diamondSelectionError,
            positiveBtnTitle: R.string.commonString.ok,
          );
    }
  }

  void sendAnalyticsReport() {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MYSAVED_SEARCH,
          section: SectionAnalytics.SEARCH,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.SEARCH_RESULT,
          section: SectionAnalytics.SEARCH,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MATCH_PAIRS,
          section: SectionAnalytics.MATCHPAIRS,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.NEW_GOODS,
          section: SectionAnalytics.NEWGOODS,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_BID,
          section: SectionAnalytics.LIST,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.UPCOMING_DIAMOND,
          section: SectionAnalytics.LIST,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.EXCLUSIVE_DIAMOND,
          section: SectionAnalytics.EXCLUSIVEDIAMOND,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_BID,
          section: SectionAnalytics.LIST,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_REMINDER,
          section: SectionAnalytics.REMINDER,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_CART:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_CART,
          section: SectionAnalytics.CART,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_WATCHLIST,
          section: SectionAnalytics.WATCHLIST,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_ENQUIRY,
          section: SectionAnalytics.ENQUIRY,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_OFFER,
          section: SectionAnalytics.MYOFFER,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.MY_COMMENT,
          section: SectionAnalytics.COMMENT,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.STONE_OF_THE_DAY,
          section: SectionAnalytics.LIST,
          action: ActionAnalytics.LIST,
        );
        break;
      case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH:
        AnalyticsReport.shared.sendAnalyticsData(
          buildContext: context,
          page: PageAnalytics.OfflineSearchHistory,
          section: SectionAnalytics.OFFLINESEARCH,
          action: ActionAnalytics.LIST,
        );
        break;
    }
  }
}
