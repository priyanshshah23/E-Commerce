import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/material.dart';

Future showBottomSheetForMenu(BuildContext context,
    List<BottomTabModel> moreList, ActionClick actionClick, String title,
    {bool isDisplaySelection = true}) {
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
                child: Text(
                  title,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.only(
                  bottom: getSize(15),
                ),
                shrinkWrap: true,
                itemCount: moreList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      /*moreList.forEach((element) {
                        element.isSelected = false;
                      });
                      moreList[index].isSelected = true;
                      setSetter(() {});*/
                      Navigator.pop(context);
                      actionClick(ManageCLick(bottomTabModel: moreList[index]));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getSize(12), horizontal: getSize(20)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: getSize(14),
                            width: getSize(14),
                            child: Image.asset(
                              moreList[index].image,
                              color: moreList[index].imageColor != null
                                  ? moreList[index].imageColor
                                  : appTheme.textColor,
                            ),
                          ),
                          SizedBox(
                            width: getSize(22),
                          ),
                          Expanded(
                            child: Text(moreList[index].title,
                                style: appTheme.black14TextStyle),
                          ),
                          isDisplaySelection
                              ? Container(
                                  height: getSize(16),
                                  width: getSize(16),
                                  child: Image.asset(
                                    moreList[index].isSelected
                                        ? selectedFilter
                                        : unselectedFilter,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        });
      });
}
