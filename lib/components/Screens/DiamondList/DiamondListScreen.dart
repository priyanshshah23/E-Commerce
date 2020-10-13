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

  @override
  _DiamondListScreenState createState() => _DiamondListScreenState();
}

class _DiamondListScreenState extends StatefulScreenWidgetState {
  BaseList diamondList;
 int page =  DEFAULT_PAGE;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => callApi(false));
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    DiamondListReq req = DiamondListReq();
    req.page = page;
    req.limit =DEFAULT_LIMIT ;
    req.isNotReturnTotal = true;
    req.isNotReturnTotal = true;

    SyncManager.instance.callApiForDiamondList(
      context,
      req,
      (diamondListResp) {
        print("success" + diamondListResp.toString());
        fillArrayList();
        diamondList.state.setApiCalling(false);
      },
      (onError) {
        //print("Error");
      },
    );
  }

  fillArrayList() {
    diamondList.state.listCount=5;
    diamondList.state.listItems = ListView.builder(
      itemCount: diamondList.state.listCount,
      itemBuilder: (context,index){
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
                  getBackButton(context,height: getSize(15),width: getSize(10)),
                  SizedBox(
                    width: getSize(20),
                  ),
                  Text(
                    "Search Result",
                    textAlign: TextAlign.left,
                    style: appTheme.black16TextStyle.copyWith(
                      fontSize: getFontSize(20)
                    ),
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
