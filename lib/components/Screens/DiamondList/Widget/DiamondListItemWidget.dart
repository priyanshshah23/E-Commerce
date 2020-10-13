import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondItemWidget extends StatefulWidget {

  DiamondModel item;
  DiamondItemWidget({this.item});
  @override
  _DiamondItemWidgetState createState() => _DiamondItemWidgetState();
}

class _DiamondItemWidgetState extends State<DiamondItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: getSize(10),
        top: getSize(5),
      ),
      width: MathUtilities.screenWidth(context),
      decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: BorderRadius.circular(getSize(5)),
          border: Border.all(color: appTheme.dividerColor)
          //boxShadow: getBoxShadow(context),
          ),
      child: Row(
        children: <Widget>[
          getCaratAndDiscountDetail(),
          //   getIdColorDetail(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: getSize(10),
                right: getSize(10),
              ),
              child: Column(
                children: <Widget>[
                  getIdShapeDetail(),
                  getDymentionAndCaratDetail(),
                  getTableDepthAndAmountDetail()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getCaratAndDiscountDetail() {
    return Container(
      padding: EdgeInsets.only(
        top: getSize(8),
        left: getSize(10),
        right: getSize(10),
        bottom: getSize(5),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSize(5)),
            bottomLeft: Radius.circular(getSize(5)),
          ),
          color: appTheme.colorPrimary),
      child: Column(
        children: <Widget>[
          Text(
            "12.50",
            style:
                appTheme.white16TextStyle.copyWith(fontSize: getFontSize(14)),
          ),
          Text(
            "Carat",
            style:
                appTheme.white16TextStyle.copyWith(fontSize: getFontSize(14)),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: getSize(5)),
            width: getSize(55),
            height: getSize(20),
            decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(getSize(5))),
            child: Text(
              "3.05%",
              style: appTheme.green10TextStyle,
            ),
          )
        ],
      ),
    );
  }

  getIdShapeDetail() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getText("6878989"),
          Expanded(child: Container()),
          getText("Round"),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText("D"),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText("IF"),
          ),
          Row(
            children: <Widget>[
              getText("EX"),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              getText("EX"),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              getText("EX"),
            ],
          )
        ],
      ),
    );
  }

  getDymentionAndCaratDetail() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getText("MAD"),
          getText("7.27 X 7.3 - 14.57"),
          getText("GIA"),
          getAmountText(R.string().commonString.doller+"13,992.50/Cts"),
        ],
      ),
    );
  }

  getTableDepthAndAmountDetail(){
    return Padding(
      padding: EdgeInsets.only(top: getSize(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getText("Yellow"),
          getText("59.00%T"),
          getText("59.00%D"),
          getAmountText(R.string().commonString.doller+"20,988.75/Amt"),
        ],
      ),
    );
  }

  getText(String text) {
    return Text(
      text,
      style: appTheme.black12TextStyle,
    );
  }


  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.black12TextStyle.copyWith(
        color: ColorConstants.colorPrimary
      ),
    );
  }
}
