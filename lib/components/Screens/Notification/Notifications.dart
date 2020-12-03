import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/Notification/NotificationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/utils/navigator.dart';
import '../../../modules/ThemeSetting.dart';

class Notifications extends StatefulScreenWidget {
  static const route = "Notifications";

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends StatefulScreenWidgetState {
  bool flagForHandlingNullPastMegaTitle;
  BaseList notificationList;
  int page = DEFAULT_PAGE;

  var arrList = List<NotificationModel>();
  @override
  void initState() {
    flagForHandlingNullPastMegaTitle = false;
    super.initState();
    notificationList = BaseList(BaseListState(
//      imagePath: noRideHistoryFound,
      noDataMsg: APPNAME,
      noDataDesc: R.string().noDataStrings.noDataFound,
      refreshBtn: R.string().commonString.refresh,
      enablePullDown: true,
      enablePullUp: true,
      onPullToRefress: () {
        callApi(true);
      },
      onRefress: () {
        callApi(true);
      },
      onLoadMore: () {
        callApi(false, isLoading: true);
      },
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi(false);
    });
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arrList.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;

    NetworkCall<NotificationResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .getNotificationList(dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((resp) async {
      notificationList.state.listCount = resp.data.list.length;
      notificationList.state.totalCount = resp.data.count;
      page = page + 1;
      arrList.addAll(resp.data.list);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      for (int i = 0; i < arrList.length; i++) {
        var date = DateUtilities().getDateFromString(arrList[i].strDate,
            formatter: DateUtilities.dd_mm_yyyy_);

        final aDate = DateTime(date.year, date.month, date.day);
        if (i == 0 || (arrList[i].strDate != arrList[i - 1].strDate)) {
          if (aDate == today) {
            arrList[i].megaTitle = R.string().commonString.today;
          } else if (aDate == yesterday) {
            arrList[i].megaTitle = R.string().commonString.yesterday;
          } else {
            var past = arrList
                .where((element) =>
                    element.megaTitle == R.string().commonString.past)
                .toList();
            if (isNullEmptyOrFalse(past)) {
              arrList[i].megaTitle = R.string().commonString.past;
              break;
            }
          }
        }
        if (aDate == today) {
          arrList[i].flagForPastNotificationTime = false;
        } else if (aDate == yesterday) {
          arrList[i].flagForPastNotificationTime = false;
        } else {
          arrList[i].flagForPastNotificationTime = true;
        }
      }
      fillArrayList();
      notificationList.state.setApiCalling(false);
    }).catchError((onError) {
      if (isRefress) {
        arrList.clear();
        notificationList.state.listCount = arrList.length;
        notificationList.state.totalCount = arrList.length;
      }
      notificationList.state.setApiCalling(false);
    });
  }

  fillArrayList() {
    notificationList.state.listCount = arrList.length;
    notificationList.state.listItems = ListView.builder(
      shrinkWrap: true,
      itemCount: arrList.length,
      itemBuilder: (context, index) {
        return getNotificationItem(arrList[index],
            isShowShadow: arrList[index].isRead);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppBackground(
        child: Scaffold(
            appBar: getAppBar(
              context,
              R.string().commonString.notifications,
              bgColor: appTheme.whiteColor,
              leadingButton: getBackButton(context),
              centerTitle: false,
            ),
            body: notificationList),
      ),
    );
  }

  getNotificationItem(NotificationModel model, {bool isShowShadow = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isNullEmptyOrFalse(model.megaTitle)
            ? Container(
                margin: EdgeInsets.only(
                  left: getSize(20),
                  right: getSize(20),
                  top: getSize(20),
                  bottom: getSize(20),
                ),
                child: Text(
                  model.megaTitle ?? "",
                  style: appTheme.blackNormal18TitleColorblack.copyWith(
                    color: appTheme.colorPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : Container(),
        InkWell(
          onTap: () {
            callApiForMakeNotificationMarkAsRead(model.id);
          },
          child: Container(
            margin: EdgeInsets.only(
              left: getSize(16),
              right: getSize(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(
                        top: getSize(8),
                        bottom: getSize(8),
                      ),
                      padding: EdgeInsets.only(
                        // left: getSize(35),
                        left: getSize(10),
                        right: getSize(10),
                        top: getSize(10),
                        bottom: getSize(10),
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.whiteColor,
                        boxShadow: isShowShadow
                            ? [
                                BoxShadow(
                                    color: appTheme.lightColorPrimary,
                                    blurRadius: getSize(10),
                                    spreadRadius: getSize(2),
                                    offset: Offset(1, 8)),
                              ]
                            : null,
                        border: isShowShadow
                            ? null
                            : Border.all(color: appTheme.dividerColor),
                        borderRadius: BorderRadius.circular(getSize(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getSize(10),
                          right: getSize(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.title ?? "-",
                              style: appTheme.black14TextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: getSize(5),
                            ),
                            Text(
                              model.message ?? "-",
                              style: appTheme.black12TextStyle,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: getSize(5),
                            ),
                            getNotificationTime(model),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getNotificationTime(NotificationModel model) {
    if (!model.flagForPastNotificationTime) {
      return Text(
        TimeAgo.timeAgoSinceDate(DateUtilities().getDateFromString(
            DateUtilities().convertServerDateToFormatterString(
                model.createdAt ?? "",
                formatter: DateUtilities.dd_mm_yyyy_hh_mm),
            formatter: DateUtilities.dd_mm_yyyy_hh_mm)),
        style: appTheme.grey12HintTextStyle,
        maxLines: 2,
        textAlign: TextAlign.start,
      );
    } else {
      return Text(
        DateUtilities().convertDateToFormatterString(
            DateUtilities().convertServerDateToFormatterString(
                model.createdAt ?? "",
                formatter: DateUtilities.dd_mm_yyyy_hh_mm_ss_a),
            formatter: DateUtilities.dd_mm_yyyy_hh_mm_ss_a),
        style: appTheme.grey12HintTextStyle,
        maxLines: 2,
        textAlign: TextAlign.start,
      );
    }
  }

  callApiForMakeNotificationMarkAsRead(String notificationId) {
    Map<String, dynamic> req = {};
    req["id"] = notificationId;

    NetworkCall<BaseApiResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .markAsReadNotification(req),
      context,
      isProgress: true,
    )
        .then((resp) async {
      print("notification Readed");
      //Redirection from notification.
      // if(resp.)

    }).catchError(
      (onError) => {
        if (onError is ErrorResp) print(onError),
      },
    );
  }

  getColorClarityLab() {
    return Row(
      children: [
        getText(
          "123",
        ),
        Spacer(),
        getText(
          "456",
        ),
        Spacer(),
        getText(
          "789",
        ),
      ],
    );
  }

  getStoneIdShape() {
    return Row(
      children: [
        getText("123"),
        Spacer(),
        getText(
          "456gyhg",
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  getText(String text, {FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: appTheme.black12TextStyle.copyWith(
        fontSize: getFontSize(12),
        fontWeight: fontWeight,
      ),
    );
  }

  getCutPolSynData() {
    return Row(
      children: [
        getText("123"),
        Spacer(),
        getDot(),
        Spacer(),
        getText("456"),
        Spacer(),
        getDot(),
        Spacer(),
        getText("789"),
      ],
    );
  }

  getDot() {
    return Padding(
      padding: EdgeInsets.only(left: getSize(4), right: getSize(4)),
      child: Container(
        height: getSize(4),
        width: getSize(4),
        decoration:
            BoxDecoration(color: appTheme.dividerColor, shape: BoxShape.circle),
      ),
    );
  }

  getImageView() {
    return Material(
      elevation: 10,
      shadowColor: appTheme.shadowColor,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(getSize(30)),
      child: Container(
        width: getSize(60),
        height: getSize(60),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(10)),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(getSize(20))),
              child: Image.asset(
                diamond,
                width: getSize(40),
                height: getSize(40),
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}

class TimeAgo {
  static String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if (difference.inDays > 8) {
      return DateUtilities().getFormattedDateString(date,
          formatter: DateUtilities.dd_mm_yyyy_hh_mm);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates)
          ? '${(difference.inDays / 7).floor()} ${R.string().commonString.weekAgo}'
          : R.string().commonString.lastWeek;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ${R.string().commonString.dayAgo}';
    } else if (difference.inDays >= 1) {
      return (numericDates)
          ? R.string().commonString.onedayAgo
          : R.string().commonString.yesterday;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ${R.string().commonString.hourAgo}';
    } else if (difference.inHours >= 1) {
      return (numericDates)
          ? R.string().commonString.onehourAgo
          : R.string().commonString.anhourAgo;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ${R.string().commonString.mintuesAgo}';
    } else if (difference.inMinutes >= 1) {
      return (numericDates)
          ? R.string().commonString.onemintuesAgo
          : R.string().commonString.amintueAgo;
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${R.string().commonString.secondsAgo}';
    } else {
      return R.string().commonString.justNow;
    }
  }
}
