import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
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
            isNullEmptyOrFalse(widget.fromTomodel.megaTitle)
                ? SizedBox()
                : Text(
                    widget.fromTomodel.megaTitle ?? "",
                    style: appTheme.blackNormal18TitleColorblack.copyWith(
                        //decoration: TextDecoration.underline,
                        ),
                    textAlign: TextAlign.left,
                  ),
            !isNullEmptyOrFalse(widget.fromTomodel.megaTitle)
                ? SizedBox(height: getSize(20))
                : SizedBox(),
            Row(
              children: [
                Text(
                  widget.fromTomodel?.title ?? "-",
                  style: appTheme.blackMedium16TitleColorblack,
                ),
                widget.fromTomodel.isCaratRange ? Spacer() : SizedBox(),
                widget.fromTomodel.isCaratRange
                    ? InkWell(
                        onTap: () {
                          openCaratRangeBottomSheet();
                        },
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
                    : SizedBox()
              ],
            ),
            !widget.fromTomodel.fromToStyle.showUnderline
                ? SizedBox(height: getSize(16))
                : SizedBox(),
            isBothWidget(),
            SizedBox(
              height: getSize(12),
            ),
          ],
        ),
      ],
    );
  }

  isBothWidget() {
    if (!widget.fromTomodel.isOnlyFrom) {
      return Row(
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
      );
    } else {
      print("Pair No.");
      return Container(
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
      );
    }
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
                    desc: R.string.errorString.fromValueGreateThanTo,
                    positiveBtnTitle: R.string.commonString.ok,
                  );
              _minValueController.text = "";
              setState(() {});
            }
          } else {
            oldValueForFrom = "";
            widget.fromTomodel.valueFrom = oldValueForFrom;
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
        // inputFormatters: [
        //   // old regx = r'(^[+-]?\d*.?\d{0,2})$'
        //   TextInputFormatter.withFunction((oldValue, newValue) =>
        //       // RegExp(r'(^[+-]?[0-9]+\d*.?\d{0,2})$').hasMatch(newValue.text)
        //       //     ? newValue
        //       //     : oldValue)
        //
        //       // new regx = ^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$
        //       RegExp(r'^([+-]?[0-9]+[0-9]*.?[0-9]{0,2})?$')
        //               .hasMatch(newValue.text)
        //           ? newValue
        //           : oldValue)
        // ],
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) =>
          RegExp(r'(^[+-]?\d*.?\d{0,2})$').hasMatch(newValue.text)
              ? newValue
              : oldValue)
        ],
        style: appTheme.blackNormal14TitleColorblack,
        keyboardType: widget.fromTomodel.apiKey == "back"
            ? TextInputType.text
            : TextInputType.number,
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
                    desc: R.string.errorString.toValueGreaterThanFrom,
                    positiveBtnTitle: R.string.commonString.ok,
                  );
              _maxValueController.text = "";
              setState(() {});
            }
          } else {
            oldValueForTo = "";
            widget.fromTomodel.valueTo = oldValueForTo;
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
        keyboardType: widget.fromTomodel.apiKey == "back"
            ? TextInputType.text
            : TextInputType.number,
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

  openCaratRangeBottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: appTheme.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setSetter) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: getSize(28)),
                  child: Text(
                    "Select Range",
                    style: appTheme.commonAlertDialogueTitleStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: getSize(Spacing.leftPadding),
                      right: getSize(Spacing.rightPadding),
                      top: getSize(8),
                      bottom: getSize(8)),
                  child: SelectionWidget(widget.fromTomodel.selectionModel),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getSize(Spacing.leftPadding),
                      vertical: getSize(16)),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            // alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.symmetric(
                              vertical: getSize(15),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: appTheme.colorPrimary,
                                width: getSize(1),
                              ),
                              borderRadius: BorderRadius.circular(getSize(5)),
                            ),
                            child: Text(
                              R.string.commonString.cancel,
                              textAlign: TextAlign.center,
                              style: appTheme.blue14TextStyle
                                  .copyWith(fontSize: getFontSize(16)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getSize(20),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            //alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.symmetric(
                              vertical: getSize(15),
                            ),
                            decoration: BoxDecoration(
                                color: appTheme.colorPrimary,
                                borderRadius: BorderRadius.circular(getSize(5)),
                                boxShadow: getBoxShadow(context)),
                            child: Text(
                              R.string.commonString.btnSubmit,
                              textAlign: TextAlign.center,
                              style: appTheme.white16TextStyle,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
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
