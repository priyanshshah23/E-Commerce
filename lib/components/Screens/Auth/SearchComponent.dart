import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                          if(validateValue(_minValueController.text.trim()) == true) {
                            if (num.parse(value) <= min || num.parse(value) >= max) {
                              //showToast("Please Enter Valid value");
                              if (oldValueForFrom != null || oldValueForFrom != "") {
                                _minValueController.text = oldValueForFrom;
                                _minValueController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: _minValueController.text.length));
                              }
                            }
                          }
                        }
                        oldValueForFrom = _minValueController.text.trim();
                      },
                      focusNode: _focusMinValue,
                      controller: _minValueController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
//                      inputFormatters: [
//                        BlacklistingTextInputFormatter(RegExp(r'^[0-9]*\.[0-9]{3}$')),
//                      ],
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
                      keyboardType: TextInputType.number,
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
    Pattern pattern = r'^[0-9]*\.[0-9]{2}$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

}
