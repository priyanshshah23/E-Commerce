import 'dart:convert';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/services.dart';

class Config {
  Future<List<FormBaseModel>> getFilterJson() async {
    String jsonForm =
        await rootBundle.loadString('assets/Json/FilterJson.json');
    ;
    List<dynamic> fieldList = jsonDecode(jsonForm);
    List<FormBaseModel> formModels = [];
    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        String viewType = element["viewType"];
        if (viewType == "FromTo") {
          formModels.add(FromToModel.fromJson(element));
        } else if (viewType == "Selection") {
          SelectionModel selectionModel = SelectionModel.fromJson(element);
          List<Master> arrMaster =
              await Master.getSubMaster(selectionModel.masterCode);
          selectionModel.masters = arrMaster;
          formModels.add(selectionModel);
        } else if (viewType == "colorWidget") {
          ColorModel colorModel = ColorModel.fromJson(element);
          formModels.add(colorModel);
          List<Master> arrMaster =
              await Master.getSubMaster(colorModel.masterCode);
          colorModel.masters = arrMaster;
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

FormBaseModel({this.apiKey,this.desc,this.title});
  FormBaseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    apiKey = json['apiKey'];
    desc = json['desc'];
  }
}

class FromToModel extends FormBaseModel {
  String labelFrom;
  String labelTo;
  String valueFrom;
  String valueTo;
  String maxValue;
  String minValue;

  FromToModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    labelFrom = json['labelFrom'];
    labelTo = json['labelTo'];
    valueFrom = json['valueFrom'];
    valueTo = json['valueTo'];
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
  bool isShowAllSelected;
  bool isShowMore;
  bool isShowMoreSelected;

SelectionModel({this.isShowAll,this.isShowAllSelected,
    this.isShowMore,this.isShowMoreSelected,this.masterCode,this.masters,this.verticalScroll,this.orientation});
  SelectionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    verticalScroll = json["verticalScroll"];
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
