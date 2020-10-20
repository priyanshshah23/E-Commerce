import 'dart:collection';
import 'dart:convert';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Config {
  Future<List<Master>> getLocalDataJson() async {
    String jsonForm = await rootBundle.loadString('assets/Json/Localdata.json');

    List<dynamic> fieldList = jsonDecode(jsonForm);
    List<Master> masters = [];
    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        masters.add(Master.fromJson(element));
      }
    }
    return masters;
  }

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

  Future<List<FilterOptions>> getOptionsJson() async {
    String jsonForm =
        await rootBundle.loadString('assets/Json/SortingPopup.json');

    List<dynamic> fieldList = jsonDecode(jsonForm);
    List<FilterOptions> optionsModels = [];
    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        optionsModels.add(FilterOptions.fromJson(element));
      }
    }
    return optionsModels;
  }

  Future<List<FormBaseModel>> getFilterJson() async {
    String jsonForm =
        await rootBundle.loadString('assets/Json/FilterJson.jsonc');

    List<dynamic> fieldList = jsonDecode(jsonForm);

    List<FormBaseModel> formModels =
        []; //list of onlymodels. //store formbasemodels with sequence...

    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        String viewType = element["viewType"];
        if (element["isActive"] ?? true) {
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
          } else if (viewType == ViewTypes.groupWidget) {
            ColorModel colorModel = ColorModel.fromJson(element);
            formModels.add(colorModel);

            if (colorModel.showGroup) {
              List<Master> arrMaster =
                  await Master.getSubMaster(colorModel.masterCode);
              List<Master> arrGroupMaster =
                  await Master.getSubMaster(colorModel.groupMasterCode);
              colorModel.mainMasters = arrMaster;
              colorModel.groupMaster = arrGroupMaster;
              colorModel.masters = arrMaster;
            } else if (colorModel.showWhiteFancy) {
              List<Master> arrMaster =
                  await Master.getSubMaster(colorModel.masterCode);
              List<Master> arrGroupMaster =
                  await Master.getSubMaster(MasterCode.fancyColor);

              List<Master> intensity =
                  await Master.getSubMaster(MasterCode.intensity);
              List<Master> overtone =
                  await Master.getSubMaster(MasterCode.overTone);
              colorModel.mainMasters = arrMaster;
              colorModel.groupMaster = arrGroupMaster;
              colorModel.intensity = intensity;
              colorModel.overtone = overtone;
              colorModel.masters = arrMaster;
            }
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
    }
    // formModels.sort((model1, model2) {
    //   return model1.sequence.compareTo(model2.sequence);
    // });
    return formModels;
  }

  Future<List<DiamondDetailUIModel>> getDiamonDetailUIJson() async {
    String jsonForm =
        await rootBundle.loadString('assets/Json/DiamondDetail.json');

    List<dynamic> fieldList = jsonDecode(jsonForm);
    List<DiamondDetailUIModel> tabModels = [];
    for (int i = 0; i < fieldList.length; i++) {
      dynamic element = fieldList[i];
      if (element is Map<String, dynamic>) {
        tabModels.add(DiamondDetailUIModel.fromJson(element));
      }
    }

    //sort list according to sequence.
    // tabModels.sort((model1, model2) {
    //   return model1.sequence.compareTo(model2.sequence);
    // });
    return tabModels;
  }
}

class FormBaseModel {
  String megaTitle;
  String title;
  String apiKey;
  String desc;
  String viewType;
  String tab;
  int sequence;

  FormBaseModel({
    this.apiKey,
    this.desc,
    this.title,
    this.megaTitle,
  });
  FormBaseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    megaTitle = json["megaTitle"] ?? "";
    apiKey = json['apiKey'];
    desc = json['desc'];
    viewType = json["viewType"];
    tab = json["tab"];
    sequence = json["sequence"];
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
  String groupMasterCode;
  bool verticalScroll;
  bool isShowAll;
  bool isShowAllSelected = false;
  bool isShowMore;
  bool isShowMoreSelected = true;
  String allLableTitle;
  FromToStyle fromToStyle;
  bool isSingleSelection;
  List<MasterSelection> masterSelection;
  List<String> caratRangeChipsToShow = [];

  SelectionModel(
      {title,
      this.masters,
      this.orientation,
      this.allLableTitle,
      this.isShowAll,
      this.verticalScroll,
      apiKey}) {
    super.title = title;
    super.apiKey = apiKey;
  }

  SelectionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    groupMasterCode = json["groupMasterCode"];
    verticalScroll = json["verticalScroll"] ?? false;
    orientation = json["orientation"];
    isShowAll = json['isShowAll'] ?? false;
    isShowMore = json['isShowMore'] ?? false;
    masterCode = json["masterCode"];
    allLableTitle = json["allLableTitle"];
    fromToStyle = json['fromToStyle'] != null
        ? new FromToStyle.fromJson(json['fromToStyle'])
        : null;
    isSingleSelection = json["isSingleSelection"] ?? false;
    if (json['masterSelection'] != null) {
      masterSelection = new List<MasterSelection>();
      json['masterSelection'].forEach((v) {
        masterSelection.add(new MasterSelection.fromJson(v));
      });
    }
  }
}

class ColorModel extends SelectionModel {
  bool isGroupSelected = false;
  bool showGroup;
  bool showRadio;
  bool showWhiteFancy;
  List<Master> mainMasters = [];
  List<Master> groupMaster = [];

  SelectionModel intensitySelection;
  SelectionModel overtoneSelection;

  List<Master> intensity = [];
  List<Master> overtone = [];

  ColorModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    showRadio = json["showRadio"] ?? false;
    showGroup = json["showGroup"] ?? false;
    showWhiteFancy = json["showWhiteFancy"] ?? true;
  }
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

class MasterSelection {
  String code;
  List<MasterToSelect> masterToSelect;

  MasterSelection({this.code, this.masterToSelect});

  MasterSelection.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['masterToSelect'] != null) {
      masterToSelect = new List<MasterToSelect>();
      json['masterToSelect'].forEach((v) {
        masterToSelect.add(new MasterToSelect.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.masterToSelect != null) {
      data['masterToSelect'] =
          this.masterToSelect.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MasterToSelect {
  String code;
  List<String> subMasters;

  MasterToSelect({this.code, this.subMasters});

  MasterToSelect.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    subMasters = json['subMasters'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['subMasters'] = this.subMasters;
    return data;
  }
}
