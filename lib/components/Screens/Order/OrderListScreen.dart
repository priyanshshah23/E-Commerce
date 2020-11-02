import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Order/OrderListModel.dart';
import 'package:flutter/material.dart';

class OrderListScreen extends StatefulScreenWidget {
  static const route = "Diamond order Screen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_MY_ORDER;
  bool isFromDrawer = false;

  OrderListScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _OrderListScreenState createState() => _OrderListScreenState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _OrderListScreenState extends StatefulScreenWidgetState {
  int moduleType;
  bool isFromDrawer;

  _OrderListScreenState({this.moduleType, this.isFromDrawer});

  DiamondConfig diamondConfig;
  BaseList diamondList;
  List<OrderItem> arraDiamond = List<OrderItem>();
  int page = DEFAULT_PAGE;
  DiamondCalculation diamondCalculation = DiamondCalculation();
  DiamondCalculation groupDiamondCalculation = DiamondCalculation();

  @override
  void initState() {
    super.initState();

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
    dict["filters"] = {};
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
        dict["filters"]["status"] = MemoConstant.MEMO_ORDER;
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
        dict["filters"]["status"] = MemoConstant.MEMO_PURCHASE;
        break;
    }

    NetworkCall<OrderListResp>()
        .makeCall(
      () =>
          app.resolve<ServiceModule>().networkService().diamondOrderList(dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((diamondListResp) async {
      arraDiamond.addAll(diamondListResp.data.list);
      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data.count;
      manageDiamondSelection();
      page = page + 1;
      diamondList.state.setApiCalling(false);
      setState(() {});
    }).catchError((onError) {
      if (isRefress) {
        arraDiamond.clear();
        diamondList.state.listCount = arraDiamond.length;
        diamondList.state.totalCount = arraDiamond.length;
      }
      diamondList.state.setApiCalling(false);
    });
  }

  fillArrayList() {
    diamondList.state.listItems = ListView.builder(
      itemCount: arraDiamond.length,
      padding: EdgeInsets.only(
          left: getSize(Spacing.leftPadding),
          right: getSize(Spacing.rightPadding)),
      itemBuilder: (context, index) {
        groupDiamondCalculation.setAverageCalculation(arraDiamond[index].memoDetails);
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: getSize(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getPrimaryText(arraDiamond[index].memoNo ?? ""),
                  getPrimaryText(
                    R.string().commonString.date +
                        " : " +
                        DateUtilities().convertServerDateToFormatterString(
                            arraDiamond[index].createdAt,
                            formatter: DateUtilities.dd_mm_yyyy),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: getSize(4), bottom: getSize(4)),
              child: Container(
                width: MathUtilities.screenWidth(context),
                decoration: BoxDecoration(
                    boxShadow: getBoxShadow(context),
                    color: appTheme.whiteColor,
                    borderRadius: BorderRadius.circular(getSize(6)),
                    border: Border.all(color: appTheme.colorPrimary)
                    //boxShadow: getBoxShadow(context),
                    ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: arraDiamond[index].memoDetails.length,
                  itemBuilder: (context, diamondIndex) {
                    return DiamondItemWidget(
                        leftPadding: 4.0,
                        rightPadding: 4.0,
                        groupDiamondCalculation: diamondIndex == arraDiamond[index].memoDetails.length-1 ? groupDiamondCalculation : null,
                        item: arraDiamond[index].memoDetails[diamondIndex],
                        actionClick: (manageClick) {
                          manageRowClick(index, manageClick.type);
                        });
                  },
                ),
              ),
            ),
          ],
        );
      },
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
    });
    return list;
  }

  manageRowClick(int index, int type) {
    /* switch (type) {
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
        NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
        break;
    }*/
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
    }
  }

  manageDiamondSelection() {
    fillArrayList();
    List<DiamondModel> list = [];
    arraDiamond.forEach((element) {
      list.addAll(element.memoDetails);
    });
    diamondCalculation.setAverageCalculation(list);
    diamondList.state.setApiCalling(false);
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              DiamondListHeader(
                diamondCalculation: diamondCalculation,
              ),
              SizedBox(
                height: getSize(20),
              ),
              Expanded(
                child: diamondList,
              )
            ],
          ),
        ));
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {}
}
