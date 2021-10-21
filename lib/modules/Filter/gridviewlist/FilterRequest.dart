import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';

class FilterRequest {
  Map<String, dynamic> createRequest(List<FormBaseModel> list,
      {List selectedStatus,
      bool isFromLayout = false,
      bool isFromMatch = false}) {
    Map<String, dynamic> map = {};
    map["isFcCol"] = false;
    List<String> arrWsts = [];
    List<String> arrStage = [];
    for (var element in list) {
      if (element.viewType == ViewTypes.selection) {
        SelectionModel selectionModel = element as SelectionModel;
        if (selectionModel.masterCode == MasterCode.canadamarkparent ||
            selectionModel.masterCode == MasterCode.newarrivalsgroup) {
          List<Master> arrMaster = selectionModel.masters
              .where((element) => element.isSelected == true)
              .toList();
          if (!isNullEmptyOrFalse(arrMaster)) {
            for (var item in arrMaster) {
              if (item.code == MasterCode.canadamark) {
                map["isCm"] = ["CERT", "ELIG"];
              } else if (item.code == MasterCode.typeiia) {
                map["type2"] = {"!=": null};
              } else if (item.code == MasterCode.xray) {
                map["isXray"] = true;
              } else if (item.code == MasterCode.newarrivals) {
                arrWsts.add("B");
              } else if (item.code == MasterCode.brownStatic) {
                map["excludeFilter"] = {"brown": true};
              } else if (item.code == MasterCode.noBlack) {
                map["excludeFilter"] = {"noBlack": true};
              } else if (item.code == MasterCode.noOpen) {
                map["excludeFilter"] = {"noOpen": true};
              } else if (item.code == MasterCode.eyecleanStatic) {
                if (!isNullEmptyOrFalse(item.map))
                  map.addAll(item.map as Map<String, dynamic>);
              }
            }
          }
        } else if (selectionModel.masterCode == MasterCode.dor ||
            selectionModel.masterCode == MasterCode.fm) {
          List<Master> arrMaster = selectionModel.masters
              .where((element) => element.isSelected == true)
              .toList();

          List<String> arr = [];

          if (!isNullEmptyOrFalse(arrMaster)) {
            for (var item in arrMaster) {
              arr.add(item.code);
            }

            map[selectionModel.apiKey] = arr;
          }
        } else if (selectionModel.masterCode == MasterCode.arrivals) {
          if (!isNullEmptyOrFalse((element as SelectionModel).fromDate) &&
              !isNullEmptyOrFalse((element as SelectionModel).toDate)) {
            map["inDt"] = {
              ">=": selectionModel.fromDate,
              "<=": selectionModel.toDate
            };
          }
        } else {
          if (selectionModel.masterCode == MasterCode.stage) {
            arrStage = Master.getSelectedId(selectionModel.masters);

            if (!isNullEmptyOrFalse(arrStage)) {
              arrWsts.addAll(arrStage);
            }
          } else if (selectionModel.masterCode != MasterCode.make) {
            List<String> arrStr = Master.getSelectedId(selectionModel.masters);
            if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
          }
        }
      }

      if (element.viewType == ViewTypes.fromTo) {
        if (!isNullEmptyOrFalse((element as FromToModel).valueFrom) &&
            !isNullEmptyOrFalse((element as FromToModel).valueTo)) {
          Map<String, num> fromToValue = {};

          fromToValue[">="] = num.parse((element as FromToModel).valueFrom);
          fromToValue["<="] = num.parse((element as FromToModel).valueTo);

          map[element.apiKey] = fromToValue;
        }

        if ((element as FromToModel).isCaratRange) {
          List<Map<String, dynamic>> caratRequest = Master.getSelectedCarat(
                  (element as FromToModel).selectionModel.masters) ??
              [];

          if (!isNullEmptyOrFalse(caratRequest)) map["or"] = caratRequest;
        }
      }

      if (element.viewType == ViewTypes.keytosymbol) {
        Map<String, dynamic> mapOfSelectedRadioButton = {};
        print((element as KeyToSymbolModel).listOfRadio);
        List<RadioButton> listOfSelectedRadioButton =
            (element as KeyToSymbolModel)
                .listOfRadio
                .where(
                  (element) => element.isSelected == true,
                )
                .toList();

        if (!isNullEmptyOrFalse(listOfSelectedRadioButton)) {
          var list = Master.getSelectedId((element as SelectionModel).masters);
          if (!isNullEmptyOrFalse(list)) {
            mapOfSelectedRadioButton[listOfSelectedRadioButton.first.apiKey] =
                Master.getSelectedId((element as SelectionModel).masters);

            map[element.apiKey] = mapOfSelectedRadioButton;
          }
        }
      }

      if (element.viewType == ViewTypes.certNo) {
        Map<String, dynamic> mapOfSelectedRadioButton = {};
        List<RadioButton> listOfSelectedRadioButton = (element as CertNoModel)
            .radiobutton
            .where(
              (element) => element.isSelected == true,
            )
            .toList();

        if (!isNullEmptyOrFalse(listOfSelectedRadioButton)) {
          if (!isNullEmptyOrFalse(element)) {
            if (!isNullEmptyOrFalse((element as CertNoModel).text)) {
              List<String> listOfIds = (element as CertNoModel).text.split(",");
              mapOfSelectedRadioButton[listOfSelectedRadioButton.first.apiKey] =
                  listOfIds;

              map[element.apiKey] = mapOfSelectedRadioButton;
            }
          }
        }
      }

      if (element.viewType == ViewTypes.caratRange) {
        List<Map<String, dynamic>> caratRequest =
            Master.getSelectedCarat((element as SelectionModel).masters) ?? [];

        for (var item in (element as SelectionModel).caratRangeChipsToShow) {
          Map<String, dynamic> mainDic = Map<String, dynamic>();
          Map<String, dynamic> dict = Map<String, dynamic>();
          dict[">="] = item.split("-")[0];
          dict["<="] = item.split("-")[1];

          mainDic["crt"] = dict;

          if (!isNullEmptyOrFalse(mainDic)) caratRequest.add(mainDic);
        }
        if (!isNullEmptyOrFalse(caratRequest)) map["or"] = caratRequest;
      }

      if (element.viewType == ViewTypes.shapeWidget) {
        List<String> arrStr =
            Master.getSelectedId((element as SelectionModel).masters);
        if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
      }

      if (element.viewType == ViewTypes.groupWidget) {
        ColorModel colorModel = (element as ColorModel);

        if (colorModel.masterCode == MasterCode.color) {
          if (colorModel.showWhiteFancy) {
            if (colorModel.isGroupSelected) {
              map["isFcCol"] = true;
              List<String> arrFancy =
                  Master.getSelectedId(colorModel.groupMaster);
              if (!isNullEmptyOrFalse(arrFancy)) map["fcCol"] = arrFancy;
              List<String> arrInclusion =
                  Master.getSelectedId(colorModel.intensitySelection.masters);
              if (!isNullEmptyOrFalse(arrInclusion))
                map[colorModel.intensitySelection.apiKey] = arrInclusion;
              List<String> arrOvertone =
                  Master.getSelectedId(colorModel.overtoneSelection.masters);
              if (!isNullEmptyOrFalse(arrOvertone))
                map[colorModel.overtoneSelection.apiKey] = arrOvertone;
            } else {
              List<String> arrStr = Master.getSelectedId(colorModel.masters);
              if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
            }
          } else {
            List<String> arrStr = Master.getSelectedId(colorModel.masters);
            if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
          }
        } else {
          List<String> arrStr = Master.getSelectedId(colorModel.masters);
          if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
        }
      }
    }
    if (!isNullEmptyOrFalse(arrWsts)) {
      map["wSts"] = arrWsts;
    }
    if (selectedStatus != null && selectedStatus.length > 0) {
      map['sSts'] = selectedStatus;
    }
    if (isFromMatch) {
      map['layoutNo'] = ["", "0"];
      map["pairStkNo"] = {
        "!=": [""]
      };
    }
    if (isFromLayout) {
      map['layoutNo'] = {
        "nin": ["", "0"]
      };
      // map["pairStkNo"] = {
      //   "!=": [""]
      // };
      // map["wSts"] = ["A", "M", "H", "D", "E", "B"];
      // map["isSearchVisible"] = true;
      // map["isDeleted"] = false;
    }
    return map;
  }
}

class FilterDataSource {
  List<FormBaseModel> prepareFilterDataSource(
      List<FormBaseModel> arrFilter, DisplayDataClass searchData) {
    Map<String, dynamic> dict = searchData.toJson();
    for (var item in arrFilter) {
      if (item is KeyToSymbolModel) {
        if (!isNullEmptyOrFalse(dict[item.apiKey])) {
          Map<String, dynamic> data = dict[item.apiKey];
          item.listOfRadio.forEach((element) {
            element.isSelected = false;
          });
          for (var model in item.listOfRadio) {
            if (data.keys.contains(model.apiKey)) {
              if (!isNullEmptyOrFalse(data[model.apiKey])) {
                model.isSelected = true;
                item.masters.forEach((element) {
                  if (data[model.apiKey].contains(element.sId)) {
                    element.isSelected = true;
                  }
                });
              }
            }
          }
        }
      } else if (item.viewType == ViewTypes.fromTo) {
        if (item is FromToModel) {
          if (!isNullEmptyOrFalse(dict[item.apiKey])) {
            item.valueFrom = dict[item.apiKey][">="];
            item.valueTo = dict[item.apiKey]["<="];
          }

          if (item.isCaratRange) {
            if (!isNullEmptyOrFalse(dict["or"])) {
              List<dynamic> arr = dict["or"];

              List<dynamic> arrSelected =
                  arr.map((e) => e[item.apiKey]).toList();
              List<dynamic> arrDup = arr.map((e) => e[item.apiKey]).toList();

              for (var master in item.selectionModel.masters) {
                for (var tCarat in master.grouped) {
                  for (var model in arrSelected) {
                    if (num.parse(tCarat.webDisplay.split("-")[0]) ==
                            num.parse(model[">="].toString()) &&
                        num.parse(tCarat.webDisplay.split("-")[1]) ==
                            num.parse(model["<="].toString())) {
                      tCarat.isSelected = true;
                      master.isSelected = true;
                      arrDup.remove(model);
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        if (item is ColorModel) {
          for (int i = 0; i < item.masters.length; i++) {
            Master element = item.masters[i];
            if (!isNullEmptyOrFalse(dict[item.apiKey]) &&
                dict[item.apiKey].contains(element.sId)) {
              element.isSelected = true;
            }
            item.onSelectionClick(i);
          }
        } else if (item is SelectionModel) {
          if (item.viewType == ViewTypes.caratRange) {
            if (!isNullEmptyOrFalse(dict["or"])) {
              List<dynamic> arr = dict["or"];

              List<dynamic> arrSelected =
                  arr.map((e) => e[item.apiKey]).toList();
              List<dynamic> arrDup = arr.map((e) => e[item.apiKey]).toList();

              for (var master in item.masters) {
                for (var tCarat in master.grouped) {
                  for (var model in arrSelected) {
                    if (num.tryParse(tCarat.webDisplay.split("-")[0]) ==
                            num.tryParse(model[">="].toString()) &&
                        num.tryParse(tCarat.webDisplay.split("-")[1]) ==
                            num.tryParse(model["<="].toString())) {
                      tCarat.isSelected = true;
                      master.isSelected = true;
                      arrDup.remove(model);
                    }
                  }
                }
              }
              arrDup.forEach((element) {
                item.caratRangeChipsToShow
                    .add("${element[">="]}-${element["<="]}");
              });
            }
          } else {
            if (item.masterCode == MasterCode.canadamarkparent) {
              for (var model in item.masters) {
                if (!isNullEmptyOrFalse(dict["isCm"])) {
                  item.masters.forEach((element) {
                    if (element.code == MasterCode.canadamark) {
                      element.isSelected = true;
                    }
                  });
                }
                if (!isNullEmptyOrFalse(dict["type2"])) {
                  item.masters.forEach((element) {
                    if (element.code == MasterCode.typeiia) {
                      element.isSelected = true;
                    }
                  });
                }
                if (!isNullEmptyOrFalse(dict["isXray"])) {
                  item.masters.forEach((element) {
                    if (element.code == MasterCode.xray) {
                      element.isSelected = true;
                    }
                  });
                }

                if (model.code == MasterCode.eyecleanStatic) {}
              }
            } else if (item.masterCode == MasterCode.newarrivalsgroup) {
              for (var model in item.masters) {
                if (!isNullEmptyOrFalse(dict["wSts"])) {
                  item.masters.forEach((element) {
                    if (element.code == MasterCode.newarrivals) {
                      if (dict["wSts"].contains("B")) {
                        element.isSelected = true;
                      }
                    } else if (element.code == MasterCode.upcoming) {
                      if (dict["wSts"].contains("U")) {
                        element.isSelected = true;
                      }
                    }
                  });
                }
                if (model.code == MasterCode.eyecleanStatic) {}
              }
            } else if (item.masterCode == MasterCode.dor) {
              if (!isNullEmptyOrFalse(dict["isDor"])) {
                item.masters.forEach((element) {
                  if (dict["isDor"].contains(element.code)) {
                    element.isSelected = true;
                  }
                });
              }
            } else if (item.masterCode == MasterCode.fm) {
              if (!isNullEmptyOrFalse(dict["isFm"])) {
                item.masters.forEach((element) {
                  if (dict["isFm"].contains(element.code)) {
                    element.isSelected = true;
                  }
                });
              }
            } else if (!isNullEmptyOrFalse(dict[item.apiKey])) {
              item.masters.forEach((element) {
                if (dict[item.apiKey].contains(element.sId)) {
                  element.isSelected = true;
                }
              });
            }
          }
        }
      }
    }
    return arrFilter;
  }
}
