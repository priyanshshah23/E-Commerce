import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
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

  callApi(bool isRefress,{bool isLoading=false}){

    DiamondListReq req = DiamondListReq();

    req.isNotReturnTotal = true;
    req.isNotReturnTotal = true;
    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().diamondList(req),
        context,
        isProgress: !isRefress && !isLoading)
        .then((diamondListResp) async {
          print("Sucess");
//      success(diamondListResp);
      diamondList.state.setApiCalling(false);
    }).catchError((onError) => {
      print("error:"+onError.toString()),
    diamondList.state.setApiCalling(false)
    });


//    SyncManager.instance.callApiForDiamondList(context, req, (diamondListResp){
//      print("success" + diamondListResp.toString());
//      diamondList.state.setApiCalling(false);
//
//    }, (onError){
//      //print("Error");
//    },);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.darkBlue,
        body: Padding(
          padding: EdgeInsets.only(left: getSize(20),right: getSize(20)),
          child: Column(
            children: <Widget>[
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
