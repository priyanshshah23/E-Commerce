class DiamondModuleConstant {
  static const MODULE_TYPE_SEARCH = 1;
  static const MODULE_TYPE_UPCOMING = 2;
}

class ArgumentConstant{
  static const ModuleType = "moduleType";
  static const IsFromDrawer = "isFromDrawer";
}

class DrawerConstant {
  static const int MODULE_SEARCH = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  static const int MODULE_UPCOMING = DiamondModuleConstant.MODULE_TYPE_UPCOMING;

  static const int LOGOUT = 111;
  static const int OPEN_DRAWER = 1001;
}

class MoreMenuModuleConstant {
  static const MODULE_TYPE_ENQUIRY = 1;
  static const MODULE_TYPE_WISHLIST = 2;
  static const MODULE_TYPE_PLACE_ORDER = 3;
  static const MODULE_TYPE_ADD_TO_CART = 4;
  static const MODULE_TYPE_COMMENT = 5;
  static const MODULE_TYPE_OFFER = 6;
  static const MODULE_TYPE_OFFER_VIEW = 7;
  static const MODULE_TYPE_HOLD = 8;
  static const MODULE_TYPE_DOWNLOAD = 9;
  static const MODULE_TYPE_CLEAR_SELECTION = 10;
  static const MODULE_TYPE_SHARE = 11;
}

class MoreMenuConstant {
  static const int ENQUIRY = MoreMenuModuleConstant.MODULE_TYPE_ENQUIRY;
  static const int PLACE_ORDER = MoreMenuModuleConstant.MODULE_TYPE_PLACE_ORDER;
  static const int ADD_TO_CART = MoreMenuModuleConstant.MODULE_TYPE_ADD_TO_CART;
  static const int COMMENT = MoreMenuModuleConstant.MODULE_TYPE_COMMENT;
  static const int OFFER = MoreMenuModuleConstant.MODULE_TYPE_OFFER;
  static const int OFFER_VIEW = MoreMenuModuleConstant.MODULE_TYPE_OFFER_VIEW;
  static const int HOLD = MoreMenuModuleConstant.MODULE_TYPE_HOLD;
  static const int DOWNLOAD = MoreMenuModuleConstant.MODULE_TYPE_DOWNLOAD;
  static const int CLEAR_SELECTION = MoreMenuModuleConstant.MODULE_TYPE_CLEAR_SELECTION;
  static const int SHARE = MoreMenuModuleConstant.MODULE_TYPE_SHARE;
}
