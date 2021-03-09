import 'dart:collection';

import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/shared/CommonDateTimePicker.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rxbus/rxbus.dart';

class MyBidList extends StatefulWidget {
  final DiamondConfig diamondConfig;
  final DiamondCalculation diamondCalculation;
  final String bidType;
  List<Map<String, dynamic>> sortRequest;
  final Function(BottomTabModel) onModelUpdate;
  final Function(DiamondCalculation) onDiamondCalculationUpdate;

  MyBidList({
    this.diamondConfig,
    this.diamondCalculation,
    this.bidType,
    this.sortRequest,
    this.onModelUpdate,
    this.onDiamondCalculationUpdate,
  });

  @override
  _MyBidListState createState() => _MyBidListState();
}

class _MyBidListState extends State<MyBidList> {
  BaseList diamondList;

  List<DiamondModel> arraDiamond = List<DiamondModel>();
  int page = DEFAULT_PAGE;

  int moduleType = DiamondModuleConstant.MODULE_TYPE_MY_BID;
  MyBidRange bidRange;

  @override
  void initState() {
    super.initState();

    RxBus.destroy(tag: eventSelectAllGroupDiamonds);
    RxBus.destroy(tag: eventSelectAll);
    RxBus.destroy(tag: eventDiamondMoreClick);
    RxBus.destroy(tag: eventDiamondDownloadClick);
    RxBus.destroy(tag: eventManageBottomMenuClick);
    RxBus.destroy(tag: eventSortClick);

    RxBus.register<BottomTabModel>(tag: eventSelectAll).listen((model) async {
      setSelectAllDiamond(model);
    });

    RxBus.register<bool>(tag: eventDiamondMoreClick).listen((model) async {
      clickOnMore();
    });

    RxBus.register<BottomTabModel>(tag: eventManageBottomMenuClick)
        .listen((bottomTabModel) async {
      manageBottomMenuClick(bottomTabModel);
    });

    RxBus.register<BottomTabModel>(tag: eventDiamondDownloadClick)
        .listen((model) async {
      clickOnDowload();
    });

    RxBus.register<List<Map<String, dynamic>>>(tag: eventSortClick)
        .listen((model) async {
      widget.sortRequest = model;
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

    RxBus.register<bool>(tag: eventBusRefreshList).listen((event) {
      print("action update");
      setState(() {
        manageDiamondCalculation();
      });
    });

    bidRange =
        MyBidRange(title: "Last 7 Days", type: MyBidRangeConstant.Last7Days);
    setFromToDate();
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
    });
  }

  clickOnMore() {
    List<DiamondModel> selectedList =
        arraDiamond.where((element) => element.isSelected).toList();
    if (!isNullEmptyOrFalse(selectedList)) {
      showBottomSheetForMenu(
        context,
        widget.diamondConfig.arrMoreMenu,
        (manageClick) {
          if (manageClick.bottomTabModel.type ==
              ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
//                  clearSelection();
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
  }

  clickOnDowload() {
    List<DiamondModel> selectedList =
        arraDiamond.where((element) => element.isSelected).toList();
    if (!isNullEmptyOrFalse(selectedList)) {
      BottomTabModel tabModel = BottomTabModel();
      tabModel.type = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
      widget.diamondConfig.manageDiamondAction(context, arraDiamond, tabModel,
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

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        arraDiamond.where((element) => element.isSelected).toList();

    if (bottomTabModel.type == ActionMenuConstant.ACTION_TYPE_MY_BID) {
      Map<String, dynamic> dict = new HashMap();
      dict[ArgumentConstant.ModuleType] =
          DiamondModuleConstant.MODULE_TYPE_MY_BID;
      dict[ArgumentConstant.IsFromDrawer] = false;
      NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
    } else if (!isNullEmptyOrFalse(selectedList)) {
      if (bottomTabModel.type == ActionMenuConstant.ACTION_TYPE_DELETE) {
        // callDeleteDiamond(selectedList);
      } else {
        widget.diamondConfig
            .manageDiamondAction(context, selectedList, bottomTabModel, () {
          //    onRefreshList();
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

  setSelectAllDiamond(BottomTabModel model) {
    arraDiamond.forEach((element) {
      element.isSelected = model.isSelected;
    });
    setAllSelectImage(model);
    manageDiamondSelection();
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arraDiamond.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    if (widget.sortRequest != null) {
      dict["sort"] = widget.sortRequest;
    }

    if (widget.bidType == MyBidConstant.LiveBid) {
      dict["bidType"] = [getBidTypeBasedOnTime()];
      dict["status"] = [BidStatus.BID_STATUS_PENDING];
    } else if (widget.bidType == MyBidConstant.BidHistory) {
      dict["bidType"] = [BidConstant.BID_TYPE_OPEN, BidConstant.BID_TYPE_BLIND];
      dict["status"] = [BidStatus.BID_STATUS_WIN, BidStatus.BID_STATUS_LOSS];
    }

    if (widget.bidType == MyBidConstant.BidHistory) {
      if (fromDate != null) dict["from"] = fromDate;
      if (toDate != null) dict["to"] = toDate;
    }
    NetworkCall<DiamondListResp>()
        .makeCall(
      () => widget.diamondConfig.getApiCall(moduleType, dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((diamondListResp) async {
      List<DiamondModel> list = [];
      DiamondModel diamondModel;
      TrackDiamonds trackDiamonds;
      diamondListResp.data.list.forEach((element) {
        if (element.diamonds != null) {
          element.diamonds.forEach((diamonds) {
            diamonds.isMyBid = true;
            list.add(diamonds);
          });
        } else {
          diamondModel = element.diamond;
          trackDiamonds = TrackDiamonds(
              id: diamondModel.id,
              trackId: element.id,
              remarks: element.remarks,
              reminderDate: element.reminderDate);

          diamondModel.trackItemBid = trackDiamonds;
          diamondModel.newDiscount = element.newDiscount;
          diamondModel.newAmount = element.newAmount;
          diamondModel.newPricePerCarat = element.newPricePerCarat;
          diamondModel.isMyBid = true;
          diamondModel.status = element.status ?? 0;

          diamondModel.ctPr = element.bidPricePerCarat;

          list.add(diamondModel);
        }
      });
      arraDiamond.addAll(list);
      if (widget.bidType == MyBidConstant.BidHistory)
        widget.diamondConfig.setMatchPairItem(arraDiamond);

      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data.count;
      manageDiamondSelection();
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

  manageDiamondCalculation() {
    widget.diamondCalculation
        .setAverageCalculation(arraDiamond, isFinalCalculation: true);
    widget.diamondCalculation
        .setAverageCalculation(arraDiamond, isFinalCalculation: true);

    widget.onDiamondCalculationUpdate(widget.diamondCalculation);
  }

  manageDiamondSelection() {
    fillArrayList();
    widget.diamondCalculation.setAverageCalculation(arraDiamond);
    diamondList.state.setApiCalling(false);
    setState(() {});
  }

  fillArrayList() {
    if (arraDiamond.length == 0) {
      return;
    }
    SlidableController controller = SlidableController();
    diamondList.state.listItems = ListView.builder(
      itemCount: arraDiamond.length,
      itemBuilder: (context, index) {
        return DiamondItemWidget(
            controller: controller,
            moduleType: moduleType,
            item: arraDiamond[index],
            leftSwipeList: getLeftAction((manageClick) async {
              if (manageClick.type == clickConstant.CLICK_TYPE_OFFER_EDIT) {
                //Update offer
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
              } else {
                //Detail
                var dict = Map<String, dynamic>();
                dict[ArgumentConstant.DiamondDetail] = arraDiamond[index];
                dict[ArgumentConstant.ModuleType] = moduleType;

                //  NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
                bool isBack =
                    await Navigator.of(context).push(MaterialPageRoute(
                  settings: RouteSettings(name: DiamondDetailScreen.route),
                  builder: (context) => DiamondDetailScreen(arguments: dict),
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
              setState(() {});
            });
      },
    );
  }

  callDeleteDiamond(List<DiamondModel> selectedList) {
    widget.diamondConfig.manageDiamondAction(context, selectedList,
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

      case clickConstant.CLICK_TYPE_SELECTION:
      case clickConstant.CLICK_TYPE_ROW:
        if (widget.bidType == MyBidConstant.LiveBid) {
          setState(() {
            arraDiamond[index].isSelected = !arraDiamond[index].isSelected;
            manageDiamondSelection();
            widget.diamondConfig.toolbarList.forEach((element) {
              if (element.code == BottomCodeConstant.TBSelectAll) {
                setAllSelectImage(element);
              }
            });
          });
        }
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
    }
  }

  void setAllSelectImage(BottomTabModel model) {
    List<DiamondModel> list =
        arraDiamond.where((element) => element.isSelected).toList();
    model.isSelected = (list != null && list.length == arraDiamond.length);
    widget.onModelUpdate(model);
  }

  getLeftAction(ActionClick actionClick) {
    List<Widget> leftSwipeList = [];

    if (isDisplayDetail(moduleType)) {
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

  onRefreshList() {
    arraDiamond.clear();
    page = DEFAULT_PAGE;
    callApi(false);
  }

  String fromDate, toDate;

  List<MyBidRange> getDateOptions() {
    List<MyBidRange> list = [];
    list.add(MyBidRange(title: "Today", type: MyBidRangeConstant.Today));
    list.add(
        MyBidRange(title: "Yesterday", type: MyBidRangeConstant.Yesterday));
    list.add(
        MyBidRange(title: "Last 7 Days", type: MyBidRangeConstant.Last7Days));
    list.add(
        MyBidRange(title: "This Month", type: MyBidRangeConstant.ThisMonth));
    list.add(MyBidRange(title: "This Year", type: MyBidRangeConstant.ThisYear));
    list.add(MyBidRange(title: "All", type: MyBidRangeConstant.All));
    list.add(MyBidRange(
        title: "Custom Range", type: MyBidRangeConstant.CustomRange));
    list.add(MyBidRange(title: "start", type: MyBidRangeConstant.CustomRange));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.bidType == MyBidConstant.BidHistory)
          Padding(
            padding: EdgeInsets.all(
              getSize(16),
            ),
            child: popupList(getDateOptions(), (selectedValue) {
              if (selectedValue.type == MyBidRangeConstant.CustomRange) {
                openDateTimeDialog(
                  context,
                  (manageClick1) {
                    //
                    openDateTimeDialog(
                      context,
                      (manageClick2) {
                        setState(() {
                          bidRange = selectedValue;
                          fromDate = manageClick1.date;
                          toDate = manageClick2.date;
                        });

                        callApi(true);
                      },
                      isTime: false,
                      title: "Select To Date",
                      initialDate: DateUtilities()
                          .convertServerStringToFormatterDate(
                              manageClick1.date),
                      minDate: DateUtilities()
                          .convertServerStringToFormatterDate(
                              manageClick1.date),
                    );
                  },
                  isTime: false,
                  title: "Select From Date",
                  minDate: DateUtilities().convertServerStringToFormatterDate(
                      app.resolve<PrefUtils>().getUserDetails().createdAt),
                );
              } else {
                setState(() {
                  bidRange = selectedValue;
                  setFromToDate();
                });
                callApi(true);
              }
              // widget.item.selectedBackPer = selectedValue;
              // RxBus.post(true, tag: eventBusDropDown);
            }),
          ),
        Expanded(child: diamondList),
      ],
    );
  }

  setFromToDate() {
    var todayDate = DateTime.now();
    switch (bidRange?.type) {
      case MyBidRangeConstant.Today:
        fromDate =
            DateTime(todayDate.year, todayDate.month, todayDate.day).toString();
        toDate =
            DateTime(todayDate.year, todayDate.month, todayDate.day).toString();
        break;

      case MyBidRangeConstant.Yesterday:
        fromDate = DateTime(todayDate.year, todayDate.month, todayDate.day - 1)
            .toString();
        toDate = DateTime(todayDate.year, todayDate.month, todayDate.day - 1)
            .toString();
        break;

      case MyBidRangeConstant.Last7Days:
        fromDate = DateTime(todayDate.year, todayDate.month, todayDate.day - 7)
            .toString();
        toDate =
            DateTime(todayDate.year, todayDate.month, todayDate.day).toString();
        break;

      case MyBidRangeConstant.ThisMonth:
        fromDate = DateTime(todayDate.year, todayDate.month, 1).toString();
        toDate = DateTime(todayDate.year, todayDate.month + 1, 0).toString();
        break;

      case MyBidRangeConstant.ThisYear:
        fromDate = DateTime(todayDate.year, 1, 1).toString();
        toDate = DateTime(todayDate.year + 1, 0, 31).toString();
        break;

      case MyBidRangeConstant.All:
        fromDate = app.resolve<PrefUtils>().getUserDetails().createdAt;
        toDate =
            DateTime(todayDate.year, todayDate.month, todayDate.day).toString();
        ;
        break;
    }
  }

  getDateTitle() {
    return bidRange.type == MyBidRangeConstant.All
        ? 'All'
        : (fromDate == null || toDate == null
            ? 'Select Date'
            : DateUtilities().convertServerDateToFormatterString(fromDate,
                    formatter: DateUtilities.dd_mm_yyyy_) +
                " - " +
                DateUtilities().convertServerDateToFormatterString(toDate,
                    formatter: DateUtilities.dd_mm_yyyy_));
  }

  Widget popupList(List<MyBidRange> list, Function(MyBidRange) selectedValue,
          {bool isPer = false}) =>
      PopupMenuButton<MyBidRange>(
        shape: TooltipShapeBorder(arrowArc: 0.5),
        onSelected: (newValue) {
          // add this property
          selectedValue(newValue);
        },
        itemBuilder: (context) => [
          for (var item in list)
            PopupMenuItem(
              value: item,
              height: getSize(30),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(
                        item.title,
                        bidRange?.type == item.type
                            ? appTheme.blackNormal14TitleColorPrimary
                            : appTheme.blackNormal14TitleColorblack)
                  ],
                ),
              ),
            ),
        ],
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: appTheme.borderColor),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  getSize(5),
                ),
              )),
          padding: EdgeInsets.symmetric(
              vertical: getSize(0), horizontal: getSize(3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getCommonIconWidget(
                  imageName: calender, imageType: IconSizeType.small),
              Expanded(
                child: Text(
                  getDateTitle(),
                  style: appTheme.black14TextStyle,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: getSize(24),
              ),
            ],
          ),
        ),
        offset: Offset(25, 110),
      );
}

class MyBidTab {
  String type;
  String title;

  MyBidTab({this.type, this.title = ''});
}

class MyBidRange {
  String title;
  String type;

  MyBidRange({this.title, this.type});
}
