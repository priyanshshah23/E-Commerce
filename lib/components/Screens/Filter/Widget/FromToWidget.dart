import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';

class FromToWidget extends StatefulWidget {
  static const route = "SearchComponent";
  FromToModel fromTomodel;

  FromToWidget(this.fromTomodel);

  @override
  _FromToWidgetState createState() => _FromToWidgetState();
}

class _FromToWidgetState extends State<FromToWidget> {
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  var _focusMinValue = FocusNode();
  var _focusMaxValue = FocusNode();
  String oldValueForFrom;
  String oldValueForTo;

  @override
  void initState() {
    super.initState();
    _minValueController.text = widget.fromTomodel.valueFrom;
    _maxValueController.text = widget.fromTomodel.valueTo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.fromTomodel?.title ?? "-",
              style: appTheme.blackMedium16TitleColorblack,
            ),
            !widget.fromTomodel.fromToStyle.showUnderline
                ? SizedBox(height: getSize(16))
                : SizedBox(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: getSize(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(getSize(5)),
                      border: Border.all(
                        width: getSize(1.0),
                        color: widget.fromTomodel.fromToStyle.showUnderline
                            ? Colors.transparent
                            : appTheme.borderColor,
                      ),
                    ),
                    child: Center(child: getFromTextFieldWithPadding()),
                  ),
                ),
                SizedBox(
                  width: getSize(15),
                ),
                Expanded(
                  child: Container(
                    height: getSize(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(getSize(5)),
                      border: Border.all(
                        width: getSize(1.0),
                        color: widget.fromTomodel.fromToStyle.showUnderline
                            ? Colors.transparent
                            : appTheme.borderColor,
                      ),
                    ),
                    child: Center(child: getToTextFieldWithPadding()),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getSize(12),
            ),
          ],
        ),
      ],
    );
  }

  getFromTextFieldWithPadding() {
    if (widget.fromTomodel.fromToStyle.showUnderline) {
      return getFromTexteField();
    }
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(8),
        right: getSize(8),
      ),
      child: getFromTexteField(),
    );
  }

  getToTextFieldWithPadding() {
    if (widget.fromTomodel.fromToStyle.showUnderline) {
      return getToTextField();
    }
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(8),
        right: getSize(8),
      ),
      child: getToTextField(),
    );
  }

  getFromTexteField() {
    return Focus(
      onFocusChange: (hasfocus) {
        if (hasfocus == false) {
          if (_minValueController.text.isNotEmpty &&
              _maxValueController.text.isNotEmpty) {
            if (num.parse(_minValueController.text.trim()) <=
                num.parse(_maxValueController.text.trim())) {
              // app.resolve<CustomDialogs>().confirmDialog(
              //       context,
              //       title: "Value Error",
              //       desc: "okay",
              //       positiveBtnTitle: "Try Again",
              //     );
            } else {
              app.resolve<CustomDialogs>().confirmDialog(
                    context,
                    title: "",
                    desc: R.string().errorString.fromValueGreateThanTo,
                    positiveBtnTitle: R.string().commonString.ok,
                  );
              _minValueController.text = "";
              setState(() {});
            }
          }
        }
        // Focus.of(context).unfocus();
      },
      child: TextField(
        textAlign: widget.fromTomodel.fromToStyle.showUnderline
            ? TextAlign.left
            : TextAlign.center,
        onChanged: (value) {
          if (value != null || value != "") {
            if (num.parse(value) < widget.fromTomodel.minValue ||
                num.parse(value) > widget.fromTomodel.maxValue) {
              if (oldValueForFrom != null || oldValueForFrom != "") {
                _minValueController.text = oldValueForFrom;
                _minValueController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _minValueController.text.length));
              }
            }
          }

          oldValueForFrom = _minValueController.text.trim();
          widget.fromTomodel.valueFrom = oldValueForFrom;
          print("=======>>" + oldValueForFrom);
        },
        onSubmitted: (value) {},
        focusNode: _focusMinValue,
        controller: _minValueController,
        inputFormatters: [
          // old regx = r'(^[+-]?\d*.?\d{0,2})$'
          TextInputFormatter.withFunction((oldValue, newValue) =>
              // RegExp(r'(^[+-]?[0-9]+\d*.?\d{0,2})$').hasMatch(newValue.text)
              //     ? newValue
              //     : oldValue)

              // new regx = ^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$
              RegExp(r'^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$')
                      .hasMatch(newValue.text)
                  ? newValue
                  : oldValue)
        ],
        style: appTheme.blackNormal14TitleColorblack,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: widget.fromTomodel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.fromTomodel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          enabledBorder: widget.fromTomodel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.fromTomodel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          hintText: widget.fromTomodel?.labelFrom ?? "-",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }

  getToTextField() {
    return Focus(
      onFocusChange: (hasfocus) {
        if (hasfocus == false) {
          if (_minValueController.text.isNotEmpty &&
              _maxValueController.text.isNotEmpty) {
            if (num.parse(_minValueController.text.trim()) <=
                num.parse(_maxValueController.text.trim())) {
              // app.resolve<CustomDialogs>().confirmDialog(
              //       context,
              //       title: "Value Error",
              //       desc: "okay",
              //       positiveBtnTitle: "Try Again",
              //     );
            } else {
              app.resolve<CustomDialogs>().confirmDialog(
                    context,
                    title: "",
                    desc: R.string().errorString.toValueGreaterThanFrom,
                    positiveBtnTitle: R.string().commonString.ok,
                  );
              _maxValueController.text = "";
              setState(() {});
            }
          }
        }
        // Focus.of(context).unfocus();
      },
      child: TextField(
        textAlign: widget.fromTomodel.fromToStyle.showUnderline
            ? TextAlign.left
            : TextAlign.center,
        onChanged: (value) {
          if (value != null || value != "") {
            if (num.parse(value) < widget.fromTomodel.minValue ||
                num.parse(value) > widget.fromTomodel.maxValue) {
              if (oldValueForTo != null || oldValueForTo != "") {
                _maxValueController.text = oldValueForTo;
                _maxValueController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _maxValueController.text.length));
              }
            }
          }
          oldValueForTo = _maxValueController.text.trim();
          widget.fromTomodel.valueTo = oldValueForTo;
          print("=======>" + oldValueForTo);
        },
        focusNode: _focusMaxValue,
        controller: _maxValueController,
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) =>
              RegExp(r'(^[+-]?\d*.?\d{0,2})$').hasMatch(newValue.text)
                  ? newValue
                  : oldValue)
        ],
        onSubmitted: (value) {
          print(oldValueForTo);
        },
        style: appTheme.blackNormal14TitleColorblack,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: widget.fromTomodel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.fromTomodel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          enabledBorder: widget.fromTomodel.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.fromTomodel.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          hintText: widget.fromTomodel?.labelTo ?? "-",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }

  bool validateValue(String value) {
    Pattern pattern = r'^-?\d+(?:\.\d+)?$';
    RegExp regex = new RegExp(pattern);
    print(regex.hasMatch(value));
    return (!regex.hasMatch(value)) ? false : true;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
