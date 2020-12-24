import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfflineDownloadPopup extends StatefulWidget {
  final Function(bool, String) onAccept;
  OfflineDownloadPopup({Key key, this.onAccept}) : super(key: key);

  @override
  _OfflineDownloadPopupState createState() => _OfflineDownloadPopupState();
}

class _OfflineDownloadPopupState extends State<OfflineDownloadPopup> {
  bool isDownloadSearched = true;
  String selectedDate;

  @override
  void initState() {
    super.initState();
    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.OFFLINE_DOWNLOAD,
        section: SectionAnalytics.VIEW,
        action: ActionAnalytics.OPEN);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(
        left: getSize(16),
        right: getSize(16),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(getSize(8)))),
      content: Container(
        width: MathUtilities.screenWidth(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Confirmation',
              textAlign: TextAlign.center,
              style: appTheme.commonAlertDialogueTitleStyle,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getSize(20),
              ),
              child: Text(
                'Please read & accept terms before download stock offline.',
                textAlign: TextAlign.center,
                style: appTheme.commonAlertDialogueDescStyle,
              ),
            ),
            Text(
              'There may be price and availability variations in the intervening period between placing an order offline and when the order is confirmed online. The changed of the same will be communicated to you via message. Please ensure that you take a note of it before confirming the order.',
              style: appTheme.blackNormal14TitleColorblack,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: getSize(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: getSize(10),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: getSize(1),
                  color: appTheme.borderColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                  getSize(10),
                )),
              ),
              child: InkWell(
                onTap: () {
                  //
                  openAddReminder(context, (manageClick) {
                    setState(() {
                      selectedDate = manageClick.date;
                    });
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Remind me later',
                        textAlign: TextAlign.center,
                        style: appTheme.commonAlertDialogueDescStyle.copyWith(
                          color: appTheme.colorPrimary,
                        ),
                      ),
                    ),
                    Spacer(),
                    (selectedDate != null)
                        ? Text(
                            DateUtilities().convertServerDateToFormatterString(
                                selectedDate,
                                formatter:
                                    DateUtilities.dd_mm_yyyy_hh_mm_ss_aa),
                            style: appTheme.blackNormal14TitleColorblack,
                          )
                        : Container(
                            height: getSize(26),
                            width: getSize(26),
                            child: Image.asset(unselectedIcon),
                          ),
                  ],
                ),
              ),
              height: getSize(50),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isDownloadSearched) {
                      setState(() {
                        isDownloadSearched = true;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getSize(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: getSize(16),
                          width: getSize(16),
                          child: isDownloadSearched
                              ? Image.asset(selectedIcon)
                              : Image.asset(unselectedIcon),
                        ),
                        SizedBox(
                          width: getSize(10),
                        ),
                        Text(
                          'Searched Stock',
                          style: isDownloadSearched
                              ? appTheme.blackNormal14TitleColorPrimary
                              : appTheme.blackNormal14TitleColorblack,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: getSize(20),
                ),
                GestureDetector(
                  onTap: () {
                    if (isDownloadSearched) {
                      setState(() {
                        isDownloadSearched = false;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getSize(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: getSize(16),
                          width: getSize(16),
                          child: !isDownloadSearched
                              ? Image.asset(selectedIcon)
                              : Image.asset(unselectedIcon),
                        ),
                        SizedBox(
                          width: getSize(10),
                        ),
                        Text(
                          'All Stock',
                          style: !isDownloadSearched
                              ? appTheme.blackNormal14TitleColorPrimary
                              : appTheme.blackNormal14TitleColorblack,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: getSize(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getSize(50),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: appTheme.colorPrimary,
                            width: getSize(1),
                          ),
                          borderRadius: BorderRadius.circular(getSize(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              getSize(8), getSize(14), getSize(8), getSize(14)),
                          child: Text(
                            R.string.commonString.cancel,
                            textAlign: TextAlign.center,
                            style: appTheme.commonAlertDialogueDescStyle
                                .copyWith(
                                    color: appTheme.colorPrimary,
                                    fontSize: getFontSize(14)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(20),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onAccept(isDownloadSearched, selectedDate);
                      },
                      child: Container(
                        height: getSize(50),
                        decoration: BoxDecoration(
                            color: appTheme.colorPrimary,
                            borderRadius: BorderRadius.circular(getSize(5)),
                            boxShadow: getBoxShadow(context)),
                        child: Padding(
                          padding: EdgeInsets.all(getSize(16)),
                          child: Text(
                            "Accept",
                            textAlign: TextAlign.center,
                            style: appTheme.white16TextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
