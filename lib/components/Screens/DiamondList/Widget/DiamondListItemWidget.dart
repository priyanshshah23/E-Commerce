import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondOfferInfoWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Widget> leftSwipeList;
  bool isUpdateOffer;

  DiamondItemWidget({
    this.item,
    this.actionClick,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.controller,
    this.list,
    this.moduleType,
    this.leftSwipeList,
    this.groupDiamondCalculation,
    this.isUpdateOffer = false,
  });

  @override
  _DiamondItemWidgetState createState() => _DiamondItemWidgetState();
}

class _DiamondItemWidgetState extends State<DiamondItemWidget> {
  final TextEditingController _offeredDiscountTextFieldController =
      TextEditingController();
  final TextEditingController _offeredPricePerCaratTextfieldContoller =
      TextEditingController();
  var _focusOfferedDisc = FocusNode();
  var _focusOfferedPricePerCarat = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.item.setBidAmount();

    if (widget.item.isAddToOffer ?? false || widget.item.isAddToBid ?? false) {
      RxBus.register<bool>(tag: eventBusDropDown).listen((event) {
//        Future.delayed(Duration(seconds: 1));
        setState(() {});
      });

      _offeredDiscountTextFieldController.text = PriceUtilities.getDoubleValue(
          widget.isUpdateOffer
              ? widget.item.newDiscount
              : widget.item.getFinalDiscount());
      _offeredPricePerCaratTextfieldContoller.text =
          PriceUtilities.getDoubleValue(widget.isUpdateOffer
              ? widget.item.newAmount
              : widget.item.getFinalRate());
      widget.item.offeredDiscount = PriceUtilities.getDoubleValue(
          num.parse(_offeredDiscountTextFieldController.text));
      widget.item.offeredAmount =
          num.parse(_offeredPricePerCaratTextfieldContoller.text);
      widget.item.offeredPricePerCarat = PriceUtilities.getDoubleValue(
          num.parse(_offeredPricePerCaratTextfieldContoller.text) *
              widget.item.crt);
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
            isNullEmptyOrFalse(widget.item.displayTitle) == false
                ? Padding(
                    padding:
                        EdgeInsets.only(top: getSize(8.0), bottom: getSize(16)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.item.isGroupSelected =
                              !widget.item.isGroupSelected;
                          Map<String, dynamic> map = {};
                          map["diamondModel"] = widget.item;
                          map["isSelected"] = widget.item.isGroupSelected;
                          RxBus.post(map, tag: eventSelectAllGroupDiamonds);
                        });
                      },
                      child: Row(children: [
                        widget.moduleType !=
                                DiamondModuleConstant.MODULE_TYPE_MY_OFFICE
                            ? Text(
                                widget.item.displayTitle,
                                style: appTheme.black16MediumTextStyle.copyWith(
                                  fontSize: getFontSize(14),
                                ),
                              )
                            : SizedBox(),
                        Spacer(),
                        Text(
                          "Date : " + widget.item.displayDesc,
                          style: appTheme.black16MediumTextStyle.copyWith(
                            fontSize: getFontSize(14),
                          ),
                        ),
                        SizedBox(width: getSize(8.0)),
                        // Text(
                        //   "Select All",
                        //   style: appTheme.black16MediumTextStyle.copyWith(
                        //     fontSize: getFontSize(14),
                        //   ),
                        // ),
                        // SizedBox(width: getSize(8.0)),
                        Image.asset(
                          widget.item.isGroupSelected
                              ? selectedCheckbox
                              : unSelectedCheckbox,
                          width: getSize(16),
                          height: getSize(16),
                        )
                      ]),
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
                top: widget.item.isGrouping
                    ? getSize(2)
                    : getSize(widget.item.marginTop),
              ),
              decoration:
                  (widget.item.isSectionOfferDisplay || widget.item.isGrouping)
                      ? BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: widget.item.isSectionOfferDisplay
                              ? BorderRadius.all(
                                  Radius.circular(5),
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                                color: appTheme.colorPrimary.withOpacity(0.2),
                                blurRadius: getSize(15),
                                // spreadRadius: getSize(5),
                                offset: Offset(0, 7)),
                          ],
                        )
                      : null,
              child: Column(
                children: [
                  Container(
                    child: CustomPaint(
                      painter: getPaintingType(context, widget.item.borderType),
                      child: Slidable(
                        controller: widget.controller,
                        key: Key(widget.item.id),
                        actionPane: SlidableDrawerActionPane(),
                        actions: widget.leftSwipeList == null
                            ? []
                            : widget.leftSwipeList,
                        secondaryActions:
                            widget.list == null ? [] : widget.list,
                        actionExtentRatio: 0.2,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: (widget.item.isMatchPair &&
                                    (widget.item.borderType ==
                                            BorderConstant.BORDER_LEFT_RIGHT ||
                                        widget.item.borderType ==
                                            BorderConstant.BORDER_TOP))
                                ? getSize(1)
                                : (widget.item.isAddToWatchList)
                                    ? getSize(2)
                                    : widget.item.isGrouping ||
                                            widget.item.isAddToOffer
                                        ? 0
                                        : getSize(5),
                            top: ((widget.item.isMatchPair &&
                                    (widget.item.borderType ==
                                            BorderConstant.BORDER_LEFT_RIGHT ||
                                        widget.item.borderType ==
                                            BorderConstant.BORDER_BOTTOM))
                                ? getSize(1)
                                : widget.item.isGrouping
                                    ? 0
                                    : getSize(5)),
                            left: getSize(
                                widget.item.isMatchPair ? getSize(5) : 0),
                            right: getSize(
                                widget.item.isMatchPair ? getSize(5) : 0),
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
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  children: <Widget>[
                                    getCaratAndDiscountDetail(
                                        widget.actionClick),
                                    //   getIdColorDetail(),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: getSize(10),
                                            right: getSize(10),
                                            top: getSize(8),
                                            bottom: getSize(8)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            getIdShapeDetail(),
                                            getDymentionAndCaratDetail(),
                                            getMeasurementAndColorDetails(),
                                            getTableDepthAndAmountDetail(),
                                            // getWatchlistData(),
                                            getOfferData(),
                                            // getBidDetail(),
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
                                                bottomLeft:
                                                    Radius.circular(5))),
                                        height: getSize(26),
                                        width: getSize(4),
                                        // color: Colors.red,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isNullEmptyOrFalse(
                                  widget.groupDiamondCalculation))
                                Padding(
                                  padding: EdgeInsets.only(top: getSize(8)),
                                  child: Row(
                                    children: <Widget>[
                                      getColumn(
                                          widget.groupDiamondCalculation.pcs,
                                          R.string().commonString.pcs,
                                          1),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalCarat,
                                          R.string().commonString.cts,
                                          2),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalDisc,
                                          R.string().commonString.disc,
                                          2),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalPriceCrt,
                                          R.string().commonString.avgPriceCrt +
                                              R.string().commonString.doller,
                                          3),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalAmount,
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
                  if (widget.item.isSectionOfferDisplay)
                    DiamondOfferInfoWidget(
                      widget.item,
                      widget.moduleType,
                    ),
                ],
              ),
            ),
            if (widget.item.isSectionOfferDisplay)
              SizedBox(
                height: getSize(20),
              ),
            // getWatchListDetail(),
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
            EdgeInsets.symmetric(vertical: getSize(15), horizontal: getSize(0)),
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
            SizedBox(height: getSize(4)),
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
            widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: getSize(30)),
                    width: getSize(55),
                    height: getSize(20),
                    decoration: BoxDecoration(
                        color: appTheme.whiteColor,
                        borderRadius: BorderRadius.circular(getSize(5))),
                    child: Text(
                      PriceUtilities.getPercent(widget.item.newDiscount),
                      style: appTheme.green10TextStyle,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  getIdShapeDetail() {
    return Padding(
      padding: EdgeInsets.only(bottom: getSize(4)),
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getText(
              widget.item?.vStnId ?? "", appTheme.blackNormal14TitleColorblack),
          Expanded(child: Container()),
          getText(
              widget.item?.shpNm ?? "", appTheme.blackMedium14TitleColorblack),
          Expanded(child: Container()),
          getAmountText(widget.item?.getPricePerCarat() ?? ""),
        ],
      ),
    );
  }

  getDymentionAndCaratDetail() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(4), bottom: getSize(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText(widget.item?.colNm ?? "",
                appTheme.blackMedium14TitleColorblack),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText(widget.item?.clrNm ?? "",
                appTheme.blackMedium14TitleColorblack),
          ),
          Row(
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
          getAmountText(widget.item?.getAmount() ?? ""),
        ],
      ),
    );
  }

  getMeasurementAndColorDetails() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(4), bottom: getSize(4)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: getText(
                widget.item?.lbNm ?? "", appTheme.blackMedium12TitleColorblack),
          ),
          Expanded(
            flex: 3,
            child: getTextWithLabel(widget.item?.shdNm ?? "", "S : "),
          ),
          // getText(widget.item?.msrmnt ?? ""),
          Expanded(
            flex: 5,
            child: getTextWithLabel(widget.item?.msrmnt ?? "", "M : ",
                align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  getTableDepthAndAmountDetail() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: getText(widget.item?.fluNm ?? "",
                appTheme.blackMedium12TitleColorblack),
          ),
          Expanded(
            flex: 2,
            child: getTextWithLabel(widget.item?.mlk ?? "-", "M : "),
          ),
          // PriceUtilities.getPercent(widget.item?.depPer ?? 0)
          Expanded(
            flex: 3,
            child: getTextWithLabel(
                PriceUtilities.getPercentWithoutPercentSign(
                    widget.item?.depPer ?? 0),
                "D : "),
          ),
          Expanded(
            flex: 3,
            child: getTextWithLabel(
                PriceUtilities.getPercentWithoutPercentSign(
                    widget.item?.tblPer ?? 0),
                "T : "),
          ),
          // getAmountText(widget.item?.getAmount() ?? ""),
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
                        PriceUtilities.getPrice(widget.item.newAmount) + "/Ct",
                        style: appTheme.black16MediumTextStyle.copyWith(
                          fontSize: getFontSize(14),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "|",
                      style: appTheme.primary16TextStyle.copyWith(
                        fontSize: getFontSize(14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        PriceUtilities.getPrice(widget.item.newPricePerCarat) +
                            "/Amt",
                        style: appTheme.black16MediumTextStyle.copyWith(
                          fontSize: getFontSize(14),
                        ),
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
                    getText(R.string().screenTitle.finalOffer + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(widget.item.getFinalOffer().toString(),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string().screenTitle.finalDisc + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPercent(
                            widget.item.getFinalDiscount()),
                        appTheme.blackNormal12TitleColorblack),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.finalRate + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(PriceUtilities.getPrice(widget.item.getFinalRate()),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string().screenTitle.finalValue + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalAmount()),
                        appTheme.blackNormal12TitleColorblack),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  getOfferValues() {
    var offeredAmt = 0.0;
    if (widget.item.isAddToOffer) {
      offeredAmt =
          num.parse(_offeredPricePerCaratTextfieldContoller.text ?? "0") *
              widget.item.crt;
    }
    return widget.item.isAddToOffer
        ? Padding(
            padding: EdgeInsets.only(bottom: getSize(8)),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(color: appTheme.dividerColor),
                  ),
                  height: getSize(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: getSize(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  color: appTheme.borderColor,
                                  child: Center(
                                    child: getText(
                                        R.string().screenTitle.offeredDisc +
                                            " :",
                                        appTheme.blackNormal12TitleColorblack),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Center(
                                  child: getOfferedDiscountTextField(),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: getSize(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  color: appTheme.borderColor,
                                  child: Center(
                                    child: getText(
                                        R.string().screenTitle.offeredPriceCt +
                                            " :",
                                        appTheme.blackNormal12TitleColorblack),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: getOfferedPricePerCaratTextField(),
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
                Container(
                    color: appTheme.lightColorPrimary,
                    height: getSize(40),
                    child: Center(
                        child: RichText(
                      text: TextSpan(
                        text: 'Offered Amt :    ',
                        style: appTheme.primary16TextStyle.copyWith(
                          fontSize: getFontSize(14),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: PriceUtilities.getPrice(offeredAmt),
                            style: appTheme.primary16TextStyle,
                          ),
                        ],
                      ),
                    )))
              ],
            ),
          )
        : SizedBox();
  }

  getOfferedDiscountTextField() {
    return Focus(
      onFocusChange: (hasfocus) {
        if (hasfocus == false) {
          print("Focus off");
          var discount =
              -(num.parse(_offeredDiscountTextFieldController.text).abs());
          if (isNullEmptyOrFalse(_offeredDiscountTextFieldController.text)) {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalDiscount());
            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalRate());
          } else if (discount > (widget.item.back - minOfferedDiscount)) {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalDiscount());
            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalRate());
            showToast(
              "Cannot allow discount less than ${PriceUtilities.getDoubleValue(widget.item.back - minOfferedDiscount)}",
              context: context,
            );
          } else if (maxOfferedDiscount > discount) {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalDiscount());
            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalRate());
            showToast(
              "Cannot allow discount greater than ${PriceUtilities.getDoubleValue(maxOfferedDiscount)}",
              context: context,
            );
          } else {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(discount);

            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.rap -
                    ((widget.item.rap *
                            num.parse(_offeredDiscountTextFieldController.text)
                                .abs()) /
                        100));
            widget.item.offeredDiscount = PriceUtilities.getDoubleValue(
                num.parse(_offeredDiscountTextFieldController.text));
            widget.item.offeredAmount =
                num.parse(_offeredPricePerCaratTextfieldContoller.text);
            widget.item.offeredPricePerCarat = PriceUtilities.getDoubleValue(
                num.parse(_offeredPricePerCaratTextfieldContoller.text) *
                    widget.item.crt);
          }
        }
      },
      child: TextField(
        textAlign: TextAlign.center,
        focusNode: _focusOfferedDisc,
        controller: _offeredDiscountTextFieldController,
        inputFormatters: [
          // old regx = r'(^[+-]?\d*.?\d{0,2})$'
          TextInputFormatter.withFunction((oldValue, newValue) =>
              // RegExp(r'(^[+-]?[0-9]+\d*.?\d{0,2})$').hasMatch(newValue.text)
              //     ? newValue
              //     : oldValue)

              // new regx = ^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$
              RegExp(r'^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$')
                      .hasMatch(newValue.text)
                  ? newValue
                  : oldValue)
        ],
        style: appTheme.blackNormal14TitleColorblack.copyWith(
          color: appTheme.colorPrimary,
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }

  getOfferedPricePerCaratTextField() {
    return Focus(
      onFocusChange: (hasfocus) {
        if (hasfocus == false) {
          print("Focus off");
          var discount = ((widget.item.rap -
                      num.parse(_offeredPricePerCaratTextfieldContoller.text)) /
                  widget.item.rap) *
              100;
          print(discount);
          if (isNullEmptyOrFalse(
              _offeredPricePerCaratTextfieldContoller.text)) {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalDiscount());
            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalRate());
          } else if (-discount > (widget.item.back - minOfferedDiscount)) {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalDiscount());
            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalRate());
            showToast(
              "Cannot allow discount less than ${PriceUtilities.getDoubleValue(widget.item.back - minOfferedDiscount)}",
              context: context,
            );
          } else if (maxOfferedDiscount > -discount) {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalDiscount());
            _offeredPricePerCaratTextfieldContoller.text =
                PriceUtilities.getDoubleValue(widget.item.getFinalRate());
            showToast(
              "Cannot allow discount greater than ${PriceUtilities.getDoubleValue(maxOfferedDiscount)}",
              context: context,
            );
          } else {
            _offeredDiscountTextFieldController.text =
                PriceUtilities.getDoubleValue(-discount);
            widget.item.offeredDiscount =
                _offeredDiscountTextFieldController.text;
            widget.item.offeredAmount =
                num.parse(_offeredPricePerCaratTextfieldContoller.text);
            widget.item.offeredPricePerCarat = PriceUtilities.getDoubleValue(
                num.parse(_offeredPricePerCaratTextfieldContoller.text) *
                    widget.item.crt);
          }
        }
      },
      child: TextField(
        textAlign: TextAlign.center,
        focusNode: _focusOfferedPricePerCarat,
        controller: _offeredPricePerCaratTextfieldContoller,
        inputFormatters: [
          // old regx = r'(^[+-]?\d*.?\d{0,2})$'
          TextInputFormatter.withFunction((oldValue, newValue) =>
              // RegExp(r'(^[+-]?[0-9]+\d*.?\d{0,2})$').hasMatch(newValue.text)
              //     ? newValue
              //     : oldValue)

              // new regx = ^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$
              RegExp(r'^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$')
                      .hasMatch(newValue.text)
                  ? newValue
                  : oldValue)
        ],
        style: appTheme.blackNormal14TitleColorblack.copyWith(
          color: appTheme.colorPrimary,
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
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
                    getText(R.string().screenTitle.bidDisc + "(%) :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPercent(
                            widget.item.getFinalDiscount()),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string().screenTitle.bidValue + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalAmount()),
                        appTheme.blackNormal12TitleColorblack),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.finalRate + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(widget.item.getBidFinalRate()),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string().screenTitle.finalValue + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(
                            widget.item.getBidFinalAmount()),
                        appTheme.blackNormal12TitleColorblack),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string().screenTitle.bidPricePerCt + " :",
                        appTheme.blackNormal12TitleColorblack),
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
                          child: getText(
                              PriceUtilities.getPrice(
                                  widget.item.getFinalRate()),
                              appTheme.blackNormal12TitleColorblack),
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
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(14)),
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

getText(String text, TextStyle style) {
  return Text(
    text,
    style: style,
  );
}

getPrimaryText(String text) {
  return Text(
    text,
    style: appTheme.black16MediumTextStyle.copyWith(
      fontSize: getFontSize(14),
    ),
  );
}

getPopupItems(String per, {bool isPer = false}) {
  return PopupMenuItem(
    value: per,
    height: getSize(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getText(per + (isPer ? "%" : ""), appTheme.blackNormal12TitleColorblack)
      ],
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

getTextWithLabel(String text, String label,
    {TextAlign align = TextAlign.left, MainAxisAlignment aligmentOfRow}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: aligmentOfRow ?? MainAxisAlignment.end,
    children: [
      Text(label,
          textAlign: align,
          style: appTheme.dividerColorNormal12Title.copyWith(
              fontWeight: FontWeight.bold,
              color: appTheme.textColor.withOpacity(0.3))),
      Text(
        text,
        style: appTheme.black12TextStyle,
      ),
    ],
  );
}
