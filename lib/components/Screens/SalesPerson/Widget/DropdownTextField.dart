import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/utils/CommonTextfield.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownTextField extends StatefulWidget {
  CellModel item;
  Function(CellModel item) onTapCallBack;

  DropDownTextField(this.item, {this.onTapCallBack});

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.item.userText != null && widget.item.userText.isNotEmpty) {
      _controller.text = widget.item.userText;
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.item.userText ?? "";
    return InkWell(
      onTap: () {
        widget.onTapCallBack(widget.item);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: EdgeInsets.only(top: getSize(10), bottom: getSize(10)),
          child: TextFormField(
            focusNode: _focusNode,
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: getCommonIconWidget(
                imageName: widget.item.perfixImage,
                imageType: IconSizeType.small,
              ),
              contentPadding: EdgeInsets.fromLTRB(0, 0, 012, 12),
              hintText: widget.item.hintText,
              hintStyle: appTheme.grey16HintTextStyle,
              errorStyle: appTheme.error16TextStyle,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                borderSide:
                    BorderSide(color: appTheme.dividerColor, width: getSize(1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                borderSide:
                    BorderSide(color: appTheme.dividerColor, width: getSize(1)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                borderSide:
                    BorderSide(color: appTheme.dividerColor, width: getSize(1)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                borderSide:
                    BorderSide(color: appTheme.dividerColor, width: getSize(1)),
              ),
              suffixIcon: getCommonIconWidget(
                imageName: downArrow,
                imageType: IconSizeType.medium,
              ),
            ),
            validator: (text) {
              if (widget.item.isRequired) {
                if (text.isEmpty) {
                  return widget.item.emptyValidationText;
                } else {
                  return null;
                }
              }
            },
            onFieldSubmitted: (String text) {
              widget.item.userText = text;
              FocusScope.of(context).unfocus();
            },
            onChanged: (String text) {
              widget.item.userText = text;
            },
            onEditingComplete: () {},
          ),
        ),
      ),
    );
    return InkWell(
      onTap: () {
        widget.onTapCallBack(widget.item);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: EdgeInsets.only(top: getSize(10), bottom: getSize(0)),
          child: CommonTextfield(
            focusNode: _focusNode,
            textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                imageName: widget.item.perfixImage,
                imageType: IconSizeType.small,
              ),
              inputController: _controller,
              keyboardType: TextInputType.text,
              hintText: widget.item.hintText,
              formatter: [
                BlacklistingTextInputFormatter(RegExp(RegexForEmoji)),
              ],
              type: TextFieldType.DropDown,
            ),
            inputAction: widget.item.inputAction,
            validation: (text) {
              if (widget.item.isRequired) {
                if (text.isEmpty) {
                  return widget.item.emptyValidationText;
                } else {
                  return null;
                }
              }
            },
            textCallback: (text) {
              widget.item.userText = text;
            },
            onNextPress: () {
              _focusNode.nextFocus();
            },
          ),
        ),
      ),
    );
  }
}
