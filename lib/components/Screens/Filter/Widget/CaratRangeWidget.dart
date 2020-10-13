import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaratRangeWidget extends StatefulWidget {
  SelectionModel selectionModel;
  CaratRangeWidget(this.selectionModel);

  @override
  _CaratRangeWidgetState createState() => _CaratRangeWidgetState();
}

class _CaratRangeWidgetState extends State<CaratRangeWidget> {
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  var _focusMinValue = FocusNode();
  var _focusMaxValue = FocusNode();
  String oldValueForFrom;
  String oldValueForTo;

  @override
  void initState() {
    super.initState();
    widget.selectionModel.title = "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          Text(
            "Carat Range",
            style: appTheme.blackNormal18TitleColorblack,
            textAlign: TextAlign.left,
          ),
          Spacer(),
          getFromTextField(),
          SizedBox(width: getSize(16)),
          getToTextField(),
          SizedBox(width: getSize(16)),
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: appTheme.colorPrimary,
                borderRadius: BorderRadius.circular(
                  getSize(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image.asset(
                    plusIcon,
                    width: getSize(16),
                    height: getSize(16),
                  ),
                ),
              ),
            ),
          )
        ]),
        SizedBox(height: getSize(16)),
        SelectionWidget(widget.selectionModel)
      ],
    );
  }

  getFromTextField() {
    return Container(
      width: getSize(100),
      height: getSize(30),
      child: TextField(
        textAlign: widget.selectionModel.fromToStyle.showUnderline
            ? TextAlign.left
            : TextAlign.center,
        onChanged: (value) {
          oldValueForFrom = _minValueController.text.trim();
        },
        onSubmitted: (value) {},
        focusNode: _focusMinValue,
        controller: _minValueController,
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) =>
              RegExp(r'(^[+-]?\d*.?\d{0,2})$').hasMatch(newValue.text)
                  ? newValue
                  : oldValue)
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: widget.selectionModel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.selectionModel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          enabledBorder: widget.selectionModel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.selectionModel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          hintText: "From",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }

  getToTextField() {
    return Container(
      width: getSize(100),
      height: getSize(30),
      child: TextField(
        textAlign: widget.selectionModel.fromToStyle.showUnderline
            ? TextAlign.left
            : TextAlign.center,
        onChanged: (value) {
          oldValueForTo = _maxValueController.text.trim();
        },
        focusNode: _focusMaxValue,
        controller: _maxValueController,
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) =>
              RegExp(r'(^[+-]?\d*.?\d{0,2})$').hasMatch(newValue.text)
                  ? newValue
                  : oldValue)
        ],
        onSubmitted: (value) {},
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: widget.selectionModel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.selectionModel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          enabledBorder: widget.selectionModel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.selectionModel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          hintText: "To",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }
}
