import 'package:diamnow/app/app.export.dart';
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.fromTomodel?.title ?? "-",
              style: appTheme.blackNormal14TitleColorblack,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (value != null || value != "") {
                        if (num.parse(value) < widget.fromTomodel.minValue ||
                            num.parse(value) > widget.fromTomodel.maxValue) {
                          if (oldValueForFrom != null ||
                              oldValueForFrom != "") {
                            _minValueController.text = oldValueForFrom;
                            _minValueController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                    _minValueController.text.length));
                          }
                        }
                      }

                      oldValueForFrom = _minValueController.text.trim();
                    },
                    onSubmitted: (value) {
                      if (value != null) {
                        if(_maxValueController.text != null) {
                          if(num.parse(_maxValueController.text.trim()) < num.parse(value)) {
                            app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "Value Error",
                              desc:
                              "From Value should be less than or equal to To value",
                              positiveBtnTitle: "Try Again",
                            );
                          } else {
                            //todo something
                            app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "Value Error",
                              desc:
                              "okay",
                              positiveBtnTitle: "Try Again",
                            );
                          }
                        }
                      }
                    },
                    focusNode: _focusMinValue,
                    controller: _minValueController,
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                              (oldValue, newValue) =>
                          RegExp(r'(^[+-]?\d*.?\d{0,2})$')
                              .hasMatch(newValue.text)
                              ? newValue
                              : oldValue)
                    ],
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: appTheme.dividerColor,width: getSize(1))
                      ),
                      hintText: widget.fromTomodel?.labelFrom ?? "-",
                      hintStyle: appTheme.grey14HintTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: getSize(15),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (value != null || value != "") {
                        if (num.parse(value) < widget.fromTomodel.minValue ||
                            num.parse(value) > widget.fromTomodel.maxValue) {
                          if (oldValueForTo != null ||
                              oldValueForTo != "") {
                            _maxValueController.text = oldValueForTo;
                            _maxValueController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                    _maxValueController.text.length));
                          }
                        }
                      }
                      oldValueForTo = _maxValueController.text.trim();
                    },
                    focusNode: _focusMaxValue,
                    controller: _maxValueController,
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                              (oldValue, newValue) =>
                          RegExp(r'(^[+-]?\d*.?\d{0,2})$')
                              .hasMatch(newValue.text)
                              ? newValue
                              : oldValue)
                    ],
                    onSubmitted: (value) {
                      if (value != null) {
                        if(_minValueController.text != null) {
                          if(num.parse(_minValueController.text.trim()) > num.parse(value)) {
                            app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "Value Error",
                              desc:
                              "To Value should be greater than or equal to From value",
                              positiveBtnTitle: "Try Again",
                            );
                          } else {
                            //todo something
                            app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "Value Error",
                              desc:
                              "okay",
                              positiveBtnTitle: "Try Again",
                            );
                          }
                        }
                      }
                    },
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: widget.fromTomodel?.labelTo ?? "-",
                      hintStyle: appTheme.grey14HintTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: getSize(10),
        ),
      ],
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
