import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondSquareGridItem extends StatefulWidget {
  DiamondModel item;
  ActionClick actionClick;
  List<Widget> list;
  Summary summary;
  int moduleType = DiamondModuleConstant.MODULE_TYPE_DIAMOND_SEARCH_RESULT;

  DiamondSquareGridItem(
      {this.item, this.moduleType, this.summary, this.actionClick, this.list});
  @override
  _DiamondSquareGridItemState createState() => _DiamondSquareGridItemState();
}

class _DiamondSquareGridItemState extends State<DiamondSquareGridItem> {
  num total;
  num piece;
  num avg;
  @override
  void initState() {
    super.initState();
    total = num.tryParse(widget.summary.totalCrt);
    piece = widget.summary.stoneCount;
    avg = total / piece;
    widget.summary.avgSize = PriceUtilities.getDoubleValue(avg).toString();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget
            .actionClick(ManageCLick(type: clickConstant.CLICK_TYPE_SELECTION));
      },
      child: widget.moduleType != DiamondModuleConstant.MODULE_TYPE_LAYOUT
          ? Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(getSize(4)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(
                      color: widget.item.isSelected
                          ? appTheme.colorPrimary
                          : appTheme.dividerColor.withOpacity(0.5),
                    ),
                    color: widget.item.isSelected
                        ? appTheme.lightColorPrimary
                        : appTheme.whiteColor,
                    boxShadow: widget.item.isSelected
                        ? [
                            BoxShadow(
                                color: appTheme.colorPrimary.withOpacity(0.05),
                                blurRadius: getSize(8),
                                spreadRadius: getSize(2),
                                offset: Offset(0, 8)),
                          ]
                        : [BoxShadow(color: Colors.transparent)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: getSize(5)),
                              child: getImageView(
                                widget.item.getDiamondImage(),
                                placeHolderImage: diamond,
                                width: MathUtilities.screenWidth(context),
                                // height: getSize(100),
                              ),
                            ),
                            getFirstRow(),
                            getMiddleRow(),
                            getThirdRow(),
                            getFourthRow(),
                          ],
                        ),
                      ),
                      Container(
                        child: Center(
                            child: Container(
                          decoration: BoxDecoration(
                              color: widget.item.getStatusColor(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          height: getSize(26),
                          width: getSize(4),
                          // color: Colors.red,
                        )),
                      ),
                    ],
                  ),
                ),
                widget.item.isSelected
                    ? Container(
                        alignment: Alignment.center,
                        height: getSize(20),
                        width: getSize(20),
                        decoration: BoxDecoration(
                            color: appTheme.colorPrimary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(getSize(5)),
                              bottomRight: Radius.circular(getSize(5)),
                            )),
                        child: Icon(
                          Icons.check,
                          color: appTheme.whiteColor,
                          size: getSize(15),
                        ),
                      )
                    : SizedBox()
              ],
            )
          : Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(getSize(4)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(
                        color: appTheme.dividerColor.withOpacity(0.5)),
                    color: appTheme.whiteColor,
                    boxShadow: [
                      BoxShadow(
                          color: appTheme.colorPrimary.withOpacity(0.05),
                          blurRadius: getSize(8),
                          spreadRadius: getSize(2),
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getSize(5), bottom: getSize(10)),
                                  child: getImageView(
                                    DiamondUrls.layout +
                                        widget.summary.layoutNo +
                                        ".jpg",
                                    placeHolderImage: diamond,
                                    width: MathUtilities.screenWidth(context),
                                    // height: getSize(100),
                                  ),
                                ),
                              ]),
                        )
                      ]),
                      InkWell(
                        onTap: () {
                          Map<String, dynamic> dict =
                              new Map<String, dynamic>();
                          dict[ArgumentConstant.ModuleType] =
                              DiamondModuleConstant.MODULE_TYPE_INNER_LAYOUT;
                          dict["filterId"] = widget.summary.layoutNo;
                          NavigationUtilities.pushRoute(DiamondListScreen.route,
                              args: dict);
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                getLayoutFirstRow(),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                getLayoutMiddleRow(),
                              ],
                            )
                          ],
                        ),
                      ),

                      // getFirstRow(),
                      // getMiddleRow(),
                      // getThirdRow(),
                      // getFourthRow(),
                    ],
                  ),
                ),
              ],
            ),
    );
    // widget.item.isSelected
    //     ? Container(
    //         alignment: Alignment.center,
    //         height: getSize(20),
    //         width: getSize(20),
    //         decoration: BoxDecoration(
    //             color: appTheme.colorPrimary,
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(getSize(5)),
    //               bottomRight: Radius.circular(getSize(5)),
    //             )),
    //         child: Icon(
    //           Icons.check,
    //           color: appTheme.whiteColor,
    //           size: getSize(15),
    //         ),
    //       )
    //     : SizedBox()
  }

  getText16(String text, {TextAlign align, TextStyle style}) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: style == null
          ? appTheme.black16TextStyle.copyWith(
              fontSize: getFontSize(16),
            )
          : style,
    );
  }

  getFirstRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(8),
        bottom: getSize(4),
      ),
      child: Row(
        children: [
          getText(widget.item?.vStnId ?? ""),
          Expanded(child: Container()),
          getText(widget.item?.shpNm ?? ""),
          Expanded(child: Container()),
          Text(PriceUtilities.getPercent(widget.item?.getFinalDiscount() ?? 0),
              style: appTheme.blue12TextStyle),
        ],
      ),
    );
  }

  getLayoutFirstRow() {
    return Padding(
      padding: EdgeInsets.only(
          top: getSize(8), bottom: getSize(4), left: getSize(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Shape: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.shapes ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Avg. Size: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.avgSize ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Color: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.colRange ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Clarity: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.clrRange ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Floro: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.fluRange ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Layout No: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.layoutNo ?? ""),
            ],
          ),
        ],
      ),
    );
  }

  getMiddleRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(4),
        bottom: getSize(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PriceUtilities.getDoubleValue(widget.item?.crt ?? 0),
            style: appTheme.blue16TextStyle,
          ),
          SizedBox(
            width: getSize(5),
          ),
          Text(
            R.string.commonString.carat,
            style: appTheme.blue12TextStyle,
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          getText(widget.item?.colNm ?? ""),
          Expanded(child: Container()),
          getText(widget.item?.clrNm ?? ""),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  getLayoutMiddleRow() {
    return Padding(
      padding: EdgeInsets.only(
          top: getSize(8), bottom: getSize(4), right: getSize(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Total Weight: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.totalCrt + " Ct" ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "No. of Pcs: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.stoneCount.toString() ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Avg. Rapaport: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.avgRap ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Avg Disc in %: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.avgBack ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Avg Rate in $dollar: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.avgCtPr ?? ""),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "Total Amt in $dollar: ",
                style: appTheme.blue16BoldTextStyle,
              ),
              getText16(widget.summary?.totalAmt ?? ""),
            ],
          ),
        ],
      ),
    );
  }

  getThirdRow() {
    return Center(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: getSize(4),
            bottom: getSize(4),
          ),
          child: Row(
            children: [
              getText(widget.item?.cutNm ?? ""),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              getText(widget.item?.polNm ?? ""),
              Container(
                height: getSize(4),
                width: getSize(4),
                decoration: BoxDecoration(
                    color: appTheme.dividerColor, shape: BoxShape.circle),
              ),
              getText(widget.item?.symNm ?? ""),
              Expanded(child: Container()),
              getAmountText(widget.item?.getPricePerCarat() ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  getFourthRow() {
    return Padding(
        padding: EdgeInsets.only(
          top: getSize(4),
          bottom: getSize(4),
        ),
        child: Row(
          children: [
            getText(widget.item?.lbNm ?? ""),
            Expanded(child: Container()),
            getAmountText(widget.item?.getAmount() ?? ""),
          ],
        ));
  }

  getText(String text) {
    return Text(
      text,
      style: appTheme.black12TextStyle,
    );
  }

  getPrimaryText(String text) {
    return Text(
      text,
      style: appTheme.primary16TextStyle,
    );
  }

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.blue14TextStyle,
    );
  }
}
