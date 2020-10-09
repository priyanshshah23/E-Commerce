import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';

class SearchComponent extends StatefulWidget {
  String title;
  num max;
  num min;
  Function(num, num) setValue;

  SearchComponent({
    this.title,
    this.max,
    this.min,
    this.setValue,
  });

  @override
  _SearchComponentState createState() => _SearchComponentState(
        title: title,
        max: max,
        min: min,
      );
}

class _SearchComponentState extends State<SearchComponent> {
  String title;
  num max;
  num min;

  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  var _focusMinValue = FocusNode();
  var _focusMaxValue = FocusNode();
  String oldValueForFrom;
  String oldValueForTo;

  _SearchComponentState({
    this.title,
    this.max,
    this.min,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: appTheme.textBlackColor,
        ),
        SizedBox(
          height: getSize(10),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getSize(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: appTheme.commonAlertDialogueTitleStyle,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (value != null || value != "") {
                          if(validateValue(value)) {
                            if (num.parse(value) <= min || num.parse(value) >= max) {
                              if (oldValueForFrom != null || oldValueForFrom != "") {
                                _minValueController.text = oldValueForFrom;
                                _minValueController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: _minValueController.text.length));
                              }
                            }
                            oldValueForFrom = _minValueController.text.trim();
                          } else {
                            _minValueController.text = oldValueForFrom;
                            _minValueController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _minValueController.text.length));
                          }
                        }

                      },
                      focusNode: _focusMinValue,
                      controller: _minValueController,
                      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(),
                        hintText: "From",
                        hintStyle: appTheme.commonAlertDialogueDescStyle,
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
                          if (num.parse(value) <= min || num.parse(value) >= max) {
                            //showToast("Please Enter Valid value");
                            if (oldValueForTo != null || oldValueForTo != "") {
                              _maxValueController.text = oldValueForTo;
                              _maxValueController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: _maxValueController.text.length));
                            }
                          }
                        }
                        oldValueForTo = _maxValueController.text.trim();
                        widget.setValue(
                            num.parse(_minValueController.text.trim()),
                            num.parse(_maxValueController.text.trim()));
                      },
                      focusNode: _focusMaxValue,
                      controller: _maxValueController,
                      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(),
                        hintText: "To",
                        hintStyle: appTheme.commonAlertDialogueDescStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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