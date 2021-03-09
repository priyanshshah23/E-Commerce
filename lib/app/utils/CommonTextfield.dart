import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../app.export.dart';
import 'math_utils.dart';

typedef OnValidation(String text);

class CommonTextfield extends StatefulWidget {
  final TextFieldOption textOption;
  final Function(String text) textCallback;
  final VoidCallback tapCallback;
  final VoidCallback onNextPress;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final bool showUnderLine;
  final bool enable;
  final bool autoFocus;
  final bool autoCorrect;
  final bool alignment;
  final bool readOnly;
  final OnValidation validation;
  TextStyle hintStyleText;

  CommonTextfield(
      {@required this.textOption,
      @required this.textCallback,
      this.tapCallback,
      this.onNextPress,
      this.inputAction,
      this.autoFocus,
      this.focusNode,
      this.alignment,
      this.showUnderLine = true,
      this.enable = true,
      this.validation,
      this.autoCorrect = true,
      this.hintStyleText,
      this.readOnly = false});

  @override
  _CommonTextfieldState createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  bool obscureText = false;
  IconData obscureIcon = Icons.visibility;

  @override
  void initState() {
    super.initState();

    obscureText = widget.textOption.isSecureTextField ?? false;
  }

  @override
  void didUpdateWidget(CommonTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.only(
//          left:
//              widget.textOption.prefixWid != null ? getSize(10) : getSize(20)),
//      height: getSize(75),
//      alignment: Alignment.center,

      child: TextFormField(
        // textAlignVertical: TextAlignVertical(y: 0.3),
        autocorrect: widget.autoCorrect,
        enabled: widget.enable,
        readOnly: widget.readOnly,
        onTap: () {
          if (widget.tapCallback != null) {
            widget.tapCallback();
          }
        },
        maxLines: widget.textOption.maxLine,
        textInputAction: widget.inputAction ?? TextInputAction.done,
        focusNode: widget.focusNode ?? null,
        autofocus: widget.autoFocus ?? false,
        controller: widget.textOption.inputController ?? null,
        obscureText: this.obscureText,
        style: appTheme.black16TextStyle,
        keyboardType: widget.textOption.keyboardType ?? TextInputType.text,
        textCapitalization:
            widget.textOption.textCapitalization ?? TextCapitalization.none,
        cursorColor: appTheme.colorPrimary,
        inputFormatters: widget.textOption.formatter ?? [],
        decoration: InputDecoration(
          contentPadding: widget.textOption.prefixWid != null
              ? EdgeInsets.all(0)
              : EdgeInsets.only(left: getSize(18), top: getSize(16)),
          errorStyle: appTheme.error16TextStyle,
          errorMaxLines: 3,
          fillColor: widget.textOption.fillColor ?? fromHex("#F6F6F6"),
          enabledBorder: !widget.textOption.isBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      widget.textOption.maxLine != null
                          ? getSize(25)
                          : getSize(50))),
                  borderSide: BorderSide(
                      color: appTheme.dividerColor, width: getSize(2)),
                ),
          focusedBorder: !widget.textOption.isBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      widget.textOption.maxLine != null
                          ? getSize(25)
                          : getSize(50))),
                  borderSide: BorderSide(
                      color: appTheme.dividerColor, width: getSize(0.7)),
                ),
          border: !widget.textOption.isBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      widget.textOption.maxLine != null
                          ? getSize(25)
                          : getSize(50))),
                  borderSide: BorderSide(
                      color: appTheme.dividerColor, width: getSize(0.7)),
                ),
//         errorBorder: widget.textOption.errorBorder ?? OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(11)),
//             borderSide: BorderSide.none
//         ),
          labelText: widget.textOption.labelText,
          hintStyle: appTheme.grey16HintTextStyle,
          hintText: widget.textOption.hintText,
          labelStyle: TextStyle(
            color: appTheme.textColor,
            fontSize: getFontSize(21),
          ),
          prefixIcon: widget.textOption.prefixWid,
          suffix: widget.textOption.postfixWidOnFocus,
          suffixIcon: (widget.textOption.isSecureTextField != null &&
                  widget.textOption.isSecureTextField)
              ? IconButton(
                  icon: Icon(
                    obscureIcon,
                    color: appTheme.textBlackColor,
                    size: getSize(15),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        this.obscureText = !this.obscureText;
                        if (this.obscureText) {
                          this.obscureIcon = Icons.visibility;
                        } else {
                          this.obscureIcon = Icons.visibility_off;
                        }
                        if (!widget.focusNode.hasPrimaryFocus)
                          widget.focusNode.canRequestFocus = false;
                        widget.focusNode.unfocus();
                      },
                    );
                    //TextInputConnection;
                  },
                )
              : widget.textOption.type == TextFieldType.DropDown
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                      ),
                    )
                  : widget.textOption.postfixWid,
        ),
        /*onSubmitted: (String text) {
          this.widget.textCallback(text);
          FocusScope.of(context).unfocus();
          if (widget.onNextPress != null) {
            widget.onNextPress();
          }
        },*/
        onFieldSubmitted: (String text) {
          this.widget.textCallback(text);
          FocusScope.of(context).unfocus();
          if (widget.onNextPress != null) {
            widget.onNextPress();
          }
        },
        validator: widget.validation,
        onChanged: (String text) {
          this.widget.textCallback(text);
        },
        onEditingComplete: () {
          this.widget.textCallback(widget.textOption.inputController.text);
        },
      ),
    );
  }
}

class TextFieldOption {
  String text = "";
  String labelText;
  String hintText;
  bool isSecureTextField = false;
  TextInputType keyboardType;
  TextFieldType type;
  int maxLine;
  TextStyle hintStyleText;
  Widget prefixWid;
  Widget postfixWid;
  Widget postfixWidOnFocus;
  bool autoFocus;
  Color fillColor;
  InputBorder errorBorder;
  List<TextInputFormatter> formatter;
  TextEditingController inputController;
  TextCapitalization textCapitalization;
  bool isBorder;
  TextAlign textAlign;

  TextFieldOption(
      {this.text,
      this.labelText,
      this.hintText,
      this.isBorder = true,
      this.textAlign,
      this.isSecureTextField,
      this.keyboardType,
      this.type,
      this.maxLine = 1,
      this.autoFocus,
      this.formatter,
      this.hintStyleText,
      this.inputController,
      this.prefixWid,
      this.postfixWid,
      this.postfixWidOnFocus,
      this.fillColor,
      this.errorBorder,
      this.textCapitalization});
}

enum TextFieldType {
  Normal,
  DropDown,
}
