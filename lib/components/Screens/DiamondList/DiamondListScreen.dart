import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
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
  num avgCarat = 0;

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
      avgCarat = arraDiamond.map((m) => m.crt).reduce((a, b) => a + b) /
          arraDiamond.length;
      print("average ${avgCarat}");
      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data.count;
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
            childAspectRatio: 1.0,
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
                    diamondList.state.setApiCalling(false);
                  });
                },
                child: DiamondItemWidget(
                  item: arraDiamond[index],
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    print("carat..... ${avgCarat}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: getAppBar(
          context,
          "Search Result",
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), right: getSize(20), top: getSize(20)),
          child: Column(
            children: <Widget>[
              DiamondListHeader(
                carat: avgCarat,
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
