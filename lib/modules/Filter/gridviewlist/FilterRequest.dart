import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';

class FilterRequest {
  Map<String, dynamic> createRequest(List<FormBaseModel> list) {
    Map<String, dynamic> map = {};

    list.forEach((element) {
      if (element.viewType == ViewTypes.selection) {
        List<String> selectedMasterIds=(element as SelectionModel)
            .masters
            .where((element) => element.isSelected == true)
            .map((e) => e.sId).toList();
        map[element.apiKey]=selectedMasterIds;      
      }
    });

    list.forEach((element) {
      if(element.viewType == ViewTypes.fromTo){
        Map<String,num> fromToValue = {};
        fromToValue[">="] = (element as FromToModel).minValue;
        fromToValue["<="] = (element as FromToModel).maxValue;
            
        map[element.apiKey]=fromToValue;      
      } 
    });

    // list.forEach((element) { 
    //   if(element.viewType == ViewTypes.keytosymbol){
    //     List<String
    //   }
    // });

  }
}
