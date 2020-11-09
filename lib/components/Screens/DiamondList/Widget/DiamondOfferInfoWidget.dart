import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:flutter/material.dart';

class DiamondOfferInfoWidget extends StatefulWidget {
  final num leftPadding;
  final num rightPadding;
  final num topPadding;
  final num bottomPadding;

  DiamondOfferInfoWidget({
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
            Row(
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
                          child: getAmountText(
                              PriceUtilities.getPrice(13992.50) + "/Cts"),
                        ),
                      ),
                      Flexible(
                        child: getAmountText(
                            PriceUtilities.getPrice(20988.75) + "/Amt"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: getSize(7),
              ),
              child: Row(
                children: [
                  Text(
                    R.string().commonString.validTill,
                    style: appTheme.grey12HintTextStyle,
                  ),
                  Spacer(),
                  Text(
                    '20-10-2020',
                    style: appTheme.black14TextStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getSize(5),
                    ),
                    child: Text(
                      '16days',
                      style: appTheme.grey12HintTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: getSize(7),
              ),
              child: Row(
                children: [
                  Text(
                    R.string().commonString.remark,
                    style: appTheme.grey12HintTextStyle,
                  ),
                  Expanded(
                    child: Text(
                      'But I must explain to you how all this. ',
                      style: appTheme.black12TextStyle,
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(14)),
    );
  }
}
