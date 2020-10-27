import 'package:diamnow/models/FilterModel/BottomTabModel.dart';

class DiamondModuleConstant {
  static const MODULE_TYPE_SEARCH = 1;
  static const MODULE_TYPE_QUICK_SEARCH = 2;
  static const MODULE_TYPE_NEW_ARRIVAL = 3;
  static const MODULE_TYPE_EXCLUSIVE_DIAMOND = 4;
  static const MODULE_TYPE_DIAMOND_AUCTION = 5;
  static const MODULE_TYPE_STONE_OF_THE_DAY = 6;
  static const MODULE_TYPE_MY_WATCH_LIST = 7;
  static const MODULE_TYPE_MY_CART = 8;
  static const MODULE_TYPE_MY_ENQUIRY = 9;
  static const MODULE_TYPE_MY_BID = 10;
  static const MODULE_TYPE_MY_HOLD = 11;
  static const MODULE_TYPE_MY_ORDER = 12;
  static const MODULE_TYPE_MY_OFFICE = 13;
  static const MODULE_TYPE_MY_OFFER = 14;
  static const MODULE_TYPE_MY_PURCHASE = 15;
  static const MODULE_TYPE_MY_SAVED_SEARCH = 16;
  static const MODULE_TYPE_MY_DEMAND = 17;
  static const MODULE_TYPE_TERM_CONDITION = 18;
  static const MODULE_TYPE_PRIVACY_POLICY = 19;
  static const MODULE_TYPE_ABOUT_US = 20;
  static const MODULE_TYPE_CONTACT_US = 21;
  static const MODULE_TYPE_CHANGE_PASSWORD = 22;
  static const MODULE_TYPE_LOGOUT = 23;
  static const MODULE_TYPE_UPCOMING = 24;
  static const MODULE_TYPE_PROFILE = 25;
  static const MODULE_TYPE_MY_COMMENT = 26;
  static const MODULE_TYPE_COMPARE = 27;
  static const MODULE_TYPE_MATCH_PAIR = 28;
  static const MODULE_TYPE_RECENT_SEARCH = 29;
  static const MODULE_TYPE_OPEN_DRAWER = 1000;
  static const MODULE_TYPE_HOME = 100;
}

class ArgumentConstant {
  static const ModuleType = "moduleType";
  static const IsFromDrawer = "isFromDrawer";
  static const DiamondDetail = "diamondModel";
  static const DiamondList = "diamondList";
}

typedef ActionClick(ManageCLick manageCLick);

class ManageCLick {
  int type;
  BottomTabModel bottomTabModel;
  String remark;
  String companyName;
  String date;

  ManageCLick(
      {this.bottomTabModel,
      this.type,
      this.companyName,
      this.remark,
      this.date});
}

class clickConstant {
  static const CLICK_TYPE_ROW = 1;
  static const CLICK_TYPE_SELECTION = 2;
  static const CLICK_TYPE_CONFIRM = 3;
}

class DiamondTrackConstant {
  static const TRACK_TYPE_CART = 1;
  static const TRACK_TYPE_WATCH_LIST = 2;
  static const TRACK_TYPE_OFFER = 4;
  static const TRACK_TYPE_ENQUIRY = 6;
  static const TRACK_TYPE_COMMENT = 99;
  static const TRACK_TYPE_APPOINTMENT = 100;
  static const TRACK_TYPE_BID = 101;
}

class BidConstant {
  static const BID_TYPE_ADD = 2;
}

class MemoConstant {
  static const MEMO_ORDER = 1;
  static const MEMO_PURCHASE = 2;
}

class BidStatus {
  static const BID_STATUS_ACTIVE = 1;
}

class BorderConstant {
  static const BORDER_TOP = 1;
  static const BORDER_BOTTOM = 2;
  static const BORDER_LEFT_RIGHT = 3;
  static const BORDER_NONE = 4;
  static const BORDER_MARGIN = 4.0;
}

class ActionMenuConstant {
  static const ACTION_TYPE_ENQUIRY = 1;
  static const ACTION_TYPE_WISHLIST = 2;
  static const ACTION_TYPE_PLACE_ORDER = 3;
  static const ACTION_TYPE_ADD_TO_CART = 4;
  static const ACTION_TYPE_COMMENT = 5;
  static const ACTION_TYPE_OFFER = 6;
  static const ACTION_TYPE_APPOINTMENT = 7;
  static const ACTION_TYPE_HOLD = 8;
  static const ACTION_TYPE_DOWNLOAD = 9;
  static const ACTION_TYPE_CLEAR_SELECTION = 10;
  static const ACTION_TYPE_SHARE = 11;
  static const ACTION_TYPE_STATUS = 12;
  static const ACTION_TYPE_MORE = 13;
  static const ACTION_TYPE_COMPARE = 14;
  static const ACTION_TYPE_BID = 15;
}

class MoreMenuConstant {
  static const int ENQUIRY = ActionMenuConstant.ACTION_TYPE_ENQUIRY;
  static const int PLACE_ORDER = ActionMenuConstant.ACTION_TYPE_PLACE_ORDER;
  static const int ADD_TO_CART = ActionMenuConstant.ACTION_TYPE_ADD_TO_CART;
  static const int COMMENT = ActionMenuConstant.ACTION_TYPE_COMMENT;
  static const int OFFER = ActionMenuConstant.ACTION_TYPE_OFFER;
  static const int OFFER_VIEW = ActionMenuConstant.ACTION_TYPE_APPOINTMENT;
  static const int HOLD = ActionMenuConstant.ACTION_TYPE_HOLD;
  static const int DOWNLOAD = ActionMenuConstant.ACTION_TYPE_DOWNLOAD;
  static const int CLEAR_SELECTION =
      ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION;
  static const int SHARE = ActionMenuConstant.ACTION_TYPE_SHARE;
}
