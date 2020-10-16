import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
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
  void initState() {
    super.initState();
  }
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
          boxShadow: widget.item.isSelected
              ? getBoxShadow(context)
              : [BoxShadow(color: Colors.transparent)],
          borderRadius: BorderRadius.circular(getSize(6)),
          border: Border.all(
              color: widget.item.isSelected
                  ? appTheme.colorPrimary
                  : appTheme.dividerColor)
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
          ),
          Container(
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                  color: widget.item.getStatusColor(),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5))),
              height: getSize(26),
              width: getSize(4),
              // color: Colors.red,
            )),
          ),
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
        color: widget.item.isSelected
            ? appTheme.colorPrimary
            : appTheme.dividerColor,
      ),
      child: Column(
        children: <Widget>[
          Text(
            PriceUtilities.getPercent(widget.item?.crt ?? 0),
            style: appTheme.blue14TextStyle.copyWith(
                color: widget.item.isSelected
                    ? appTheme.whiteColor
                    : appTheme.colorPrimary),
          ),
          Text(
            "Carat",
            style: appTheme.blue14TextStyle.copyWith(
                color: widget.item.isSelected
                    ? appTheme.whiteColor
                    : appTheme.colorPrimary),
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
              PriceUtilities.getPercent(widget.item?.back) ?? "",
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
          getText(widget.item?.vStnId ?? ""),
          Expanded(child: Container()),
          getText(widget.item?.shpNm ?? ""),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText(widget.item?.colNm ?? ""),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText(widget.item?.clrNm ?? ""),
          ),
          Row(
            children: <Widget>[
              getText(widget.item?.cutNm ?? ""),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              getText(widget.item?.polNm ?? ""),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              getText(widget.item?.symNm ?? ""),
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
          getText(widget.item?.fluNm ?? ""),
          getText(widget.item?.msrmnt ?? ""),
          getText(widget.item?.lbNm ?? ""),
          getAmountText(R.string().commonString.doller +
                  widget.item?.ctPr.toStringAsFixed(2) +
                  "/Cts" ??
              ""),
        ],
      ),
    );
  }

  getTableDepthAndAmountDetail() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getText(widget.item?.shpNm ?? ""),
          getText(PriceUtilities.getPercent(widget.item?.tblPer ?? 0) + "T"),
          getText(PriceUtilities.getPercent(widget.item?.depPer ?? 0) + "D"),
          getAmountText(R.string().commonString.doller +
                  widget.item?.amt.toStringAsFixed(2) +
                  "/Amt" ??
              ""),
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
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(12)),
    );
  }
}
