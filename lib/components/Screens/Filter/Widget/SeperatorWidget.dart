import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/cupertino.dart';

class SeperatorWidget extends StatefulWidget {
  SeperatorModel seperatorModel;

  SeperatorWidget(this.seperatorModel);

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
      child: widget.seperatorModel.isExpand
          ? getExpandWidet()
          : Container(
        color: widget.seperatorModel.color,
        height: getSize(
            double.parse(widget.seperatorModel.height.toString())),
      ),
    );
  }

  getExpandWidet() {
    return Container(
      color: appTheme.blackColor,
      height: getSize(
          double.parse(widget.seperatorModel.height.toString())),
    );
  }

}
