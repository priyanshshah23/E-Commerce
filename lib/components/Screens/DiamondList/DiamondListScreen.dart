import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondListScreen extends StatefulScreenWidget {
  static const route = "Diamond List Screen";

  String filterId;

  DiamondListScreen(Map<String, dynamic> arguments) {
    this.filterId = arguments["filterId"];
  }

  @override
  _DiamondListScreenState createState() => _DiamondListScreenState(filterId: filterId);
}

class _DiamondListScreenState extends StatefulScreenWidgetState {
  String filterId;
_DiamondListScreenState({this.filterId});
  BaseList diamondList;
  List<DiamondModel> arraDiamond = List<DiamondModel>();
  int page = DEFAULT_PAGE;
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
    if(isRefress){
      arraDiamond.clear();
      page = DEFAULT_PAGE;
    }
    DiamondListReq filterReq = DiamondListReq();
    filterReq.page = page;
    filterReq.limit = DEFAULT_LIMIT;
    Filters filter = Filters();
    filter.diamondSearchId = filterId;

    SyncManager.instance.callApiForDiamondList(
      context,
      filterReq,
      (diamondListResp) {
        print("success" + diamondListResp.toString());
        arraDiamond.addAll(diamondListResp.data.diamonds);
        diamondList.state.listCount = arraDiamond.length;
        diamondList.state.totalCount = diamondListResp.data.count;
        fillArrayList();
        page = page + 1;
        diamondList.state.setApiCalling(false);
      },
      (onError) {
        print("erorrr..." + onError);
        if (isRefress) {
          arraDiamond.clear();
          diamondList.state.listCount = arraDiamond.length;
          diamondList.state.totalCount = arraDiamond.length;
        }
        diamondList.state.setApiCalling(false);
        //print("Error");
      },
    );
  }

  fillArrayList() {
    diamondList.state.listItems = ListView.builder(
      itemCount: arraDiamond.length,
      itemBuilder: (context, index) {
        return DiamondItemWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        body: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), right: getSize(20), top: getSize(20)),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  getBackButton(context,
                      height: getSize(15), width: getSize(10)),
                  SizedBox(
                    width: getSize(20),
                  ),
                  Text(
                    "Search Result",
                    textAlign: TextAlign.left,
                    style: appTheme.black16TextStyle
                        .copyWith(fontSize: getFontSize(20)),
                  ),
                ],
              ),
              DiamondListHeader(),
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
