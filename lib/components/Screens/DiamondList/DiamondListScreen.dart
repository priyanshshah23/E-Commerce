import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondExpandItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondSquareGridItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/FinalCalculation.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
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

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  String filterId = "";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;

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
    }
  }

  @override
  _DiamondListScreenState createState() => _DiamondListScreenState(
        filterId: filterId,
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _DiamondListScreenState extends StatefulScreenWidgetState {
  String filterId;
  int moduleType;
  bool isFromDrawer;
  String sortingKey;
  Map<String, dynamic> dictFilters;

  _DiamondListScreenState({this.filterId, this.moduleType, this.isFromDrawer});

  DiamondConfig diamondConfig;
  BaseList diamondList;
  List<DiamondModel> arraDiamond = List<DiamondModel>();
  int page = DEFAULT_PAGE;
  DiamondCalculation diamondCalculation = DiamondCalculation();
  DiamondCalculation diamondFinalCalculation = DiamondCalculation();
  List<FilterOptions> optionList = List<FilterOptions>();
  bool isGrid = false;
  int viewTypeCount = 0;

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

    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems();
    diamondList = BaseList(BaseListState(
//      imagePath: noRideHistoryFound,
      noDataMsg: APPNAME,
      noDataDesc: R.string().noDataStrings.noDataFound,
      refreshBtn: R.string().commonString.refresh,
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
    setState(() {
      //
    });
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arraDiamond.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
      case DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH:
        dict["filters"] = {};
        dict["filters"]["diamondSearchId"] = this.filterId;
        break;
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        dict["filters"] = {};
        dict["filters"]["diamondSearchId"] = this.filterId;
        if (sortingKey != null) {
          dict["sort"] = sortingKey;
        }
        break;
      case DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR:
        dict["filters"] = {};
        dict["filters"]["diamondSearchId"] = this.filterId;
        break;
      case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
        dict["filters"] = {};
        dict["filters"]["wSts"] = DiamondStatus.DIAMOND_STATUS_BID;
        break;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        dict["filters"] = {};
        dict["filters"]["wSts"] = DiamondStatus.DIAMOND_STATUS_UPCOMING;
        dict["filters"]["inDt"] = {};
        var date = DateTime.now();
        print(date.add(Duration(days: 5, hours: 5, minutes: 30)));
        dict["filters"]["inDt"]["<="] =
            date.add(Duration(days: 7)).toUtc().toIso8601String();
        Map<String, dynamic> dict1 = Map<String, dynamic>();
        dict1["inDt"] = "ASC";
        dict["sort"] = [dict1];

        break;
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        dict["filters"] = {};
        dict["filters"]["or"] = diamondConfig.getExclusiveDiamondReq();
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
        dict["type"] = "stone_of_day";
        break;
    }
    NetworkCall<DiamondListResp>()
        .makeCall(
      () => diamondConfig.getApiCall(moduleType, dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((diamondListResp) async {
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
                  diamondModel.trackItemOffer = trackDiamonds;
                  diamondModel.memoNo = element.memoNo;
                  diamondModel.offerValidDate = element.offerValidDate;
                  diamondModel.offerStatus = element.offerStatus;
                  diamondModel.newAmount = element.newAmount;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
                  diamondModel.trackItemReminder = trackDiamonds;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
                  diamondModel.trackItemComment = trackDiamonds;
                  break;
                case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
                  diamondModel.trackItemOffice = trackDiamonds;
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
          arraDiamond.addAll(diamondListResp.data.diamonds);
          break;
      }
      diamondConfig.setMatchPairItem(arraDiamond);
      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data.count;
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
                  list: getRightAction((manageClick) {
                    manageRowClick(index, manageClick.type);
                  }),
                  actionClick: (manageClick) {
                    manageRowClick(index, manageClick.type);
                  });
            },
          )
        : viewTypeCount == 1
            ? ListView.builder(
                itemCount: arraDiamond.length,
                itemBuilder: (context, index) {
                  return DiamondExpandItemWidget(
                      item: arraDiamond[index],
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
//    diamondList.state.listItems = isGrid
//        ? GridView.count(
//            shrinkWrap: true,
//            crossAxisCount: 2,
////            childAspectRatio: 0.8,
//      childAspectRatio: 1,
//
//      mainAxisSpacing: 10,
//            crossAxisSpacing: 8,
//            padding: EdgeInsets.only(
//              left: getSize(Spacing.leftPadding),
//              bottom: getSize(Spacing.leftPadding),
//              right: getSize(Spacing.rightPadding),
//            ),
//            children: List.generate(arraDiamond.length, (index) {
//              var item = arraDiamond[index];
//              return DiamondSquareGridItem(
//                  item: item,
//                  list: getRightAction((manageClick) {
//                    manageRowClick(index, manageClick.type);
//                  }),
//                  actionClick: (manageClick) {
//                    manageRowClick(index, manageClick.type);
//                  });
//              return DiamondGridItemWidget(
//                  item: item,
//                  list: getRightAction((manageClick) {
//                    manageRowClick(index, manageClick.type);
//                  }),
//                  actionClick: (manageClick) {
//                    manageRowClick(index, manageClick.type);
//                  });
//            }),
//          )
//        : ListView.builder(
//            itemCount: arraDiamond.length,
//            itemBuilder: (context, index) {
////              return DiamondExpandItemWidget(
////                  item: arraDiamond[index],
////                  list: getRightAction((manageClick) {
////                    manageRowClick(index, manageClick.type);
////                  }),
////                  actionClick: (manageClick) {
////                    manageRowClick(index, manageClick.type);
////                  });
//              return DiamondItemWidget(
//                  controller: controller,
//                  item: arraDiamond[index],
//                  list: getRightAction((manageClick) {
//                    manageRowClick(index, manageClick.type);
//                  }),
//                  actionClick: (manageClick) {
//                    manageRowClick(index, manageClick.type);
//                  });
//            },
//          );
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
    if (isDisplayDelete(moduleType)) {
      list.add(
        IntrinsicHeight(
          child: IconSlideAction(
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
              ],
            ),
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    for (int i = 0; i < diamondConfig.toolbarList.length; i++) {
      var element = diamondConfig.toolbarList[i];
      list.add(GestureDetector(
        onTap: arraDiamond != null && arraDiamond.length > 0
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
      case clickConstant.CLICK_TYPE_SELECTION:
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
      case clickConstant.CLICK_TYPE_ROW:
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

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBSelectAll:
        model.isSelected = !model.isSelected;
        setSelectAllDiamond(model);
        break;
      case BottomCodeConstant.TBGrideView:
        viewTypeCount += 1;
        if (viewTypeCount == 4) {
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
          ),
        ).then((value) {
          sortingKey = value;
          callApi(true);
        });
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
    if (moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL) {
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

    return Scaffold(
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
            DiamondListHeader(
              diamondCalculation: diamondCalculation,
              moduleType: moduleType,
            ),
            SizedBox(
              height: getSize(16),
            ),
            Expanded(
              child: diamondList,
            ),
            this.moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL
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
    );
  }

  Widget getBottomTab() {
    return arraDiamond != null && arraDiamond.length > 0
        ? BottomTabbarWidget(
            arrBottomTab: diamondConfig.arrBottomTab,
            onClickCallback: (obj) {
              //
              if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
                List<DiamondModel> selectedList =
                    arraDiamond.where((element) => element.isSelected).toList();
                if (selectedList != null && selectedList.length > 0) {
                  showBottomSheetForMenu(context, diamondConfig.arrMoreMenu,
                      (manageClick) {
                    if (manageClick.bottomTabModel.type ==
                        ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
                      clearSelection();
                    } else {
                      manageBottomMenuClick(manageClick.bottomTabModel);
                    }
                  }, R.string().commonString.more, isDisplaySelection: false);
                } else {
                  app.resolve<CustomDialogs>().confirmDialog(
                        context,
                        title: "",
                        desc: R.string().errorString.diamondSelectionError,
                        positiveBtnTitle: R.string().commonString.ok,
                      );
                }
              } else if (obj.type == ActionMenuConstant.ACTION_TYPE_STATUS) {
                showStatusDialogue();
//          showBottomSheetForMenu(context, diamondConfig.arrStatusMenu,
//              (manageClick) {}, R.string().commonString.status,
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
                      color: appTheme.textFieldBorderColor,
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
                        style: appTheme.blackNormal18TitleColorblack,
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
                              color: diamondConfig
                                  .arrStatusMenu[index].imageColor);
                        },
                      ),
                      SizedBox(
                        height: getSize(10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

//          AlertDialog(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(getSize(5)),
//          ),
//          content: Container(                  height: 66,
//
//            color: appTheme.whiteColor,
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Container(
//                  height: 66,
////                  constraints: BoxConstraints(
////                      minHeight: 50,
////                      maxHeight: MathUtilities.screenHeight(context) - 300),
//                  child: ListView.builder(
////                    shrinkWrap: true,
//                    itemCount: diamondConfig.arrStatusMenu.length,
//
//                    itemBuilder: (BuildContext context, int index) {
//                      return getStatusDialogueRow(
//                          title: diamondConfig.arrStatusMenu[index].title,
//                          color: appTheme.greenColor);
//                    },
//                  ),
//                ),
//              ],
//            ),
//          ),
//        );
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
            style: appTheme.black12TextStyle
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
    manageDiamondSelection();
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        arraDiamond.where((element) => element.isSelected).toList();
    if (selectedList != null && selectedList.length > 0) {
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
            desc: R.string().errorString.diamondSelectionError,
            positiveBtnTitle: R.string().commonString.ok,
          );
    }
  }
}
