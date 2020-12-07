import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DiamondExpandItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;
  List<Widget> list;
  List<Widget> leftSwipeList;
  SlidableController controller;
  int moduleType;

  DiamondExpandItemWidget({
    this.item,
    this.actionClick,
    this.controller,
    this.list,
    this.moduleType,
    this.leftSwipeList,
  });

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
        child: Slidable(
          controller: widget.controller,
          key: Key(widget.item.id),
          actionPane: SlidableDrawerActionPane(),
          actions: widget.leftSwipeList == null ? [] : widget.leftSwipeList,
          secondaryActions: widget.list == null ? [] : widget.list,
          actionExtentRatio: 0.2,
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
                        : appTheme.dividerColor,
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
                          getSecondRow(),
                          getThirdRow(),
                          getFourthRow(),
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
      ),
    );
  }

  getFirstRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(10),
        right: getSize(5),
      ),
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: getText(widget.item?.vStnId ?? "",
                    appTheme.blackNormal14TitleColorblack),
              )),
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: getText(widget.item?.shpNm ?? "",
                  appTheme.blackMedium14TitleColorblack),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              PriceUtilities.getDoubleValue(widget.item?.crt ?? 0),
              style: appTheme.blue16TextStyle,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              " " + R.string().commonString.carat,
              style: appTheme.blue16TextStyle.copyWith(
                fontSize: getFontSize(14),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              PriceUtilities.getPercent(widget.item?.getFinalDiscount() ?? 0),
              style: appTheme.blue14TextStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  getSecondRow() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(4), bottom: getSize(4)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: getText(widget.item?.colNm ?? "",
                appTheme.blackMedium14TitleColorblack),
          ),
          Expanded(
            flex: 2,
            child: getText(widget.item?.clrNm ?? "",
                appTheme.blackMedium14TitleColorblack),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                getText(widget.item?.cutNm ?? "",
                    appTheme.blackMedium14TitleColorblack),
                Container(
                  height: getSize(4),
                  width: getSize(4),
                  decoration: BoxDecoration(
                      color: appTheme.dividerColor, shape: BoxShape.circle),
                ),
                getText(widget.item?.polNm ?? "",
                    appTheme.blackMedium14TitleColorblack),
                Container(
                  height: getSize(4),
                  width: getSize(4),
                  decoration: BoxDecoration(
                      color: appTheme.dividerColor, shape: BoxShape.circle),
                ),
                getText(widget.item?.symNm ?? "",
                    appTheme.blackMedium14TitleColorblack),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: getAmountText(
              widget.item?.getPricePerCarat() ?? "",
              align: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  getThirdRow() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(4), bottom: getSize(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: getText(
                widget.item?.lbNm ?? "", appTheme.blackMedium12TitleColorblack),
          ),
          Expanded(
            flex: 2,
            child: getTextWithLabel(widget.item?.shdNm ?? "", "S : "),
          ),
          // getText(widget.item?.msrmnt ?? ""),
          Expanded(
            flex: 2,
            child: getText(
                widget.item?.fluNm ?? "", appTheme.blackMedium12TitleColorblack,
                align: TextAlign.right),
          ),

          Expanded(
            flex: 4,
            child: getAmountText(
              widget.item?.getAmount() ?? "",
              align: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  getFourthRow() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: getTextWithLabel(widget.item?.mlk ?? "-", "M : ",
                aligmentOfRow: MainAxisAlignment.start),
          ),
          // PriceUtilities.getPercent(widget.item?.depPer ?? 0)
          Expanded(
            flex: 2,
            child: getTextWithLabel(
                PriceUtilities.getPercentWithoutPercentSign(
                    widget.item?.depPer ?? 0),
                "D : "),
          ),
          Expanded(
            flex: 2,
            child: getTextWithLabel(
                PriceUtilities.getPercentWithoutPercentSign(
                    widget.item?.tblPer ?? 0),
                "T : "),
          ),
          Expanded(
            flex: 4,
            child: getTextWithLabel(widget.item?.msrmnt ?? "", "M : ",
                align: TextAlign.right),
          ),
          // getAmountText(widget.item?.getAmount() ?? ""),
        ],
      ),
    );
  }

  getText(String text, TextStyle style, {TextAlign align}) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: style,
    );
  }

  getPrimaryText(String text) {
    return Text(
      text,
      style: appTheme.primary16TextStyle,
    );
  }

  getAmountText(String text, {TextAlign align}) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(14)),
    );
  }
}
