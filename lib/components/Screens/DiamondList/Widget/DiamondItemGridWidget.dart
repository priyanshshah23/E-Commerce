import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondGridItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;

  DiamondGridItemWidget({this.item, this.actionClick});

  @override
  _DiamondGridItemWidgetState createState() => _DiamondGridItemWidgetState();
}

class _DiamondGridItemWidgetState extends State<DiamondGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: getSize(75)),
            decoration: BoxDecoration(
              color: appTheme.whiteColor,
              borderRadius: BorderRadius.circular(getSize(5)),
              border: Border.all(
                  color: appTheme.dividerColor),
            ),
            child: Column(
              children: [
                Expanded(child: SizedBox()),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.item.isSelected
                              ? appTheme.colorPrimary
                              : appTheme.lightBGColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                        ),
                        width: getSize(48),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: getSize(8),
                            left: getSize(5),
                            right: getSize(5),
                            bottom: getSize(5),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                widget.actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_SELECTION));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    widget.item?.crt.toString() ?? "",
                                    style: appTheme.blue14TextStyle.copyWith(
                                      color: widget.item.isSelected
                                          ? appTheme.whiteColor
                                          : appTheme.colorPrimary,
                                      fontSize: getFontSize(12),
                                    ),
                                  ),
                                  Text(
                                    R.string().commonString.carat,
                                    style: appTheme.blue14TextStyle.copyWith(
                                      color: widget.item.isSelected
                                          ? appTheme.whiteColor
                                          : appTheme.colorPrimary,
                                      fontSize: getFontSize(10),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: getSize(5)),
                                    // width: getSize(55),
                                    // height: getSize(19),
                                    decoration: BoxDecoration(
                                        color: appTheme.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(getSize(5))),
                                    child: Padding(
                                      padding: EdgeInsets.all(getSize(2)),
                                      child: Text(
                                        widget.item?.back.toString() + " %" ?? "",
                                        style: appTheme.green10TextStyle
                                            .copyWith(fontSize: getFontSize(8)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getSize(2),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: getSize(4),
                              ),
                              Row(
                                children: [
                                  getText(widget.item?.vStnId ?? ""),
                                  // Expanded(child: Container()),
                                  Spacer(),
                                  getAmountText(
                                      widget.item?.getPricePerCarat() ?? ""),
                                ],
                              ),
                              SizedBox(
                                height: getSize(6),
                              ),
                              Row(
                                children: [
                                  getText(widget.item?.shpNm ?? ""),
                                  Spacer(),
                                  getAmountText(widget.item?.getAmount() ?? ""),
                                ],
                              ),
                              SizedBox(
                                height: getSize(6),
                              ),
                              Row(
                                children: <Widget>[
                                  getText(widget.item?.colNm ?? ""),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: getSize(5),
                                      right: getSize(5),
                                    ),
                                    child: getText(widget.item?.clrNm ?? ""),
                                  ),
                                  getText(widget.item?.cutNm ?? ""),
                                  Container(
                                    height: getSize(4),
                                    width: getSize(4),
                                    decoration: BoxDecoration(
                                        color: appTheme.dividerColor,
                                        shape: BoxShape.circle),
                                  ),
                                  getText(widget.item?.polNm ?? ""),
                                  Container(
                                    height: getSize(4),
                                    width: getSize(4),
                                    decoration: BoxDecoration(
                                        color: appTheme.dividerColor,
                                        shape: BoxShape.circle),
                                  ),
                                  getText(widget.item?.symNm ?? ""),
                                  // SizedBox(
                                  //   width: getSize(6),
                                  // ),
                                  Spacer(),
                                  getText(widget.item?.lbNm ?? "")
                                ],
                              ),
                              SizedBox(
                                height: getSize(8),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getSize(2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          getDiamondImageView()
        ],
      ),
    );return GestureDetector(
      onTap: () {
        widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_ROW));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(
                    color: widget.item.isSelected
                        ? appTheme.colorPrimary
                        : appTheme.dividerColor)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: getSize(16),
                  ),
                  // left: getSize(26), right: getSize(26)
                  child: Center(
                    child: getImageView(
                      widget.item.getDiamondImage(),
                      placeHolderImage: diamond,
                      width: MathUtilities.screenWidth(context),
                      height: getSize(96),
                    ),
                    // child: Image.asset(
                    //   diamond,
                    //   height: getSize(96),
                    // ),
                  ),
                ),
                SizedBox(
                  height: getSize(4),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: appTheme.whiteColor,
                      borderRadius: BorderRadius.circular(getSize(5)),
                      border: Border.all(color: appTheme.lightBGColor)
                      //boxShadow: getBoxShadow(context),
                      ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.item.isSelected
                              ? appTheme.colorPrimary
                              : appTheme.lightBGColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                        ),
                        width: getSize(48),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: getSize(8),
                            left: getSize(5),
                            right: getSize(5),
                            bottom: getSize(5),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                widget.actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_SELECTION));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    widget.item?.crt.toString() ?? "",
                                    style: appTheme.blue14TextStyle.copyWith(
                                      color: widget.item.isSelected
                                          ? appTheme.whiteColor
                                          : appTheme.colorPrimary,
                                      fontSize: getFontSize(12),
                                    ),
                                  ),
                                  Text(
                                    R.string().commonString.carat,
                                    style: appTheme.blue14TextStyle.copyWith(
                                      color: widget.item.isSelected
                                          ? appTheme.whiteColor
                                          : appTheme.colorPrimary,
                                      fontSize: getFontSize(10),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: getSize(5)),
                                    // width: getSize(55),
                                    // height: getSize(19),
                                    decoration: BoxDecoration(
                                        color: appTheme.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(getSize(5))),
                                    child: Padding(
                                      padding: EdgeInsets.all(getSize(2)),
                                      child: Text(
                                        widget.item?.back.toString() + " %" ??
                                            "",
                                        style: appTheme.green10TextStyle
                                            .copyWith(fontSize: getFontSize(8)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getSize(2),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: getSize(4),
                            ),
                            Row(
                              children: [
                                getText(widget.item?.vStnId ?? ""),
                                // Expanded(child: Container()),
                                Spacer(),
                                getAmountText(
                                    widget.item?.getPricePerCarat() ?? ""),
                              ],
                            ),
                            SizedBox(
                              height: getSize(6),
                            ),
                            Row(
                              children: [
                                getText(widget.item?.shpNm ?? ""),
                                Spacer(),
                                getAmountText(widget.item?.getAmount() ?? ""),
                              ],
                            ),
                            SizedBox(
                              height: getSize(6),
                            ),
                            Row(
                              children: <Widget>[
                                getText(widget.item?.colNm ?? ""),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getSize(5),
                                    right: getSize(5),
                                  ),
                                  child: getText(widget.item?.clrNm ?? ""),
                                ),
                                getText(widget.item?.cutNm ?? ""),
                                Container(
                                  height: getSize(4),
                                  width: getSize(4),
                                  decoration: BoxDecoration(
                                      color: appTheme.dividerColor,
                                      shape: BoxShape.circle),
                                ),
                                getText(widget.item?.polNm ?? ""),
                                Container(
                                  height: getSize(4),
                                  width: getSize(4),
                                  decoration: BoxDecoration(
                                      color: appTheme.dividerColor,
                                      shape: BoxShape.circle),
                                ),
                                getText(widget.item?.symNm ?? ""),
                                // SizedBox(
                                //   width: getSize(6),
                                // ),
                                Spacer(),
                                getText(widget.item?.lbNm ?? "")
                              ],
                            ),
                            SizedBox(
                              height: getSize(8),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getSize(2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: widget.item.getStatusColor(),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                width: getSize(26),
                height: getSize(4),
                // color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }


  getDiamondImageView() {
    return Material(
      elevation: 12,
      shadowColor: appTheme.shadowColor,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(getSize(75)),
      child: Container(
        width: getSize(150),
        height: getSize(150),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(10)),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(getSize(75))),
                                  child: getImageView(
                                    widget.item.getDiamondImage(),
//                                    finalUrl: model.img
//                                        ? DiamondUrls.image +
//                                        model.vStnId +
//                                        ".jpg"
//                                        : "",
                                  placeHolderImage: diamond,
                                  ),
          ),
        ),
      ),
    );
  }

  getText(String text) {
    return Text(
      text,
      style: appTheme.black12TextStyle.copyWith(
        fontSize: getFontSize(10),
      ),
    );
  }

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(10)),
    );
  }
}
