import 'dart:math';

import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/Libraries/horizontalTableView/horizontal_data_table.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseApiResp.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/QuickSearch/QuickSearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickSearchScreen extends StatefulWidget {
  static const route = "QuickSearchScreen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;

  QuickSearchScreen(Map<String, dynamic> arguments) {
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
  _QuickSearchScreenState createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends State<QuickSearchScreen> {
  List<FormBaseModel> arrData = [];

  Config config = Config();
  String flCode = "fl";
  String ifCode = "if";
  String si2Code = "si2";
  String si2DesCode = "si2-";
  var outPutWidth;
  double cellHeight = getSize(60);
  double rowWidth = getSize(80);
  List<Master> arrColors = [];
  List<Master> arrClarity = [];
  List<CellModel> arrCell = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      config.getFilterJson().then((result) {
        setState(() {
          arrData = result
              .where((element) =>
                  element.viewType == ViewTypes.shapeWidget ||
                  element.viewType == ViewTypes.caratRange)
              .toList();
        });

        for (var item in arrData) {
          if (item is SelectionModel) {
            item.isShowAll = false;
            if (item.viewType == ViewTypes.caratRange) {
              item.showFromTo = false;
              item.masters
                  .removeWhere((element) => element.sId == item.allLableTitle);
              item.masters.first.isSelected = true;
            } else if (item.viewType == ViewTypes.shapeWidget) {
              item.masters
                  .removeWhere((element) => element.sId == item.allLableTitle);
              item.masters.first.isSelected = true;
            }
          }
        }
        getCombineColors().then((value) {
          arrColors = value;
          setState(() {});
        });
        getCombineClarity().then((value) {
          arrClarity = value;
          var test = (MathUtilities.screenWidth(context) - getSize(120)) /
              arrClarity.length;
          outPutWidth = test < rowWidth ? rowWidth : test;
          setState(() {});
        });

        callApiForQuickSearch();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
          context,
          R.string().screenTitle.quickSearch,
          bgColor: appTheme.whiteColor,
          leadingButton: getDrawerButton(context, true),
          centerTitle: false,
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: this.arrData.length,
              itemBuilder: (context, index) {
                return getWidgets(this.arrData[index]);
              },
            ),
            SizedBox(height: getSize(20)),
            isNullEmptyOrFalse(arrClarity)
                ? SizedBox()
                : getHorizontalDataWidget(),
          ],
        ));
  }

  Widget getWidgets(FormBaseModel model) {
    if (model.viewType == ViewTypes.shapeWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: ShapeWidget(model),
      );
    } else if (model.viewType == ViewTypes.caratRange) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: CaratRangeWidget(model),
      );
    } else {
      return SizedBox();
    }
  }

  //Get Combine Clarity
  Future<List<Master>> getCombineClarity() async {
    List<Master> tempClarity = List<Master>();
    List<Master> clarity = await Master.getSubMaster(MasterCode.clarity);

    for (var item in clarity) {
      item.isSelected = true;
      if (item.webDisplay?.toLowerCase() == flCode) {
        List<Master> findIf = clarity
            .where((element) => element.webDisplay?.toLowerCase() == ifCode)
            .toList();
        if (!isNullEmptyOrFalse(findIf)) {
          item.mergeModel = findIf.first;
          tempClarity.add(item);
        }
      } else if (item.webDisplay?.toLowerCase() == si2Code) {
        List<Master> findSi2 = clarity
            .where((element) => element.webDisplay?.toLowerCase() == si2DesCode)
            .toList();
        if (!isNullEmptyOrFalse(findSi2)) {
          item.mergeModel = findSi2.first;
          tempClarity.add(item);
        }
      } else if (item.webDisplay?.toLowerCase() == ifCode) {
        print("IF");
      } else if (item.webDisplay?.toLowerCase() == si2DesCode) {
        print("SI2");
      } else {
        tempClarity.add(item);
      }
    }
    print(tempClarity);
    return tempClarity;
  }

  Future<List<Master>> getCombineColors() async {
    List<Master> tempColor = List<Master>();
    List<Master> color = await Master.getSubMaster(MasterCode.color);

    for (var item in color) {
      item.isSelected = true;
      List<String> arr = [
        "m",
        "n",
        "o",
        "p",
        "q",
        "r",
        "s",
        "t",
        "u",
        "v",
        "w",
        "x",
        "y",
        "z"
      ];

      if (item.webDisplay?.toLowerCase() == "m") {
        for (var str in arr) {
          List<Master> findIf = color
              .where((element) => element.webDisplay?.toLowerCase() == str)
              .toList();
          if (!isNullEmptyOrFalse(findIf)) {
            for (var id in (findIf.first.grouped.map((e) => e.sId ?? ""))) {
              item.groupingIds.add(id);
            }
          }
        }

        item.groupName = "M-Z";
        tempColor.add(item);
      } else if (!arr.contains(item.webDisplay?.toLowerCase() ?? "")) {
        item.groupName = item.webDisplay ?? "";
        tempColor.add(item);
      }
    }

    return tempColor;
  }

  Map<String, dynamic> getPriceRequest() {
    Map<String, dynamic> request = {};
    SelectionModel model = arrData
        .singleWhere((element) => element.viewType == ViewTypes.shapeWidget);
    request["shape"] = Master.getSelectedId(model.masters);

    SelectionModel model1 = arrData
        .singleWhere((element) => element.viewType == ViewTypes.caratRange);
    List<Master> selectedCarat =
        model1.masters.where((element) => element.isSelected).toList();

    var range = List<Map<String, dynamic>>();
    for (var item in selectedCarat) {
      List<num> arrMin = item.grouped.map((e) => e.fromCarat).toList();
      num minFrom = arrMin.reduce(min);

      List<num> arrMax = item.grouped.map((e) => e.toCarat).toList();
      num maxTo = arrMax.reduce(max);

      var rangeDic = Map<String, dynamic>();
      rangeDic["from"] = minFrom;
      rangeDic["to"] = maxTo;
      rangeDic["id"] = item.sId;
      range.add(rangeDic);
    }

    request["range"] = range;
    return request;
  }

  getHorizontalDataWidget() {
    return Padding(
      padding: EdgeInsets.all(getSize(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(10)),
          border: Border.all(
            width: getSize(1.0),
            color: appTheme.borderColor,
          ),
        ),
        child: HorizontalDataTable(
          elevation: 5,
          leftHandSideColumnWidth: getSize(60),
          rowSeparatorWidget: Divider(
            height: getSize(1),
            color: appTheme.borderColor,
          ),
          rightHandSideColumnWidth: this.arrClarity.length * outPutWidth,
          isFixedHeader: true,
          headerWidgets: _getHorizontalRow(),
          leftSideItemBuilder: _getVerticalColumn,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: arrColors.length,
        ),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  List<Widget> _getHorizontalRow() {
    return [
      _getTitleItemWidget(R.string().commonString.colorGroup, 200),
      for (var item in arrClarity)
        _getTitleItemWidget(
          item.name,
          outPutWidth,
        ),
    ];
  }

  Widget _getVerticalColumn(BuildContext context, int index) {
    return Container(
      child: Text(
        arrColors[index].name,
        style: appTheme.blackNormal14TitleColorblack,
      ),
      width: 100,
      height: cellHeight,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
    );
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: appTheme.blackNormal14TitleColorblack,
      ),
      width: width,
      height: cellHeight,
      padding: EdgeInsets.only(left: 2, right: 2),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < arrClarity.length; i++)
          for (int j = 0; j < arrColors.length; j++)
            if (j == index)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: getSize(0.5),
                    color: appTheme.borderColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    arrColors[index].name,
                    style: appTheme.blackNormal14TitleColorblack,
                  ),
                ),
                width: outPutWidth,
                height: cellHeight,
                padding: EdgeInsets.only(left: 4, right: 4),
                alignment: Alignment.center,
              ),
      ],
    );
  }

  callApiForQuickSearch() {
    NetworkCall<QuickSearchResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .quickSearch(getPriceRequest()),
      context,
      isProgress: true,
    )
        .then((resp) async {
      print(resp);
    }).catchError((onError) {
      print(onError);
    });
  }
}

class CellModel {
  Master cellObj;
  List<Master> dataArr;
}
