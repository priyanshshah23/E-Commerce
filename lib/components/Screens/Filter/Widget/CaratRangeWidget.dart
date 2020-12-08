import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
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

  // List<String> caratRangeChipsToShow = [];

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
            style: appTheme.blackMedium16TitleColorblack,
            textAlign: TextAlign.left,
          ),
          Spacer(),
          widget.selectionModel.showFromTo
              ? Container(
                  height: getSize(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(
                      width: getSize(1.0),
                      color: widget.selectionModel.fromToStyle.showUnderline
                          ? Colors.transparent
                          : appTheme.borderColor,
                    ),
                  ),
                  child: Center(child: getFromTextField()),
                )
              : SizedBox(),
          SizedBox(width: getSize(16)),
          widget.selectionModel.showFromTo
              ? Container(
                  height: getSize(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(5)),
                    border: Border.all(
                      width: getSize(1.0),
                      color: widget.selectionModel.fromToStyle.showUnderline
                          ? Colors.transparent
                          : appTheme.borderColor,
                    ),
                  ),
                  child: Center(child: getToTextField()),
                )
              : SizedBox(),
          SizedBox(width: getSize(16)),
          widget.selectionModel.showFromTo
              ? InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (_minValueController.text.isNotEmpty &&
                        _maxValueController.text.isNotEmpty) {
                      if (num.parse(_minValueController.text.trim()) <=
                          num.parse(_maxValueController.text.trim())) {
                        String text =
                            "${_minValueController.text}-${_maxValueController.text}";
                        if (!widget.selectionModel.caratRangeChipsToShow
                            .contains(text)) {
                          widget.selectionModel.caratRangeChipsToShow.add(text);
                          setState(() {});
                        }
                        _minValueController.text = "";
                        _maxValueController.text = "";
                      } else {
                        app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "",
                              desc:
                                  R.string.errorString.fromValueGreateThanTo,
                              positiveBtnTitle: R.string.commonString.ok,
                            );
                        _minValueController.text = "";
                        setState(() {});
                      }
                    }
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
        ]),
        getCaratRangeChips(),
        SizedBox(height: getSize(16)),
        SelectionWidget(widget.selectionModel),
        SizedBox(height: getSize(8)),
      ],
    );
  }

  getCaratRangeChips() {
    return Wrap(
      spacing: getSize(6),
      runSpacing: getSize(0),
      children: List<Widget>.generate(
          widget.selectionModel.caratRangeChipsToShow.length, (int index) {
        return Chip(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getSize(10))),
          label: Text(
            widget.selectionModel.caratRangeChipsToShow[index].toString(),
            style: appTheme.blackMedium14TitleColorblack,
          ),
          backgroundColor: appTheme.unSelectedBgColor,
          deleteIcon: Icon(
            Icons.clear,
            color: appTheme.textColor,
            size: getSize(16),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getSize(5)),
              side: BorderSide(color: appTheme.colorPrimary)),
          onDeleted: () {
            setState(() {
              widget.selectionModel.caratRangeChipsToShow.removeWhere((entry) {
                return entry ==
                    widget.selectionModel.caratRangeChipsToShow[index]
                        .toString();
              });
            });
          },
        );
      }),
    );
  }

  getFromTextField() {
    return Container(
      width: getSize(70),
      height: getSize(30),
      child: Focus(
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
            }
          }
          // Focus.of(context).unfocus();
        },
        child: TextField(
          textAlign: widget.selectionModel.fromToStyle.showUnderline
              ? TextAlign.left
              : TextAlign.center,
          onChanged: (value) {
            oldValueForFrom = _minValueController.text.trim();
          },
          onSubmitted: (value) {},
          style: appTheme.blackNormal14TitleColorblack,
          focusNode: _focusMinValue,
          controller: _minValueController,
          inputFormatters: [
            TextInputFormatter.withFunction((oldValue, newValue) =>
                RegExp(r'(^[+-]?\d*.?\d{0,2})$').hasMatch(newValue.text)
                    ? newValue
                    : oldValue),
            LengthLimitingTextInputFormatter(4),
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
            hintText: R.string.commonString.fromLbl,
            hintStyle: appTheme.grey14HintTextStyle,
          ),
        ),
      ),
    );
  }

  getToTextField() {
    return Container(
      width: getSize(70),
      height: getSize(30),
      child: Focus(
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
            }
          }
          // Focus.of(context).unfocus();
        },
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
                    : oldValue),
            LengthLimitingTextInputFormatter(4),
          ],
          onSubmitted: (value) {},
          style: appTheme.blackNormal14TitleColorblack,
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
            hintText: R.string.commonString.toLbl,
            hintStyle: appTheme.grey14HintTextStyle,
          ),
        ),
      ),
    );
  }
}
