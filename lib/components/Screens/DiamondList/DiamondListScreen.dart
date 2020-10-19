import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/Screens/More/DiamondBottomSheets.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  Map<String, dynamic> dictFilters;
  String filterId = "";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_UPCOMING;
  bool isFromDrawer = false;

  DiamondListScreen(Map<String, dynamic> arguments) {
    if (arguments != null) {
      this.filterId = arguments["filterId"];
      this.dictFilters = arguments["filters"];
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
      dictFilters: dictFilters);
}

class _DiamondListScreenState extends StatefulScreenWidgetState {
  String filterId;
  int moduleType;
  bool isFromDrawer;
  Map<String, dynamic> dictFilters;

  _DiamondListScreenState(
      {this.filterId, this.moduleType, this.isFromDrawer, this.dictFilters});

  DiamondConfig diamondConfig;
  BaseList diamondList;
  List<DiamondModel> arraDiamond = List<DiamondModel>();
  int page = DEFAULT_PAGE;
  DiamondCalculation diamondCalculation = DiamondCalculation();
  List<FilterOptions> optionList = List<FilterOptions>();
  bool isGrid = false;

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

  callApiforUpcoming(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arraDiamond.clear();
      page = DEFAULT_PAGE;
    }

    DiamondListReq req = DiamondListReq();
    req.page = page;
    req.limit = DEFAULT_LIMIT;
    ReqFilters filter = ReqFilters();
    filter.wSts = "U";
    InDt inDt = InDt();
    inDt.lessThan = DateTime.now().toIso8601String();
    filter.inDt = inDt;
    req.filters = filter;
    req.sort = "inDt ASC";

    NetworkCall<DiamondListResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().diamondList(req),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((UpcomingListResp) async {
      print("Count ${UpcomingListResp.data.count}");
      arraDiamond.addAll(UpcomingListResp.data.diamonds);

      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = UpcomingListResp.data.count;
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

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arraDiamond.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    dict["filters"] = this.dictFilters;
    dict["filters"]["diamondSearchId"] = this.filterId;

    NetworkCall<DiamondListResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .diamondListPaginate(dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((diamondListResp) async {
      arraDiamond.addAll(diamondListResp.data.diamonds);

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
    diamondList.state.listItems = isGrid
        ? GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.009,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            children: List.generate(arraDiamond.length, (index) {
              var item = arraDiamond[index];
              return DiamondGridItemWidget(
                  item: item,
                  actionClick: (manageClick) {
                    manageRowClick(index, manageClick.type);
                  });
            }),
          )
        : ListView.builder(
            itemCount: arraDiamond.length,
            itemBuilder: (context, index) {
              return DiamondItemWidget(
                  item: arraDiamond[index],
                  actionClick: (manageClick) {
                    manageRowClick(index, manageClick.type);
                  });
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
            element.image,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
      ));
    });
    return list;
  }

  manageRowClick(int index, int type) {
    switch (type) {
      case clickConstant.CLICK_TYPE_SELECTION:
        setState(() {
          arraDiamond[index].isSelected = !arraDiamond[index].isSelected;
          manageDiamondSelection();
        });
        break;
      case clickConstant.CLICK_TYPE_ROW:
        var dict = Map<String, dynamic>();
        dict[ArgumentConstant.DiamondDetail] = arraDiamond[index];
        NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
        break;
    }
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBSelectAll:
        setSelectAllDiamond(model);
        break;
      case BottomCodeConstant.TBGrideView:
        isGrid = !isGrid;
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
        );
        break;
    }
  }

  setSelectAllDiamond(BottomTabModel model) {
    List<DiamondModel> list =
        arraDiamond.where((element) => element.isSelected).toList();
    if (list != null && list.length == arraDiamond.length) {
      model.isSelected = false;
    } else {
      model.isSelected = true;
    }
    arraDiamond.forEach((element) {
      element.isSelected = model.isSelected;
    });
    setState(() {});
    manageDiamondSelection();
  }

  manageDiamondSelection() {
    fillArrayList();
    diamondCalculation.setAverageCalculation(arraDiamond);
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
        actionItems: getToolbarItem(),
      ),
      bottomNavigationBar: getBottomTab(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), right: getSize(20), top: getSize(20)),
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
        ),
      ),
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
            if (manageClick.bottomTabModel.type ==
                ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
              arraDiamond.forEach((element) {
                element.isSelected = false;
              });
              manageDiamondSelection();
            } else {
              manageBottomMenuClick(manageClick.bottomTabModel);
            }
          });
        } else if (obj.type == ActionMenuConstant.ACTION_TYPE_STATUS) {
        } else {
          manageBottomMenuClick(obj);
        }
      },
    );
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        arraDiamond.where((element) => element.isSelected).toList();
    if (selectedList != null && selectedList.length > 0) {
      diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel);
    } else {
      app.resolve<CustomDialogs>().errorDialog(
          context, "Selection Error", "Please select at least one item.",
          btntitle: R.string().commonString.btnTryAgain);
    }
  }
}
