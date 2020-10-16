import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';

class DiamondConfig {
  int moduleType;

  List<BottomTabModel> toolbarList = [];

  DiamondConfig(this.moduleType);

  initItems() {
    toolbarList = getToolbarItem();
  }

  String getScreenTitle() {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        return R.string().screenTitle.searchDiamond;
      default:
        return R.string().screenTitle.searchDiamond;
    }
  }

  List<BottomTabModel> getToolbarItem() {
    List<BottomTabModel> list = [];
    list.add(BottomTabModel(
        title: "",
        image: selectAll,
        code: BottomCodeConstant.TBSelectAll,
        sequence: 0,
        isCenter: true));
    list.add(BottomTabModel(
        title: "",
        image: gridView,
        code: BottomCodeConstant.TBGrideView,
        sequence: 1,
        isCenter: true));
    list.add(BottomTabModel(
        title: "",
        image: filter,
        code: BottomCodeConstant.TBSortView,
        sequence: 2,
        isCenter: true));
    list.add(BottomTabModel(
        title: "",
        image: download,
        code: BottomCodeConstant.TBDownloadView,
        sequence: 3,
        isCenter: true));
    return list;
  }
}
