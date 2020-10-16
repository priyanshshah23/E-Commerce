import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/material.dart';

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  String filterId = "";

  DiamondListScreen(Map<String, dynamic> arguments) {
    this.filterId = arguments["filterId"];
  }

  @override
  _DiamondListScreenState createState() =>
      _DiamondListScreenState(filterId: filterId);
}

class _DiamondListScreenState extends StatefulScreenWidgetState {
  String filterId;

  _DiamondListScreenState({this.filterId});

  BaseList diamondList;
  List<DiamondModel> arraDiamond = List<DiamondModel>();
  int page = DEFAULT_PAGE;
  String totalCarat = "0";
  String totalDisc = "0";
  String totalPriceCrt = "0";
  String totalAmount = "0";
  String pcs = "0";

  List<BottomTabModel> arrBottomTab;
  bool isGrid = true;

  @override
  void initState() {
    super.initState();

    diamondList = BaseList(BaseListState(
//      imagePath: noRideHistoryFound,
      noDataMsg: APPNAME,
      noDataDesc: "No record found",
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

    arrBottomTab = BottomTabBar.getDiamondListScreenBottomTabs();
    setState(() {
      //
    });
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    print("filter Id : ${filterId}");
    if (isRefress) {
      arraDiamond.clear();
      page = DEFAULT_PAGE;
    }
    DiamondListReq filterReq = DiamondListReq();
    filterReq.page = page;
    filterReq.limit = DEFAULT_LIMIT;
    Filters filter = Filters();
    filter.diamondSearchId = filterId;
    filterReq.filters = filter;
    SyncManager.instance.callApiForDiamondList(context, filterReq,
        (diamondListResp) {
      arraDiamond.addAll(diamondListResp.data.diamonds);
//      avgCarat = arraDiamond.map((m) => m.crt).reduce((a, b) => a + b) /
//          arraDiamond.length;
//      pcs = arraDiamond.length;
      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data.count;
      getAverageCalculation(diamondListResp.data.diamonds);
      fillArrayList();
      page = page + 1;
      diamondList.state.setApiCalling(false);
      setState(() {});
    }, (onError) {
      print("erorrr..." + onError);
      if (isRefress) {
        arraDiamond.clear();
        diamondList.state.listCount = arraDiamond.length;
        diamondList.state.totalCount = arraDiamond.length;
      }
      diamondList.state.setApiCalling(false);
    }, isProgress: !isRefress && !isLoading);
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
              return InkWell(
                onTap: () {
                  setState(() {
                    arraDiamond[index].isSelected =
                        !arraDiamond[index].isSelected;
                    fillArrayList();
                    diamondList.state.setApiCalling(false);
                  });
                },
                child: DiamondGridItemWidget(
                  item: item,
                ),
              );
              // return Container(
              //   color: Colors.green,
              // );
            }),
          )
        : ListView.builder(
            itemCount: arraDiamond.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    setState(() {
                      arraDiamond[index].isSelected =
                          !arraDiamond[index].isSelected;
                      fillArrayList();
                      getAverageCalculation(arraDiamond);
                      diamondList.state.setApiCalling(false);
                    });
                  },
                  child: DiamondItemWidget(
                    item: arraDiamond[index],
                  ));
            },
          );
  }

  getAverageCalculation(List<DiamondModel> diamondList) {
    double carat = 0.0;
    double avgDisc = 0.0;
    double avgRapCrt = 0.0;
    double avgAmount = 0.0;
    double totalRap = 0.0;
    double priceCrt = 0.0;
    List<DiamondModel> filterList;
    Iterable<DiamondModel> list = diamondList.where((item) {
      return item.isSelected == true;
    });
    filterList = list.toList();
    if (filterList != null && filterList.length > 0) {
      for (var i in filterList) {
        carat += i.crt;
        totalRap += i.crt * i.rap;
        priceCrt += i.crt * i.ctPr;
        avgDisc += getAvgDiscount(getFinalRate(i.ctPr), i.rap);
      }
      avgRapCrt = totalRap / carat;
      totalCarat = PriceUtilities.getPrice(carat);
      totalPriceCrt =
          PriceUtilities.getPrice(getAveragePriceCrt(priceCrt, carat));
      totalDisc = PriceUtilities.getPercent(avgDisc);
      pcs = filterList.length.toString();
    } else {
      for (var i in diamondList) {
        carat += i.crt;
        totalRap += i.crt * i.rap;
        priceCrt += i.crt * i.ctPr;
        avgDisc += getAvgDiscount(getFinalRate(i.ctPr), i.rap);
      }
      avgRapCrt = totalRap / carat;
      totalCarat = PriceUtilities.getPrice(carat);
      totalPriceCrt =
          PriceUtilities.getPrice(getAveragePriceCrt(priceCrt, carat));
      totalDisc = PriceUtilities.getPercent(avgDisc);
      pcs = diamondList.length.toString();
    }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: getAppBar(
          context,
          "Search Result",
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
          actionItems: [
            Padding(
              padding: EdgeInsets.only(right: getSize(20)),
              child: Image.asset(
                selectAll,
                height: getSize(20),
                width: getSize(20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: getSize(20)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                },
                child: Image.asset(
                  gridView,
                  height: getSize(20),
                  width: getSize(20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: getSize(20)),
              child: Image.asset(
                filter,
                height: getSize(20),
                width: getSize(20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: getSize(20)),
              child: Image.asset(
                download,
                height: getSize(20),
                width: getSize(20),
              ),
            ),
          ],
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
      arrBottomTab: arrBottomTab,
      onClickCallback: (obj) {
        //
        if (obj.code == BottomCodeConstant.dLShowSelected) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dLCompare) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.dLMore) {
          //
          print(obj.code);
          // callApiForGetFilterId();
        } else if (obj.code == BottomCodeConstant.dLStatus) {
          //
          print(obj.code);
        }
      },
    );
  }
}
