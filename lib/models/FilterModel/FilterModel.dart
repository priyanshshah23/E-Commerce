import 'dart:convert';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
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
        } else if (viewType == ViewTypes.text) {
          CertNoModel seperatorModel = CertNoModel.fromJson(element);
          formModels.add(seperatorModel);
        }
      }
    }
    return formModels;
  }
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

  FromToModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    labelFrom = json['labelFrom'];
    labelTo = json['labelTo'];
    maxValue = json['maxValue'];
    minValue = json['minValue'];
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
  bool isShowMoreSelected = false;

  SelectionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    verticalScroll = json["verticalScroll"] ?? false;
    orientation = json["orientation"];
    isShowAll = json['isShowAll'] ?? false;
    isShowMore = json['isShowMore'] ?? false;
    masterCode = json["masterCode"];
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
  List<CertNoItemModel> items = [];

  CertNoModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['items'] != null) {
      items = new List<CertNoItemModel>();
      json['list'].forEach((v) {
        items.add(new CertNoItemModel.fromJson(v));
      });
    }
  }
}

class CertNoItemModel extends FormBaseModel {
  bool isSelected;

  CertNoItemModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    isSelected = json['isSelected'];
  }
}
