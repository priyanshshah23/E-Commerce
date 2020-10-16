import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/price_utility.dart';
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
import 'package:flutter/material.dart';

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  Map<String, dynamic> dictFilters;
  String filterId = "";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
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
  String totalCarat = "0";
  String totalDisc = "0";
  String totalPriceCrt = "0";
  String totalAmount = "0";
  String pcs = "0";
  List<FilterOptions> optionList = List<FilterOptions>();
  bool isGrid = false;
  bool isAccountTerm = false;

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

  getAverageCalculation() {
    double carat = 0.0;
    double avgDisc = 0.0;
    double avgRapCrt = 0.0;
    double avgPriceCrt = 0.0;
    double avgAmount = 0.0;
    double totalamt = 0.0;
    double termDiscAmount = 0.0;

    List<DiamondModel> filterList;
    Iterable<DiamondModel> list = arraDiamond.where((item) {
      return item.isSelected == true;
    });
    if (list == null || list.length == 0) {
      filterList = arraDiamond;
    } else {
      filterList = list.toList();
    }
    List<num> arrValues =
        SyncManager.instance.getTotalCaratAvgRapAmount(filterList);
    carat = arrValues[0];
    totalamt = arrValues[2];
    avgRapCrt = arrValues[3];
    avgPriceCrt = arrValues[4];
    termDiscAmount = arrValues[5];
    avgAmount = totalamt / carat;
    totalPriceCrt = PriceUtilities.getPrice(avgPriceCrt);
    totalAmount = PriceUtilities.getPrice(avgAmount);
    if (isAccountTerm) {
      avgDisc = (1 - (termDiscAmount / avgRapCrt)) * (-100);
      totalDisc = PriceUtilities.getPercent(avgDisc);
    } else {
      avgDisc = (1 - (avgPriceCrt / avgRapCrt)) * (-100);
      totalDisc = PriceUtilities.getPercent(avgDisc);
    }
    totalCarat = PriceUtilities.getDoubleValue(carat);
    pcs = filterList.length.toString();
  }

  getAveragePriceCrt(num totalPrice, num totalcarat) {
    return totalPrice / totalcarat;
  }

  getAvgDiscount(num priceCrt, num rapPrice) {
    num avgDiscount = priceCrt / rapPrice;
    return avgDiscount;
  }

  getFinalRate(num priceCrt) {
    return (priceCrt * 0.98).toDouble();
  }

  getFinalDiscount(num finalRate, num rapPrice) {
    return ((1 - (finalRate / rapPrice)) * 100).toDouble();
  }

  calulate(List<DiamondModel> diamondList) {
    double carat = 0.0;
    double calcAmount = 0.0;
    double rapAvg = 0.0;
    double fancyCarat = 0.0;
    double fancyAmt = 0.0;
    List<DiamondModel> filterList;

    Iterable<DiamondModel> list = diamondList.where((item) {
      return item.isSelected == true;
    });
    filterList = list.toList();

    if (filterList != null && filterList.length > 0) {
      List<num> arrValues =
          SyncManager.instance.getTotalCaratRapAmount(filterList);
      carat = arrValues[0];
      calcAmount = arrValues[1];
      rapAvg = arrValues[2];
      fancyCarat = arrValues[3];
      fancyAmt = arrValues[4];
      pcs = filterList.length.toString();
    } else {
      List<num> arrValues =
          SyncManager.instance.getTotalCaratRapAmount(diamondList);
      carat = arrValues[0];
      calcAmount = arrValues[1];
      rapAvg = arrValues[2];
      fancyCarat = arrValues[3];
      fancyAmt = arrValues[4];
      pcs = diamondList.length.toString();
    }

    num calcDiscount = (calcAmount / rapAvg * 100) - 100;
    if (fancyCarat > 0) {
      carat += fancyCarat;
    }

    if (fancyAmt > 0) {
      calcAmount += fancyAmt;
    }

    num calcPricePerCarat = calcAmount / carat;
    if (calcPricePerCarat > 0 || calcDiscount < 0) {
      totalPriceCrt = PriceUtilities.getPrice(calcPricePerCarat);
    } else {
      totalPriceCrt = PriceUtilities.getPrice(0);
    }
    if (calcDiscount > 0 || calcDiscount < 0) {
      totalDisc = PriceUtilities.getPercent(calcDiscount);
    } else {
      totalDisc = PriceUtilities.getPercent(0);
    }
    totalAmount = PriceUtilities.getPrice(calcAmount);
    totalCarat = PriceUtilities.getDoubleValue(carat);
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
    getAverageCalculation();
    diamondList.state.setApiCalling(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), right: getSize(20), top: getSize(20)),
          child: Column(
            children: <Widget>[
              DiamondListHeader(
                pcs: pcs,
                totalDisc: totalDisc,
                totalCarat: totalCarat,
                totalPriceCrt: totalPriceCrt,
                totalAmount: totalAmount,
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
        if (obj.code == BottomCodeConstant.dLShowSelected) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dLCompare) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dLMore) {
          showBottomSheetForMenu(context, diamondConfig.arrMoreMenu,
              (manageClick) {
            diamondConfig.manageDiamondAction(
                arraDiamond, manageClick.bottomTabModel);
          });
        } else if (obj.code == BottomCodeConstant.dLStatus) {
          //
          print(obj.code);
        }
      },
    );
  }
}
