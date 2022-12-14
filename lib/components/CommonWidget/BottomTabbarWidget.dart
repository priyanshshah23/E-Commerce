import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/material.dart';

typedef OnClickBottomMenu(BottomTabModel type);

class BottomTabbarWidget extends StatefulWidget {
  List<BottomTabModel> arrBottomTab;

  OnClickBottomMenu onClickCallback;

  BottomTabbarWidget({this.arrBottomTab, this.onClickCallback});

  @override
  _BottomTabbarWidgetState createState() => _BottomTabbarWidgetState();
}

class _BottomTabbarWidgetState extends State<BottomTabbarWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.arrBottomTab != null && widget.arrBottomTab.length > 0) {
      return SafeArea(
        child: Container(
          height: getSize(60),
          color: appTheme.colorPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < widget.arrBottomTab.length; i++)
                Container(
                  //padding: EdgeInsets.symmetric(horizontal: getSize(10)),
                  width: MathUtilities.screenWidth(context) /
                      widget.arrBottomTab.length,
                  color: widget.arrBottomTab[i].getBackgroundColor(),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (widget.onClickCallback != null) {
                          widget.onClickCallback(widget.arrBottomTab[i]);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.arrBottomTab[i].isCenter
                              ? Container(
                                  // color:
                                  //     arrBottomTab[i].centerImageBackgroundColor,
                                  // color: Colors.white,
                                  decoration: new BoxDecoration(
                                    color: widget.arrBottomTab[i]
                                        .getCenterImageBackgroundColor(),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  width: getSize(40),
                                  height: getSize(40),
                                  child: Center(
                                    child: Image.asset(
                                      widget.arrBottomTab[i].image,
                                      width: getSize(20),
                                      height: getSize(20),
                                    ),
                                  ))
                              : Image.asset(
                                  widget.arrBottomTab[i].image,
                                  color: widget.arrBottomTab[i].color != null
                                      ? widget.arrBottomTab[i].color
                                      : null,
                                  width: getSize(20),
                                  height: getSize(20),
                                ),
                          if (widget.arrBottomTab[i].isCenter == false)
                            SizedBox(
                              height: i == 0 ? getSize(10) : getSize(8),
                            ),
                          if (widget.arrBottomTab[i].isCenter == false)
                            Padding(
                              padding: EdgeInsets.only(
                                left: i == 0 ? getSize(5) : getSize(0),
                                right: i == widget.arrBottomTab.length - 1
                                    ? getSize(5)
                                    : getSize(0),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.arrBottomTab[i].title,
                                  style: appTheme.getTabbarTextStyle(
                                      textColor: widget.arrBottomTab[i]
                                          .getTextColor()),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
