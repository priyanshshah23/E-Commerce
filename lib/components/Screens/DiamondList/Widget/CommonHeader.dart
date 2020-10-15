import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:flutter/material.dart';

class DiamondListHeader extends StatefulWidget {
  String totalCarat = "0";
  String totalDisc = "0";
  String totalPriceCrt = "0";
  String totalAmount = "0";
  String pcs = "0";

  DiamondListHeader(
      {this.pcs,
      this.totalCarat,
      this.totalDisc,
      this.totalPriceCrt,
      this.totalAmount});

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
          getColumn(widget.pcs, "Pcs"),
          getColumn(widget.totalCarat, "Cts"),
          getColumn(widget.totalDisc, "Disc %"),
          Expanded(
            child: getColumn(
                widget.totalPriceCrt, "Avg. Price/Ct " + R.string().commonString.doller),
          ),
          Expanded(
            child: getColumn(widget.totalAmount, "Amount " + R.string().commonString.doller),
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
