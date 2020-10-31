import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:flutter/material.dart';

class RecentSearchWidget extends StatefulWidget {
  @override
  _RecentSearchWidgetState createState() => _RecentSearchWidgetState();
}

class _RecentSearchWidgetState extends State<RecentSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
        top: getSize(20),
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              getTitleText(R.string().screenTitle.recentSearch),
              Spacer(),
              InkWell(
                onTap: () {
                  //
                },
                child: getViewAll(),
              ),
            ],
          ),
          SizedBox(
            height: getSize(20),
          ),
          Container(
              height: getSize(160),
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return getRecentItem();
                },)
//            child: GridView.count(
//              scrollDirection: Axis.horizontal,
//              shrinkWrap: true,
//              crossAxisCount: 2,
////              childAspectRatio: 0.36,
//              // without Price
//               childAspectRatio: 0.327, // with Price
//              mainAxisSpacing: 10,
//              crossAxisSpacing: 10,
//              children: List.generate(5, (index) {
//                return InkWell(
//                    onTap: () {
////                      moveToDetail();
//                    },
//                    child: getRecentItem());
//              },
//              ),
//            ),
          )
        ],
      ),
    );
  }

  getRecentItem() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(10),
        right: getSize(20),
        bottom: getSize(20),
      ),
      child: Container(
        padding: EdgeInsets.all(getSize(10)),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          border: Border.all(color: appTheme.textGreyColor),
        ),
        child: Column(
          children: [
           getText("21-10-2020 at 01:43 PM"),
            Divider(height: getSize(20),color: appTheme.textGreyColor,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                  child: Row(
                    children: [
                      getText("Shape", style: appTheme.grey12TextStyle),
                      SizedBox(width: getSize(5),),
                      getText("Round, Pear"),
                    ],
                  ),
                ),
                  Expanded(
                    child: Row(
                      children: [
                        getText("Carat", style: appTheme.grey12TextStyle),
                        SizedBox(width: getSize(5),),
                        getText("7.05, 12.05"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        getText("Color", style: appTheme.grey12TextStyle),
                        SizedBox(width: getSize(5),),
                        getText("D, E, F"),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getTitleText(String title) {
    return Text(
      title,
      style: appTheme.blackNormal18TitleColorblack.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  getViewAll() {
    return Text(
      R.string().screenTitle.viewAll,
      style: appTheme.black14TextStyle.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.colorPrimary,
      ),
    );
  }

  getText(String text, {TextStyle style}) {
    return Text(
      text,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.left,
      style: style ?? appTheme.black12TextStyle,
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

}
