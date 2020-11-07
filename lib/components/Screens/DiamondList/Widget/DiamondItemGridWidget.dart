import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondGridItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;
  List<Widget> list;

  DiamondGridItemWidget({this.item, this.actionClick, this.list});

  @override
  _DiamondGridItemWidgetState createState() => _DiamondGridItemWidgetState();
}

class _DiamondGridItemWidgetState extends State<DiamondGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_ROW));
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: getSize(75)),
            decoration: BoxDecoration(
              boxShadow: widget.item.isSelected
                  ? getBoxShadow(context)
                  : [BoxShadow(color: Colors.transparent)],
              color: appTheme.whiteColor,
              borderRadius: BorderRadius.circular(getSize(5)),
              border: Border.all(color: appTheme.dividerColor.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Expanded(child: SizedBox()),
                IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(getSize(5)),
                      border: Border.all(
                          color: widget.item.isSelected
                              ? appTheme.colorPrimary
                              : appTheme.lightBGColor),
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
                              bottom: getSize(8),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  widget.actionClick(ManageCLick(
                                      type:
                                          clickConstant.CLICK_TYPE_SELECTION));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          borderRadius: BorderRadius.circular(
                                              getSize(5))),
                                      child: Padding(
                                        padding: EdgeInsets.all(getSize(2)),
                                        child: Text(
                                          widget.item?.back.toString() + " %" ??
                                              "",
                                          style: appTheme.green10TextStyle
                                              .copyWith(
                                                  fontSize: getFontSize(10)),
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
                            //  color: Colors.red,
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
                                    Expanded(
                                      flex: 6,
                                      child: getText(widget.item?.vStnId ?? ""),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: getText(widget.item?.shpNm ?? ""),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: getSize(6),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: getText(widget.item?.colNm ?? ""),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: getAmountText(
                                        widget.item?.getPricePerCarat() ?? "",
                                        align: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: getSize(6),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: getText(widget.item?.clrNm ?? ""),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: getAmountText(
                                        widget.item?.getAmount() ?? "",
                                        align: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: getSize(8),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
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
                                      Spacer(),
                                      getText(widget.item?.lbNm ?? ""),
                                    ],
                                  ),
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
                ),
              ],
            ),
          ),
          getDiamondImageView()
        ],
      ),
    );
  }

  getDiamondImageView() {
    return Material(
      elevation: 10,
      shadowColor: appTheme.shadowColor,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(getSize(75)),
      child: Container(
        width: getSize(140),
        height: getSize(140),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(getSize(75))),
            child: getImageView(widget.item.getDiamondImage(),
//                                    finalUrl: model.img
//                                        ? DiamondUrls.image +
//                                        model.vStnId +
//                                        ".jpg"
//                                        : "",
                placeHolderImage: diamond,
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  getText(String text, {TextAlign align}) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: appTheme.black12TextStyle.copyWith(
        fontSize: getFontSize(12),
      ),
    );
  }

  getAmountText(String text, {TextAlign align}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: align ?? TextAlign.left,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(12)),
    );
  }
}
