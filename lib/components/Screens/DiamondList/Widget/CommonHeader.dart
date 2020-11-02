import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiamondListHeader extends StatefulWidget {
  DiamondCalculation diamondCalculation;
  int moduleType;
  DiamondListHeader({
    this.diamondCalculation,
    this.moduleType,
  });

  @override
  _DiamondListHeaderState createState() => _DiamondListHeaderState();
}

class _DiamondListHeaderState extends State<DiamondListHeader> {
  Duration difference;
  Timer _timer;
  bool isTimerCompleted = false;
  var totalSeconds = 0;

  @override
  void initState() {
    super.initState();

    calcualteDifference();
  }

  calcualteDifference() {
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL) {
      isTimerCompleted = false;
      var currentTime = DateTime.now();
      var strBlindBid = DateTime(
          currentTime.year, currentTime.month, currentTime.day + 1, 10, 59, 0);
      var strLookandBid = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 14, 59, 0);
      difference = strLookandBid.difference(currentTime);

      if (strLookandBid.difference(currentTime).inSeconds < 0) {
        difference = strBlindBid.difference(currentTime);
      }

      totalSeconds = difference.inSeconds;
      startTimer();
    }
  }

  @override
  void dispose() {
    // Cancels the timer when the page is disposed.
    if(_timer != null) {
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
          } else {
            totalSeconds = totalSeconds - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
        top: getSize(20),
      ),
      child: Column(children: [
        Container(
          width: MathUtilities.screenWidth(context),
          padding: EdgeInsets.symmetric(
            horizontal: getSize(10),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: appTheme.dividerColor),
              borderRadius: BorderRadius.circular(getSize(5))),
          child: Row(
            children: <Widget>[
              getColumn(
                  widget.diamondCalculation.pcs, R.string().commonString.pcs),
              Expanded(
                child: Container(),
              ),
              getColumn(widget.diamondCalculation.totalCarat,
                  R.string().commonString.cts),
              Expanded(
                child: Container(),
              ),
              getColumn(widget.diamondCalculation.totalDisc,
                  R.string().commonString.disc),
              Expanded(
                child: Container(),
              ),
              getColumn(
                  widget.diamondCalculation.totalPriceCrt,
                  R.string().commonString.avgPriceCrt +
                      R.string().commonString.doller),
              Expanded(
                child: Container(),
              ),
              getColumn(
                  widget.diamondCalculation.totalAmount,
                  R.string().commonString.amount +
                      R.string().commonString.doller)
            ],
          ),
        ),
        widget.moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL
            ? Padding(
                padding: EdgeInsets.only(top: getSize(2.0)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(color: appTheme.selectedFilterColor),
                    color: appTheme.selectedFilterColor,
                  ),
                  height: getSize(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              R.string().commonString.bidEndsIn,
                              style: appTheme.primaryColor14TextStyle,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: getSize(8.0), left: getSize(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              " " + R.string().commonString.hours,
                              style: appTheme.black12TextStyle,
                            ),
                            SizedBox(width: getSize(16)),
                            Text(
                              Duration(seconds: totalSeconds)
                                  .inMinutes
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, "0"),
                              style: appTheme.blackBold12TextStyle,
                            ),
                            Text(
                              " " + R.string().commonString.minutes,
                              style: appTheme.black12TextStyle,
                            ),
                            SizedBox(width: getSize(16)),
                            Text(
                              Duration(seconds: totalSeconds)
                                  .inSeconds
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, "0"),
                              style: appTheme.blackBold12TextStyle,
                            ),
                            Text(
                              " " + R.string().commonString.seconds,
                              style: appTheme.black12TextStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container()
      ]),
    );
  }

  getColumn(String text, String lable) {
    return Container(
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
    );
  }

  setDivider() {
    return Container(
      height: getSize(20),
      width: getSize(2),
      color: appTheme.textGreyColor,
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
      style: appTheme.black16TextStyle.copyWith(fontSize: getFontSize(10)),
    );
  }
}
