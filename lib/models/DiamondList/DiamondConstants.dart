import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/cupertino.dart';

class DiamondModuleConstant {
  static const MODULE_TYPE_SEARCH = 1;
  static const MODULE_TYPE_UPCOMING = 2;
  static const MODULE_TYPE_PROFILE = 3;
}

class ArgumentConstant {
  static const ModuleType = "moduleType";
  static const IsFromDrawer = "isFromDrawer";
  static const DiamondDetail = "diamondModel";
}

typedef ActionClick(ManageCLick manageCLick);

class ManageCLick {
  int type;
  BottomTabModel bottomTabModel;
  ManageCLick({this.bottomTabModel, this.type});
}

class DrawerConstant {
  static const int MODULE_SEARCH = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  static const int MODULE_UPCOMING = DiamondModuleConstant.MODULE_TYPE_UPCOMING;
  static const int MODULE_PROFILE = DiamondModuleConstant.MODULE_TYPE_PROFILE;

  static const int LOGOUT = 111;
  static const int OPEN_DRAWER = 1001;
}

class clickConstant {
  static const CLICK_TYPE_ROW = 1;
  static const CLICK_TYPE_SELECTION = 2;
}

class ActionMenuConstant {
  static const ACTION_TYPE_ENQUIRY = 1;
  static const ACTION_TYPE_WISHLIST = 2;
  static const ACTION_TYPE_PLACE_ORDER = 3;
  static const ACTION_TYPE_ADD_TO_CART = 4;
  static const ACTION_TYPE_COMMENT = 5;
  static const ACTION_TYPE_OFFER = 6;
  static const ACTION_TYPE_OFFER_VIEW = 7;
  static const ACTION_TYPE_HOLD = 8;
  static const ACTION_TYPE_DOWNLOAD = 9;
  static const ACTION_TYPE_CLEAR_SELECTION = 10;
  static const ACTION_TYPE_SHARE = 11;
}

class MoreMenuConstant {
  static const int ENQUIRY = ActionMenuConstant.ACTION_TYPE_ENQUIRY;
  static const int PLACE_ORDER = ActionMenuConstant.ACTION_TYPE_PLACE_ORDER;
  static const int ADD_TO_CART = ActionMenuConstant.ACTION_TYPE_ADD_TO_CART;
  static const int COMMENT = ActionMenuConstant.ACTION_TYPE_COMMENT;
  static const int OFFER = ActionMenuConstant.ACTION_TYPE_OFFER;
  static const int OFFER_VIEW = ActionMenuConstant.ACTION_TYPE_OFFER_VIEW;
  static const int HOLD = ActionMenuConstant.ACTION_TYPE_HOLD;
  static const int DOWNLOAD = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
  static const int CLEAR_SELECTION =
      ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION;
  static const int SHARE = ActionMenuConstant.ACTION_TYPE_SHARE;
}
