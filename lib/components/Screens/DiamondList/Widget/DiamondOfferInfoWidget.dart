import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondOfferInfoWidget extends StatefulWidget {
  DiamondModel diamondModel;
  int moduleType;
  final num leftPadding;
  final num rightPadding;
  final num topPadding;
  final num bottomPadding;

  DiamondOfferInfoWidget(
    this.diamondModel,
    this.moduleType, {
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
  });

  @override
  _DiamondOfferInfoWidgetState createState() => _DiamondOfferInfoWidgetState();
}

class _DiamondOfferInfoWidgetState extends State<DiamondOfferInfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          left: getSize(widget.leftPadding != 0
              ? widget.leftPadding
              : Spacing.leftPadding),
          right: getSize(widget.rightPadding != 0
              ? widget.leftPadding
              : Spacing.rightPadding),
          top: getSize(widget.rightPadding != 0 ? widget.leftPadding : 7),
          bottom: getSize(widget.rightPadding != 0 ? widget.leftPadding : 11),
        ),
        child: Column(
          children: [
            getOfferedItems(),
            getDateItem(),
            getRemarkItem(),
          ],
        ));
  }

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(14)),
    );
  }

  getOfferedItems() {
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER ||
        widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      return Container();
    }
    return Row(
      children: [
        Text(
          R.string().commonString.offered,
          style: appTheme.darkBlue16TextStyle.copyWith(
            fontSize: getSize(12),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getAmountText('-50.05%'),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: getSize(16),
                    right: getSize(10),
                  ),
                  child:
                      getAmountText(PriceUtilities.getPrice(13992.50) + "/Cts"),
                ),
              ),
              Flexible(
                child:
                    getAmountText(PriceUtilities.getPrice(20988.75) + "/Amt"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  getDateItem() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(7),
      ),
      child: Row(
        children: [
          Text(
            getDateTitle(),
            style: appTheme.grey12HintTextStyle,
          ),
          Spacer(),
          Text(
            getDate(),
            style: appTheme.black14TextStyle,
          ),
        ],
      ),
    );
  }

  getRemarkItem() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(7),
      ),
      child: Row(
        children: [
          Text(
            R.string().commonString.remark,
            style: appTheme.grey12HintTextStyle,
          ),
          SizedBox(width: getSize(16)),
          Spacer(),
          Expanded(
            child: Text(
              getRemarks(),
              style: appTheme.black12TextStyle,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  String getRemarks() {
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      return isNullEmptyOrFalse(widget.diamondModel.remarks)
          ? "-"
          : widget.diamondModel.remarks;
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      return isNullEmptyOrFalse(widget.diamondModel.purpose)
          ? "-"
          : widget.diamondModel.purpose;
    }

    return "-";
  }

  String getDateTitle() {
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      return R.string().commonString.officeVisitDate;
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      return R.string().commonString.validTill;
    }

    return "-";
  }

  String getDate() {
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      return isNullEmptyOrFalse(widget.diamondModel.date)
          ? "-"
          : DateUtilities().convertServerDateToFormatterString(
              widget.diamondModel.date,
              formatter: DateUtilities.dd_mm_yyyy);
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      return isNullEmptyOrFalse(widget.diamondModel.offerValidDate)
          ? "-"
          : DateUtilities().convertServerDateToFormatterString(
              widget.diamondModel.offerValidDate,
              formatter: DateUtilities.dd_mm_yyyy);
    }

    return "-";
  }
}
