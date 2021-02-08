import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';

class DiamondCompare {
  List<DiamondDetailUIModel> compareDetailList;
  bool isSelected = false;
  DiamondModel diamondModel;
  DiamondCompare({this.diamondModel, this.compareDetailList});
}
