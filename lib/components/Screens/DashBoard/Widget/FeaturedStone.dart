import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class FeaturedStoneWidget extends StatefulWidget {
  List<DiamondModel> diamondList;

  FeaturedStoneWidget({this.diamondList});

  @override
  _FeaturedStoneWidgetState createState() => _FeaturedStoneWidgetState();
}

class _FeaturedStoneWidgetState extends State<FeaturedStoneWidget> {
  @override
  Widget build(BuildContext context) {
    return isNullEmptyOrFalse(widget.diamondList)
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(
              top: getSize(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: getSize(Spacing.leftPadding),
                    right: getSize(Spacing.rightPadding),
                  ),
                  child: Row(
                    children: [
                      getTitleText(R.string.screenTitle.newArrival),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Map<String, dynamic> dict = new HashMap();
                          dict[ArgumentConstant.ModuleType] =
                              DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL;
                          dict[ArgumentConstant.IsFromDrawer] = false;
                          NavigationUtilities.pushRoute(DiamondListScreen.route,
                              args: dict);
                        },
                        child: getViewAll(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getSize(8),
                ),
                Container(
                  height: widget.diamondList.length > 1
                      ? getSize(170)
                      : getSize(85),
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    crossAxisCount: widget.diamondList.length > 1 ? 2 : 1,
//              childAspectRatio: 0.36,
                    // without Price
                    childAspectRatio: 0.23,
                    // with Price
                    mainAxisSpacing: 15,
                    children: List.generate(
                      widget.diamondList.length,
                      (index) {
                        return InkWell(
                            onTap: () {
                              moveToDetail(widget.diamondList[index]);
                            },
                            child: getRecentItem(widget.diamondList[index]));
                      },
                    ),
                  ),
                )
              ],
            ),
          );
  }

  moveToDetail(DiamondModel model) {
    var dict = Map<String, dynamic>();
    dict[ArgumentConstant.DiamondDetail] = model;
    dict[ArgumentConstant.ModuleType] = DiamondModuleConstant.MODULE_TYPE_HOME;
    NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
  }

  getRecentItem(DiamondModel model) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getSize(20),
        left: getSize(Spacing.leftPadding),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: getSize(10),
          top: getSize(10),
          bottom: getSize(10),
        ),
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
                Container(
                  width: getSize(49),
                  height: getSize(39),
                  decoration: BoxDecoration(
                    color: appTheme.textGreyColor,
                    borderRadius: BorderRadius.circular(getSize(2)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(getSize(2)),
                    child: getImageView(
                      model.getDiamondImage(),
                      width: getSize(49),
                      height: getSize(39),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: getSize(280),
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
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: MathUtilities.screenWidth(context) / 8.5,
                                child: getText(model.vStnId,
                                    style: appTheme.black12TextStyle),
                              ),
                            ),
                            SizedBox(
                              width: getSize(3),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: MathUtilities.screenWidth(context) / 10,
                                child: getText(model.shpNm,
                                    style: appTheme.black12TextStyleMedium),
                              ),
                            ),
                            SizedBox(
                              width: getSize(3),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: MathUtilities.screenWidth(context) / 4.5,
                                child: getText(
                                    "${PriceUtilities.getDoubleValue(model.crt)} Ct",
                                    style: appTheme.primaryColor14TextStyle),
                              ),
                            ),
                            SizedBox(
                              width: getSize(3),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: MathUtilities.screenWidth(context) / 9,
                                child: getText(
                                    PriceUtilities.getPercent(model.back),
                                    style: appTheme.blue12TextStyle),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getSize(5),
                        ),
                        Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: MathUtilities.screenWidth(context) / 8.5,
                                child: getText(model.colNm,
                                    style: appTheme.black12TextStyle),
                              ),
                            ),
                            SizedBox(
                              width: getSize(3),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: MathUtilities.screenWidth(context) / 10,
                                child: getText(model.clrNm,
                                    style: appTheme.black12TextStyle),
                              ),
                            ),
                            SizedBox(
                              width: getSize(3),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                width: MathUtilities.screenWidth(context) / 4.5,
                                child: getCutPolSynData(model),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(right: getSize(3)),
                                alignment: Alignment.centerRight,
                                width: MathUtilities.screenWidth(context) / 9,
                                child: getText(model.lbNm,
                                    style: appTheme.black12TextStyle),
                              ),
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
      R.string.screenTitle.viewAll,
      style: appTheme.black14TextStyle.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.colorPrimary,
      ),
    );
  }

  getCutPolSynData(DiamondModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getText(
          model.cutNm ?? "-",
          style: appTheme.black12TextStyle,
        ),
        getDot(),
        getText(
          model.polNm ?? "-",
          style: appTheme.black12TextStyle,
        ),
        getDot(),
        getText(
          model.symNm ?? "-",
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
