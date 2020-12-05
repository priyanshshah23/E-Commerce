const String baseURL = "http://pndevelopapi.democ.in/";
//const String baseURL = "192.168.0.212:8094/";
const apiV1 = "api/v1/";

const DEVICE_TYPE_ANDROID = 1; //Android
const DEVICE_TYPE_IOS = 2; //IOS
const DEFAULT_PAGE = 1;
const DEFAULT_LIMIT = 100;
const SUCCESS = 1;
const FAIL = 2;

var IMAGEFILESIZE = 10.0;

const APPNAME = "My Diamonds";

const CODE_OK = "OK";
const CODE_SUCCESS = "SUCCESS";
const E_FORBIDDEN = "E_FORBIDDEN";

const MISMATCHED_TIME_ZONE = "MISMATCHED_TIME_ZONE";
const CODE_UNAUTHORIZED = "E_UNAUTHORIZED";
const CODE_TOKEN_EXPIRE = "E_TOKEN_EXPIRE";
const CODE_ERROR = "E_ERROR";
const CODE_DEVICE_LOGOUT = "CODE_DEVICE_LOGOUT";
const CODE_KILL_SWITCH = "CODE_KILL_SWITCH";
const TOKEN_EXPIRY_CODE = "TOKEN_EXPIRY_CODE";
const INTERNET_UNAWAILABLE = "INTERNET_UNAWAILABLE";
const NO_CONNECTION = "Internet unavailable.";
const MOBILE_NOT_VERIFIED = "Your mobile is not verified.";
const SOMETHING_WENT_WRONG = "Something went wrong, please try again later.";
const PARSING_WRONG = "Something went wrong, please try again later.";
const createdAt_DESC = "createdAt DESC";
const successStatusCode = 200;
const addedSuccesStatusCode = 201;
const notFoundStatusCode = 404;

const signupURl = "http://192.168.0.187:3003/device/signup";
const termConditionUrl = "https://loremipsum.io/";
const privacyPolicyUrl = "https://loremipsum.io/";
const aboutUsUrl = "https://loremipsum.io/";

const eventBusTag = "EventBus";
const eventBusSocket = "EventBusSocket";
const eventBusLogout = "EventBusLogout";
const eventBusDropDown = "EventBusDropDown";
const eventBusRefreshList = "DiamondListRefresh";

const imagePath = "assest/icon.png";
const String googleDocViewURL =
    "https://docs.google.com/gview?embedded=true&url=";

const String diamondImageURL =
    "https://s3.ap-south-1.amazonaws.com/finestargroup/RealImages/";

const String ONE_SIGNAL_KEY = "cd966ee9-bb9a-4679-b14c-dd8f4eb36f75";

const RegexForEmoji =
    r'(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])';
// r'((\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]))';
const RegexForTextField =
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]|[ -%^&"!#])';

const RegexForStrongPasswd =
    r'(^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$)';
//check number
const numberRegExp = r'[a-z][A-Z]!@#$%^&*()_+{}:">?<,./;';
// DB Constant
const alphaNumberRegEx = r'[a-zA-Z0-9]';
const alphaRegEx = r'[a-zA-Z]';
const spaceRegEx = r'\s';
const numberRegXWithDecimalAllows = r'([0-9]*[0-9]+\.)[0-9]{0,2}';
const IMAGE_FILE_SIZE = 10.0;
const BUSINESS_TYPE = "BUSINESS_TYPE";
const NATURE_OF_ORG = "NATURE_OF_ORG";

//Offer min/max discount
const num minOfferedDiscount = -5;
const num maxOfferedDiscount = -70;

class Spacing {
  static const num leftPadding = 16.0;
  static const num rightPadding = 16.0;
}

//Master Code
class MasterCode {
  static const String shape = "SHAPE";
  static const String color = "COLOR";
  static const String fancyColor = "FANCY_COLOR";
  static const String intensity = "INTENSITY";
  static const String overTone = "OVERTONE";
  static const String clarity = "CLARITY";
  static const String fluorescence = "FLUORESCENCE";
  static const String colorShade = "SHADE";
  static const String lab = "LAB";
  static const String cut = "CUT";
  static const String polish = "POLISH";
  static const String symmetry = "SYMMETRY";
  static const String location = "LOCATION";
  static const String keyToSymbol = "KEY_TO_SYMBOLS";
  static const String blackTable = "BLACK_INCLUSION_TABLE";
  static const String blackside = "BLACK_INCLUSION_SIDE";
  static const String blackCrown = "BLACK_INCLUSION_CROWN";
  static const String whiteside = "WHITE_INCLUSION_SIDE";
  static const String whiteTable = "WHITE_INCLUSION_TABLE";
  static const String whiteCrown = "WHITE_INCLUSION_CROWN";
  static const String milky = "MILKEY";
  static const String tableOpen = "OPEN_TABLE";
  static const String crownOpen = "OPEN_CROWN";
  static const String pavilionOpen = "OPEN_PAVILION";
  static const String origin = "ORIGIN";
  static const String eyeClean = "EYECLEAN";
  static const String hAndA = "H_AND_A";
  static const String girdle = "GIRDLE";
  static const String girdleCondition = "GIRDLE_COND";
  static const String culet = "CULET";
  static const String culetCondition = "CULET_COND";
  static const String make = "MAKE";
  static const String arrivals = "ARRIVALS";
  static const String stage = "STAGE";
  static const String noBgm = "NoBGM";
  static const String colorGroup = "COLORGROUP";
  static const String clarityGroup = "CLARITYGROUP";
  static const String canadamarkparent = "CANADAMARKPARENT";
  static const String typeiia = "TYPEIIA";
  static const String canadamark = "CANADAMARK";
  static const String xray = "XRAY";
  static const String upcoming = "UPCOMING";
  static const String eyecleanStatic = "EYECLEANSTATIC";
  static const String newarrivalsgroup = "NEWARRIVALSGROUP";
  static const String newarrivals = "NEWARRIVAL";
  static const String dor = "DOR";
  static const String fm = "FM";
  static const String natural = "NATURAL";
  static const String mixTint = "MIX_TINT";
  static const String companySize = "COMPANY_SIZE";
  static const String openInclusion = "OPEN_INCLUSION";
  static const String blackInclusion = "BLACK_INCLUSION";
  static const String docTypePersonal = "DOC_TYPE_PERSONAL";
  static const String docTypeBusiness = "DOC_TYPE_BUSINESS";

  // static const String mixTint = "MIX_TINT";
}

class DiamondStatus {
  static const String DIAMOND_STATUS_AVAILABLE = "A";
  static const String DIAMOND_STATUS_ON_MINE = "M";
  static const String DIAMOND_STATUS_OFFER = "O";
  static const String DIAMOND_STATUS_SHOW = "S";
  static const String DIAMOND_STATUS_BID = "B";
  static const String DIAMOND_STATUS_UPCOMING = "U";
  static const String DIAMOND_STATUS_HOLD = "H";
}

class StaticPageConstant {
  static const String ABOUT_US = "ABOUT_US";
  static const String PRIVACY_POLICY = "PRIVACY_POLICY";
  static const String TERMS_CONDITION = "TERMS_CONDITION";
  static const String CONTACT_US = "CONTACT_US";
}

class DiamondSearchType {
  static const int RECENT = 1;
  static const int SAVE = 2;
  static const int DEMAND = 3;
  static const int API_SEARCH = 4;
  static const int PAIR_SEARCH = 5;
  static const int VOICE_SEARCH = 6;
  static const int LUCKY_SEARCH = 7;
  static const int ARTICLE = 8;
  static const int COLLECTION = 9;
}

class VirtualTypesString {
  static const String phoneCall = "Phone Call";
  static const String webConference = "Web Conference";
  static const String inPerson = "In Person";
}

class InvoiceTypesString {
  static const String today = "Today";
  static const String tomorrow = "Tommorrow";
  static const String later = "Later";
}

class InvoiceTypes {
  static const int today = 1;
  static const int tomorrow = 2;
  static const int later = 3;
}

class DashboardConstants {
  static const String stoneOfTheDay = "stone_of_day";
  static const String best = "best";
}

class SavedSearchType {
  static const int savedSearch = 2;
  static const int recentSearch = 1;
}

class NotificationConstant {
  static const MODULE_TYPE_SEARCH = 1;
  static const MODULE_TYPE_DIAMOND_COMPARE = 2;
  static const MODULE_TYPE_WATCHLIST = 3;
  static const MODULE_TYPE_ADD_ENQUIRY = 4;
  static const MODULE_TYPE_REMINDER = 5;
  static const MODULE_TYPE_LUCKY = 6;
  static const MODULE_TYPE_STONE_OF_DAY = 7;
  static const MODULE_TYPE_EXCLUSIVE_STONE = 8;
  static const MODULE_TYPE_FANCY_DIAMOND = 9;
  static const MODULE_TYPE_NEW_GOODS = 10;
  static const MODULE_TYPE_MATCH_PAIR = 11;
  static const MODULE_TYPE_OFFLINE_STOCK = 12;
  static const MODULE_TYPE_PRICE_CALC = 13;
  static const MODULE_TYPE_CONCIERGE = 14;
  static const MODULE_TYPE_QR_CODE = 15;
  static const MODULE_TYPE_MORE = 16;
  static const MODULE_TYPE_RATE_US = 17;
  static const MODULE_TYPE_CONTACT_US = 18;
  static const MODULE_TYPE_DIAMOND_DETAIL = 19;
  static const MODULE_TYPE_QUICK_SEARCH = 20;
  static const MODULE_TYPE_PROFILE = 21;
  static const MODULE_TYPE_COMMENT = 22;
  static const MODULE_TYPE_ENQUIRY = 23;
  static const MODULE_TYPE_CART = 24;
  static const MODULE_TYPE_RECENT_SEARCH = 25;
  static const MODULE_TYPE_SAVED_SEARCH = 26;
  static const MODULE_TYPE_OFFLINE_STOCK_SEARCH = 27;
  static const MODULE_TYPE_OFFLINE_STOCK_LIST = 28;
  static const MODULE_TYPE_OFFLINE_STOCK_HISTORY = 29;
  static const MODULE_TYPE_HOSPITALITY = 30;
  static const MODULE_TYPE_TRANSPORT_ROSTER = 31;
  static const MODULE_TYPE_APPOINTMENTS = 32;
  static const MODULE_TYPE_PERSONS = 33;
  static const MODULE_TYPE_ABOUT_FINESTAR = 34;
  static const MODULE_TYPE_NEWS = 35;
  static const MODULE_TYPE_TERMS_CONDITION = 36;
  static const MODULE_TYPE_ORDER_PLACE = 37;
  static const MODULE_TYPE_HOLD = 38;
  static const MODULE_TYPE_MEMO = 39;
  static const MODULE_TYPE_BID = 40;
  static const MODULE_TYPE_SHIPMENT = 92;
  static const MODULE_TYPE_BEST = 93;
  static const MODULE_TYPE_DEMAND_EXPIRY = 94;
  static const MODULE_TYPE_DEMAND = 95;
  static const MODULE_TYPE_OFFER = 97;
  static const MODULE_TYPE_REQUEST = 98;
  static const MODULE_TYPE_OTHER = 99;
}
