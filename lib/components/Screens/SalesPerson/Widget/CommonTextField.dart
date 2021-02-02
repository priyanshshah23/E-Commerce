import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatefulWidget {
  CellModel item;

  CommonTextField(
    this.item,
  );

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
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
    return Padding(
      padding: EdgeInsets.only(top: getSize(10), bottom: getSize(10)),
      child: TextFormField(
        focusNode: _focusNode,
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: widget.item?.perfixImage != null
              ? getCommonIconWidget(
                  imageName: widget.item?.perfixImage ?? "",
                  imageType: IconSizeType.small,
                )
              : null,
          contentPadding:
              EdgeInsets.fromLTRB(widget.item.leftPadding, 0, 012, 12),
          hintText: widget.item.hintText,
          hintStyle: appTheme.grey16HintTextStyle,
          errorStyle: appTheme.error16TextStyle,
          errorMaxLines: 2,
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
          focusedErrorBorder:OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
            borderSide:
            BorderSide(color: appTheme.dividerColor, width: getSize(1)),
          ),
        ),
        maxLines: widget.item.maxLine,
        textInputAction: widget.item.inputAction,
        keyboardType: widget.item.keyboardType,
        validator: (text) {
          if (widget.item.isRequired) {
            if (text.isEmpty) {
              return widget.item.emptyValidationText;
            } else {
              if (widget.item.type == CellType.HoldTime) {
                if (int.tryParse(text) < 1 || int.tryParse(text) > 72) {
                  return widget.item.patternValidationText;
                } else {
                  return null;
                }
              }
              return null;
            }
          }
        },
        inputFormatters: getInputFormatter(),
        onFieldSubmitted: (String text) {
          widget.item.userText = text;
          FocusScope.of(context).unfocus();
          _focusNode.nextFocus();
        },
        onChanged: (String text) {
          widget.item.userText = text;
        },
        onEditingComplete: () {},
      ),
    );
  }

  getInputFormatter() {
    if (widget.item.type == CellType.HoldTime) {
      return [WhitelistingTextInputFormatter.digitsOnly];
    } else {
      return [
        BlacklistingTextInputFormatter(RegExp(RegexForEmoji)),
      ];
    }
  }
}
