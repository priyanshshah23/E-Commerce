import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;

  DiamondItemWidget({this.item, this.actionClick});

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
    return GestureDetector(
      onTap: () {
        widget
            .actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_SELECTION));
      },
      child: Container(
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
            getCaratAndDiscountDetail(widget.actionClick),
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
                    getTableDepthAndAmountDetail(),
                    getWatchListDetail(),
                  ],
                ),
              ),
            ),

//            Container(
//              child: Center(
//                  child: Container(
//                decoration: BoxDecoration(
//                    color: widget.item.getStatusColor(),
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(5),
//                        bottomLeft: Radius.circular(5))),
//                height: getSize(26),
//                width: getSize(4),
//                // color: Colors.red,
//              )),
//            ),
          ],
        ),
      ),
    );
  }

  getCaratAndDiscountDetail(ActionClick actionClick) {
    return GestureDetector(
      onTap: () {
        actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_SELECTION));
      },
      child: Container(
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
              R.string().commonString.carat,
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
          getAmountText(widget.item?.getPricePerCarat() ?? ""),
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
          getAmountText(widget.item?.getAmount() ?? ""),
        ],
      ),
    );
  }

  getWatchListDetail() {
    List<String> backPerList = widget.item.getWatchlistPer();
    return widget.item.isAddToWatchList
        ? Padding(
            padding: EdgeInsets.only(top: getSize(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getText(R.string().screenTitle.todayDiscPer),
                getText((widget.item.back ?? "").toString() + "%"),
                getText(R.string().screenTitle.expDiscPer),
                _offsetPopup(widget.item, backPerList),
              ],
            ),
          )
        : Container();
  }

  Widget _offsetPopup(DiamondModel model, List<String> backPerList) =>
      PopupMenuButton<String>(
        shape: TooltipShapeBorder(arrowArc: 0.5),
        itemBuilder: (context) => [
          for (var item in backPerList) getPopupItems(item, model),
          PopupMenuItem(
            height: getSize(30),
            value: "Start",
            child: SizedBox(),
          ),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: getSize(1), horizontal: getSize(10)),
          decoration: BoxDecoration(
              border: Border.all(color: appTheme.dividerColor),
              borderRadius: BorderRadius.circular(getSize(5))),
          child: Row(
            children: <Widget>[
              getText(model.getSelectedBackPer()),
              SizedBox(
                height: getSize(5),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: getSize(20),
              ),
            ],
          ),
        ),
        offset: Offset(25, 110),
      );

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(12)),
    );
  }
}

getText(String text) {
  return Text(
    text,
    style: appTheme.black12TextStyle,
  );
}

getPopupItems(String per, DiamondModel model) {
  return PopupMenuItem(
    value: per,
    height: getSize(20),
    child: GestureDetector(
      onTap: () {
        model.selectedBackPer = per;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[getText(per + "%")],
      ),
    ),
  );
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 5.0,
    this.arrowWidth = 15.0,
    this.arrowHeight = 30.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.topRight.dx - (x + 2), rect.topRight.dy - (y - 15))
      ..relativeLineTo(-x * r, y * r)
      ..relativeQuadraticBezierTo(x, 0, x, 0)
      ..relativeLineTo(-x * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
