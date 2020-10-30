import 'dart:collection';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/FilterRequest.dart';
import 'package:flutter/material.dart';

class MyDemandScreen extends StatefulWidget {
  static const route = "MyDemandScreen";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_MY_DEMAND;
  bool isFromDrawer = false;

  MyDemandScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _MyDemandScreenState createState() => _MyDemandScreenState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _MyDemandScreenState extends State<MyDemandScreen> {
  int moduleType;
  bool isFromDrawer;

  DateUtilities dateUtilities = DateUtilities();

  BaseList myDemandBaseList;
  List<SavedSearchModel> arrList = [];
  int page = DEFAULT_PAGE;

  _MyDemandScreenState({this.moduleType, this.isFromDrawer});

  @override
  void initState() {
    super.initState();
    myDemandBaseList = BaseList(BaseListState(
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
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arrList.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    dict["type"] = DiamondSearchType.DEMAND;
    dict["isAppendMasters"] = true;

    NetworkCall<SavedSearchResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().mySavedSearch(dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((savedSearchResp) async {
      myDemandBaseList.state.listCount = savedSearchResp.data.list.length;
      myDemandBaseList.state.totalCount = savedSearchResp.data.count;
      arrList.addAll(savedSearchResp.data.list);
      fillArrayList();
      page = page + 1;
      myDemandBaseList.state.setApiCalling(false);
      setState(() {});
    }).catchError((onError) {
      if (isRefress) {
        arrList.clear();

        myDemandBaseList.state.listCount = arrList.length;
        myDemandBaseList.state.totalCount = arrList.length;
      }

      myDemandBaseList.state.setApiCalling(false);
    });
  }

  fillArrayList() {
    myDemandBaseList.state.listItems = ListView.builder(
      itemCount: myDemandBaseList.state.listCount,
      itemBuilder: (BuildContext context, int index) {
        SavedSearchModel savedSearchModel = arrList[index];
        List<Map<String, dynamic>> arrData =
            getDisplayData(savedSearchModel.displayData);
        return getItemWidget(savedSearchModel, arrData);
        // return Text("hello");
      },
    );
  }

  getItemWidget(SavedSearchModel model, List<Map<String, dynamic>> arr) {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(5),
        top: getSize(16),
        right: getSize(5),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(5)),
          border: Border.all(color: appTheme.borderColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getSize(10), vertical: getSize(12)),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        model.name,
                        style: appTheme.black16TextStyle,
                      ),
                      SizedBox(height: getSize(4)),
                      Text(
                        model.expiryDate,
                        // dateUtilities
                        //     .convertDateToFormatterString(model.expiryDate),
                        style: appTheme.blackNormal12TitleColorblack,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: getSize(40),
                        height: getSize(40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(getSize(35)),
                            border:
                                Border.all(color: ColorConstants.borderColor)),
                        child: IconButton(
                          icon: Image.asset(
                            edit_icon,
                            width: getSize(20),
                            height: getSize(20),
                          ),
                          onPressed: () {
                            Map<String, dynamic> dict = {};
                            dict["searchData"] = model.searchData;
                            dict[ArgumentConstant.IsFromDrawer] = false;
                            NavigationUtilities.pushRoute(FilterScreen.route,
                                args: dict);
                          },
                        ),
                      ),
                      SizedBox(
                        width: getSize(10),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: getSize(40),
                        height: getSize(40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(getSize(35)),
                            border:
                                Border.all(color: ColorConstants.borderColor)),
                        child: IconButton(
                          icon: Image.asset(
                            home_delete,
                            width: getSize(15),
                            height: getSize(15),
                          ),
                          onPressed: () {
                            app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              barrierDismissible: true,
                              title: "",
                              desc: "You really want to delete ${model.name}.",
                              positiveBtnTitle: R.string().commonString.ok,
                              negativeBtnTitle: R.string().commonString.cancel,
                              onClickCallback: (buttonType) {
                                if (buttonType ==
                                    ButtonType.PositveButtonClick) {
                                  SyncManager.instance
                                      .callApiForDeleteSavedSearch(
                                          context, model.id ?? "",
                                          success: (resp) {
                                    callApi(true);
                                  });
                                }
                                
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: getSize(10),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: getSize(40),
                        height: getSize(40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(getSize(35)),
                            border:
                                Border.all(color: ColorConstants.borderColor)),
                        child: IconButton(
                          icon: Image.asset(
                            saved_icon,
                            width: getSize(20),
                            height: getSize(20),
                          ),
                          onPressed: () {
                            Map<String, dynamic> dict = new HashMap();
                            dict["filterId"] = model.id;
                            dict[ArgumentConstant.ModuleType] = moduleType;
                            NavigationUtilities.pushRoute(
                                DiamondListScreen.route,
                                args: dict);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: getSize(20),
              ),
              if (arr.length <= 5) listOfSelectedFilter(arr, model),
              if (arr.length > 5 && model.isExpand)
                listOfSelectedFilter(arr, model),
              if (arr.length > 5 && !model.isExpand)
                Column(
                  children: <Widget>[
                    for (int i = 0; i < 5; i++)
                      Row(children: [
                        Text(
                          "${arr[i]["key"] ?? ""} :",
                          textAlign: TextAlign.left,
                          style: appTheme.grey16HintTextStyle,
                        ),
                        SizedBox(width: getSize(16)),
                        Expanded(
                          child: Text(arr[i]["value"] ?? "",
                              textAlign: TextAlign.right,
                              style: appTheme.primaryColor14TextStyle),
                        ),
                      ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            model.isExpand ^= true;
                            myDemandBaseList.state.setApiCalling(false);
                            fillArrayList();
                          },
                          child: Text(
                            R.string().commonString.viewDetails,
                            textAlign: TextAlign.center,
                            style: appTheme.primaryColor14TextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Column listOfSelectedFilter(
      List<Map<String, dynamic>> arr, SavedSearchModel savedSearchModel) {
    int length = arr.length;
    return Column(
      children: <Widget>[
        for (int i = 0; i < length; i++)
          Row(
            children: [
              Text(
                "${arr[i]["key"] ?? ""} :",
                textAlign: TextAlign.left,
                style: appTheme.grey16HintTextStyle,
              ),
              SizedBox(width: getSize(16)),
              Expanded(
                child: Text(arr[i]["value"] ?? "",
                    textAlign: TextAlign.right,
                    style: appTheme.primaryColor14TextStyle),
              ),
            ],
          ),
        savedSearchModel.isExpand && arr.length > 5
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      savedSearchModel.isExpand ^= true;
                      myDemandBaseList.state.setApiCalling(false);
                      fillArrayList();
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          R.string().commonString.viewLessDetails,
                          textAlign: TextAlign.center,
                          style: appTheme.primaryColor14TextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }

  getDisplayData(DisplayDataClass displayDataClass) {
    List<Map<String, String>> arrData = [];

    if (!isNullEmptyOrFalse(displayDataClass.shp)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Shape";
      for (int i = 0; i < displayDataClass.shp.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.shp.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.or)) {
      Map<String, String> displayDataKeyValue = {};
      List<String> tempList = [];
      for (int i = 0; i < displayDataClass.or.length; i++) {
        if (!isNullEmptyOrFalse(displayDataClass.or[i].crt)) {
          String temp = displayDataClass.or[i].crt.back.toString() +
              "-" +
              displayDataClass.or[i].crt.empty.toString();
          tempList.add(temp);
        }
      }
      displayDataKeyValue["key"] = "Carat Range";
      displayDataKeyValue["value"] = tempList.join(", ");

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.col)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Color";
      for (int i = 0; i < displayDataClass.col.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.col.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.shd)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Shade";
      for (int i = 0; i < displayDataClass.shd.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.shd.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.clr)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Clarity";
      for (int i = 0; i < displayDataClass.clr.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.clr.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cut)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Cut";
      for (int i = 0; i < displayDataClass.cut.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.cut.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.pol)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Polish";
      for (int i = 0; i < displayDataClass.pol.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.pol.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.sym)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Symmentry";
      for (int i = 0; i < displayDataClass.sym.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.sym.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.hA)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "H & A";
      for (int i = 0; i < displayDataClass.hA.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.hA.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.brlncy)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Brilliancy";
      for (int i = 0; i < displayDataClass.brlncy.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.brlncy.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.wSts)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Web Status";
      for (int i = 0; i < displayDataClass.wSts.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.wSts.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.isCm)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "isCm";
      for (int i = 0; i < displayDataClass.isCm.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.isCm.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.isDor)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "isDor";
      for (int i = 0; i < displayDataClass.isDor.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.isDor.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.isFm)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "isFm";
      for (int i = 0; i < displayDataClass.isFm.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.isFm.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.blkTbl)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Black Table";
      for (int i = 0; i < displayDataClass.blkTbl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.blkTbl.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.blkSd)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Black Side";
      for (int i = 0; i < displayDataClass.blkSd.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.blkSd.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.wTbl)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "White Table";
      for (int i = 0; i < displayDataClass.wTbl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.wTbl.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.cult)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Culet";
      for (int i = 0; i < displayDataClass.cult.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.cult.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.wSd)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "White Inclusion Side";
      for (int i = 0; i < displayDataClass.wSd.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.wSd.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.opTbl)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Open Table";
      for (int i = 0; i < displayDataClass.opTbl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.opTbl.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.opPav)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Open Pavallion";
      for (int i = 0; i < displayDataClass.opPav.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.opPav.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.opCrwn)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Open Crown";
      for (int i = 0; i < displayDataClass.opCrwn.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.opCrwn.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.grdl)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Girdle";
      for (int i = 0; i < displayDataClass.grdl.length; i++) {
        displayDataKeyValue["value"] = displayDataClass.grdl.join(", ");
      }

      arrData.add(displayDataKeyValue);
    }

    if (!isNullEmptyOrFalse(displayDataClass.ctPr)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Carat Per Price";

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
      Map<String, String> displayDataKeyValue = {};
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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Table Percentage";

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
      Map<String, String> displayDataKeyValue = {};
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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Ratio";

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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Length";

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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Width";

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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Height";

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
      Map<String, String> displayDataKeyValue = {};
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
      Map<String, String> displayDataKeyValue = {};
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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Girdle Per";

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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Pavallion Angle";

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
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Pavallion Height";

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
      Map<String, String> displayDataKeyValue = {};
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
      Map<String, String> displayDataKeyValue = {};
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
      Map<String, String> displayDataKeyValue = {};
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
      if (!isNullEmptyOrFalse(displayDataClass.type2.empty)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "type2";

        displayDataKeyValue["value"] = displayDataClass.type2.empty.toString();
        arrData.add(displayDataKeyValue);
      }
    }

    if (!isNullEmptyOrFalse(displayDataClass.kToSArr)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "Key to Symbol";

      String temp = displayDataClass.kToSArr.kToSArrIn.join(", ");
      displayDataKeyValue["value"] = temp;
      arrData.add(displayDataKeyValue);
    }

    if (isNullEmptyOrFalse(arrData)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "All All All All All";
      arrData.add(displayDataKeyValue);
    }

    return arrData;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context,
        R.string().commonString.myDemand,
        centerTitle: false,
        bgColor: appTheme.whiteColor,
        leadingButton: isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(20), vertical: getSize(10)),
        child: myDemandBaseList,
      ),
    );
  }
}
