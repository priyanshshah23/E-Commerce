import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:flutter/material.dart';

class DiamondListHeader extends StatefulWidget {
  DiamondCalculation diamondCalculation;

  DiamondListHeader({
    this.diamondCalculation,
  });

  @override
  _DiamondListHeaderState createState() => _DiamondListHeaderState();
}

class _DiamondListHeaderState extends State<DiamondListHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MathUtilities.screenWidth(context),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getColumn(widget.diamondCalculation.pcs, R.string().commonString.pcs),
          getColumn(widget.diamondCalculation.totalCarat,
              R.string().commonString.cts),
          getColumn(widget.diamondCalculation.totalDisc,
              R.string().commonString.disc),
          Expanded(
            child: getColumn(
                widget.diamondCalculation.totalPriceCrt,
                R.string().commonString.avgPriceCrt +
                    R.string().commonString.doller),
          ),
          Expanded(
            child: getColumn(
                widget.diamondCalculation.totalAmount,
                R.string().commonString.amount +
                    R.string().commonString.doller),
          )
        ],
      ),
    );
  }

  getColumn(String text, String lable) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: getSize(15), horizontal: getSize(10)),
      decoration: BoxDecoration(
          border: Border.all(color: appTheme.dividerColor),
          borderRadius: BorderRadius.circular(getSize(5))),
      child: Column(
        children: <Widget>[
          getDetailText(text),
          SizedBox(
            height: getSize(5),
          ),
          getLableText(lable),
        ],
      ),
    );
  }

  setDivider() {
    return Container(
      height: getSize(20),
      width: getSize(2),
      color: appTheme.textGreyColor,
    );
  }

  getDetailText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }

  getLableText(String text) {
    return Text(
      text,
      style: appTheme.black16TextStyle.copyWith(fontSize: getFontSize(10)),
    );
  }
}
