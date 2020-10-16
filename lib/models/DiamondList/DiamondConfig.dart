import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';

class DiamondConfig {
  int moduleType;

  DiamondConfig(this.moduleType);

  String getScreenTitle() {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        return R.string().screenTitle.searchDiamond;
    }
  }
}
