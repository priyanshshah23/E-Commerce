import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/material.dart';

class DiamondGridItemWidget extends StatefulWidget {
  DiamondModel item;

  DiamondGridItemWidget({this.item});

  @override
  _DiamondGridItemWidgetState createState() => _DiamondGridItemWidgetState();
}

class _DiamondGridItemWidgetState extends State<DiamondGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                top: getSize(16), left: getSize(26), right: getSize(26)),
            child: Center(
              child: Image.asset(
                diamond,
                height: getSize(96),
              ),
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
                            "Carat",
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
                SizedBox(
                  width: getSize(2),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          getText(widget.item?.vStnId ?? ""),
                          // Expanded(child: Container()),
                          Spacer(),
                          getAmountText(widget.item?.getPricePerCarat() ?? "-"),
                        ],
                      ),
                      SizedBox(
                        height: getSize(8),
                      ),
                      Row(
                        children: [
                          getText(widget.item?.shpNm ?? ""),
                          Spacer(),
                          getAmountText(widget.item?.getAmount() ?? "-"),
                        ],
                      ),
                      SizedBox(
                        height: getSize(8),
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
                        height: getSize(4),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5))),
                                width: getSize(26),
                                height: getSize(4),
                                // color: Colors.red,
                              ),
                            ),
                          ),
                          Spacer(),
                          Spacer(),
                        ],
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
      text.replaceAll(RegExp(r"([.]*00)(?!.*\d)"), ""),
      // text,
      style: appTheme.blue14TextStyle.copyWith(fontSize: getFontSize(10)),
    );
  }
}
