import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    arrData = Config.instance.arrFilter
        .where((element) =>
            element.viewType == ViewTypes.shapeWidget ||
            element.viewType == ViewTypes.caratRange)
        .toList();

    for (var item in arrData) {
      if (item.viewType == ViewTypes.caratRange) {
        if (item is SelectionModel) {}
      }
    }
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
}
