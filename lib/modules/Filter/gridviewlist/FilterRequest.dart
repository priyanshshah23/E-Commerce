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
        map[element.apiKey] =
            Master.getSelectedId((element as SelectionModel).masters);
      }
    });

    list.forEach((element) {
      if (element.viewType == ViewTypes.fromTo) {
        if (!isNullEmptyOrFalse((element as FromToModel).valueFrom) &&
            !isNullEmptyOrFalse((element as FromToModel).valueTo)) {
          Map<String, int> fromToValue = {};

          fromToValue[">="] = int.parse((element as FromToModel).valueFrom);
          fromToValue["<="] = int.parse((element as FromToModel).valueTo);

          map[element.apiKey] = fromToValue;
        }
      }
    });

    list.forEach((element) {
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
    });

    list.forEach((element) {
      if (element.viewType == ViewTypes.certNo) {
        Map<String, dynamic> mapOfSelectedRadioButton = {};
        List<RadioButton> listOfSelectedRadioButton = (element as CertNoModel)
            .radiobutton
            .where(
              (element) => element.isSelected == true,
            )
            .toList();

        if (!isNullEmptyOrFalse(listOfSelectedRadioButton)) {
          if (!isNullEmptyOrFalse((element as SelectionModel))) {
            List<String> listOfIds = (element as CertNoModel).text.split(",");
            mapOfSelectedRadioButton[listOfSelectedRadioButton.first.apiKey] =
                listOfIds;

            map[element.apiKey] = mapOfSelectedRadioButton;
          }
        }
      }
    });

    list.forEach((element) {
      if (element.viewType == ViewTypes.caratRange) {
        map[(element as SelectionModel).apiKey] =
            Master.getSelectedId((element as SelectionModel).masters);
      }
    });

    list.forEach((element) {
      if (element.viewType == ViewTypes.shapeWidget) {
        map[element.apiKey] =
            Master.getSelectedId((element as SelectionModel).masters);
      }
    });
  }
}
