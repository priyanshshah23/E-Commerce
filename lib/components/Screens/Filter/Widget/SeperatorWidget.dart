import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/cupertino.dart';

class SeperatorWidget extends StatefulWidget {
  SeperatorModel seperatorModel;
  Function(SeperatorModel) callBack;

  SeperatorWidget(this.seperatorModel, {this.callBack});

  @override
  _SeperatorWidget createState() => _SeperatorWidget();
}

class _SeperatorWidget extends State<SeperatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getSize(
              double.parse(widget.seperatorModel.leftPadding.toString())),
          right: getSize(
              double.parse(widget.seperatorModel.rightPadding.toString())),
          top: getSize(
              double.parse(widget.seperatorModel.topPadding.toString())),
          bottom: getSize(
              double.parse(widget.seperatorModel.bottomPadding.toString()))),
      child: widget.seperatorModel.filterName != ""
          ? getExpandWidet()
          : Container(
              color: widget.seperatorModel.color,
              height: getSize(
                double.parse(
                  widget.seperatorModel.height.toString(),
                ),
              ),
            ),
    );
  }

  getExpandWidet() {
    return GestureDetector(
      onTap: () => widget.callBack(widget.seperatorModel),
      child: Container(
        // color: appTheme.blackColor,
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: widget.seperatorModel.color))),
        height: getSize(52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: getSize(16),
                top: getSize(16),
                left: getSize(16),
              ),
              child: Text(
                widget.seperatorModel.filterName,
                style: appTheme.black16MediumTextStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: getSize(16)),
              child: Container(
                height: getSize(16),

                width: getSize(16),
                child: widget.seperatorModel.isExpand
                    ? Image.asset(downArrow)
                    : Image.asset(upArrow),
                // child: items[index].isSelected
                //     ? Image.asset(selectedIcon)
                //     : Image.asset(unselectedIcon),
              ),
            )
          ],
        ),
      ),
    );
  }
}
