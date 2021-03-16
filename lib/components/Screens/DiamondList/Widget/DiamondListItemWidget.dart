import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondOfferInfoWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController _noteController = TextEditingController();
  var _focusNote = FocusNode();
  Duration difference;
  Timer _timer;
  bool isTimerCompleted = false;
  var totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    widget.item.setBidAmount();
    calcualteDifference();
    RxBus.register<bool>(tag: eventBusRefreshItem).listen((event) {
//        Future.delayed(Duration(seconds: 1));

      _noteController.text = widget.item.remarks ?? "";
      setState(() {});
    });

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
    if (widget.item.isNotes) {
      _noteController.text = widget.item.remarks;
    }
  }

  @override
  void didUpdateWidget(covariant DiamondItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.isNoteUpdated ?? false) {
      print('false');
      _noteController.text = widget.item.remarks;
      widget.item.isNoteUpdated = false;
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

                            // ? Text(
                            //     widget.item.displayTitle,
                            //     style: appTheme.black16MediumTextStyle.copyWith(
                            //       fontSize: getFontSize(14),
                            //     ),
                            // )
                            // : SizedBox(),

                            ? Text(
                                (widget.item?.displayDesc ?? ""),
                                style: appTheme.black16MediumTextStyle.copyWith(
                                  fontSize: getFontSize(14),
                                ),
                              )
                            : SizedBox(),
                        Spacer(),
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
                              border: Border.all(color: appTheme.bodercolour)
                              //boxShadow: getBoxShadow(context),
                              ),
                          child: Column(
                            children: [
                              getOfferedBottomSection(),
                              //getofferdetails(),
                              Padding(
                                padding: EdgeInsets.only(top: getSize(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    getCaratDetail(widget.actionClick),
                                    getStoneAndAmountDetails(),
                                    getDiamondImage()
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getSize(14), right: getSize(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    getDiscountDetails(),
                                    getMeasurementDetails(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getSize(11),
                                    right: getSize(10),
                                    top: getSize(10),
                                    bottom: getSize(10)),
                                child: Row(
                                  children: [
                                    getStatusDetails(),
                                    getTableDetails(),
                                  ], //getMeasurementAndColorDetails(),
                                ),
                              ),
                              getBidDetail(),
                              getOfferData(),
                              getWatchlistData()
                            ],
                          ),
                          /*child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  children: <Widget>[
                                    getCaratAndDiscountDetail(
                                        widget.actionClick),
                                    // getIdColorDetail(),

                                    Expanded(
                                      child: Container(
                                        // height: getSize(120),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: getSize(8),
                                              right: getSize(8),
                                              top: getSize(8),
                                              bottom: getSize(8)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          getIdShapeDetail(),
                                                          getDymentionAndCaratDetail(),
                                                        ],
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getSize(8)),
                                                      child: getImageView(
                                                        widget.item
                                                            .getDiamondImage(),
                                                        placeHolderImage:
                                                            diamond,
                                                        width: getSize(62),
                                                        height: getSize(62),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              getMeasurementAndColorDetails(),
                                              getTableDepthAndAmountDetail(),
                                              getOfferData(),

                                              // getWatchlistData(),

                                              //
                                              // getBidDetail(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Container(
                                    //   child: Center(
                                    //       child: Container(
                                    //     decoration: BoxDecoration(
                                    //         color: widget.item.getStatusColor(),
                                    //         borderRadius: BorderRadius.only(
                                    //             topLeft: Radius.circular(5),
                                    //             bottomLeft:
                                    //                 Radius.circular(5))),
                                    //     height: getSize(26),
                                    //     width: getSize(4),
                                    //     // color: Colors.red,
                                    //   )),
                                    // ),
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
                                          R.string.commonString.pcs,
                                          1),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalCarat,
                                          R.string.commonString.cts,
                                          2),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalDisc,
                                          R.string.commonString.disc,
                                          2),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalPriceCrt,
                                          R.string.commonString.avgPriceCrt +
                                              dollar,
                                          3),
                                      getColumn(
                                          widget.groupDiamondCalculation
                                              .totalAmount,
                                          R.string.commonString.amount + dollar,
                                          3)
                                    ],
                                  ),
                                ),
                              getOfferedBottomSection(),
                            ],
                          ),*/
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
            getWatchListDetail(),
            getNotesDetail(),
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

  getCaratDetail(ActionClick actionClick) {
    return GestureDetector(
      onTap: () {
        actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_SELECTION));
      },
      child: Container(
        padding: EdgeInsets.only(
          left: getSize(8),
          right: getSize(8),
          bottom: getSize(8),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSize(5)),
            bottomLeft: Radius.circular(getSize(5)),
          ),
          // color: Colors.red,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: widget.item.isSelected
                              ? appTheme.colorPrimary
                              : appTheme.dividerColor,
                          borderRadius: BorderRadius.circular(getSize(5))),
                      width: getSize(52),
                      height: getSize(62),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            PriceUtilities.getDoubleValue(
                                widget.item?.crt ?? 0),
                            style: appTheme.blue14TextStyle.copyWith(
                                fontSize: getSize(14),
                                color: widget.item.isSelected
                                    ? appTheme.whiteColor
                                    : appTheme.colorPrimary),
                          ),
                          Text(
                            R.string.commonString.carat,
                            style: appTheme.blue14TextStyle.copyWith(
                                fontSize: getSize(10),
                                color: widget.item.isSelected
                                    ? appTheme.whiteColor
                                    : appTheme.colorPrimary),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: getSize(4)),
            // Container(
            //   alignment: Alignment.center,
            //   margin: EdgeInsets.only(top: getSize(5)),
            //   width: getSize(60),
            //   height: getSize(20),
            //   decoration: BoxDecoration(
            //       color: appTheme.whiteColor,
            //       borderRadius: BorderRadius.circular(getSize(5))),
            //   child: Text(
            //     PriceUtilities.getPercent(widget.item.isAddToBid
            //             ? widget.item.getbidFinalDiscount()
            //             : widget.item?.getFinalDiscount()) ??
            //         "",
            //     style: appTheme.green10TextStyle,
            //   ),
            // ),
            // widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER
            //     ? Container(
            //         alignment: Alignment.center,
            //         margin: EdgeInsets.only(top: getSize(30)),
            //         width: getSize(55),
            //         height: getSize(20),
            //         decoration: BoxDecoration(
            //             // color: appTheme.whiteColor,
            //             color: Colors.red,
            //             borderRadius: BorderRadius.circular(getSize(5))),
            //         child: Text(
            //           PriceUtilities.getPercent(widget.item.newDiscount),
            //           style: appTheme.green10TextStyle,
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }

  getStoneAndAmountDetails() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getIdShapeDetail(),
        getShapeAndAmountDetail(),
        getColorAndCutPolishDetail(),
      ],
    ));
  }

  getDiscountDetail() {
    return Container(
      alignment: Alignment.center,
      //margin: EdgeInsets.only(top: getSize(5), left: getSize(14)),
      width: getSize(44),
      height: getSize(16),
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
    );
  }

  // getDiamondList2() {
  //   return Expanded(
  //     flex: 4,
  //     child: Row(
  //       children: <Widget>[
  //         getText(
  //             widget.item?.cutNm ?? "-", appTheme.blackMedium14TitleColorblack),
  //         SizedBox(width: getSize(2.0)),
  //         Container(
  //           height: getSize(4),
  //           width: getSize(4),
  //           decoration: BoxDecoration(
  //               color: appTheme.dividerColor, shape: BoxShape.circle),
  //         ),
  //         SizedBox(width: getSize(2.0)),
  //         getText(
  //             widget.item?.polNm ?? "-", appTheme.blackMedium14TitleColorblack),
  //         SizedBox(width: getSize(2.0)),
  //         Container(
  //           height: getSize(4),
  //           width: getSize(4),
  //           decoration: BoxDecoration(
  //               color: appTheme.dividerColor, shape: BoxShape.circle),
  //         ),
  //         SizedBox(width: getSize(2.0)),
  //         getText(
  //             widget.item?.symNm ?? "-", appTheme.blackMedium14TitleColorblack),
  //       ],
  //     ),
  //   );
  // }

  getDiamondList3() {}

  getIdShapeDetail() {
    return Padding(
      padding: EdgeInsets.only(bottom: getSize(4)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            // flex: 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: getText(
                (widget.item?.vStnId ?? "").replaceAll('null', '--'),
                appTheme.blackNormal14TitleColorblack,
              ),
            ),
          ),
          // Expanded(
          //   flex: 2,
          //   child: FittedBox(
          //     fit: BoxFit.scaleDown,
          //     child: getText(widget.item?.shpNm ?? "",
          //         appTheme.blackMedium14TitleColorblack),
          //   ),
          // ),
          getAmountText(
              (widget.item?.getPricePerCarat() ?? "").replaceAll('null', '--'),
              align: TextAlign.right),
        ],
      ),
    );
  }

  getShapeAndAmountDetail() {
    return Padding(
        padding: EdgeInsets.only(bottom: getSize(4)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            // flex: 2,
            child: getText((widget.item?.shpNm ?? "").replaceAll('null', '--'),
                appTheme.blackMedium14TitleColorblack),
          ),
          getAmountText(
              (widget.item?.getAmount() ?? "-").replaceAll('null', '--'))
        ]));
  }

  getColorAndCutPolishDetail() {
    return Padding(
        padding: EdgeInsets.only(bottom: getSize(4)),
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getText((widget.item?.colNm ?? "").replaceAll('null', '--'),
                  appTheme.blackMedium14TitleColorblack),
              Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: getText(
                        (widget.item?.clrNm ?? "-").replaceAll('null', '--'),
                        appTheme.blackMedium14TitleColorblack),
                  )),
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    getText(
                        (widget.item?.cutNm ?? "-").replaceAll('null', '--'),
                        appTheme.blackMedium14TitleColorblack),
                    SizedBox(width: getSize(2.0)),
                    Container(
                      height: getSize(4),
                      width: getSize(4),
                      decoration: BoxDecoration(
                          color: appTheme.dividerColor, shape: BoxShape.circle),
                    ),
                    SizedBox(width: getSize(2.0)),
                    getText(
                        (widget.item?.polNm ?? "-").replaceAll('null', '--'),
                        appTheme.blackMedium14TitleColorblack),
                    SizedBox(width: getSize(2.0)),
                    Container(
                      height: getSize(4),
                      width: getSize(4),
                      decoration: BoxDecoration(
                          color: appTheme.dividerColor, shape: BoxShape.circle),
                    ),
                    SizedBox(width: getSize(2.0)),
                    getText(
                        (widget.item?.symNm ?? "-").replaceAll('null', '--'),
                        appTheme.blackMedium14TitleColorblack),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: getText(
                      (widget.item?.lbNm ?? "").replaceAll('null', '--'),
                      appTheme.blackMedium12TitleColorblack),
                ),
              ),
            ]));
  }

  /*getSecondRow() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(10), right: getSize(10)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: getText(widget.item?.colNm ?? "-",
                appTheme.blackMedium14TitleColorblack),
          ),
          Expanded(
            flex: 3,
            child: getText(widget.item?.clrNm ?? "-",
                appTheme.blackMedium14TitleColorblack),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                getText(widget.item?.cutNm ?? "-",
                    appTheme.blackMedium14TitleColorblack),
                SizedBox(width: getSize(2.0)),
                Container(
                  height: getSize(4),
                  width: getSize(4),
                  decoration: BoxDecoration(
                      color: appTheme.dividerColor, shape: BoxShape.circle),
                ),
                SizedBox(width: getSize(2.0)),
                getText(widget.item?.polNm ?? "-",
                    appTheme.blackMedium14TitleColorblack),
                SizedBox(width: getSize(2.0)),
                Container(
                  height: getSize(4),
                  width: getSize(4),
                  decoration: BoxDecoration(
                      color: appTheme.dividerColor, shape: BoxShape.circle),
                ),
                SizedBox(width: getSize(2.0)),
                getText(widget.item?.symNm ?? "-",
                    appTheme.blackMedium14TitleColorblack),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: getText(
                widget.item?.lbNm ?? "", appTheme.blackMedium12TitleColorblack),
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
  }*/

  getDiamondImage() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getSize(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(getSize(8)),
        child: getImageView(
          widget.item.getDiamondImage(),
          placeHolderImage: diamond,
          width: getSize(62),
          height: getSize(62),
          fit: BoxFit.cover,
        ),
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
            child: getText(
              (widget.item?.getColorName() ?? "-").replaceAll('null', '--'),
              appTheme.blackMedium14TitleColorblack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: getSize(10),
            ),
            child: getText((widget.item?.clrNm ?? "-").replaceAll('null', '--'),
                appTheme.blackMedium14TitleColorblack),
          ),
          Row(
            children: <Widget>[
              getText(
                (widget.item?.cutNm ?? "-").replaceAll('null', '--'),
                appTheme.blackMedium14TitleColorblack,
              ),
              SizedBox(width: getSize(2.0)),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              SizedBox(width: getSize(2.0)),
              getText((widget.item?.polNm ?? "-").replaceAll('null', '--'),
                  appTheme.blackMedium14TitleColorblack),
              SizedBox(width: getSize(2.0)),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              SizedBox(width: getSize(2.0)),
              getText((widget.item?.symNm ?? "-").replaceAll('null', '--'),
                  appTheme.blackMedium14TitleColorblack),
            ],
          ),
          //getAmountText(widget.item?.getAmount() ?? "-"),
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
          Container(
            alignment: Alignment.center,
            //margin: EdgeInsets.only(top: getSize(5), left: getSize(14)),

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
          Expanded(
            child: getText((widget.item?.lbNm ?? "").replaceAll('null', '--'),
                appTheme.blackMedium12TitleColorblack),
          ),
          Expanded(
            flex: 3,
            child: getTextWithLabel(
                (widget.item?.shdNm ?? "-").replaceAll('null', '--'), "S : "),
          ),
          // getText(widget.item?.msrmnt ?? ""),
          Expanded(
            flex: 4,
            child: getTextWithLabel(
                (widget.item?.msrmnt ?? "-").replaceAll('null', '--'), "M : ",
                align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  getDiscountDetails() {
    return Container(
      margin: EdgeInsets.only(right: getSize(15)),
      alignment: Alignment.center,
      //margin: EdgeInsets.only(top: getSize(5), left: getSize(14)),

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
    );
  }

  getMeasurementDetails() {
    return Expanded(
      child: Container(
        height: getSize(16),
        // padding: EdgeInsets.only(left: getSize(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Align(
              alignment: Alignment.centerLeft,
              child: getTextWithLabel(
                (widget.item?.shdNm ?? "-").replaceAll('null', '--'),
                "S : ",
              ),
            )),
            Expanded(
              flex: 1,
              child: getTextWithLabel(
                  (widget.item?.fluNm ?? "-").replaceAll('null', '--'),
                  "FL : "),
            ),
            // PriceUtilities.getPercent(widget.item?.depPer ?? 0)
            Expanded(
              flex: 2,
              child: getTextWithLabel(
                  (widget.item?.msrmnt ?? "-").replaceAll('null', '--'),
                  "M : "),
            ),
            // getAmountText(widget.item?.getAmount() ?? ""),
          ],
        ),
      ),
    );
  }

  getStatusDetails() {
    return Container(
      margin: EdgeInsets.only(right: getSize(10)),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Container(
            width: getSize(6),
            height: getSize(6),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: widget.item.getStatusColor()),
          ),
          SizedBox(
            width: getSize(2),
          ),
          getText(
              widget.item.getStatusText(),
              appTheme.black12TextStyle
                  .copyWith(color: widget.item.getStatusColor()))
        ],
      ),
    );
    // return Container(
    //   margin: EdgeInsets.only(right: getSize(10)),
    //   alignment: Alignment.center,
    //   child: getText(
    //       widget.item.getStatusText(),
    //       appTheme.black12TextStyle
    //           .copyWith(color: widget.item.getStatusColor())),
    // );
  }

  getTableDetails() {
    return Expanded(
      child: Container(
        height: getSize(16),
        // padding: EdgeInsets.only(left: getSize(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: getTextWithLabel(
                (widget.item?.ratio.toString() ?? "-").replaceAll('null', '--'),
                "R : ",
              ),
            ),
            Flexible(
              flex: 4,
              child: getTextWithLabel(
                  (widget.item?.eClnNm ?? "-").replaceAll('null', '--'),
                  "EC : "),
            ),
            // PriceUtilities.getPercent(widget.item?.depPer ?? 0)
            Flexible(
              flex: 2,
              child: getTextWithLabel(
                  (widget.item?.depPer.toString() ?? "-")
                      .replaceAll('null', '--'),
                  "D% : "),
            ),
            Flexible(
              flex: 2,
              child: getTextWithLabel(
                  (widget.item?.tblPer.toString() ?? "-")
                      .replaceAll('null', '--'),
                  "T% : "),
            ),
            // getAmountText(widget.item?.getAmount() ?? ""),
          ],
        ),
      ),
    );
  }

  //getRowThreeDetails() {
  // return Expanded(
  //   child: Container(
  //     height: getSize(16),
  //     // padding: EdgeInsets.only(left: getSize(16)),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Expanded(
  //             flex: 1,
  //             child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: getTextWithLabel(
  //                 widget.item?.ratio.toString() ?? "-",
  //                 "R : ",
  //               ),
  //             )),
  //         Expanded(
  //           flex: 1,
  //           child: getTextWithLabel(widget.item?.eClnNm ?? "-", "EC : "),
  //         ),
  //         // PriceUtilities.getPercent(widget.item?.depPer ?? 0)
  //         Expanded(
  //           flex: 1,
  //           child: getTextWithLabel(
  //               widget.item?.depPer.toString() ?? "-", "D% : "),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: getTextWithLabel(
  //               widget.item?.tblPer.toString() ?? "-", "T% : "),
  //         ),
  //         // getAmountText(widget.item?.getAmount() ?? ""),
  //       ],
  //     ),
  //   ),
  // );
  //}

  //Watch list
  getNotesDetail() {
    return (widget.item.isNotes ?? false)
        ? Container(
            decoration: BoxDecoration(
                border: Border.all(color: appTheme.dividerColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(getSize(6)),
                )),
            height: getSize(54),
            child: !widget.item.isNoteEditable
                ? Container(
                    decoration: BoxDecoration(
                        color: appTheme.dividerColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(getSize(6)),
                          bottomLeft: Radius.circular(getSize(6)),
                        )),
                    // width: getSize(341),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 11, bottom: 11, top: 9),
                          child: Text(
                            "Note : " + widget.item.remarks,
                            style: appTheme.blackMedium12TitleColorblack,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: appTheme.dividerColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(getSize(6)),
                              bottomLeft: Radius.circular(getSize(6)),
                            )),
                        width: getSize(72),
                        child: Center(
                          child: Text(
                            "Note :",
                            style: appTheme.blackMedium12TitleColorblack,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CommonTextfield(
                          focusNode: _focusNote,
                          readOnly: !widget.item.isNoteEditable,
                          textOption: TextFieldOption(
                            isBorder: false,
                            textAlign: TextAlign.right,
                            // contentPadding: EdgeInsets.symmetric(
                            //   horizontal: getSize(10),
                            // ),

                            hintText: 'Enter Note',
                            maxLine: 2,
                            keyboardType: TextInputType.multiline,
                            fillColor: appTheme.dividerColor,
                            // fillColor: Colors.red,
                            inputController: _noteController,
                            formatter: [
                              //  WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
                              BlacklistingTextInputFormatter(
                                  RegExp(RegexForEmoji))
                            ],
                          ),
                          textCallback: (text) {
                            widget.item.remarks = text;
                          },
                          inputAction: TextInputAction.newline,
                          onNextPress: () {
                            _focusNote.unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
          )
        : Container();
  }

  Widget getDiscountUpOrDown(num disc, num newDisc) {
    bool isUp = false;
    bool isEqual = false;
    num diff = 0;
    if (newDisc < disc) {
      isUp = true;
      diff = newDisc - disc;
    } else if (newDisc > disc) {
      diff = disc - newDisc;
    } else {
      isEqual = true;
    }
    return Expanded(
        child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${(diff).toStringAsFixed(0)}%",
              style: appTheme.black12TextStyleMedium
                  .copyWith(color: isUp ? Colors.green : Colors.red)),
          SizedBox(width: getSize(4)),
          Image.asset(
            !isUp ? upRedArrow : downGreenArrow,
            height: getSize(10),
          )
        ],
      ),
    ));
  }

  getofferdetails() {
    return widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER
        ? Padding(
            padding: EdgeInsets.only(top: getSize(0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(0)),
                border: Border.all(color: appTheme.dividerColor.withOpacity(1)),
                // color: appTheme.dividerColor.withOpacity(0.5),
              ),
              height: getSize(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: getSize(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: getTimingDetails(),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          color:
                              getBidStatusColor(widget?.item?.offerStatus ?? 0)
                                  .withOpacity(0.2),
                          child: Text(
                            getBidStatus(widget?.item?.offerStatus ?? 0),
                            style: appTheme.black12TextStyleMedium.copyWith(
                                color: getBidStatusColor(
                                    widget?.item?.offerStatus ?? 0)),
                          ))
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: getSize(16)),
                        child: Image.asset(
                          editPen1,
                          height: getSize(16),
                          width: getSize(16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          // top: getSize(12),
                          right: getSize(1),
                        ),
                        child: Image.asset(
                          delete_icon_medium,
                          height: getSize(16),
                          width: getSize(16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  getBidStatus(int offerStatus) {
    switch (offerStatus) {
      case DiamondBidStatus.Pending:
        return "Pending";
      case DiamondBidStatus.Accepted:
        return "Accepted";
      case DiamondBidStatus.Rejected:
        return "Rejected";
      default:
        return '';
    }
  }

  getBidStatusColor(int offerStatus) {
    switch (offerStatus) {
      case DiamondBidStatus.Pending:
        return appTheme.greenColor;
      case DiamondBidStatus.Accepted:
        return appTheme.greenColor;
      case DiamondBidStatus.Rejected:
        return appTheme.errorColor;
      default:
        return Colors.transparent;
    }
  }

  getWatchlistData() {
    return widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST
        ? Padding(
            padding: EdgeInsets.only(top: getSize(8.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(5)),
                border:
                    Border.all(color: appTheme.dividerColor.withOpacity(0.5)),
                color: appTheme.dividerColor.withOpacity(0.5),
              ),
              height: getSize(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        R.string.screenTitle.expDiscPer +
                            " : " +
                            "${widget.item.newDiscount}%",
                        style: appTheme.black12TextStyleMedium,
                      ),
                    ),
                  ),
                  if (widget.item.getFinalDiscount() != widget.item.newDiscount)
                    getDiscountUpOrDown(widget.item.getFinalDiscount(),
                        widget.item.newDiscount),
                  // Expanded(
                  //     child: Center(
                  //   child: Text(
                  //     "${(widget.item.newDiscount - widget.item.getFinalDiscount()).toStringAsFixed(2)}%",
                  //     style: appTheme.black12TextStyleMedium,
                  //   ),
                  // ))
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
                          R.string.screenTitle.expDiscPer + " :",
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
                border:
                    Border.all(color: appTheme.dividerColor.withOpacity(0.5)),
                color: appTheme.dividerColor.withOpacity(0.5),
              ),
              height: getSize(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: Text(
                      PriceUtilities.getPercent(widget.item.newDiscount),
                      style: appTheme.black16MediumTextStyle.copyWith(
                          color: Colors.green, fontSize: getFontSize(14)),
                    ),
                  ),
                  Center(
                    child: Text(
                      PriceUtilities.getPrice(widget.item.newAmount) + "/Ct",
                      style: appTheme.black16MediumTextStyle.copyWith(
                        fontSize: getFontSize(14),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      PriceUtilities.getPrice(widget.item.newPricePerCarat) +
                          "/Amt",
                      style: appTheme.black16MediumTextStyle.copyWith(
                        fontSize: getFontSize(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  getTimingDetails() {
    return <Widget>[];
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
                    getText(R.string.screenTitle.finalOffer + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(widget.item.getFinalOffer().toString(),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string.screenTitle.finalDisc + " :",
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
                    getText(R.string.screenTitle.finalRate + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(PriceUtilities.getPrice(widget.item.getFinalRate()),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string.screenTitle.finalValue + " :",
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
                                        R.string.screenTitle.offeredDisc + " :",
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
                                        R.string.screenTitle.offeredPriceCt +
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

  getOfferedBottomSection() {
    if (widget.moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: getSize(8),
          ),
          color: appTheme.dividerColor,
          height: 0.6,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: getSize(8),
            bottom: getSize(8),
          ),
          child: Row(
            children: [
              Container(
                  //width: getPercentageWidth(80),
                  padding: EdgeInsets.only(
                    right: getSize(20),
                  ),
                  // child: RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     text: "Exp. Date.:\t",
                  //     style: appTheme.grey12TextStyle,
                  //     children: <TextSpan>[
                  //       TextSpan(
                  //         text: isNullEmptyOrFalse(widget.item.offerValidDate)
                  //             ? "-"
                  //             : DateUtilities()
                  //                 .convertServerDateToFormatterString(
                  //                     widget.item.offerValidDate,
                  //                     formatter: DateUtilities.hh_mm_ss),
                  //         style: appTheme.black12TextStyleMedium,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  child: totalSeconds == 0
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: getSize(12.0), right: getSize(75)),
                          child: Text(
                            R.string.commonString.offerExpired,
                            style: appTheme.blackBold12TextStyle,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              left: getSize(12.0), right: getSize(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                Duration(seconds: totalSeconds)
                                    .inHours
                                    .remainder(60 * 60)
                                    .toString()
                                    .padLeft(2, "0"),
                                style: appTheme.blackBold12TextStyle,
                              ),
                              Text(
                                " " + R.string.commonString.hrs,
                                style: appTheme.black12TextStyle,
                              ),
                              SizedBox(width: getSize(5)),
                              Text(
                                Duration(seconds: totalSeconds)
                                    .inMinutes
                                    .remainder(60)
                                    .toString()
                                    .padLeft(2, "0"),
                                style: appTheme.blackBold12TextStyle,
                              ),
                              Text(
                                " " + R.string.commonString.min,
                                style: appTheme.black12TextStyle,
                              ),
                              SizedBox(width: getSize(5)),
                              Text(
                                Duration(seconds: totalSeconds)
                                    .inSeconds
                                    .remainder(60)
                                    .toString()
                                    .padLeft(2, "0"),
                                style: appTheme.blackBold12TextStyle,
                              ),
                              Text(
                                " " + R.string.commonString.sec,
                                style: appTheme.black12TextStyle,
                              ),
                            ],
                          ),
                        )),
              Container(
                //width: getPercentageWidth(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(3)),
                    color: widget.item.getOfferStatusColor().withOpacity(0.1)),
                child: Text(
                  widget.item.getOfferStatus(),
                  style: appTheme.blackNormal14TitleColorPrimary.copyWith(
                    color: widget.item.getOfferStatusColor(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Row(),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: getSize(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     app.resolve<CustomDialogs>().confirmDialog(
                    //           context,
                    //           title: R.string.screenTitle.remarks,
                    //           desc: widget.item.remarks ?? "-",
                    //           positiveBtnTitle: R.string.commonString.ok,
                    //         );
                    //   },
                    //   child: Padding(
                    //     padding: EdgeInsets.all(getSize(2.0)),
                    //     child: Image.asset(
                    //       exclamation,
                    //       width: getSize(16),
                    //       height: getSize(16),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: getSize(10),
                    // ),
                    widget.item.offerStatus != OfferStatus.rejected
                        ? InkWell(
                            onTap: () {
                              widget.actionClick(ManageCLick(
                                  type: clickConstant.CLICK_TYPE_EDIT));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(getSize(2.0)),
                              child: Image.asset(
                                edit_icon,
                                width: getSize(16),
                                height: getSize(16),
                              ),
                            ),
                          )
                        : SizedBox(),
                    widget.item.offerStatus != OfferStatus.rejected
                        ? SizedBox(
                            width: getSize(10),
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: () {
                        widget.actionClick(
                          ManageCLick(type: clickConstant.CLICK_TYPE_DELETE),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(getSize(2.0)),
                        child: Image.asset(
                          delete_icon_medium,
                          width: getSize(16),
                          height: getSize(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  calcualteDifference() {
    isTimerCompleted = false;
    var currentTime = DateTime.now();
    var temp = DateUtilities()
        .convertServerStringToFormatterDate(widget.item.offerValidDate);
    print(temp);
    // var offerValidDate = DateTime.parse(temp);
    if (currentTime.isBefore(temp)) {
      difference = temp.difference(currentTime);
      totalSeconds = difference.inSeconds;
      startTimer();
    } else {
      //offer expire;
    }
  }

  void dispose() {
    // Cancels the timer when the page is disposed.
    if (_timer != null) {
      _timer.cancel();
    }

    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (totalSeconds < 1) {
            timer.cancel();
            isTimerCompleted = true;
            Future.delayed(Duration(seconds: 65), () {
              calcualteDifference();
            });
            RxBus.post(true, tag: eventDiamondRefresh);
          } else {
            totalSeconds = totalSeconds - 1;
          }
        },
      ),
    );
  }

  getOfferedDiscountTextField() {
    return Focus(
      onFocusChange: (hasfocus) {
        if (hasfocus == false) {
          print("Focus off");
          var discount = num.parse(_offeredDiscountTextFieldController.text);
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
        keyboardType: TextInputType.text,
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
                padding: EdgeInsets.only(
                    left: getSize(10), right: getSize(10), bottom: getSize(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string.screenTitle.bidDisc + "(%) :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPercent(
                            widget.item.getFinalDiscount()),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string.screenTitle.bidValue + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(widget.item.getFinalAmount()),
                        appTheme.blackNormal12TitleColorblack),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: getSize(10), right: getSize(10), bottom: getSize(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getText(R.string.screenTitle.finalRate + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(widget.item.getBidFinalRate()),
                        appTheme.blackNormal12TitleColorblack),
                    getText(R.string.screenTitle.finalValue + " :",
                        appTheme.blackNormal12TitleColorblack),
                    getText(
                        PriceUtilities.getPrice(
                            widget.item.getBidFinalAmount()),
                        appTheme.blackNormal12TitleColorblack),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: getSize(10), right: getSize(10), bottom: getSize(10)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: appTheme.dividerColor),
                      borderRadius: BorderRadius.circular(getSize(4))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: getSize(36),
                          decoration: BoxDecoration(
                            color: appTheme.dividerColor,
                          ),
                          child: Center(
                            child: getText(
                                R.string.screenTitle.bidPricePerCt + " :",
                                appTheme.blackNormal12TitleColorblack),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: getSize(36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.item.bidPlus = false;
                                    widget.item.minusAmount = 20;
                                    widget.item.ctPr =
                                        widget.item.getbidAmount();
                                    RxBus.post(false, tag: eventBusDropDown);
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: getSize(10)),
                                  decoration: BoxDecoration(
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
                                    vertical: getSize(5),
                                    horizontal: getSize(10)),
                                decoration: BoxDecoration(
                                    // border:
                                    //     Border.all(color: appTheme.dividerColor),
                                    borderRadius:
                                        BorderRadius.circular(getSize(5))),
                                child: getText(
                                    PriceUtilities.getPrice(
                                        widget.item.getFinalRate()),
                                    appTheme.black16MediumTextStyle),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.item.bidPlus = true;
                                    widget.item.plusAmount = 20;
                                    widget.item.ctPr =
                                        widget.item.getbidAmount();
                                    RxBus.post(true, tag: eventBusDropDown);
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: getSize(10)),
                                  decoration: BoxDecoration(
                                    // color: appTheme.colorPrimary,
                                    borderRadius: BorderRadius.circular(
                                      getSize(5),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                      child: Image.asset(
                                        plusGreenIcon,
                                        width: getSize(16),
                                        height: getSize(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

  getAmountText(String text, {TextAlign align}) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
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

getText(String text, TextStyle style, {TextAlign align}) {
  return Text(text, textAlign: align ?? TextAlign.left, style: style);
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
