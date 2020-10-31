import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:flutter/material.dart';

class StoneOfDayWidget extends StatefulWidget {
  @override
  _StoneOfDayWidgetState createState() => _StoneOfDayWidgetState();
}

class _StoneOfDayWidgetState extends State<StoneOfDayWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              getTitleText(R.string().screenTitle.stoneOfDay),
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
              height: getSize(200),
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return getRecentItem();
                },
              )
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
          boxShadow: [
            BoxShadow(
              color: appTheme.textGreyColor.withOpacity(0.2),
              blurRadius: getSize(10),
              spreadRadius: getSize(8),
              offset: Offset(3, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(getSize(5)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: getSize(14)),
              width: getSize(104),
              height: getSize(83),
              decoration: BoxDecoration(
                color: appTheme.textGreyColor,
                borderRadius: BorderRadius.circular(getSize(2)),
              ),
              child: Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(getSize(2)),
                  child: getImageView(
                    "",
                    finalUrl: "",
                    width: getSize(85),
                    height: getSize(65),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: getSize(250),
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: getSize(10),
                  right: getSize(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getText("191071", style: appTheme.black12TextStyle),
                        SizedBox(height: getSize(5),),
                        getText("D", style: appTheme.black12TextStyle),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getText("ROUND", style: appTheme.black12TextStyleMedium),
                        SizedBox(height: getSize(5),),
                        getText("IF", style: appTheme.black12TextStyle),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getText("12.50 Carat", style: appTheme.primaryColor14TextStyle),
                        SizedBox(height: getSize(5),),
                        getColorClarityLab(),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getText("-44.03%", style: appTheme.blue12TextStyle),
                        SizedBox(height: getSize(5),),
                        getText("GIA",style: appTheme.black12TextStyle),
                      ],
                    )
                  ],
                ),
              ),
            ),
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

  getColorClarityLab() {
    return Row(
      children: [
        getText(
          "123",
          style: appTheme.black12TextStyle,
        ),
        getDot(),
        getText(
          "456",
          style: appTheme.black12TextStyle,
        ),
        getDot(),
        getText(
          "789",
          style: appTheme.black12TextStyle,
        ),
      ],
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
