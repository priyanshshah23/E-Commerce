import 'dart:collection';
import 'dart:convert';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxbus/rxbus.dart';

class Config {
  List<Master> arrLocalData = [];
  List<TabModel> arrTabs = [];
  List<FilterOptions> arrSorting = [];
  List<FormBaseModel> arrFilter = [];

  Future<List<Master>> getLocalDataJson() async {
    if (isNullEmptyOrFalse(arrLocalData)) {
      String jsonForm =
          await rootBundle.loadString('assets/Json/Localdata.json');

      List<dynamic> fieldList = jsonDecode(jsonForm);
      for (int i = 0; i < fieldList.length; i++) {
        dynamic element = fieldList[i];

        if (element is Map<String, dynamic>) {
          arrLocalData.add(Master.fromJson(element));
        }
      }
    }
    return arrLocalData;
  }

  Future<List<TabModel>> getTabJson() async {
    if (isNullEmptyOrFalse(arrTabs)) {
      String jsonForm = await rootBundle.loadString('assets/Json/TabJson.json');

      List<dynamic> fieldList = jsonDecode(jsonForm);

      for (int i = 0; i < fieldList.length; i++) {
        dynamic element = fieldList[i];
        if (element is Map<String, dynamic>) {
          if (element["isActive"] ?? true) {
            arrTabs.add(TabModel.fromJson(element));
          }
        }
      }
    }
    return arrTabs;
  }

  Future<List<FilterOptions>> getOptionsJson() async {
    if (isNullEmptyOrFalse(arrSorting)) {
      String jsonForm =
          await rootBundle.loadString('assets/Json/SortingPopup.json');
      List<dynamic> fieldList = jsonDecode(jsonForm);
      for (int i = 0; i < fieldList.length; i++) {
        dynamic element = fieldList[i];
        if (element is Map<String, dynamic>) {
          if (element["request"] is List<dynamic>) {
            dynamic request = element;

            List<Map<String, dynamic>> list = [];
            (element["request"] as List<dynamic>).forEach((item) {
              if (item is Map<String, dynamic>) {
                list.add(item);
              }
            });
            request["request"] = list;
            arrSorting.add(FilterOptions.fromJson(request));
          } else {
            arrSorting.add(FilterOptions.fromJson(element));
          }
        }
      }
    }
    return arrSorting;
  }

  Future<List<FormBaseModel>> getFilterJson({booll }) async {
    if (isNullEmptyOrFalse(arrFilter)) {
      String jsonForm =
          await rootBundle.loadString('assets/Json/FilterJson.jsonc');
      List<dynamic> fieldList = jsonDecode(jsonForm);
      for (int i = 0; i < fieldList.length; i++) {
        dynamic element = fieldList[i];
        if (element is Map<String, dynamic>) {
          String viewType = element["viewType"];
          if (element["isActive"] ?? true) {
            if (viewType == "searchText") {
              arrFilter.add(FormBaseModel.fromJson(element));
            } else if (viewType == ViewTypes.fromTo) {
              var fromToModel = FromToModel.fromJson(element);
              arrFilter.add(fromToModel);

              if (fromToModel.isCaratRange) {
                SelectionModel selectionModel =
                    SelectionModel.fromJson(element);

                List<Master> arrMaster = await Master.getSizeMaster();

                selectionModel.masters = arrMaster;

                if (selectionModel.isShowAll == true) {
                  appendAllTitle(selectionModel);
                }

                if (selectionModel.isShowMore == true) {
                  appendShowMoreTitle(selectionModel);
                }

                fromToModel.selectionModel = selectionModel;
                // arrFilter.add(FromToModel.fromJson(element));
              }
            } else if (viewType == ViewTypes.shapeWidget) {
              SelectionModel selectionModel = SelectionModel.fromJson(element);
              arrFilter.add(selectionModel);

              List<Master> arrMaster =
                  await Master.getSubMaster(selectionModel.masterCode);
              selectionModel.masters = arrMaster;

              if (selectionModel.isShowAll == true) {
                appendAllTitle(selectionModel);
              }
            } else if (viewType == ViewTypes.selection) {
              SelectionModel selectionModel = SelectionModel.fromJson(element);
              arrFilter.add(selectionModel);
              List<Master> arrMaster =
                  await Master.getSubMaster(selectionModel.masterCode);
              selectionModel.masters = arrMaster;

              if (selectionModel.isShowAll == true) {
                appendAllTitle(selectionModel);
              }
              if (selectionModel.isShowMore == true) {
                appendShowMoreTitle(selectionModel);
              }
            } else if (viewType == ViewTypes.groupWidget) {
              ColorModel colorModel = ColorModel.fromJson(element);
              arrFilter.add(colorModel);

              if (colorModel.showGroup) {
                List<Master> arrMaster =
                    await Master.getSubMaster(colorModel.masterCode);
                List<Master> arrGroupMaster =
                    await Master.getSubMaster(colorModel.groupMasterCode);
                colorModel.mainMasters = arrMaster;
                colorModel.groupMaster = arrGroupMaster;
                colorModel.masters = arrMaster;

                if (colorModel.isShowAll == true) {
                  appendAllTitle(colorModel);
                }

                if (colorModel.isShowMore == true) {
                  appendShowMoreTitle(colorModel);
                }
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

                if (colorModel.isShowAll == true) {
                  appendAllTitle(colorModel);
                }

                if (colorModel.isShowMore == true) {
                  appendShowMoreTitle(colorModel);
                }
              }
            } else if (viewType == ViewTypes.seperator) {
              SeperatorModel seperatorModel = SeperatorModel.fromJson(element);
              arrFilter.add(seperatorModel);
            } else if (viewType == ViewTypes.certNo) {
              CertNoModel seperatorModel = CertNoModel.fromJson(element);
              arrFilter.add(seperatorModel);
            } else if (viewType == ViewTypes.keytosymbol) {
              KeyToSymbolModel keyToSymbol = KeyToSymbolModel.fromJson(element);
              arrFilter.add(keyToSymbol);
              List<Master> arrMaster =
                  await Master.getSubMaster(keyToSymbol.masterCode);
              keyToSymbol.masters = arrMaster;

              if (keyToSymbol.isShowAll == true) {
                appendAllTitle(keyToSymbol);
              }
            } else if (viewType == ViewTypes.caratRange) {
              SelectionModel selectionModel = SelectionModel.fromJson(element);
              arrFilter.add(selectionModel);
              List<Master> arrMaster = await Master.getSizeMaster();

              selectionModel.masters = arrMaster;

              if (selectionModel.isShowAll == true) {
                appendAllTitle(selectionModel);
              }

              if (selectionModel.isShowMore == true) {
                appendShowMoreTitle(selectionModel);
              }
            }
          }
        }
      }
    }

    // formModels.sort((model1, model2) {
    //   return model1.sequence.compareTo(model2.sequence);
    // });
    return arrFilter;
  }

  Future<List<DiamondDetailUIModel>> getDiamonCompareUIJson() async {
    String jsonForm =
        await rootBundle.loadString('assets/Json/DiamondCompare.json');

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

  appendAllTitle(SelectionModel model) {
    Master allMaster = Master();
    allMaster.sId = model.allLableTitle;
    allMaster.webDisplay = model.allLableTitle;
    allMaster.code = model.allLableTitle;
    allMaster.group = model.allLableTitle;

    List<Master> arrSelectedMaster =
        model.masters.where((element) => element.isSelected).toList();
    if (!isNullEmptyOrFalse(arrSelectedMaster)) {
      arrSelectedMaster.length == model.masters.length
          ? allMaster.isSelected = true
          : allMaster.isSelected = false;
    }

    if (model.masterCode == MasterCode.color) {
      // model.masters.insert(0, allMaster);
      if (model is ColorModel) {
        if (model.showWhiteFancy) {
          model.intensity.insert(0, allMaster);
          model.overtone.insert(0, allMaster);
        }
        model.masters.insert(0, allMaster);
        model.groupMaster.insert(0, allMaster);
      }
    } else {
      model.masters.insert(0, allMaster);
    }
    // model.masters.insert(0, allMaster);
  }

  appendShowMoreTitle(SelectionModel model) {
    Master allMaster = Master();
    allMaster.sId = R.string.commonString.showMore;
    allMaster.webDisplay = R.string.commonString.showMore;
    allMaster.code = R.string.commonString.showMore;
    allMaster.group = R.string.commonString.showMore;

    List<Master> arrSelectedMaster =
        model.masters.where((element) => element.isSelected).toList();
    if (!isNullEmptyOrFalse(arrSelectedMaster)) {
      arrSelectedMaster.length == model.masters.length
          ? allMaster.isSelected = true
          : allMaster.isSelected = false;
    }

    if (model.verticalScroll) {
      if (model.showMoreTagAfterTotalItemCount > 4) {
        if (model.masterCode == MasterCode.color) {
          if (model is ColorModel) {
            model.masters.add(allMaster);
            if (model.showWhiteFancy) {
              model.intensity.add(allMaster);
              model.overtone.add(allMaster);
            }
          }
        } else {
          model.masters.add(allMaster);
        }
      }
    }
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
  bool isExpanded;

  FormBaseModel({
    this.apiKey,
    this.desc,
    this.title,
    this.megaTitle,
    this.viewType,
    this.isExpanded,
  });
  FormBaseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    megaTitle = json["megaTitle"] ?? "";
    apiKey = json['apiKey'];
    desc = json['desc'];
    viewType = json["viewType"];
    tab = json["tab"];
    sequence = json["sequence"];
    isExpanded = true;
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
  bool isCaratRange;
  SelectionModel selectionModel;
  bool isOnlyFrom;

  FromToModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    labelFrom = json['labelFrom'];
    labelTo = json['labelTo'];
    maxValue = json['maxValue'];
    minValue = json['minValue'];
    fromToStyle = json['fromToStyle'] != null
        ? new FromToStyle.fromJson(json['fromToStyle'])
        : null;
    isCaratRange = json["isCaratRange"] ?? false;
    isOnlyFrom = json["isOnlyFrom"] ?? false;
    print(isOnlyFrom);
  }
}

class SelectionModel extends FormBaseModel {
  String masterCode;
  List<Master> masters = [];
  String orientation;
  String groupMasterCode;
  bool verticalScroll;
  int gridViewItemCount;
  bool isShowAll;
  bool isExpand;
  String filterName;
  List<dynamic> childrenApiKeys;
  bool isShowAllSelected = false;
  bool isShowMore;
  bool isShowMoreSelected = true;
  bool isShowMoreHorizontal = false;
  String allLableTitle;
  FromToStyle fromToStyle;
  bool isSingleSelection;
  List<MasterSelection> masterSelection;
  List<String> caratRangeChipsToShow = [];
  int numberOfelementsToShow;
  bool showFromTo;
  int showMoreTagAfterTotalItemCount = 9;
  bool valueKeyisCode;

  SelectionModel(
      {title,
      this.masters,
      this.orientation,
      this.allLableTitle,
      this.isShowAll,
      this.isExpand,
      this.filterName,
      this.childrenApiKeys,
      this.verticalScroll,
      this.gridViewItemCount,
      this.masterCode,
      this.showMoreTagAfterTotalItemCount,
      this.isShowMore,
      this.isShowMoreHorizontal,
      this.valueKeyisCode = false,
      apiKey,
      viewType}) {
    super.title = title;
    super.apiKey = apiKey;
    super.viewType = viewType;
  }

  SelectionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    groupMasterCode = json["groupMasterCode"];
    verticalScroll = json["verticalScroll"] ?? false;
    gridViewItemCount = json["gridViewItemCount"] ?? 3;
    orientation = json["orientation"];
    isShowAll = json['isShowAll'] ?? false;
    isExpand = json['isExpand'] ?? false;
    filterName = json['filterName'] ?? "";
    childrenApiKeys = json['childrenApiKeys'] ?? [];
    isShowMore = json['isShowMore'] ?? false;
    isShowMoreHorizontal = json['isShowMoreHorizontal'] ?? false;
    masterCode = json["masterCode"];
    allLableTitle = json["allLableTitle"];
    fromToStyle = json['fromToStyle'] != null
        ? new FromToStyle.fromJson(json['fromToStyle'])
        : null;
    numberOfelementsToShow = json["numberOfelementsToShow"] ?? 11;
    isSingleSelection = json["isSingleSelection"] ?? false;
    showMoreTagAfterTotalItemCount =
        json["showMoreTagAfterTotalItemCount"] ?? 5;
    if (json['masterSelection'] != null) {
      masterSelection = new List<MasterSelection>();
      json['masterSelection'].forEach((v) {
        masterSelection.add(new MasterSelection.fromJson(v));
      });
    }
    showFromTo = json["showFromTo"] ?? true;
    valueKeyisCode = json["valueKeyisCode"] ?? false;
  }

  void onSelectionClick(int index) {
    if (isShowAll == true) {
      if (masters[index].sId == allLableTitle) {
        if (masters[0].isSelected == true) {
          masters.forEach((element) {
            if (element.sId != R.string.commonString.showMore) {
              element.isSelected = true;
            }
          });

          //Group Logic is Selected
          if (viewType == ViewTypes.groupWidget) {
            Map<String, bool> m = Map<String, bool>();
            m[masterCode] = masters[index].isSelected;
            RxBus.post(m, tag: eventMasterForGroupWidgetSelectAll);
          }
        } else {
          masters.forEach((element) {
            element.isSelected = false;
          });

          //Group Logic is Selected
          if (viewType == ViewTypes.groupWidget) {
            Map<String, bool> m = Map<String, bool>();
            m[masterCode] = masters[index].isSelected;
            RxBus.post(m, tag: eventMasterForGroupWidgetSelectAll);
          }
        }
      } else {
        if (masters[index].sId == allLableTitle) {
          masters.forEach((element) {
            element.isSelected = false;
          });
        } else {
          if (masters
                  .where((element) =>
                      element.isSelected == true &&
                      element.sId != allLableTitle)
                  .toList()
                  .length ==
              (isShowMore ? masters.length - 2 : masters.length - 1)) {
            masters[0].isSelected = true;
          } else {
            masters[0].isSelected = false;
            Map<String, dynamic> m = Map<String, dynamic>();
            m["masterCode"] = masterCode;
            m["isSelected"] = masters[index].isSelected;
            m["selectedMasterCode"] = masters[index].code;
            m["masterSelection"] = masterSelection;
            if (viewType == ViewTypes.groupWidget) {
              if (this is ColorModel) {
                m["isGroupSelected"] = (this as ColorModel).isGroupSelected;
                RxBus.post(m, tag: eventMasterForSingleItemOfGroupSelection);
              }
            }
          }
        }
      }
    } else {
      if (masters[index].code == MasterCode.eyecleanStatic) {
        Master.getSubMaster(MasterCode.eyeClean).then((result) {
          if (!isNullEmptyOrFalse(result)) {
            for (var master in result) {
              if (master.code.toLowerCase() == "y") {
                Map<String, dynamic> map = {};

                map["eCln"] = [master.sId];
                if (master.isSelected) masters[index].map = map;

                break;
              }
            }
          }
        });
      } else {
        Map<String, dynamic> m = Map<String, dynamic>();
        m["masterCode"] = masterCode;
        m["isSelected"] = masters[index].isSelected;
        m["selectedMasterCode"] = masters[index].code;
        m["masterSelection"] = masterSelection;
        if (viewType == ViewTypes.groupWidget) {
          if (this is ColorModel) {
            m["isGroupSelected"] = (this as ColorModel).isGroupSelected;
            RxBus.post(m, tag: eventMasterForSingleItemOfGroupSelection);
          }
        }
      }
    }
    if (isShowMore == true) {
      if (isShowMoreSelected) {
        if (index == showMoreTagAfterTotalItemCount - 1) {
          if (masters[masters.length - 1].sId ==
              R.string.commonString.showMore) {
            if (masters[masters.length - 1].webDisplay ==
                R.string.commonString.showMore) {
              isShowMoreSelected = false;
            } else {
              isShowMoreSelected = true;
            }
          }
        }
      } else {
        if (masters[index].sId == R.string.commonString.showMore) {
          if (masters[index].webDisplay == R.string.commonString.showLess) {
            isShowMoreSelected = true;
          } else {
            isShowMoreSelected = false;
          }
        }
      }
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
  num topPadding;
  num bottomPadding;

  SeperatorModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    height = json["height"] ?? 1;
    color = fromHex(json['color'] ?? "#E3E3E3");
    leftPadding = json['leftPadding'] ?? 0;
    rightPadding = json['rightPadding'] ?? 0;
    topPadding = json["topPadding"] ?? 0;
    bottomPadding = json["bottomPadding"] ?? 0;
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
