import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

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
    if (widget.item.isAddToOffer ?? false) {
      RxBus.register<bool>(tag: eventBusDropDown).listen((event) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_ROW));
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: getSize(Spacing.leftPadding),
          right: getSize(Spacing.rightPadding),
        ),
        child: Container(
          decoration: getBoxDecorationType(context, widget.item.borderType),
          margin: EdgeInsets.only(
            bottom: getSize(widget.item.marginBottom),
            top: getSize(widget.item.marginTop),
          ),
          child: Container(
            margin: EdgeInsets.only(
              bottom: getSize(widget.item.isMatchPair &&
                      (widget.item.borderType ==
                              BorderConstant.BORDER_LEFT_RIGHT ||
                          widget.item.borderType == BorderConstant.BORDER_TOP)
                  ? 1
                  : 5),
              top: getSize(widget.item.isMatchPair &&
                      (widget.item.borderType ==
                              BorderConstant.BORDER_LEFT_RIGHT ||
                          widget.item.borderType ==
                              BorderConstant.BORDER_BOTTOM)
                  ? 1
                  : 5),
              left: getSize(widget.item.isMatchPair ? 5 : 0),
              right: getSize(widget.item.isMatchPair ? 5 : 0),
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
            child: Wrap(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      getCaratAndDiscountDetail(widget.actionClick),
                      //   getIdColorDetail(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: getSize(10),
                              right: getSize(10),
                              top: getSize(8),
                              bottom: getSize(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              getIdShapeDetail(),
                              getDymentionAndCaratDetail(),
                              getTableDepthAndAmountDetail(),
                              getWatchListDetail(),
                              getOfferDetail(),
                              getBidDetail(),
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
                ),
              ],
            ),
          ),
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
          bottom: getSize(8),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              PriceUtilities.getDoubleValue(widget.item?.crt ?? 0),
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
            ),
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
    DropDownItem item = DropDownItem(widget.item, DropDownItem.BACK_PER);
    return widget.item.isAddToWatchList
        ? Padding(
            padding: EdgeInsets.only(top: getSize(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getText(R.string().screenTitle.todayDiscPer + " :"),
                getText(PriceUtilities.getPercent(widget.item?.back) ?? ""),
                getText(R.string().screenTitle.expDiscPer + " :"),
                popupList(widget.item, backPerList, item, (selectedValue) {
                  widget.item.selectedBackPer = selectedValue;
                  RxBus.post(true, tag: eventBusDropDown);
                }, isPer: true),
              ],
            ),
          )
        : Container();
  }

  getOfferDetail() {
    List<String> offerPer = widget.item.getOfferPer();
    List<String> offerHour = widget.item.getOfferHour();
    DropDownItem itemOffer = DropDownItem(widget.item, DropDownItem.QUOTE);
    DropDownItem itemHour = DropDownItem(widget.item, DropDownItem.HOURS);
    return widget.item.isAddToOffer
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.finalOffer + " :"),
                    getText(widget.item.getFinalOffer().toString()),
                    getText(R.string().screenTitle.finalDisc + " :"),
                    getText(PriceUtilities.getPercent(
                        widget.item.getFinalDiscount())),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.finalRate + " :"),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalRate())),
                    getText(R.string().screenTitle.finalValue + " :"),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalAmount())),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.offer + " :"),
                    popupList(widget.item, offerPer, itemOffer,
                        (selectedValue) {
                      widget.item.selectedOfferPer = selectedValue;
                      RxBus.post(true, tag: eventBusDropDown);
                    }),
                    getText(R.string().screenTitle.hours + " :"),
                    popupList(widget.item, offerHour, itemHour,
                        (selectedValue) {
                      widget.item.selectedOfferHour = selectedValue;
                      RxBus.post(true, tag: eventBusDropDown);
                    }),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  getBidDetail() {
    return widget.item.isAddToBid
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.bidDisc + "(%) :"),
                    getText(widget.item.getFinalOffer().toString()),
                    getText(R.string().screenTitle.bidValue + " :"),
                    getText(PriceUtilities.getPercent(
                        widget.item.getFinalDiscount())),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.finalRate + " :"),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalRate())),
                    getText(R.string().screenTitle.finalValue + " :"),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalAmount())),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.bidPricePerCt + " :"),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: getSize(10)),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(
                                getSize(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Image.asset(
                                  minusIcon,
                                  width: getSize(16),
                                  height: getSize(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: getSize(5), horizontal: getSize(10)),
                          decoration: BoxDecoration(
                              border: Border.all(color: appTheme.dividerColor),
                              borderRadius: BorderRadius.circular(getSize(5))),
                          child: getText(PriceUtilities.getPrice(
                              widget.item.getFinalAmount())),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(left: getSize(10)),
                            decoration: BoxDecoration(
                              color: appTheme.colorPrimary,
                              borderRadius: BorderRadius.circular(
                                getSize(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Image.asset(
                                  plusIcon,
                                  width: getSize(16),
                                  height: getSize(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Widget popupList(DiamondModel model, List<String> backPerList,
          DropDownItem dropDownItem, Function(String) selectedValue,
          {bool isPer = false}) =>
      PopupMenuButton<String>(
        shape: TooltipShapeBorder(arrowArc: 0.5),
        onSelected: (newValue) {
          // add this property
          selectedValue(newValue);
        },
        itemBuilder: (context) => [
          for (var item in backPerList)
            getPopupItems(item, model, isPer: isPer),
          PopupMenuItem(
            height: getSize(30),
            value: "Start",
            child: SizedBox(),
          ),
        ],
        child: dropDownItem,
        offset: Offset(25, 110),
      );

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(12)),
    );
  }
}

class DropDownItem extends StatefulWidget {
  DiamondModel model;
  static const BACK_PER = 1;
  static const QUOTE = 2;
  static const HOURS = 3;

  int type = BACK_PER;

  DropDownItem(this.model, this.type);

  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: getSize(1), horizontal: getSize(10)),
      decoration: BoxDecoration(
          border: Border.all(color: appTheme.dividerColor),
          borderRadius: BorderRadius.circular(getSize(5))),
      child: Row(
        children: <Widget>[
          getText(widget.model.getSelectedDetail(widget.type)),
          SizedBox(
            height: getSize(5),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: getSize(20),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    /*onclick = () {
      setState(() {});
    };*/
    RxBus.register<bool>(tag: eventBusDropDown).listen((event) {
      setState(() {});
    });
  }
}

getText(String text) {
  return Text(
    text,
    style: appTheme.black12TextStyle,
  );
}

getPopupItems(String per, DiamondModel model, {bool isPer = false}) {
  return PopupMenuItem(
    value: per,
    height: getSize(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[getText(per + (isPer ? "%" : ""))],
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
