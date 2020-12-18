import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/OfflineSearchHistory/OfflineSearchHistoryModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OfflineSearchHistory extends StatefulWidget {
  static const String route = "OfflineSearchHistory";

  OfflineSearchHistory({
    Key key,
  }) : super(key: key);

  @override
  _OfflineSearchHistoryState createState() => _OfflineSearchHistoryState();
}

class _OfflineSearchHistoryState extends State<OfflineSearchHistory> {
  List<OfflineSearchHistoryModel> arrHistory = [];
  SlidableController controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  fetchData() async {
    arrHistory =
        await AppDatabase.instance.offlineSearchHistoryDao.getSearchHistory();
    print(arrHistory);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        "Search History",
        leadingButton: getDrawerButton(context, true),
        bgColor: appTheme.whiteColor,
        centerTitle: false,
      ),
      body: arrHistory.length > 0
          ? ListView.builder(
              itemBuilder: (context, index) {
                return Slidable(
                  controller: this.controller,
                  key: Key(arrHistory[index].date),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: getRightAction(callBack: () async {
                    await AppDatabase.instance.offlineSearchHistoryDao
                        .delete(arrHistory[index].date);
                    await AppDatabase.instance.diamondDao
                        .deleteByDate(arrHistory[index].date);
                    fetchData();
                  }),
                  child: InkWell(
                    onTap: () {
                      Map<String, dynamic> dict = new HashMap();
                      dict["isdrawer"] = false;
                      dict["downloadDate"] = arrHistory[index].date;
                      dict[ArgumentConstant.ModuleType] =
                          DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK;
                      NavigationUtilities.pushRoute(DiamondListScreen.route,
                          args: dict);
                    },
                    child: getSearchedItem(arrHistory[index]),
                  ),
                );
              },
              itemCount: arrHistory.length,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    noDataFound,
                    width: getSize(200),
                    height: getSize(200),
                  ),
                  SizedBox(
                    height: getSize(16),
                  ),
                  Text(
                    APPNAME,
                    style: appTheme.greenPrimaryNormal14TitleColor.copyWith(
                      fontSize: getFontSize(28),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: getSize(16),
                  ),
                  Text(
                    R.string.noDataStrings.noDataFound,
                    style: appTheme.grey14HintTextStyle.copyWith(
                      fontSize: getFontSize(22),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  getSearchedItem(OfflineSearchHistoryModel model) {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(16),
        right: getSize(16),
        top: getSize(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          boxShadow: [
            BoxShadow(
                color: appTheme.lightColorPrimary,
                blurRadius: getSize(10),
                spreadRadius: getSize(2),
                offset: Offset(1, 8)),
          ],
          border: Border.all(color: appTheme.dividerColor),
          borderRadius: BorderRadius.circular(getSize(5)),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            getSize(8.0),
          ),
          child: Column(
            children: [
              getFirstRow(model),
              getSecondRow(model),
              getThirdRow(model),
            ],
          ),
        ),
      ),
    );
  }

  getFirstRow(OfflineSearchHistoryModel model) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getSize(8.0),
      ),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Pcs",
                style: appTheme.grey14HintTextStyle,
              ),
              SizedBox(width: getSize(35)),
              Text(
                model.pcs.toString(),
                style: appTheme.blackMedium14TitleColorblack,
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Carat",
                style: appTheme.grey14HintTextStyle,
              ),
              SizedBox(width: getSize(24)),
              Text(
                PriceUtilities.getDoubleValue(model.carat),
                style: appTheme.blackMedium14TitleColorblack,
              ),
            ],
          ),
        ],
      ),
    );
  }

  getSecondRow(OfflineSearchHistoryModel model) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getSize(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Date",
            style: appTheme.grey14HintTextStyle,
          ),
          SizedBox(width: getSize(24)),
          Text(
            model.date,
            style: appTheme.blackMedium14TitleColorblack,
          ),
        ],
      ),
    );
  }

  getThirdRow(OfflineSearchHistoryModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Expiry Date",
          style: appTheme.grey14HintTextStyle,
        ),
        SizedBox(width: getSize(24)),
        Text(
          DateUtilities().convertDateToFormatterString(
            model.expiryDate,
            formatter: DateUtilities.yyyy_mm_dd,
          ),
          style: appTheme.blackMedium14TitleColorblack,
        ),
      ],
    );
  }

  List<Widget> getRightAction({Function callBack}) {
    List<Widget> list = [];
    list.add(
      IntrinsicHeight(
        child: IconSlideAction(
          color: Colors.transparent,
          onTap: () {
            callBack();
          },
          iconWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: fromHex("#FFE7E7"),
                  border: Border.all(color: fromHex("#FF4D4D")),
                  shape: BoxShape.circle,
                ),
                height: getSize(40),
                width: getSize(40),
                child: Padding(
                  padding: EdgeInsets.all(getSize(10)),
                  child: Image.asset(
                    home_delete,
                    // height: getSize(20),
                    // width: getSize(20),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(8)),
                child: Text(R.string.commonString.delete,
                    style: appTheme.primaryNormal12TitleColor.copyWith(
                      color: fromHex("#FF4D4D"),
                    )),
              )
            ],
          ),
        ),
      ),
    );

    return list;
  }
}
