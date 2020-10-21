import 'dart:math';

import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
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
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: this.arrData.length,
          itemBuilder: (context, index) {
            return getWidgets(this.arrData[index]);
          },
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
        item.mergeModel = findIf.first;
        tempClarity.add(item);
      } else if (item.webDisplay?.toLowerCase() == si2Code) {
        List<Master> findSi2 = clarity
            .where((element) => element.webDisplay?.toLowerCase() == si2DesCode)
            .toList();
        item.mergeModel = findSi2.first;
        tempClarity.add(item);
      } else if (item.webDisplay?.toLowerCase() == ifCode) {
        print("IF");
      } else if (item.webDisplay?.toLowerCase() == si2DesCode) {
        print("SI2");
      } else {
        tempClarity.add(item);
      }
    }

    return tempClarity;
  }

  Map<String, dynamic> getPriceRequest() {
    Map<String, dynamic> request = {};
    SelectionModel model = arrData
        .singleWhere((element) => element.viewType == ViewTypes.shapeWidget);
    request["shape"] = Master.getSelectedId(model.masters);

    SelectionModel model1 = arrData
        .singleWhere((element) => element.viewType == ViewTypes.caratRange);
    List<Master> selectedCarat =
        model1.masters.where((element) => element.isSelected);

    var range = List<Map<String, dynamic>>();
    for (var item in selectedCarat) {
      List<num> arrMin = item.grouped.map((e) => e.fromCarat).toList();
      num minFrom = arrMin.reduce(min);

      List<num> arrMax = item.grouped.map((e) => e.toCarat).toList();
      num maxTo = arrMin.reduce(max);

      var rangeDic = Map<String, dynamic>();
      rangeDic["from"] = minFrom;
      rangeDic["to"] = maxTo;
      rangeDic["id"] = item.sId;
      range.add(rangeDic);
    }

    request["range"] = range;
    return request;
  }
}
