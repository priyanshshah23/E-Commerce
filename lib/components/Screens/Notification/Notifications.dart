import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/utils/navigator.dart';
import '../../../modules/ThemeSetting.dart';

class Notifications extends StatefulScreenWidget {
  static const route = "Notifications";

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends StatefulScreenWidgetState {
  BaseList notificationList;
  int page = DEFAULT_PAGE;

  @override
  void initState() {
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
//    if (isRefress) {
////      arraDiamond.clear();
//      page = DEFAULT_PAGE;
//    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    fillArrayList();
    notificationList.state.setApiCalling(false);
//    NetworkCall<DiamondListResp>()
//        .makeCall(
//          () => diamondConfig.getApiCall(moduleType, dict),
//      context,
//      isProgress: !isRefress && !isLoading,
//    )
//        .then((diamondListResp) async {
//
////      notificationList.state.listCount = arraDiamond.length;
////      notificationList.state.totalCount = diamondListResp.data.count;
//      page = page + 1;
////      notificationList.state.setApiCalling(false);
//    }).catchError((onError) {
//      if (isRefress) {
////        arraDiamond.clear();
////        notificationList.state.listCount = arraDiamond.length;
////        notificationList.state.totalCount = arraDiamond.length;
//      }
////      notificationList.state.setApiCalling(false);
//    });
  }

  fillArrayList() {
//    notificationList.state.totalCount = 10;
    notificationList.state.listCount = 10;
    notificationList.state.listItems = ListView(
//      crossAxisAlignment: CrossAxisAlignment.start,
      shrinkWrap: true,
      children: [
        Container(
            margin: EdgeInsets.only(
              left: getSize(20),
              right: getSize(20),
            ),
            child: Text(
              "Today",
              style: appTheme.primary16TextStyle,
            )),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return getNotificationItem();
          },
        ),
        Container(
            margin: EdgeInsets.only(
              left: getSize(20),
              right: getSize(20),
            ),
            child: Text(
              "Yesterday",
              style: appTheme.black16TextStyle,
            )),
        ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return getNotificationItem();
          },
        ),
        Container(
            margin: EdgeInsets.only(
              left: getSize(20),
              right: getSize(20),
            ),
            child: Text(
              "Past",
              style: appTheme.black16TextStyle,
            )),
        ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return getNotificationItem();
          },
        ),
      ],
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
          body: Column(
            children: [
              Expanded(child: notificationList),
            ],
          ),
        ),
      ),
    );
  }

  getNotificationItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: getSize(20),
            right: getSize(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          left: getSize(30),
                          bottom: getSize(20),
                          top: getSize(20),
                        ),
                        padding: EdgeInsets.only(
                          left: getSize(35),
                          right: getSize(10),
                          top: getSize(10),
                          bottom: getSize(10),
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          boxShadow: [
                            BoxShadow(
                                color: appTheme.textBlackColor.withOpacity(0.1),
                                blurRadius: getSize(10),
                                spreadRadius: getSize(2),
                                offset: Offset(0, 8)),
                          ],
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
                                "Order Placed",
                                style: appTheme.black16TextStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: getSize(5),
                              ),
                              Text(
                                "Your Order Placed Successfully. Your Memo No:- ORD000064",
                                style: appTheme.black14TextStyle,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: getSize(8),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Pieces : ",
                                          style: appTheme.black12TextStyle,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "20",
                                            style:
                                                appTheme.black12TextStyleBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Carat : ",
                                          style: appTheme.black12TextStyle,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "15.10",
                                            style:
                                                appTheme.black12TextStyleBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Value : ",
                                          style: appTheme.black12TextStyle,
                                        ),
                                        Expanded(
                                          child: Text(
                                            PriceUtilities.getPrice(100),
                                            style:
                                                appTheme.black12TextStyleBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: getSize(5),
                              ),
                              Text(
                                "10 Mins ago",
                                style: appTheme.grey14HintTextStyle,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        )),
                    getImageView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
              )
//                                  child: getImageView(
//                                    "",
//                                    finalUrl: model.img
//                                        ? DiamondUrls.image +
//                                        model.vStnId +
//                                        ".jpg"
//                                        : "",
//                                    width: getSize(40),
//                                    height: getSize(40),
//                                    fit: BoxFit.cover,
//                                  ),
              ),
        ),
      ),
    );
  }
}
