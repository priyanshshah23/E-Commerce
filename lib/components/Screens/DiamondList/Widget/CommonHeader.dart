import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:flutter/material.dart';

class DiamondListHeader extends StatefulWidget {
  @override
  _DiamondListHeaderState createState() => _DiamondListHeaderState();
}

class _DiamondListHeaderState extends State<DiamondListHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MathUtilities.screenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getColumn("0","Pcs"),
          setDivider(),
          getColumn("0","Cts"),
          setDivider(),
          getColumn("0","Disc %"),
          setDivider(),
          getColumn("0","Price " + R.string().commonString.doller),
          setDivider(),
          getColumn("0","Amount " + R.string().commonString.doller),
        ],
      ),
    );
  }

  getColumn(String text,String lable){
    return Column(
      children: <Widget>[
        getDetailText(text),
        getLableText(lable)
      ],
    );
  }

  setDivider(){
    return Container(
      height: getSize(20),
      width: getSize(2),
      color: appTheme.textGreyColor,
    );
  }

  getDetailText(String text) {
    return Text(
      text,
      style: appTheme.white16TextStyle,
    );
  }

  getLableText(String text) {
    return Text(
      text,
      style: appTheme.white16TextStyle,
    );
  }
}
