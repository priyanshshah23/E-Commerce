import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';

class CertNoWidget extends StatefulWidget {
  static const route = "SearchComponent";
  CertNoModel certNoModel;

  CertNoWidget(this.certNoModel);

  @override
  _CertNoWidgetState createState() => _CertNoWidgetState();
}

class _CertNoWidgetState extends State<CertNoWidget> {
  final TextEditingController _stoneIdController = TextEditingController();
  var _focusStoneId = FocusNode();

  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          childAspectRatio: 5.0,
          // Generate 100 widgets that display their index in the List.
          children:
              List.generate(widget.certNoModel.radiobutton.length, (index) {
            var item = widget.certNoModel.radiobutton[index];
            return getRadioButton(index, item, (int value) {
              //
              setState(() {
                widget.certNoModel.radiobutton
                    .map((e) => e.isSelected = false)
                    .toList();

                item.isSelected = true;
                _radioValue = value;
              });
            });
            // return Text(
            //   'Item $index',
            // );
          }),
        ),
        SizedBox(height: getSize(30)),
        getStoneIdTextField(),
      ],
    );
  }

  getStoneIdTextField() {
    return TextFormField(
      autocorrect: false,
      maxLines: 8,
      textInputAction: TextInputAction.done,
      focusNode: _focusStoneId,
      autofocus: false,
      controller: _stoneIdController,
      style: appTheme.blackNormal14TitleColorblack,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        errorMaxLines: 2,
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(getSize(6))),
          borderSide: BorderSide(color: appTheme.borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(getSize(6))),
          borderSide: BorderSide(color: appTheme.borderColor, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(getSize(6))),
          borderSide: BorderSide(color: appTheme.borderColor, width: 1),
        ),
        hintStyle: appTheme.grey14HintTextStyle,
        hintText: widget.certNoModel.title,
      ),
      onFieldSubmitted: (String text) {
        widget.certNoModel.text = _stoneIdController.text.trim();
        FocusScope.of(context).unfocus();
      },
      onChanged: (String text) {
        widget.certNoModel.text = _stoneIdController.text.trim();
      },
    );
  }

  getRadioButton(int index, RadioButton model, dynamic onClick) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.certNoModel.radiobutton
              .map((e) => e.isSelected = false)
              .toList();

          model.isSelected = true;
          _radioValue = index;
        });
      },
      child: Row(
        children: [
          Radio(
            value: index,
            groupValue: _radioValue,
            onChanged: onClick,
            activeColor: appTheme.colorPrimary,
          ),
          Text(
            model.title,
            style: appTheme.black16TextStyle,
          ),
        ],
      ),
    );
  }
}
