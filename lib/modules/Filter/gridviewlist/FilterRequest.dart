import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';

class FilterRequest {
  Map<String, dynamic> createRequest(List<FormBaseModel> list) {
    Map<String, dynamic> map = {};

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
                map["wSts"] = "B";
              } else if (item.code == MasterCode.upcoming) {
                map["wSts"] = "U";
              } else if (item.code == MasterCode.eyecleanStatic) {
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
        } else {
          List<String> arrStr = Master.getSelectedId(selectionModel.masters);
          if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
        }
      }

      if (element.viewType == ViewTypes.fromTo) {
        if (!isNullEmptyOrFalse((element as FromToModel).valueFrom) &&
            !isNullEmptyOrFalse((element as FromToModel).valueTo)) {
          Map<String, int> fromToValue = {};

          fromToValue[">="] = int.parse((element as FromToModel).valueFrom);
          fromToValue["<="] = int.parse((element as FromToModel).valueTo);

          map[element.apiKey] = fromToValue;
        }
      }

      if (element.viewType == ViewTypes.keytosymbol) {
        Map<String, dynamic> mapOfSelectedRadioButton = {};
        List<RadioButton> listOfSelectedRadioButton =
            (element as KeyToSymbolModel)
                .listOfRadio
                .where(
                  (element) => element.isSelected == true,
                )
                .toList();

        if (!isNullEmptyOrFalse(listOfSelectedRadioButton)) {
          mapOfSelectedRadioButton[listOfSelectedRadioButton.first.apiKey] =
              Master.getSelectedId((element as SelectionModel).masters);

          map[element.apiKey] = mapOfSelectedRadioButton;
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
            Master.getSelectedCarat((element as SelectionModel).masters);

        for (var item in (element as SelectionModel).caratRangeChipsToShow) {
          Map<String, dynamic> mainDic = Map<String, dynamic>();
          Map<String, dynamic> dict = Map<String, dynamic>();
          dict[">="] = item.split("-")[0];
          dict["<="] = item.split("-")[1];

          mainDic["crt"] = dict;
          caratRequest.add(mainDic);
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
        }
      }
    }

    return map;
  }
}
