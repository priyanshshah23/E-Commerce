import 'dart:io';

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
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
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
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/AnalyticsModel/AnalyticsModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rxbus/rxbus.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  String filterId = "";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;
  List<FormBaseModel> filterModel;

  String downloadDate = "";

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
      if (arguments["filterModel"] != null) {
        filterModel = arguments["filterModel"];
      }
      if (arguments["downloadDate"] != null) {
        downloadDate = arguments["downloadDate"];
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
      );
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

  _DiamondListScreenState(
      {this.filterId,
      this.moduleType,
      this.isFromDrawer,
      this.filterModel,
      this.downloadDate});

  DiamondConfig diamondConfig;
  BaseList diamondList;
  List<DiamondModel> arraDiamond = List<DiamondModel>();
  int page = DEFAULT_PAGE;
  DiamondCalculation diamondCalculation = DiamondCalculation();
  DiamondCalculation diamondFinalCalculation = DiamondCalculation();
  List<FilterOptions> optionList = List<FilterOptions>();
  bool isGrid = false;
  bool hasData = false;
  int viewTypeCount = 0;
  ScreenshotCallback screenshotCallback = ScreenshotCallback();

  @override
  void initState() {
    super.initState();
    Config().getOptionsJson().then((result) {
      result.forEach((element) {
        if (element.isActive) {
          optionList.add(element);
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
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    if (sortRequest != null) {
      dict["sort"] = sortRequest;
    }

    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
      case DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH:
        dict["filters"] = [{
          "diamondSearchId" : this.filterId
        }];
//        dict["filters"]["diamondSearchId"] = this.filterId;
        break;
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
      dict["filters"] = [{
          "diamondSearchId" : this.filterId
        }];
        // dict["filters"] = [{}];
        // dict["filters"]["diamondSearchId"] = this.filterId;

        break;
      case DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR:
        dict["filters"] = [{
          "diamondSearchId" : this.filterId
        }];
//        dict["filters"] = [{}];
//        dict["filter"]["diamondSearchId"] = this.filterId;
        break;
      case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
        dict["filters"] = [{}];
        dict["viewType"] = 2;
        break;
      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        dict["filters"] = [{
          "wSts" : DiamondStatus.DIAMOND_STATUS_BID
        }];
//        dict["filters"] = [{}];
//        dict["filters"]["wSts"] = DiamondStatus.DIAMOND_STATUS_BID;
        break;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        var date = DateTime.now();
        dict["filters"] = [{
          "wSts" : DiamondStatus.DIAMOND_STATUS_UPCOMING,
          "inDt":{
            "<=" : date.add(Duration(days: 7)).toUtc().toIso8601String()
          }
        }];
        Map<String, dynamic> dict1 = Map<String, dynamic>();
        dict1["inDt"] = "ASC";
        dict["sort"] = [dict1];

//        dict["filters"] = [{}];
//        dict["filters"]["wSts"] = DiamondStatus.DIAMOND_STATUS_UPCOMING;
//        dict["filters"]["inDt"] = {};
//
//        print(date.add(Duration(days: 5, hours: 5, minutes: 30)));
//        dict["filters"]["inDt"]["<="] =
//            date.add(Duration(days: 7)).toUtc().toIso8601String();
//        Map<String, dynamic> dict1 = Map<String, dynamic>();
//        dict1["inDt"] = "ASC";
//        dict["sort"] = [dict1];

        break;
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        dict["filters"] = [{
          "or" : diamondConfig.getExclusiveDiamondReq()
        }];
//        dict["filters"] = {};
//        dict["filters"]["or"] = diamondConfig.getExclusiveDiamondReq();
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
        dict["filters"] = [{
          "wSts" : "D"
        }];
//        dict["filters"] = {};
//        dict["filters"]["wSts"] = "D";

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
        hasData = diamondListResp.data[0].diamonds.length > 0 ||
            diamondListResp.data[0].list.length > 0;
      }
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
          diamondListResp.data[0].list.forEach((element) {
            if (element.diamonds != null) {
              element.diamonds.forEach((diamonds) {
                switch (moduleType) {
                  case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
                    diamonds.memoNo = element.id;
                    diamonds.date = element.date;
                    diamonds.createdAt = element.createdAt;
                    diamonds.purpose = element.purpose;
                    break;
                }
                list.add(diamonds);
              });
            } else {
              diamondModel = element.diamond;
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
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
                  diamondModel.createdAt = element.createdAt;
                  diamondModel.trackItemOffer = trackDiamonds;
                  diamondModel.memoNo = element.memoNo;
                  diamondModel.offerValidDate = element.offerValidDate;
                  diamondModel.offerStatus = element.offerStatus;
                  diamondModel.newAmount = element.newAmount;
                  diamondModel.newDiscount = element.newDiscount;
                  diamondModel.newPricePerCarat = element.newPricePerCarat;
                  diamondModel.remarks = element.remarks;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
                  diamondModel.trackItemReminder = trackDiamonds;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
                  diamondModel.trackItemComment = trackDiamonds;
                  break;

                case DiamondModuleConstant.MODULE_TYPE_MY_BID:
                  diamondModel.trackItemBid = trackDiamonds;
                  break;
              }
              list.add(diamondModel);
            }
          });
          arraDiamond.addAll(list);
          break;

        default:
          arraDiamond.addAll(diamondListResp.data[0].diamonds);
          break;
      }
      diamondConfig.setMatchPairItem(arraDiamond);
      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data[0].count;
      manageDiamondSelection();
      //callBlockApi(isProgress: true);
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
      hasData = diamondListResp.data[0].diamonds.length > 0 ||
          diamondListResp.data[0].list.length > 0;
    }

    arraDiamond.addAll(diamondListResp.data[0].diamonds);
    diamondConfig.setMatchPairItem(arraDiamond);
    diamondList.state.listCount = arraDiamond.length;
    diamondList.state.totalCount = diamondListResp.data[0].count;
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

  fillArrayList() {
    if (arraDiamond.length == 0) {
      return;
    }
    SlidableController controller = SlidableController();
    diamondList.state.listItems = viewTypeCount == 0
        ? ListView.builder(
            itemCount: arraDiamond.length,
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

                      model =
                          DiamondModel.fromJson(arraDiamond[index].toJson());
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
                    } else {
                      //Detail
                      var dict = Map<String, dynamic>();
                      dict[ArgumentConstant.DiamondDetail] = arraDiamond[index];
                      dict[ArgumentConstant.ModuleType] = moduleType;

                      //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
                      bool isBack =
                          await Navigator.of(context).push(MaterialPageRoute(
                        settings:
                            RouteSettings(name: DiamondDetailScreen.route),
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
                              DiamondModuleConstant.MODULE_TYPE_MY_OFFER ||
                          moduleType ==
                              DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
                        List<DiamondModel> filter = arraDiamond
                            .where((element) =>
                                element.memoNo == arraDiamond[index].memoNo)
                            .toList();
                        if (isNullEmptyOrFalse(filter) == false) {
                          List<DiamondModel> filter2 = filter
                              .where((element) => element.isSelected == true)
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
          )
        : viewTypeCount == 1
            ? ListView.builder(
                itemCount: arraDiamond.length,
                itemBuilder: (context, index) {
                  return DiamondExpandItemWidget(
                      item: arraDiamond[index],
                      leftSwipeList: getLeftAction((manageClick) async {
                        //Detail
                        var dict = Map<String, dynamic>();
                        dict[ArgumentConstant.DiamondDetail] =
                            arraDiamond[index];
                        dict[ArgumentConstant.ModuleType] = moduleType;

                        //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
                        bool isBack =
                            await Navigator.of(context).push(MaterialPageRoute(
                          settings:
                              RouteSettings(name: DiamondDetailScreen.route),
                          builder: (context) =>
                              DiamondDetailScreen(arguments: dict),
                        ));
                        if (isBack != null && isBack) {
                          onRefreshList();
                        }
                      }),
                      list: getRightAction((manageClick) {
                        manageRowClick(index, manageClick.type);
                      }),
                      actionClick: (manageClick) {
                        manageRowClick(index, manageClick.type);
                      });
                },
              )
            : viewTypeCount == 2
                ? GridView.count(
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
                      return DiamondGridItemWidget(
                          item: item,
                          list: getRightAction((manageClick) {
                            manageRowClick(index, manageClick.type);
                          }),
                          actionClick: (manageClick) {
                            manageRowClick(index, manageClick.type);
                          });
                    }),
                  )
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
  }

  callBlockApi({bool isProgress = false}) {
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
                    color: appTheme.lightColorPrimary,
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
                      color: appTheme.lightColorPrimary,
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
    List<Widget> list = [];
    for (int i = 0; i < diamondConfig.toolbarList.length; i++) {
      var element = diamondConfig.toolbarList[i];
      if (element.code == BottomCodeConstant.TBDownloadView &&
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
      } else {
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
            child: Image.asset(
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
    }

    return list;
  }

  callDeleteDiamond(List<DiamondModel> selectedList) {
    diamondConfig.manageDiamondAction(context, selectedList,
        BottomTabModel(type: ActionMenuConstant.ACTION_TYPE_DELETE), () {
      onRefreshList();
    }, moduleType: moduleType);
  }

  manageRowClick(int index, int type) async {
    switch (type) {
      case clickConstant.CLICK_TYPE_DELETE:
        List<DiamondModel> selectedList = [];
        selectedList.add(arraDiamond[index]);
        callDeleteDiamond(selectedList);
        break;
      case clickConstant.CLICK_TYPE_EDIT:
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
        break;
      case clickConstant.CLICK_TYPE_SELECTION:
      case clickConstant.CLICK_TYPE_ROW:
        setState(() {
          arraDiamond[index].isSelected = !arraDiamond[index].isSelected;
          manageDiamondSelection();
          diamondConfig.toolbarList.forEach((element) {
            if (element.code == BottomCodeConstant.TBSelectAll) {
              setAllSelectImage(element);
            }
          });
        });
        break;
      case clickConstant.CLICK_TYPE_DETAIL:
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
      case BottomCodeConstant.TBSelectAll:
        model.isSelected = !model.isSelected;
        setSelectAllDiamond(model);
        break;
      case BottomCodeConstant.TBGrideView:
        viewTypeCount += 1;
        if (viewTypeCount == 2) {
          viewTypeCount = 0;
        }
        fillArrayList();
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
            },
          ),
        );
        break;
      case BottomCodeConstant.TBDownloadView:
        if (moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
          if (Platform.isIOS) {
            LocalNotificationManager.instance
                .requestPermissions()
                .then((value) {
              diamondConfig.actionDownloadOffline(
                context,
                () {
                  onRefreshList();
                },
                sortRequest: sortRequest,
                filterId: filterId,
              );
            });
          } else {
            diamondConfig.actionDownloadOffline(
              context,
              () {
                onRefreshList();
              },
              sortRequest: sortRequest,
              filterId: filterId,
            );
          }
        } else {
          List<DiamondModel> selectedList =
              arraDiamond.where((element) => element.isSelected).toList();
          if (!isNullEmptyOrFalse(selectedList)) {
            BottomTabModel tabModel = BottomTabModel();
            tabModel.type = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
            diamondConfig.manageDiamondAction(context, arraDiamond, tabModel,
                () {
              onRefreshList();
            });
          } else {
            app.resolve<CustomDialogs>().confirmDialog(
                  context,
                  title: "",
                  desc: R.string.errorString.diamondSelectionError,
                  positiveBtnTitle: R.string.commonString.ok,
                );
          }
        }
        break;
    }
  }

  setSelectAllDiamond(BottomTabModel model) {
    arraDiamond.forEach((element) {
      element.isSelected = model.isSelected;
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

  manageDiamondSelection() {
    fillArrayList();
    diamondCalculation.setAverageCalculation(arraDiamond);
    if (moduleType == DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
      diamondFinalCalculation.setAverageCalculation(arraDiamond,
          isFinalCalculation: true);
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
            diamondConfig.getScreenTitle(),
            bgColor: appTheme.whiteColor,
            leadingButton: isFromDrawer
                ? getDrawerButton(context, true)
                : getBackButton(context),
            centerTitle: false,
            textalign: TextAlign.left,
            actionItems: getToolbarItem(),
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
                SizedBox(
                  height: getSize(16),
                ),
                Expanded(
                  child: diamondList,
                ),
                this.moduleType ==
                        DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION
                    ? AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: isVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: FinalCalculationWidget(
                            arraDiamond, this.diamondFinalCalculation))
                    : SizedBox(),
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
      return (app.resolve<PrefUtils>().getBool(PrefUtils().keyOfferTour) ==
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
                      .getBool(PrefUtils().keySearchResultTour) ==
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
              //
              if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
                List<DiamondModel> selectedList =
                    arraDiamond.where((element) => element.isSelected).toList();
                if (!isNullEmptyOrFalse(selectedList)) {
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
                } else {
                  app.resolve<CustomDialogs>().confirmDialog(
                        context,
                        title: "",
                        desc: R.string.errorString.diamondSelectionError,
                        positiveBtnTitle: R.string.commonString.ok,
                      );
                }
              } else if (obj.type == ActionMenuConstant.ACTION_TYPE_STATUS) {
                showStatusDialogue();
//          showBottomSheetForMenu(context, diamondConfig.arrStatusMenu,
//              (manageClick) {}, R.string.commonString.status,
//              isDisplaySelection: false);
              } else if (obj.type ==
                  ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
                clearSelection();
              } else {
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
    if (!isNullEmptyOrFalse(selectedList)) {
      if (bottomTabModel.type == ActionMenuConstant.ACTION_TYPE_DELETE) {
        callDeleteDiamond(selectedList);
      } else {
        diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel,
            () {
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
