import 'package:flutter/material.dart';

class CellModel {
  final String lableText;
  final String hintText;
  final String perfixImage;
  String userText;
  String id;
  bool isEnable;
  String emptyValidationText;
  final String patternValidationText;
  final String lengthValidationText;
  final bool isPatternValidation;
  final TextInputAction inputAction;
  final TextInputType keyboardType;
  final bool isSecure;
  final bool isAllowSpace;
  final Widget postFixWid;
  final CellType type;
  final TextFieldEnum textFieldType;
  bool isResetInput;
  int maxLine;
  final num opactiy;
  final bool isValidationRequired;
  final String dateFormate;
  bool isRequired;
  bool isURL;
  bool isIFSC;
  bool isBankAccount;
  String utcDateString;
  double leftPadding;

  CellModel({
    this.lableText = "",
    @required this.hintText = "",
    this.userText = "",
    this.id = "",
    this.emptyValidationText = "",
    this.isEnable = true,
    this.isValidationRequired = true,
    this.patternValidationText = "",
    this.lengthValidationText = "",
    this.isPatternValidation = false,
    this.inputAction = TextInputAction.next,
    this.isSecure = false,
    this.isAllowSpace = false,
    this.postFixWid,
    this.type,
    this.textFieldType = TextFieldEnum.Normal,
    this.isResetInput = false,
    this.keyboardType = TextInputType.text,
    this.maxLine = 1,
    this.opactiy = 1.0,
    this.dateFormate,
    this.isRequired = true,
    this.isURL = false,
    this.isIFSC = false,
    this.isBankAccount = false,
    this.utcDateString,
    this.perfixImage,
    this.leftPadding = 0,
  });
}

enum TextFieldEnum {
  Normal,
  DropDown,
  Radio,
  DateTime,
  Separator,
  TextView,
  Button
}

enum CellType {
  //Memo Stone
  SalesPersonName,
  Memo_BrokerName,

  //Hold Stone
  Hold_Party,
  Hold_Buyer,
  HoldTime,
  Comment,

  //Buy now
  Invoice,
  BillType,
  Term,
  BrokerName
}
