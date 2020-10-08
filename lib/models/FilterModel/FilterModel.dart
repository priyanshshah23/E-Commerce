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
    List<Map<String, dynamic>> fieldList = jsonDecode(jsonForm);
    List<FormBaseModel> formModels = [];
    fieldList.forEach((element) async {
      String viewType = element["viewType"];
      if (viewType == "FromTo") {
        formModels.add(FromToModel.fromJson(element));
      } else if (viewType == "Selection") {
        SelectionModel selectionModel = SelectionModel.fromJson(element);
        var arrMaster = await AppDatabase.instance.masterDao
            .getSubMasterFromCode(selectionModel.masterCode);
        selectionModel.masters = arrMaster;
        formModels.add(selectionModel);
      }
    });
  }
}

class FormBaseModel {
  String title;
  String apiKey;
  String desc;

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
  bool isAllowMultiSelection;
  bool verticalScroll;
  bool isShowAll;
  bool isShowMore;
  bool isSelected;

  SelectionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    isAllowMultiSelection = json["isAllowMultiSelection"];
    verticalScroll = json["verticalScroll"];
    isShowAll = json['isShowAll'];
    isShowMore = json['isShowMore'];
  }
}
