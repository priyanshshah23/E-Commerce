import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/utils/CommonTextfield.dart';
import 'package:diamnow/components/Screens/MemoStone/Widget/CellModel.dart';
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
          padding: EdgeInsets.only(top: getSize(10),bottom: getSize(0)),
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
