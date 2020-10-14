import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
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
    NetworkCall<DiamondListResp>()
        .makeCall(
      () =>
          app.resolve<ServiceModule>().networkService().diamondList(filterReq),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((diamondListResp) async {
      arraDiamond.addAll(diamondListResp.data.diamonds);
      diamondList.state.listCount = arraDiamond.length;
      diamondList.state.totalCount = diamondListResp.data.count;
      page = page + 1;
      fillArrayList();

      diamondList.state.setApiCalling(false);
    }).catchError((onError) {
      if (isRefress) {
        arraDiamond.clear();
        diamondList.state.listCount = arraDiamond.length;
        diamondList.state.totalCount = arraDiamond.length;
      }
      diamondList.state.setApiCalling(false);
      print("error ${onError.toString()}");
    });
//    SyncManager.instance.callApiForDiamondList(context, filterReq,
//        (diamondListResp) {
//      arraDiamond.addAll(diamondListResp.data.diamonds);
//      diamondList.state.listCount = arraDiamond.length;
//      diamondList.state.totalCount = diamondListResp.data.count;
//      fillArrayList();
//      page = page + 1;
//      diamondList.state.setApiCalling(false);
//    }, (onError) {
//      print("erorrr..." + onError);
//      if (isRefress) {
//        arraDiamond.clear();
//        diamondList.state.listCount = arraDiamond.length;
//        diamondList.state.totalCount = arraDiamond.length;
//      }
//      diamondList.state.setApiCalling(false);
//    }, isProgress: !isRefress && !isLoading);
  }

  fillArrayList() {
    diamondList.state.listItems = ListView.builder(
      itemCount: arraDiamond.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            setState(() {
            });
          },
            child: DiamondItemWidget(
          item: arraDiamond[index],
        ));
      },
    );
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
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), right: getSize(20), top: getSize(20)),
          child: Column(
            children: <Widget>[
              DiamondListHeader(),
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
