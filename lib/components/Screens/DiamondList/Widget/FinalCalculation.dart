import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/cupertino.dart';

class FinalCalculationWidget extends StatefulWidget {
  List<DiamondModel> arrList;
  DiamondCalculation finalCalculation;
  FinalCalculationWidget(this.arrList, this.finalCalculation);

  @override
  _FinalCalculationWidgetState createState() => _FinalCalculationWidgetState();
}

class _FinalCalculationWidgetState extends State<FinalCalculationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: appTheme.blackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSize(10.0)),
            topRight: Radius.circular(getSize(10.0)),
          ),
        ),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(
              left: getSize(20.0),
              right: getSize(20.0),
              top: getSize(20.0),
            ),
            child: Text(
              "Note : The additional 2.00% on amount value has already been added in the final calculation.",
              style: appTheme.redPrimaryNormal12TitleColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: getSize(20.0),
            ),
            child: DiamondListHeader(
              diamondCalculation: widget.finalCalculation,
              moduleType: DiamondModuleConstant.MODULE_TYPE_FINAL_CALCULATION,
            ),
          )
        ]));
  }
}
