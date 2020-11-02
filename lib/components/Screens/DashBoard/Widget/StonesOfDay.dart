import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class StoneOfDayWidget extends StatefulWidget {
  List<DiamondModel> stoneList;

  StoneOfDayWidget({this.stoneList});


  @override
  _StoneOfDayWidgetState createState() => _StoneOfDayWidgetState();
}

class _StoneOfDayWidgetState extends State<StoneOfDayWidget> {
  @override
  Widget build(BuildContext context) {
    return isNullEmptyOrFalse(widget.stoneList)
        ? SizedBox()
        : Padding(
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
              height: getSize(180),
//              child: ListView.builder(
//                itemCount: 5,
//                shrinkWrap: true,
//                scrollDirection: Axis.horizontal,
//                itemBuilder: (BuildContext context, int index) {
//                  return getRecentItem();
//                },
//              )
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              crossAxisCount: 1,
//              childAspectRatio: 0.36,
              // without Price
              childAspectRatio: 0.626, // with Price
//              mainAxisSpacing: 10,
              children: List.generate( widget.stoneList.length, (index) {
                return InkWell(
                    onTap: () {
//                      moveToDetail();
                    },
                    child: getRecentItem(widget.stoneList[index]));
              },
              ),
            ),
              )
        ],
      ),
    );
  }

  getRecentItem(DiamondModel model) {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(10),
        right: getSize(20),
        bottom: getSize(20),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: getSize(10),
          top: getSize(10),),
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
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: getSize(10)),
                      width: getSize(104),
                      height: getSize(83),
                      decoration: BoxDecoration(
                        color: appTheme.textGreyColor,
                        borderRadius: BorderRadius.circular(getSize(2)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(getSize(2)),
                        child: getImageView(
                          "",
                          finalUrl: "",
                          width: getSize(104),
                          height: getSize(83),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: getSize(252),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getSize(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MathUtilities.screenWidth(context) / 8.5,
                                  child: getText(model.vStnId,
                                      style: appTheme.black12TextStyle),
                                ),
                                SizedBox(
                                  width: getSize(3),
                                ),
                                Container(
                                  width: MathUtilities.screenWidth(context) / 10,
                                  child: getText(model.shpNm,
                                      style: appTheme.black12TextStyleMedium),
                                ),
                                SizedBox(
                                  width: getSize(3),
                                ),
                                Container(
                                  width: MathUtilities.screenWidth(context) / 4.5,
                                  child: getText("${model.crt} \n ${R.string().commonString.carat}",
                                      style: appTheme.primaryColor14TextStyle),
                                ),
                                SizedBox(
                                  width: getSize(3),
                                ),
                                Container(
                                  width: MathUtilities.screenWidth(context) / 9,
                                  child:  getText(PriceUtilities.getPercent(model.back),
                                      style: appTheme.blue12TextStyle),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getSize(3),
                            ),
                            Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MathUtilities.screenWidth(context) / 8.5,
                                  child: getText(model.colNm, style: appTheme.black12TextStyle),
                                ),
                                SizedBox(
                                  width: getSize(3),
                                ),
                                Container(
                                  width: MathUtilities.screenWidth(context) / 10,
                                  child:getText(model.clrNm, style: appTheme.black12TextStyle),
                                ),
                                SizedBox(
                                  width: getSize(3),
                                ),
                                Container(
                                  width: MathUtilities.screenWidth(context) / 4.5,
                                  child: getColorClarityLab(model),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: getSize(3)),
                                  alignment: Alignment.centerRight,
                                  width: MathUtilities.screenWidth(context) / 9,
                                  child:  getText(model.lbNm, style: appTheme.black12TextStyle),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                          color: model.getStatusColor(),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      height: getSize(26),
                      width: getSize(4),
                      // color: Colors.red,
                    ),
                  ),
                ),
              ],
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

  getColorClarityLab(DiamondModel model) {
    return Row(
      children: [
        getText(
          model.colNm ?? "",
          style: appTheme.black12TextStyle,
        ),
        getDot(),
        getText(
          model.clrNm ?? "",
          style: appTheme.black12TextStyle,
        ),
        getDot(),
        getText(
          model.lbNm ?? "",
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
