import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

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
    if (widget.moduleType ==
            DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION ||
        widget.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_BID) {
      isTimerCompleted = false;
      var currentTime = DateTime.now();
      var strBlindBid = DateTime.now();
      var strLookandBid = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 14, 59, 0);

      if (currentTime.isAfter(DateTime(
          currentTime.year, currentTime.month, currentTime.day, 14, 59, 0))) {
        strBlindBid = DateTime(currentTime.year, currentTime.month,
            currentTime.day + 1, 10, 59, 0);
        difference = strBlindBid.difference(currentTime);
      } else if (currentTime.isBefore(DateTime(
          currentTime.year, currentTime.month, currentTime.day, 10, 59, 0))) {
        strBlindBid = DateTime(
            currentTime.year, currentTime.month, currentTime.day, 10, 59, 0);

        difference = strBlindBid.difference(currentTime);
      } else {
        difference = strLookandBid.difference(currentTime);
      }

      totalSeconds = difference.inSeconds;
      startTimer();
    }
  }

  @override
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
        top: getSize(8),
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
                  widget.diamondCalculation.pcs, R.string.commonString.pcs),
              Expanded(
                child: Container(),
              ),
              getColumn(widget.diamondCalculation.totalCarat,
                  R.string.commonString.cts),
              Expanded(
                child: Container(),
              ),
              getColumn(widget.diamondCalculation.totalDisc,
                  R.string.commonString.disc),
              Expanded(
                child: Container(),
              ),
              getColumn(widget.diamondCalculation.totalPriceCrt,
                  R.string.commonString.avgPriceCrt + dollar),
              // R.string.commonString.doller),
              Expanded(
                child: Container(),
              ),
              getColumn(widget.diamondCalculation.totalAmount,
                  R.string.commonString.amount + dollar)
            ],
          ),
        ),
        widget.moduleType == DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION
            ? Padding(
                padding: EdgeInsets.only(top: getSize(2.0)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(color: appTheme.dividerColor),
                    color: appTheme.dividerColor,
                  ),
                  height: getSize(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              R.string.commonString.bidEndsIn,
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
                              " " + R.string.commonString.hours,
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
                              " " + R.string.commonString.minutes,
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
                              " " + R.string.commonString.seconds,
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
          EdgeInsets.symmetric(vertical: getSize(12), horizontal: getSize(4)),
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
      overflow: TextOverflow.fade,
      style: widget.moduleType ==
              DiamondModuleConstant.MODULE_TYPE_FINAL_CALCULATION
          ? appTheme.white16TextStyle.copyWith(fontSize: getFontSize(10))
          : appTheme.black16TextStyle.copyWith(fontSize: getFontSize(10)),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
