import 'package:diamnow/models/FilterModel/BottomTabModel.dart';

class DiamondModuleConstant {
  static const MODULE_TYPE_DIAMOND_SEARCH_RESULT = 0;
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
  static const MODULE_TYPE_MY_REMINDER = 27;
  static const MODULE_TYPE_MANAGE_ADDRESS = 28;
  static const MODULE_TYPE_COMPARE = 29;
  static const MODULE_TYPE_MATCH_PAIR = 30;
  static const MODULE_TYPE_RECENT_SEARCH = 31;
  static const MODULE_TYPE_OFFLINE_STOCK = 32;
  static const MODULE_TYPE_OFFLINE_STOCK_SEARCH = 33;
  static const MODULE_TYPE_OFFLINE_STOCK_SEARCH_HISTORY = 34;
  static const MODULE_TYPE_LAYOUT = 35;
  static const MODULE_TYPE_MY_BID_HISTORY = 37;
  static const MODULE_TYPE_OPEN_DRAWER = 1000;
  static const MODULE_TYPE_HOME = 100;
  static const MODULE_TYPE_FINAL_CALCULATION = 101;
  static const MODULE_TYPE_UPLOAD_KYC = 102;
  static const MODULE_TYPE_TOUCH_ID = 103;
  static const MODULE_TYPE_MPIN = 104;
  static const MODULE_TYPE_CHANGEMPIN = 105;
  static const MODULE_TYPE_FILTER_OFFLINE_NOTI_CLICK = 106;
  static const MODULE_TYPE_NOTIFICATION = 107;
  static const MODULE_TYPE_DIAMOND_DETAIL = 108;
  static const MODULE_TYPE_VOICE_SEARCH = 109;
  static const MODULE_TYPE_PRICE_CALCULATOR = 110;
  static const MODULE_TYPE_MEMO = 111;
}

class ModulePermissionConstant {
  static const permission_dashboard = "DASHBOARD";
  static const permission_searchDiamond = "SEARCH_DIAMOND";
  static const permission_fancySearch = "FANCY_SEARCH";
  static const permission_quickSearch = "QUICK_SEARCH";
  static const permission_mySavedSearch = "SAVE_SEARCH";
  static const permission_myDemand = "DEMAND";
  static const permission_searchResult = "SEARCH_LIST";
  static const permission_compare = "COMPARE";
  static const permission_showSelected = "showSelected";
  static const permission_matchPair = "MATCH_PAIR";
  static const permission_iAmLucky = "iAmLucky";
  static const permission_parcelList = "parcelList";
  static const permission_newGoods = "NEW_ARRIVAL_BID_IT";
  static const permission_bestOfHK = "bestOfHK";
  static const permission_upcomingDiamonds = "UPCOMING";
  static const permission_cart = "CART";
  static const permission_reminder = "REMINDER";
  static const permission_watchlist = "WATCHLIST";
  static const permission_comment = "NOTES";
  static const permission_enquiry = "ENQUIRY";
  static const permission_excel = "excel";
  static const permission_order = "order";
  static const permission_purchase = "purchase";
  static const permission_stone_of_the_day = "stoneoftheday";
  static const permission_appointment = "APPOINTMENT";
  static const permission_address = "address";

  static const permission_featured = "featured";
  static const permission_auction = "auction";
  static const permission_exclusive = "EXCLUSIVE";
  static const permission_bid = "MY_BID";
  static const permission_hold = "HOLD";
  static const permission_memo = "MEMO";
  static const permission_offer = "QUOTE";
  static const permission_notification = "NOTIFICATIONS";
  static const permission_offline_stock = "offlineStock";
  static const permission_confirm_stone = "CONFIRM_STONE";
  static const permission_office = "OFFICE";
  static const permission_remove_rapnet = "REMOVE_FROM_RAPNET";
  static const permission_shipment = "SHIPMENT";
  static const permission_print = "PRINT";
  static const permission_final_calculation = "FINAL_CALCULATIONS";
  static const permission_share_via_mail = "SHARE_VIA_MAIL";
  static const permission_share_via_whatsapp = "SHARE_VIA_WHATSAPP";
  static const permission_share_via_skype = "SHARE_VIA_SKYPE";
  static const permission_suggested_stock = "SUGGESTED_STOCK";
}

class ReminderType {
  static const ReminderTypeToday = 1;
  static const ReminderTypeTomorrow = 2;
  static const ReminderTypeNextWeek = 3;
  static const ReminderTypeCustom = 4;
}

class PermissionType {
  static const permission_view = "view";
  static const permission_insert = "insert";
  static const permission_update = "update";
  static const permission_delete = "delete";
  static const permission_uploadExcel = "uploadExcel";
  static const permission_downloadExcel = "downloadExcel";
  static const permission_mailExcel = "mailExcel";
  static const permission_printPDF = "printPDF";
  static const permission_all = "all";
}

class ArgumentConstant {
  static const ModuleType = "moduleType";
  static const ActionType = "actionType";
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
  static const CLICK_TYPE_DELETE = 4;
  static const CLICK_TYPE_OFFER_EDIT = 5;
  static const CLICK_TYPE_DETAIL = 6;
  static const CLICK_TYPE_EDIT = 7;
}

class DiamondBlockType {
  static const HOLD = 1;
  static const MEMO = 2;
}

class DiamondTrackConstant {
  static const TRACK_TYPE_CART = 1;
  static const TRACK_TYPE_WATCH_LIST = 2;
  static const TRACK_TYPE_OFFICE = 3;
  static const TRACK_TYPE_OFFER = 4;
  static const TRACK_TYPE_REMINDER = 5;
  static const TRACK_TYPE_ENQUIRY = 6;
  static const TRACK_TYPE_SHIPMENT = 7;
  static const TRACK_TYPE_SHOWSELECTED = 8;
  static const TRACK_TYPE_BEST_BUY = 9;
  static const TRACK_TYPE_COMMENT = 99;
  static const TRACK_TYPE_APPOINTMENT = 100;
  static const TRACK_TYPE_BID = 101;
  static const TRACK_TYPE_PLACE_ORDER = 102;
  static const TRACK_TYPE_FINAL_CALCULATION = 103;
  static const TRACK_TYPE_UPDATE_COMMENT = 104;
}

class BidConstant {
  static const BID_TYPE_BLIND = 1;
  static const BID_TYPE_OPEN = 2;
  static const BID_TYPE_ADD = 3;
}

class MemoConstant {
  static const MEMO_ORDER = 1;
  static const MEMO_PURCHASE = 2;
}

class BidStatus {
  static const BID_STATUS_PENDING = 1;
  static const BID_STATUS_WIN = 2;
  static const BID_STATUS_LOSS = 3;
  static const BID_STATUS_ACTIVE = 4;
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
  static const ACTION_TYPE_REMINDER = 16;
  static const ACTION_TYPE_DELETE = 17;
  static const ACTION_TYPE_FINAL_CALCULATION = 18;
  static const ACTION_TYPE_CANCEL_STONE = 19;
  static const ACTION_TYPE_EXCEL = 20;
  static const ACTION_TYPE_MEMO = 21;
  static const ACTION_TYPE_MY_BID = 27;
  static const ACTION_TYPE_CONFIRM_STONE = 22;
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
