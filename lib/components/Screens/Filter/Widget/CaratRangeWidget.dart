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
            style: appTheme.blackNormal18TitleColorblack,
            textAlign: TextAlign.left,
          ),
          Spacer(),
          getFromTextField(),
          SizedBox(width: getSize(16)),
          getToTextField(),
          SizedBox(width: getSize(16)),
          InkWell(
            onTap: () {
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
                  String text =
                      "${_minValueController.text}-${_maxValueController.text}";
                  if (!widget.selectionModel.caratRangeChipsToShow.contains(text)) {
                    widget.selectionModel.caratRangeChipsToShow.add(text);
                    setState(() {});
                  }
                } else {
                  app.resolve<CustomDialogs>().confirmDialog(
                        context,
                        title: "Value Error",
                        desc:
                            "From Value should be less than or equal to To value",
                        positiveBtnTitle: "Try Again",
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
        ]),
        SizedBox(height: getSize(16)),
        getCaratRangeChips(),
        SizedBox(height: getSize(16)),
        SelectionWidget(widget.selectionModel)
      ],
    );
  }

  getCaratRangeChips() {
    return Wrap(
      spacing: getSize(6),
      runSpacing: getSize(6),
      children:
          List<Widget>.generate(widget.selectionModel.caratRangeChipsToShow.length, (int index) {
        return Chip(
          label: Text(widget.selectionModel.caratRangeChipsToShow[index].toString()),
          backgroundColor: appTheme.unSelectedBgColor,
          deleteIcon: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(20)), color: appTheme.buttonColor),
            child: Icon(
              Icons.clear,
              color: appTheme.unSelectedBgColor,
              size: getSize(16),
            ),
          ),
          shape: StadiumBorder(side: BorderSide(color: appTheme.colorPrimary)),
          onDeleted: () {
            setState(() {
              widget.selectionModel.caratRangeChipsToShow.removeWhere((entry) {
                return entry == widget.selectionModel.caratRangeChipsToShow[index].toString();
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
                      title: "Value Error",
                      desc:
                          "From Value should be less than or equal to To value",
                      positiveBtnTitle: "Try Again",
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
                      title: "Value Error",
                      desc:
                          "To Value should be greater than or equal to From value",
                      positiveBtnTitle: "Try Again",
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
                    : oldValue)
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
            hintText: "To",
            hintStyle: appTheme.grey14HintTextStyle,
          ),
        ),
      ),
    );
  }
}
