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
          left: double.parse(widget.seperatorModel.leftPadding.toString()),
          right: double.parse(widget.seperatorModel.rightPadding.toString()),
          top: getSize(16),
          bottom: getSize(16)),
      child: Container(
        color: widget.seperatorModel.color,
        height: getSize(
          double.parse(widget.seperatorModel.height.toString()),
        ),
      ),
    );
  }
}
