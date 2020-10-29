import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:flutter/cupertino.dart';
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
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
        top: getSize(20),
      ),
      child: Container(
        width: MathUtilities.screenWidth(context),
        padding: EdgeInsets.symmetric(
          horizontal: getSize(10),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: appTheme.dividerColor),
            borderRadius: BorderRadius.circular(getSize(5))),
        child: Row(
          children: <Widget>[
            getColumn(
                widget.diamondCalculation.pcs, R.string().commonString.pcs),
            Expanded(
              child: Container(),
            ),
            getColumn(widget.diamondCalculation.totalCarat,
                R.string().commonString.cts),
            Expanded(
              child: Container(),
            ),
            getColumn(widget.diamondCalculation.totalDisc,
                R.string().commonString.disc),
            Expanded(
              child: Container(),
            ),
            getColumn(
                widget.diamondCalculation.totalPriceCrt,
                R.string().commonString.avgPriceCrt +
                    R.string().commonString.doller),
            Expanded(
              child: Container(),
            ),
            getColumn(widget.diamondCalculation.totalAmount,
                R.string().commonString.amount + R.string().commonString.doller)
          ],
        ),
      ),
    );
  }

  getColumn(String text, String lable) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: getSize(15), horizontal: getSize(4)),
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
