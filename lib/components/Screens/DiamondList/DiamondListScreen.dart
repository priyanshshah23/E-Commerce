import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
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
      calulate(diamondListResp.data.diamonds);
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
    diamondList.state.listItems = ListView.builder(
      itemCount: arraDiamond.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              setState(() {
                arraDiamond[index].isSelected = !arraDiamond[index].isSelected;
                fillArrayList();
                calulate(arraDiamond);
                diamondList.state.setApiCalling(false);
              });
            },
            child: DiamondItemWidget(
              item: arraDiamond[index],
            ));
      },
    );
  }

  calulate(List<DiamondModel> diamondList){
    print("List....${diamondList.length}");

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

    if(filterList != null && filterList.length >0){
      carat = SyncManager.instance.getTotalCaratRapAmount(filterList)[0];
      calcAmount = SyncManager.instance.getTotalCaratRapAmount(filterList)[1];
      rapAvg = SyncManager.instance.getTotalCaratRapAmount(filterList)[2];
      fancyCarat = SyncManager.instance.getTotalCaratRapAmount(filterList)[3];
      fancyAmt = SyncManager.instance.getTotalCaratRapAmount(filterList)[4];
      pcs = filterList.length.toString();
    }else{
      carat = SyncManager.instance.getTotalCaratRapAmount(diamondList)[0];
      calcAmount = SyncManager.instance.getTotalCaratRapAmount(diamondList)[1];
      rapAvg = SyncManager.instance.getTotalCaratRapAmount(diamondList)[2];
      fancyCarat = SyncManager.instance.getTotalCaratRapAmount(diamondList)[3];
      fancyAmt = SyncManager.instance.getTotalCaratRapAmount(diamondList)[4];
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
    if (calcPricePerCarat > 0 || calcDiscount < 0){
    totalPriceCrt = PriceUtilities.getPrice(calcPricePerCarat);
    }else{
      totalPriceCrt = PriceUtilities.getPrice(0);
    }
    if (calcDiscount > 0 || calcDiscount < 0){
    totalDisc = PriceUtilities.getPercent(calcDiscount);
    print("Discount...${totalDisc}");
    }else{
      totalDisc = PriceUtilities.getPercent(0);
    }
    totalAmount = PriceUtilities.getPrice(calcAmount);
    totalCarat = PriceUtilities.getPrice(carat);
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
              child: Image.asset(
                gridView,
                height: getSize(20),
                width: getSize(20),
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
}
