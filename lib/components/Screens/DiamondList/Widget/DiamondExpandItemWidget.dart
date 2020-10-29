import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondExpandItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;
  List<Widget> list;

  DiamondExpandItemWidget({this.item, this.actionClick, this.list});

  @override
  _DiamondExpandItemWidgetState createState() =>
      _DiamondExpandItemWidgetState();
}

class _DiamondExpandItemWidgetState extends State<DiamondExpandItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget
            .actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_SELECTION));
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: Spacing.leftPadding,
            right: Spacing.rightPadding,
            bottom: getSize(10)),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: getSize(10), bottom: getSize(10), left: getSize(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(
                  color: widget.item.isSelected
                      ? appTheme.colorPrimary
                      : appTheme.dividerColor.withOpacity(0.5),
                ),
                color: widget.item.isSelected
                    ? appTheme.lightColorPrimary
                    : appTheme.whiteColor,
                boxShadow: widget.item.isSelected
                    ? [
                        BoxShadow(
                            color: appTheme.colorPrimary.withOpacity(0.05),
                            blurRadius: getSize(8),
                            spreadRadius: getSize(2),
                            offset: Offset(0, 8)),
                      ]
                    : [BoxShadow(color: Colors.transparent)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        getImageView(
                          widget.item.getDiamondImage(),
                          placeHolderImage: diamond,
                          width: MathUtilities.screenWidth(context),
                          height: getSize(96),
                        ),
                        getFirstRow(),
                        getLastRow()
                      ],
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
            ),
            widget.item.isSelected
                ? Container(
                    alignment: Alignment.center,
                    height: getSize(20),
                    width: getSize(20),
                    decoration: BoxDecoration(
                        color: appTheme.colorPrimary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(getSize(5)),
                          bottomRight: Radius.circular(getSize(5)),
                        )),
                    child: Icon(
                      Icons.check,
                      color: appTheme.whiteColor,
                      size: getSize(15),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  getFirstRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(10),
        bottom: getSize(5),
        right: getSize(5),
      ),
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getText(widget.item?.vStnId ?? ""),
          Expanded(child: Container()),
          getText(widget.item?.shpNm ?? ""),
          Expanded(child: Container()),
          Text(
            PriceUtilities.getDoubleValue(widget.item?.crt ?? 0),
            style: appTheme.blue16TextStyle,
          ),
          SizedBox(
            width: getSize(5),
          ),
          Text(
            R.string().commonString.carat,
            style: appTheme.blue16TextStyle,
          ),
          Expanded(child: Container()),
          Text(
            PriceUtilities.getPercent(widget.item?.getFinalDiscount()??0),
            style: appTheme.blue14TextStyle,
          ),
          Expanded(child: Container()),
          getAmountText(widget.item?.getPricePerCarat() ?? ""),
        ],
      ),
    );
  }

  getLastRow() {
    return Padding(
      padding: EdgeInsets.only(
        right: getSize(5),
      ),
      child: Row(
        children: [
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
          ),
          Expanded(child: Container()),
          getText(widget.item?.msrmnt ?? ""),
          Expanded(child: Container()),
          getText(widget.item?.lbNm ?? ""),
          Expanded(child: Container()),
          getAmountText(widget.item?.getAmount() ?? ""),
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

  getPrimaryText(String text) {
    return Text(
      text,
      style: appTheme.primary16TextStyle,
    );
  }

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(12)),
    );
  }
}
