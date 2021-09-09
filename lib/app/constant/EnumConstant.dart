import 'package:diamnow/models/DiamondList/DiamondConstants.dart';

class ViewTypes {
  static const String fromTo = "fromto";
  static const String selection = "selection";
  static const String dropDown = "dropDown";
  static const String groupWidget = "groupwidget";
  static const String seperator = "seperator";
  static const String certNo = "certNo";
  static const String keytosymbol = "keytosymbol";
  static const String caratRange = "caratrange";
  static const String shapeWidget = "shape";
}

class TabTypes {
  static const String basic = "basic";
  static const String advanced = "advanced";
  static const String stoneIdCertTab = "stoneIdCertTab";
}

class DisplayTypes {
  static const String vertical = "v";
  static const String horizontal = "h";
}

enum DialogueListType { Country, State, City, SAVEDSEARCH, BusinessType }

class VirtualTypes {
  static const int phoneCall = 1;
  static const int webConference = 2;
  static const int inPerson = 3;
}

class OrderInvoiceData {
  static const int today = 1;
  static const int tommorow = 2;
  static const int later = 3;
}

enum DownloadDataType { Images, Video, Certificate, Excel, Rough }

class DownloadAndShareDialogueConstant {
  static const int realImage1 = 1;
  static const int plottingImg = 2;
  static const int assetScopeImg = 3;
  static const int faceUpImg = 4;
  static const int idealScopeImg = 5;
  static const int realImage2 = 6;
  static const int heartAndArrowImg = 7;
  static const int arrowImg = 8;
  static const int darkFieldImg = 9;
  static const int flouresenceImg = 10;
  static const int video1 = 11;
  static const int video2 = 12;
  static const int certificate = 13;
  static const int typeIIA = 14;
  static const int excel = 15;
  static const int roughScope = 16;
  static const int roughVideo = 17;
  static const int img3D = 18;

  static const int propimage = 19;
  static const int naturalImage = 20;
}

//Documents Type
enum DocumentType {
  PhotoProof,
  BussinessProof,
}

class DocumentsConstants {
  static const String PhotoProof = "1";
  static const String BussinessProof = "2";
}

class VersionUpdateApi {
  static const String logIn = "1";
  static const String splash = "2";
  static const String signInAsGuest = "3";
  static const String signInWithMpin = "4";
}

class KYCStatus {
  static const int pending = 1;
  static const int approved = 2;
  static const int rejected = 3;
}

class Mpin {
  static const int splash = 1;
  static const int myAccount = 2;
  static const int login = 3;
  static const int changeMpin = 4;
  static const int resetMpin = 5;
  static const int forgotMpin = 6;
  static const int createMpin = 7;
}

class OfferStatus {
  static const int pending = 1;
  static const int accepted = 2;
  static const int rejected = 3;
  static const int expired = 4;
}

//MARK: Analytics
//Section
class SectionAnalytics {
  static const String ADVANCE_SEARCH = "AdvanceSearch";
  static const String ADD_DEMAND = "AddDemand";
  static const String SAVED_SEARCH = "SavedSearch";
  static const String UPLOAD_EXCEL = "UploadExcel";
  static const String RESET_FILTER = "ResetFilter";
  static const String THREE_EX = "ThreeEx";
  static const String TWO_EX = "TwoEx";
  static const String THREE_VG = "ThreeVg";
  static const String CARAT_SIZE = "CaratSize";
  static const String COLOR = "Color";
  static const String LIST = "List";
  static const String MODIFY = "Modify";
  static const String FILTER = "Filter";
  static const String PLACE_ORDER = "PlaceOrder";
  static const String SHIPMENT = "Shipment";
  static const String ENQUIRY = "Enquiry";
  static const String UPDATE = "Update";
  static const String EXPORT = "Export";
  static const String ACTION_HEADER = "ActionHeader";
  static const String TABLE = "Table";
  static const String EDIT = "edit";
  static const String DELETE = "delete";
  static const String CHANGE_PSWD = "changePswd";
  static const String INVANTORY = "invantory";
  static const String CALCULATOR = "calculator";
  static const String TRACK_SHIPMENT = "trackShipment";
  static const String LOCALE = "locale";
  static const String SEARCH = "search";
  static const String CART = "cart";
  static const String VIEW = "view";
  static const String SETTING = "setting";
  static const String WATCHLIST = "watchlist";
  static const String COMMENT = "comment";
  static const String REMINDER = "reminder";
  static const String DETAILS = "details";
  static const String MYOFFER = "Offer";
  static const String OFFLINESEARCH = "OfflineSearch";

  //Todo
  static const String SHARE = "Share";
  static const String DOWNLOAD = "download";

  static const String MATCHPAIRS = "MatchPairs";
  static const String EXCLUSIVEDIAMOND = "ExclusiveDiamond";
  static const String NEWGOODS = "NewGoods";
  static const String COMPARE = "Compare";
  static const String ADD = "add";
  static const String SCREENSHOT = "screenShot";
}

//Page Analytics
class PageAnalytics {
  static const String SEARCH_RESULT = "SearchResult";
  static const String BEST_OF_HK = "BestOfHK";
  static const String UPCOMING_DIAMOND = "UpcomingDiamond";
  static const String NEW_DIAMOND = "NewDiamond";
  static const String MY_CART = "MyCart";
  static const String MY_WATCHLIST = "MyWatchlist";
  static const String MY_REMINDER = "MyReminder";
  static const String MY_COMMENT = "MyComment";
  static const String MY_ENQUIRY = "MyEnquiry";
  static const String MY_DEMAND = "MyDemand";
  static const String MY_ORDER = "MyOrder";
  static const String FANCY_SEARCH = "FancySearch";
  static const String DIAMOND_SEARCH = "DiamondSearch";
  static const String MYSAVED_SEARCH = "MySavedSearch";
  static const String DIAMOND_LIST = "DiamondList";

  static const String MY_ACCOUNT = "MyAccount";
  static const String DRAWER = "Drawer";
  static const String VOICE_SEARCH = "VoiceSearch";
  static const String TRANSPORT = "TransPort";
  static const String MY_PURCHASE = "MyPurchase";

  //ToDo
  static const String QRCODE = "QrCode";
  static const String MY_BID = "MyBid";
  static const String HOME = "Home";
  static const String OfflineSearchHistory = "OfflineSearchHistory";
  static const String NOTIFICATION = "Notification";
  static const String HOSPITALITY = "Hospitality";
  static const String EXCLUSIVE_DIAMOND = "ExclusiveDiamond";
  static const String NEW_GOODS = "NewGoods";
  static const String I_AM_LUCKY = "IamLucky";
  static const String MATCH_PAIRS = "Matchpairs";
  static const String DIAMOND_DETAIL = "DiamondDetail";
  static const String COMPARE = "Compare";
  static const String APPOINTMENT = "Appointment";
  static const String PRICE_CALC = "pricecalculator";
  static const String QUICK_SERACH = "quicksearch";
  static const String SUGESSIONS = "sugessions";
  static const String ABOUT_US = "aboutus";
  static const String MESSAGE_TO_MD = "messagetomd";
  static const String CONTACT = "contact";
  static const String LOGOUT = "logout";

  static const String PROFILE = "profile";
  static const String OFFLINE_DOWNLOAD = "offlinedownload";
  static const String STONE_OF_THE_DAY = "stoneoftheday";
  static const String SCREENSHOT = "screenShot";
  static const String MY_OFFER = "MyOffer";

  static String getPageAnalyticsFromModuleType(int moduleType) {
    if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_CART) {
      return MY_CART;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST) {
      return MY_WATCHLIST;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH) {
      return QUICK_SERACH;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_PROFILE) {
      return PROFILE;
    } else if (moduleType ==
        DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
      return MY_BID;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR) {
      return MATCH_PAIRS;
    } else if (moduleType ==
        DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY) {
      return STONE_OF_THE_DAY;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_COMPARE) {
      return COMPARE;
    } else if (moduleType ==
        DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH_HISTORY) {
      return OfflineSearchHistory;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_NOTIFICATION) {
      return NOTIFICATION;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_DIAMOND_DETAIL) {
      return DIAMOND_DETAIL;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_DEMAND) {
      return MY_DEMAND;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL) {
      return NEW_GOODS;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_HOME) {
      return HOME;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_ORDER) {
      return MY_ORDER;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_OPEN_DRAWER) {
      return DRAWER;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_ABOUT_US) {
      return ABOUT_US;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY) {
      return ABOUT_US;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE) {
      return MY_PURCHASE;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_VOICE_SEARCH) {
      return VOICE_SEARCH;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY) {
      return MY_ENQUIRY;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_COMMENT) {
      return MY_COMMENT;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_REMINDER) {
      return MY_REMINDER;
    } else if (moduleType ==
        DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH) {
      return MYSAVED_SEARCH;
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
      return DIAMOND_SEARCH;
    }
  }
}

//Action Analytics
class ActionAnalytics {
  static const String OPEN = "open";
  static const String CLOSE = "close";
  static const String CANCEL = "cancel";
  static const String CLICK = "click";
  static const String RESET = "reset";
  static const String EMAIL_EXCEL = "emailexcel";
  static const String VIDEO = "video";
  static const String PICTURE = "picture";
  static const String CERTIFICATE = "certificate";
  static const String CHANGE = "change";
  static const String DOWNLOAD = "download";
  static const String GRID = "grid";
  static const String LIST = "list";
  static const String SELECT = "select";
  static const String UNSELECT = "unselect";
  static const String SCREENSHOT = "screenShot";
}
