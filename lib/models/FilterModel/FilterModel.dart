import 'dart:convert';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Config {
  Future<List<TabModel>> getTabJson() async {
    String jsonForm = await rootBundle.loadString('assets/Json/TabJson.json');

    List<dynamic> fieldList = jsonDecode(jsonForm);
    List<TabModel> tabModels = [];
    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        tabModels.add(TabModel.fromJson(element));
      }
    }
    return tabModels;
  }

  Future<List<FormBaseModel>> getFilterJson() async {
    String jsonForm =
        await rootBundle.loadString('assets/Json/FilterJson.jsonc');

    List<dynamic> fieldList = jsonDecode(jsonForm);
    List<FormBaseModel> formModels = [];
    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        String viewType = element["viewType"];
        if (viewType == ViewTypes.fromTo) {
          formModels.add(FromToModel.fromJson(element));
        } else if (viewType == ViewTypes.shapeWidget) {
          SelectionModel selectionModel = SelectionModel.fromJson(element);
          formModels.add(selectionModel);
          List<Master> arrMaster =
              await Master.getSubMaster(selectionModel.masterCode);
          selectionModel.masters = arrMaster;
        } else if (viewType == ViewTypes.selection) {
          SelectionModel selectionModel = SelectionModel.fromJson(element);
          formModels.add(selectionModel);
          List<Master> arrMaster =
              await Master.getSubMaster(selectionModel.masterCode);
          selectionModel.masters = arrMaster;
        } else if (viewType == ViewTypes.colorWidget) {
          ColorModel colorModel = ColorModel.fromJson(element);
          formModels.add(colorModel);
          List<Master> arrMaster =
              await Master.getSubMaster(colorModel.masterCode);
          colorModel.masters = arrMaster;
        } else if (viewType == ViewTypes.seperator) {
          SeperatorModel seperatorModel = SeperatorModel.fromJson(element);
          formModels.add(seperatorModel);
        } else if (viewType == ViewTypes.certNo) {
          CertNoModel seperatorModel = CertNoModel.fromJson(element);
          formModels.add(seperatorModel);
        } else if (viewType == ViewTypes.keytosymbol) {
          KeyToSymbolModel keyToSymbol = KeyToSymbolModel.fromJson(element);
          formModels.add(keyToSymbol);
          List<Master> arrMaster =
              await Master.getSubMaster(keyToSymbol.masterCode);
          keyToSymbol.masters = arrMaster;
        } else if (viewType == ViewTypes.caratRange) {
          SelectionModel selectionModel = SelectionModel.fromJson(element);
          formModels.add(selectionModel);
          List<Master> arrMaster = await Master.getSizeMaster();

          selectionModel.masters = arrMaster;
        }
      }
    }
    return formModels;
  }

  // getFilterReq(List<FormBaseModel> formModels) {
  //   if (formModels[0].viewType == ViewTypes.certNo) {
  //     //
  //     (List<FormBaseModel> formModels[0] is CertNoModel).
  //   }
  // }
}

class FormBaseModel {
  String title;
  String apiKey;
  String desc;
  String viewType;
  String tab;

  FormBaseModel({this.apiKey, this.desc, this.title});
  FormBaseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    apiKey = json['apiKey'];
    desc = json['desc'];
    viewType = json["viewType"];
    tab = json["tab"];
  }
}

class FromToModel extends FormBaseModel {
  String labelFrom;
  String labelTo;
  String valueFrom;
  String valueTo;
  num maxValue;
  num minValue;
  FromToStyle fromToStyle;

  FromToModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    labelFrom = json['labelFrom'];
    labelTo = json['labelTo'];
    maxValue = json['maxValue'];
    minValue = json['minValue'];
    fromToStyle = json['fromToStyle'] != null
        ? new FromToStyle.fromJson(json['fromToStyle'])
        : null;
  }
}

class SelectionModel extends FormBaseModel {
  String masterCode;
  List<Master> masters = [];
  String orientation;
  bool verticalScroll;
  bool isShowAll;
  bool isShowAllSelected = false;
  bool isShowMore;
  bool isShowMoreSelected = true;
  String allLableTitle;
  FromToStyle fromToStyle;
  SelectionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    verticalScroll = json["verticalScroll"] ?? false;
    orientation = json["orientation"];
    isShowAll = json['isShowAll'] ?? false;
    isShowMore = json['isShowMore'] ?? false;
    masterCode = json["masterCode"];
    allLableTitle = json["allLableTitle"];
    fromToStyle = json['fromToStyle'] != null
        ? new FromToStyle.fromJson(json['fromToStyle'])
        : null;
  }
}

class ColorModel extends SelectionModel {
  bool isWhiteSelected = true;
  List<Master> fancyMaster = [];

  SelectionModel intensity;
  SelectionModel overtone;

  ColorModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {}
}

class SeperatorModel extends SelectionModel {
  num height;
  Color color;
  num leftPadding;
  num rightPadding;

  SeperatorModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    height = json["height"] ?? 1;
    color = fromHex(json['color'] ?? "#E3E3E3");
    leftPadding = json['leftPadding'] ?? 0;
    rightPadding = json["rightPadding"] ?? 0;
  }
}

class CertNoModel extends FormBaseModel {
  List<RadioButton> radiobutton = [];
  String text;

  CertNoModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['radiobutton'] != null) {
      radiobutton = new List<RadioButton>();
      json['radiobutton'].forEach((v) {
        radiobutton.add(new RadioButton.fromJson(v));
      });
    }
  }
}

class FromToStyle {
  bool showUnderline;
  bool showBorder;
  Color underlineColor;
  Color borderColor;
  int borderWidth;

  FromToStyle.fromJson(Map<String, dynamic> json) {
    showUnderline = json['showUnderline'] ?? true;
    showBorder = json['showBorder'] ?? false;
    underlineColor = fromHex(json['ounderlineColor'] ?? "#E3E3E3");
    borderColor = fromHex(json['borderColor'] ?? "#E3E3E3");
    borderWidth = json['borderWidth'] ?? 1;
  }
}

class KeyToSymbolModel extends SelectionModel {
  List<RadioButton> listOfRadio = [];

  KeyToSymbolModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    for (var i in json['radiobutton']) {
      listOfRadio.add(RadioButton.fromJson(i));
    }
  }
}

class RadioButton {
  String title;
  bool isSelected;
  String apiKey;

  RadioButton.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    isSelected = json['isSelected'] ?? false;
    apiKey = json['apiKey'];
  }
}
