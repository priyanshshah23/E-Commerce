import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedSearchScreen extends StatefulScreenWidget {
  static const route = "SavedSearchScreen";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
  bool isFromDrawer = false;

  SavedSearchScreen({
    this.moduleType,
    this.isFromDrawer,
  });

  // SavedSearchScreen(
  //   Map<String, dynamic> arguments, {
  //   Key key,
  // }) : super(key: key) {
  //   if (arguments != null) {
  //     if (arguments[ArgumentConstant.ModuleType] != null) {
  //       moduleType = arguments[ArgumentConstant.ModuleType];
  //     }
  //     if (arguments[ArgumentConstant.IsFromDrawer] != null) {
  //       isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
  //     }
  //   }
  // }

  @override
  _SavedSearchScreenState createState() => _SavedSearchScreenState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _SavedSearchScreenState extends State<SavedSearchScreen>
    with AutomaticKeepAliveClientMixin<SavedSearchScreen> {
  int moduleType;
  bool isFromDrawer;
  BaseList savedSearchBaseList;
  List<SavedSearchModel> listOfSavedSearchModel = [];
  int page = DEFAULT_PAGE;

  PageController _controller = PageController();
  int sharedValue = 0;
  bool keepAlive = false;

  _SavedSearchScreenState({this.moduleType, this.isFromDrawer});

  @override
  void initState() {
    super.initState();
    savedSearchBaseList = BaseList(BaseListState(
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

  Future doAsyncStuff() async {
    keepAlive = true;
    updateKeepAlive();
    // Keeping alive...

    await Future.delayed(Duration(seconds: 10));

    keepAlive = false;
    updateKeepAlive();
    // Can be disposed whenever now.
  }


  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      listOfSavedSearchModel.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    dict["type"] = 2;
    dict["isAppendMasters"] = true;

    NetworkCall<SavedSearchResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().mySavedSearch(dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((savedSearchResp) async {
      savedSearchBaseList.state.listCount = savedSearchResp.data.list.length;
      savedSearchBaseList.state.totalCount = savedSearchResp.data.count;
      listOfSavedSearchModel = savedSearchResp.data.list;
      fillArrayList();
      page = page + 1;
      savedSearchBaseList.state.setApiCalling(false);
      setState(() {});
    }).catchError((onError) {
      if (isRefress) {
        listOfSavedSearchModel.clear();
        savedSearchBaseList.state.listCount = listOfSavedSearchModel.length;
        savedSearchBaseList.state.totalCount = listOfSavedSearchModel.length;
      }
      savedSearchBaseList.state.setApiCalling(false);
    });
  }

  fillArrayList() {
    savedSearchBaseList.state.listItems = ListView.builder(
      itemCount: savedSearchBaseList.state.listCount,
      itemBuilder: (BuildContext context, int index) {
        SavedSearchModel savedSearchModel = listOfSavedSearchModel[index];
        List<Map<String, dynamic>> arrData =
            getDisplayData(savedSearchModel.displayData);
        // return Text("hello");
        return !isNullEmptyOrFalse(arrData)
            ? Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appTheme.unSelectedBgColor,
                      boxShadow: getBoxShadow(context),
                      ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(getSize(10)),
                        child: Text(savedSearchModel?.name ?? "",
                          style: appTheme.black16TextStyle,
                        ),
                      ),
                      Divider(
                        color: appTheme.dividerColor,
                        thickness: 2,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: arrData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.all(getSize(10)),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      arrData[index]["key"] ?? "",
                                      style: appTheme.black14TextStyle,
                                    )),
                                    Expanded(
                                        child: Text(
                                      arrData[index]["value"] ?? "",
                                      style: appTheme.primaryColor14TextStyle,
                                    )),
                                  ],
                                ),
                                Divider(color: appTheme.dividerColor,)
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox();
      },
    );
  }

  getDisplayData(DisplayDataClass displayDataClass) {
    List<Map<String, dynamic>> arrData = [];

    if (!isNullEmptyOrFalse(displayDataClass.shp)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Shape";
      for (int i = 0; i < displayDataClass.shp.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.shp.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.or)) {
      Map<String, dynamic> displayDataKeyValue = {};
      List<String> tempList = [];
      for (int i = 0; i < displayDataClass.or.length; i++) {
        if (!isNullEmptyOrFalse(displayDataClass.or[i].crt)) {
          String temp = displayDataClass.or[i].crt.back.toString() +
              "-" +
              displayDataClass.or[i].crt.empty.toString();
          tempList.add(temp);
        }
      }
      displayDataKeyValue["key"] = "crt";
      displayDataKeyValue["value"] = tempList.join(  " , ");

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.col)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "col";
      for (int i = 0; i < displayDataClass.col.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.col.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.shd)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "shd";
      for (int i = 0; i < displayDataClass.shd.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.shd.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.clr)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "clr";
      for (int i = 0; i < displayDataClass.clr.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.clr.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cut)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "cut";
      for (int i = 0; i < displayDataClass.cut.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.cut.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.pol)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "pol";
      for (int i = 0; i < displayDataClass.pol.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.pol.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.sym)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "sym";
      for (int i = 0; i < displayDataClass.sym.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.sym.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.hA)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "hA";
      for (int i = 0; i < displayDataClass.hA.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.hA.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.brlncy)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "brlncy";
      for (int i = 0; i < displayDataClass.brlncy.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.brlncy.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.wSts)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "wSts";
      for (int i = 0; i < displayDataClass.wSts.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.wSts.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.isCm)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "isCm";
      for (int i = 0; i < displayDataClass.isCm.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.isCm.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.isDor)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "isDor";
      for (int i = 0; i < displayDataClass.isDor.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.isDor.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.isFm)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "isFm";
      for (int i = 0; i < displayDataClass.isFm.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.isFm.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.blkTbl)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "blkTbl";
      for (int i = 0; i < displayDataClass.blkTbl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.blkTbl.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.blkSd)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "blkSd";
      for (int i = 0; i < displayDataClass.blkSd.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.blkSd.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.wTbl)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "wTbl";
      for (int i = 0; i < displayDataClass.wTbl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.wTbl.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cult)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "cult";
      for (int i = 0; i < displayDataClass.cult.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.cult.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.wSd)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "wSd";
      for (int i = 0; i < displayDataClass.wSd.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.wSd.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.opTbl)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "opTbl";
      for (int i = 0; i < displayDataClass.opTbl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.opTbl.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.opPav)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "opPav";
      for (int i = 0; i < displayDataClass.opPav.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.opPav.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.opCrwn)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "opCrwn";
      for (int i = 0; i < displayDataClass.opCrwn.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.opCrwn.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.grdl)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "grdl";
      for (int i = 0; i < displayDataClass.grdl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.grdl.join(  " , ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.ctPr)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "ctPr";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.ctPr.back) &&
          !isNullEmptyOrFalse(displayDataClass.ctPr.empty)) {
        temp = displayDataClass.ctPr.back.toString() +
             " to " +
            displayDataClass.ctPr.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.ctPr.back)) {
        temp = displayDataClass.ctPr.back.toString();
      } else {
        temp = displayDataClass.ctPr.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.back)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "back";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.back.back) &&
          !isNullEmptyOrFalse(displayDataClass.back.empty)) {
        temp = displayDataClass.back.back.toString() +
             " to " +
            displayDataClass.back.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.back.back)) {
        temp = displayDataClass.back.back.toString();
      } else {
        temp = displayDataClass.back.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.tblPer)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "tblPer";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.tblPer.back) &&
          !isNullEmptyOrFalse(displayDataClass.tblPer.empty)) {
        temp = displayDataClass.tblPer.back.toString() +
             " to " +
            displayDataClass.tblPer.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.tblPer.back)) {
        temp = displayDataClass.tblPer.back.toString();
      } else {
        temp = displayDataClass.tblPer.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.depPer)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "depPer";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.depPer.back) &&
          !isNullEmptyOrFalse(displayDataClass.depPer.empty)) {
        temp = displayDataClass.depPer.back.toString() +
             " to " +
            displayDataClass.depPer.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.depPer.back)) {
        temp = displayDataClass.depPer.back.toString();
      } else {
        temp = displayDataClass.depPer.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.ratio)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "ratio";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.ratio.back) &&
          !isNullEmptyOrFalse(displayDataClass.ratio.empty)) {
        temp = displayDataClass.ratio.back.toString() +
             " to " +
            displayDataClass.ratio.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.ratio.back)) {
        temp = displayDataClass.ratio.back.toString();
      } else {
        temp = displayDataClass.ratio.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.length)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "length";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.length.back) &&
          !isNullEmptyOrFalse(displayDataClass.length.empty)) {
        temp = displayDataClass.length.back.toString() +
             " to " +
            displayDataClass.length.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.length.back)) {
        temp = displayDataClass.length.back.toString();
      } else {
        temp = displayDataClass.length.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.width)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "width";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.width.back) &&
          !isNullEmptyOrFalse(displayDataClass.width.empty)) {
        temp = displayDataClass.width.back.toString() +
             " to " +
            displayDataClass.width.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.width.back)) {
        temp = displayDataClass.width.back.toString();
      } else {
        temp = displayDataClass.width.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.height)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "height";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.height.back) &&
          !isNullEmptyOrFalse(displayDataClass.height.empty)) {
        temp = displayDataClass.height.back.toString() +
             " to " +
            displayDataClass.height.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.height.back)) {
        temp = displayDataClass.height.back.toString();
      } else {
        temp = displayDataClass.height.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cAng)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "cAng";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.cAng.back) &&
          !isNullEmptyOrFalse(displayDataClass.cAng.empty)) {
        temp = displayDataClass.cAng.back.toString() +
             " to " +
            displayDataClass.cAng.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.cAng.back)) {
        temp = displayDataClass.cAng.back.toString();
      } else {
        temp = displayDataClass.cAng.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cHgt)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "cHgt";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.cHgt.back) &&
          !isNullEmptyOrFalse(displayDataClass.cHgt.empty)) {
        temp = displayDataClass.cHgt.back.toString() +
             " to " +
            displayDataClass.cHgt.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.cHgt.back)) {
        temp = displayDataClass.cHgt.back.toString();
      } else {
        temp = displayDataClass.cHgt.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.grdlPer)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "grdlPer";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.grdlPer.back) &&
          !isNullEmptyOrFalse(displayDataClass.grdlPer.empty)) {
        temp = displayDataClass.grdlPer.back.toString() +
             " to " +
            displayDataClass.grdlPer.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.grdlPer.back)) {
        temp = displayDataClass.grdlPer.back.toString();
      } else {
        temp = displayDataClass.grdlPer.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.pAng)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "pAng";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.pAng.back) &&
          !isNullEmptyOrFalse(displayDataClass.pAng.empty)) {
        temp = displayDataClass.pAng.back.toString() +
             " to " +
            displayDataClass.pAng.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.pAng.back)) {
        temp = displayDataClass.pAng.back.toString();
      } else {
        temp = displayDataClass.pAng.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.pHgt)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "pHgt";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.pHgt.back) &&
          !isNullEmptyOrFalse(displayDataClass.pHgt.empty)) {
        temp = displayDataClass.pHgt.back.toString() +
             " to " +
            displayDataClass.pHgt.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.pHgt.back)) {
        temp = displayDataClass.pHgt.back.toString();
      } else {
        temp = displayDataClass.pHgt.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.lwr)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "lwr";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.lwr.back) &&
          !isNullEmptyOrFalse(displayDataClass.lwr.empty)) {
        temp = displayDataClass.lwr.back.toString() +
             " to " +
            displayDataClass.lwr.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.lwr.back)) {
        temp = displayDataClass.lwr.back.toString();
      } else {
        temp = displayDataClass.lwr.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.strLn)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "strLn";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.strLn.back) &&
          !isNullEmptyOrFalse(displayDataClass.strLn.empty)) {
        temp = displayDataClass.strLn.back.toString() +
             " to " +
            displayDataClass.strLn.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.strLn.back)) {
        temp = displayDataClass.strLn.back.toString();
      } else {
        temp = displayDataClass.strLn.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cAng)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "cAng";

      String temp = "";
      if (!isNullEmptyOrFalse(displayDataClass.cAng.back) &&
          !isNullEmptyOrFalse(displayDataClass.cAng.empty)) {
        temp = displayDataClass.cAng.back.toString() +
             " to " +
            displayDataClass.cAng.empty.toString();
      } else if (!isNullEmptyOrFalse(displayDataClass.cAng.back)) {
        temp = displayDataClass.cAng.back.toString();
      } else {
        temp = displayDataClass.cAng.empty.toString();
      }
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.type2)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "type2";

      displayDataKeyValue["value"] = displayDataClass.type2.empty;
      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.kToSArr)) {
      Map<String, dynamic> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "kToSArr";

      String temp = displayDataClass.kToSArr.kToSArrIn.join(  " , ");
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }
    return arrData;
    // setState(() {});
  }

  getSegment(String title, int index) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: getFontSize(14),
          fontWeight: FontWeight.w500,
          color: index != sharedValue
              ? appTheme.colorPrimary
              : appTheme.whiteColor,
        ),
      ),
    );
  }

    @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    return savedSearchBaseList;
  }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Scaffold(
  //     backgroundColor: appTheme.whiteColor,
  //     appBar: getAppBar(
  //       context,
  //       R.string().screenTitle.savedSearch,
  //       bgColor: appTheme.whiteColor,
  //       leadingButton: isFromDrawer
  //           ? getDrawerButton(context, true)
  //           : getBackButton(context),
  //       centerTitle: false,
  //     ),
  //     body: Column(
  //       children: [
  //         SizedBox(
  //           height: getSize(20),
  //         ),
  //         SizedBox(
  //           width: MathUtilities.screenWidth(context),
  //           child: CupertinoSegmentedControl<int>(
  //             selectedColor: appTheme.colorPrimary,
  //             unselectedColor: Colors.white,
  //             pressedColor: Colors.transparent,
  //             borderColor: appTheme.colorPrimary,
  //             children: {
  //               0: getSegment("Saved Search", 0),
  //               1: getSegment("Recent Search", 1),
  //             },
  //             onValueChanged: (int val) {
  //               setState(() {
  //                 sharedValue = val;
  //                 _controller.animateToPage(val,
  //                     duration: Duration(milliseconds: 500),
  //                     curve: Curves.easeIn);
  //               });
  //             },
  //             groupValue: sharedValue,
  //           ),
  //         ),
  //         SizedBox(
  //           height: getSize(20),
  //         ),
  //         Expanded(
  //           child: PageView.builder(
  //             physics: NeverScrollableScrollPhysics(),
  //             controller: _controller,
  //             itemCount: 2,
              
  //             onPageChanged: (int val) {
  //               setState(() {
  //                 // sharedValue = val;
  //                 // if(sharedValue==1){
  //                 //   callApi(false);
  //                 // }
  //                 _controller.animateToPage(val,
  //                     duration: Duration(milliseconds: 500),
  //                     curve: Curves.easeIn);
  //               });
  //             },

  //             itemBuilder: (context, position) {
  //               if (sharedValue == 0) {
                  
  //                   return savedSearchBaseList;
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // bool get wantKeepAlive => true;
}
