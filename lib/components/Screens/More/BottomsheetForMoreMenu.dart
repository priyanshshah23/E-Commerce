import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/material.dart';

Future showBottomSheetForMenu(
    BuildContext context, List<BottomTabModel> moreList) {
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
                  R.string().commonString.more,
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
                      moreList.forEach((element) {
                        element.isSelected = false;
                      });
                      moreList[index].isSelected = !moreList[index].isSelected;
                      setSetter(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getSize(12), horizontal: getSize(20)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: getSize(12),
                            width: getSize(12),
                            child: Image.asset(
                              moreList[index].image,
                              color: appTheme.textColor,
                            ),
                          ),
                          SizedBox(
                            width: getSize(22),
                          ),
                          Expanded(
                            child: Text(moreList[index].title,
                                style: appTheme.black12TextStyle),
                          ),
                          Container(
                            height: getSize(16),
                            width: getSize(16),
                            child: Image.asset(
                              moreList[index].isSelected
                                  ? selectedFilter
                                  : unselectedFilter,
                            ),
                          ),
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
