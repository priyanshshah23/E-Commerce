import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Widget/CommonHeader.dart';
import 'Widget/DiamondListItemWidget.dart';

Future showWatchListDialog(BuildContext context, List<DiamondModel> diamondList,
    ActionClick actionClick) {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  diamondCalculation.setAverageCalculation(diamondList);
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setSetter) {
          ActionClick actionClick = (manageClick) {
            setSetter(() {});
          };
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
                child: Text(
                  R.string().screenTitle.addToWatchList,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(8), right: getSize(8)),
                child: DiamondListHeader(
                  diamondCalculation: diamondCalculation,
                ),
              ),
              SizedBox(
                height: getSize(10),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(8), right: getSize(8)),
                child: diamondList.length < 4
                    ? ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: getSize(15),
                        ),
                        shrinkWrap: true,
                        itemCount: diamondList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return DiamondItemWidget(
                              item: diamondList[index],
                              actionClick: actionClick);
                        },
                      )
                    : Container(
                        height: getSize(100) * 4,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: getSize(15),
                          ),
                          itemCount: diamondList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DiamondItemWidget(
                                item: diamondList[index],
                                actionClick: actionClick);
                          },
                        ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: getSize(10), left: getSize(26), bottom: getSize(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        // code here
                        Navigator.pop(context);
                      },
                      child: Text(
                        R.string().commonString.cancel,
                        style: appTheme.black16TextStyle,
                      ),
                    ),
                    SizedBox(
                      width: getSize(38),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(getSize(0)),
                      onPressed: () {
                        actionClick(ManageCLick(
                            type: clickConstant.CLICK_TYPE_CONFIRM));
                      },
                      child: Text(
                        R.string().screenTitle.addToWatchList,
                        style: appTheme.black16TextStyle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      });
}
