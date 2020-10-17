import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';

class FilterRequest {
  Map<String, dynamic> createRequest(List<FormBaseModel> list) {
    Map<String, dynamic> map = {};

    list.forEach((element) {
      if (element.viewType == ViewTypes.selection) {
        List<String> arrStr =
            Master.getSelectedId((element as SelectionModel).masters);
        if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
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

        Map<String, dynamic> caratDic = Map<String, dynamic>();

        for (var item in (element as SelectionModel).caratRangeChipsToShow) {
          Map<String, dynamic> mainDic = Map<String, dynamic>();
          Map<String, dynamic> dict = Map<String, dynamic>();
          dict[">="] = item.split("-")[0];
          dict["<="] = item.split("-")[1];

          mainDic["crt"] = dict;
          caratRequest.add(mainDic);
        }
        map["or"] = caratRequest;
      }

      if (element.viewType == ViewTypes.shapeWidget) {
        List<String> arrStr =
            Master.getSelectedId((element as SelectionModel).masters);
        if (!isNullEmptyOrFalse(arrStr)) map[element.apiKey] = arrStr;
      }
    });

    return map;
  }
}
