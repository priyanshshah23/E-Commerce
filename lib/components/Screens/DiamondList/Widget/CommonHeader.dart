import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:flutter/material.dart';

class DiamondListHeader extends StatefulWidget {
  num carat = 0;
  DiamondListHeader({this.carat});

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
          getColumn(widget.carat.toString(), "Pcs"),
          getColumn("0", "Cts"),
          getColumn("0", "Disc %"),
          Expanded(
            child: getColumn(
                "0", "Avg. Price/Ct " + R.string().commonString.doller),
          ),
          Expanded(
            child: getColumn("0", "Amount " + R.string().commonString.doller),
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
      style: appTheme.black16TextStyle,
    );
  }

  getLableText(String text) {
    return Text(
      text,
      style: appTheme.black16TextStyle.copyWith(
        fontSize: getFontSize(11)
      ),
    );
  }
}
