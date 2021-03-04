import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondGridItemWidget extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;
  List<Widget> list;
  List<Widget> leftSwipeList;

  DiamondGridItemWidget(
      {this.item, this.actionClick, this.list, this.leftSwipeList});

  @override
  _DiamondGridItemWidgetState createState() => _DiamondGridItemWidgetState();
}

class _DiamondGridItemWidgetState extends State<DiamondGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_ROW));
        widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_DETAIL));
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: getSize(73)),
            decoration: BoxDecoration(
              boxShadow: widget.item.isSelected
                  ? getBoxShadow(context)
                  : [BoxShadow(color: Colors.transparent)],
              color: appTheme.whiteColor,
              // color: Colors.red,
              borderRadius: BorderRadius.circular(getSize(5)),
              border: Border.all(
                  color: widget.item.isSelected
                      ? appTheme.colorPrimary
                      : appTheme.dividerColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // SizedBox(
                //   height: getSize(73),
                // ),
                IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(getSize(5)),
                      // border: Border.all(
                      //     color: widget.item.isSelected
                      //         ? appTheme.colorPrimary
                      //         : appTheme.lightBGColor),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(getSize(10)),
                      child: Row(
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: widget.item.isSelected
                          //         ? appTheme.colorPrimary
                          //         : appTheme.lightBGColor,
                          //     borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(5),
                          //         bottomLeft: Radius.circular(5)),
                          //   ),
                          //   width: getSize(48),
                          //   child: Padding(
                          //     padding: EdgeInsets.only(
                          //       top: getSize(8),
                          //       left: getSize(5),
                          //       right: getSize(5),
                          //       bottom: getSize(8),
                          //     ),
                          //     child: Center(
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           widget.actionClick(ManageCLick(
                          //               type:
                          //                   clickConstant.CLICK_TYPE_SELECTION));
                          //         },
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Text(
                          //               widget.item?.crt.toString() ?? "",
                          //               style: appTheme.blue14TextStyle.copyWith(
                          //                 color: widget.item.isSelected
                          //                     ? appTheme.whiteColor
                          //                     : appTheme.colorPrimary,
                          //                 fontSize: getFontSize(12),
                          //               ),
                          //             ),
                          //             Text(
                          //               R.string.commonString.carat,
                          //               style: appTheme.blue14TextStyle.copyWith(
                          //                 color: widget.item.isSelected
                          //                     ? appTheme.whiteColor
                          //                     : appTheme.colorPrimary,
                          //                 fontSize: getFontSize(10),
                          //               ),
                          //             ),
                          //             Container(
                          //               alignment: Alignment.center,
                          //               margin: EdgeInsets.only(top: getSize(5)),
                          //               // width: getSize(55),
                          //               // height: getSize(19),
                          //               decoration: BoxDecoration(
                          //                   color: appTheme.whiteColor,
                          //                   borderRadius: BorderRadius.circular(
                          //                       getSize(5))),
                          //               child: Padding(
                          //                 padding: EdgeInsets.all(getSize(2)),
                          //                 child: Text(
                          //                   widget.item?.back.toString() + " %" ??
                          //                       "",
                          //                   style: appTheme.green10TextStyle
                          //                       .copyWith(
                          //                           fontSize: getFontSize(10)),
                          //                 ),
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                                      Row(
                                        children: [
                                          Container(
                                            width: getSize(6),
                                            height: getSize(6),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: widget.item
                                                    .getStatusColor()),
                                          ),
                                          SizedBox(
                                            width: getSize(2),
                                          ),
                                          getText(widget.item.getStatusText(),
                                              style: appTheme.black12TextStyle
                                                  .copyWith(
                                                      color: widget.item
                                                          .getStatusColor()))
                                        ],
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          PriceUtilities.getPercent(
                                              widget.item?.getFinalDiscount() ??
                                                  0),
                                          style: appTheme.blue12TextStyle
                                              .copyWith(
                                                  color: appTheme.greenColor),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(8),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            getText(widget.item?.vStnId ?? ""),
                                      ),
                                      // getText(widget.item?.shpNm ?? ""),

                                      Text(
                                        PriceUtilities.getDoubleValue(
                                            widget.item?.crt ?? 0),
                                        style: appTheme.blue12TextStyle,
                                        textAlign: TextAlign.right,
                                      ),
                                      Text(
                                        " " + R.string.commonString.carat,
                                        style:
                                            appTheme.blue12TextStyle.copyWith(
                                          fontSize: getFontSize(14),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(8),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child:
                                            getText(widget.item?.shpNm ?? ""),
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
                                    height: getSize(8),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child:
                                            getText(widget.item?.colNm ?? ""),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getText(
                                        widget.item?.clrNm ?? "-",
                                      ),
                                      Row(
                                        children: <Widget>[
                                          getText(
                                            widget.item?.cutNm ?? "-",
                                          ),
                                          SizedBox(width: getSize(2.0)),
                                          Container(
                                            height: getSize(4),
                                            width: getSize(4),
                                            decoration: BoxDecoration(
                                                color: appTheme.dividerColor,
                                                shape: BoxShape.circle),
                                          ),
                                          SizedBox(width: getSize(2.0)),
                                          getText(
                                            widget.item?.polNm ?? "-",
                                          ),
                                          SizedBox(width: getSize(2.0)),
                                          Container(
                                            height: getSize(4),
                                            width: getSize(4),
                                            decoration: BoxDecoration(
                                                color: appTheme.dividerColor,
                                                shape: BoxShape.circle),
                                          ),
                                          SizedBox(width: getSize(2.0)),
                                          getText(
                                            widget.item?.symNm ?? "-",
                                          ),
                                        ],
                                      ),
                                      getText(widget.item?.lbNm ?? ""),
                                      getText(widget.item?.fluNm ?? "",
                                          align: TextAlign.right),
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
    return InkWell(
      onTap: () {
        widget.actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_ROW));
      },
      child: Material(
        // elevation: 10,
        shadowColor: appTheme.shadowColor,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(getSize(75)),
        child: Container(
          width: getSize(146),
          height: getSize(146),
          decoration: BoxDecoration(
              color: appTheme.whiteColor,
              shape: BoxShape.circle,
              boxShadow: widget.item.isSelected
                  ? getBoxShadow(context)
                  : [BoxShadow(color: Colors.transparent)]),
          child: Padding(
            padding: EdgeInsets.all(getSize(0)),
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
      ),
    );
  }

  getText(String text, {TextAlign align, TextStyle style}) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: style == null
          ? appTheme.black12TextStyle.copyWith(
              fontSize: getFontSize(12),
            )
          : style,
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
