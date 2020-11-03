import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rxbus/rxbus.dart';

class DiamondItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;
  num leftPadding;
  num rightPadding;
  SlidableController controller;
  List<Widget> list;
  DiamondCalculation groupDiamondCalculation;
  int moduleType;

  DiamondItemWidget({
    this.item,
    this.actionClick,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.controller,
    this.list,
    this.moduleType,
    this.groupDiamondCalculation,
  });

  @override
  _DiamondItemWidgetState createState() => _DiamondItemWidgetState();
}

class _DiamondItemWidgetState extends State<DiamondItemWidget> {
  @override
  void initState() {
    super.initState();
    widget.item.setBidAmount();
    if (widget.item.isAddToOffer ?? false || widget.item.isAddToBid ?? false) {
      RxBus.register<bool>(tag: eventBusDropDown).listen((event) {
//        Future.delayed(Duration(seconds: 1));
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_ROW));
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: getSize(widget.leftPadding != 0
              ? widget.leftPadding
              : Spacing.leftPadding),
          right: getSize(widget.rightPadding != 0
              ? widget.leftPadding
              : Spacing.rightPadding),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.item.displayTitle != null
                ? Padding(
                    padding:
                        EdgeInsets.only(top: getSize(4.0), bottom: getSize(4)),
                    child: Text(
                      widget.item.displayTitle,
                      style: appTheme.primaryColor14TextStyle,
                    ),
                  )
                : Container(),
            /* Container(
              decoration: getBoxDecorationType(context, widget.item.borderType),
              margin: EdgeInsets.only(
                bottom: getSize(widget.item.marginBottom),
                top: getSize(widget.item.marginTop),
              ),
              child: */
            Container(
              margin: EdgeInsets.only(
                bottom: getSize(widget.item.marginBottom),
                top: getSize(widget.item.marginTop),
              ),
              child: CustomPaint(
                painter: getPaintingType(context, widget.item.borderType),
                child: Slidable(
                  controller: widget.controller,
                  key: Key(widget.item.id),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: widget.list == null ? [] : widget.list,
                  actionExtentRatio: 0.2,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: getSize(
                        widget.item.isMatchPair &&
                                (widget.item.borderType ==
                                        BorderConstant.BORDER_LEFT_RIGHT ||
                                    widget.item.borderType ==
                                        BorderConstant.BORDER_TOP)
                            ? getSize(1)
                            : (widget.item.isAddToWatchList ||
                                    widget.item.isAddToOffer)
                                ? getSize(2)
                                : getSize(5),
                      ),
                      top: getSize(widget.item.isMatchPair &&
                              (widget.item.borderType ==
                                      BorderConstant.BORDER_LEFT_RIGHT ||
                                  widget.item.borderType ==
                                      BorderConstant.BORDER_BOTTOM)
                          ? getSize(1)
                          : getSize(5)),
                      left: getSize(widget.item.isMatchPair ? getSize(5) : 0),
                      right: getSize(widget.item.isMatchPair ? getSize(5) : 0),
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
                                : appTheme.dividerColor.withOpacity(0.5))
                        //boxShadow: getBoxShadow(context),
                        ),
                    child: Column(
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
                                      getWatchlistData(),
                                      getOfferData(),
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
                        if (!isNullEmptyOrFalse(widget.groupDiamondCalculation))
                          Padding(
                            padding: EdgeInsets.only(top: getSize(8)),
                            child: Row(
                              children: <Widget>[
                                getColumn(widget.groupDiamondCalculation.pcs,
                                    R.string().commonString.pcs, 1),
                                getColumn(
                                    widget.groupDiamondCalculation.totalCarat,
                                    R.string().commonString.cts,
                                    2),
                                getColumn(
                                    widget.groupDiamondCalculation.totalDisc,
                                    R.string().commonString.disc,
                                    2),
                                getColumn(
                                    widget
                                        .groupDiamondCalculation.totalPriceCrt,
                                    R.string().commonString.avgPriceCrt +
                                        R.string().commonString.doller,
                                    3),
                                getColumn(
                                    widget.groupDiamondCalculation.totalAmount,
                                    R.string().commonString.amount +
                                        R.string().commonString.doller,
                                    3)
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            getWatchListDetail(),
            getOfferValues(),
            // ),
          ],
        ),
      ),
    );
  }

  getColumn(String text, String lable, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(5)),
          border: Border.all(color: appTheme.textGreyColor),
        ),
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
      ),
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
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: appTheme.black16TextStyle.copyWith(fontSize: getFontSize(10)),
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
          left: getSize(8),
          right: getSize(8),
          bottom: getSize(8),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSize(5)),
            bottomLeft: Radius.circular(getSize(5)),
          ),
          color: widget.item.isSelected
              ? appTheme.colorPrimary
              : appTheme.dividerColor.withOpacity(0.5),
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
                PriceUtilities.getPercent(widget.item.isAddToBid
                        ? widget.item.getbidFinalDiscount()
                        : widget.item?.getFinalDiscount()) ??
                    "",
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

  //Watch list
  getWatchlistData() {
    return widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST
        ? Padding(
            padding: EdgeInsets.only(top: getSize(8.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(color: appTheme.lightColorPrimary),
                color: appTheme.lightColorPrimary,
              ),
              height: getSize(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        R.string().screenTitle.expDiscPer +
                            " : " +
                            "${widget.item.newDiscount}%",
                        style: appTheme.black12TextStyleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  getWatchListDetail() {
    List<String> backPerList = widget.item.getWatchlistPer();
    DropDownItem item = DropDownItem(widget.item, DropDownItem.BACK_PER);
    return widget.item.isAddToWatchList
        ? Padding(
            padding: EdgeInsets.only(bottom: getSize(8.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(color: appTheme.dividerColor),
              ),
              height: getSize(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: appTheme.borderColor,
                      child: Center(
                        child: Text(
                          R.string().screenTitle.expDiscPer + " :",
                          style: appTheme.black12TextStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(1),
                    child: Container(
                      color: appTheme.borderColor,
                      height: getSize(40),
                    ),
                  ),
                  Expanded(
                    child: popupList(widget.item, backPerList, item,
                        (selectedValue) {
                      widget.item.selectedBackPer = selectedValue;
                      RxBus.post(true, tag: eventBusDropDown);
                    }, isPer: true),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  //Offer detail
  getOfferData() {
    return widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER
        ? Padding(
            padding: EdgeInsets.only(top: getSize(8.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(color: appTheme.lightColorPrimary),
                color: appTheme.lightColorPrimary,
              ),
              height: getSize(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        R.string().commonString.offerPricePerCarat +
                            " : " +
                            PriceUtilities.getPrice(widget.item.newAmount),
                        style: appTheme.black12TextStyleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  getOfferDetail() {
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
            ],
          )
        : Container();
  }

  getOfferValues() {
    List<String> offerPer = widget.item.getOfferPer();
    List<String> offerHour = widget.item.getOfferHour();
    DropDownItem itemOffer = DropDownItem(widget.item, DropDownItem.QUOTE);
    DropDownItem itemHour = DropDownItem(widget.item, DropDownItem.HOURS);
    return widget.item.isAddToOffer
        ? Padding(
            padding: EdgeInsets.only(bottom: getSize(8)),
            child: Container(
              height: getSize(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: getSize(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(getSize(5)),
                        border: Border.all(color: appTheme.dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: appTheme.borderColor,
                              child: Center(
                                child: getText(
                                    R.string().screenTitle.offer + " :"),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            child: Center(
                              child: popupList(widget.item, offerPer, itemOffer,
                                  (selectedValue) {
                                widget.item.selectedOfferPer = selectedValue;
                                RxBus.post(true, tag: eventBusDropDown);
                              }),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getSize(16)),
                  Expanded(
                    child: Container(
                      height: getSize(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(getSize(5)),
                        border: Border.all(color: appTheme.dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: appTheme.borderColor,
                              child: Center(
                                child: getText(
                                    R.string().screenTitle.hours + " :"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Center(
                                child:
                                    popupList(widget.item, offerHour, itemHour,
                                        (selectedValue) {
                                  widget.item.selectedOfferHour = selectedValue;
                                  RxBus.post(true, tag: eventBusDropDown);
                                }),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
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
                    getText(PriceUtilities.getPercent(
                        widget.item.getFinalDiscount())),
                    getText(R.string().screenTitle.bidValue + " :"),
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
                    getText(R.string().screenTitle.finalRate + " :"),
                    getText(
                        PriceUtilities.getPrice(widget.item.getBidFinalRate())),
                    getText(R.string().screenTitle.finalValue + " :"),
                    getText(PriceUtilities.getPrice(
                        widget.item.getBidFinalAmount())),
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
                          onTap: () {
                            setState(() {
                              widget.item.bidPlus = false;
                              widget.item.minusAmount = 20;
                              widget.item.ctPr = widget.item.getbidAmount();
                              RxBus.post(false, tag: eventBusDropDown);
                            });
                          },
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
                              widget.item.getFinalRate())),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.item.bidPlus = true;
                              widget.item.plusAmount = 20;
                              widget.item.ctPr = widget.item.getbidAmount();
                              RxBus.post(true, tag: eventBusDropDown);
                            });
                          },
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
          for (var item in backPerList) getPopupItems(item, isPer: isPer),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.model.getSelectedDetail(widget.type),
            style: appTheme.black14TextStyle,
          ),
          SizedBox(
            height: getSize(5),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: getSize(24),
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

getPrimaryText(String text) {
  return Text(
    text,
    style: appTheme.primary16TextStyle,
  );
}

getPopupItems(String per, {bool isPer = false}) {
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
