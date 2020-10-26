const String baseURL = "http://fndevelopapi.democ.in/";
const apiV1 = "api/v1/";

const DEVICE_TYPE_ANDROID = 1; //Android
const DEVICE_TYPE_IOS = 2; //IOS
const DEFAULT_PAGE = 1;
const DEFAULT_LIMIT = 100;
const SUCCESS = 1;
const FAIL = 2;

var IMAGEFILESIZE = 10.0;

const APPNAME = "Diamnow";
const STRIPE_KEY = "pk_test_ZCG3mwYMaOFEFAdpcQtkNIZ300fxNZXXOj";

const CODE_OK = "OK";
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

const signupURl = "http://fndevelop.democ.in/device/signup";
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

const String ONE_SIGNAL_KEY = "ceecb2ef-c463-45d3-a9d3-5ea755a48d8b";

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

class Spacing {
  static const num leftPadding = 20.0;
  static const num rightPadding = 20.0;
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
}

class DiamondStatus {
  static const String DIAMOND_STATUS_AVAILABLE = "A";
  static const String DIAMOND_STATUS_ON_MINE = "M";
  static const String DIAMOND_STATUS_OFFER = "O";
  static const String DIAMOND_STATUS_SHOW = "S";
  static const String DIAMOND_STATUS_BID = "B";
  static const String DIAMOND_STATUS_UPCOMING = "U";
}

class StaticPageConstant {
  static const String ABOUT_US = "ABOUT_US";
  static const String PRIVACY_POLICY = "PRIVACY_POLICY";
  static const String TERMS_CONDITION = "TERMS_CONDITION";
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

class UserPermission {
  static const String dashboard = "dashboard";
  static const String	searchDiamond = "searchDiamond";
  static const String	quickSearch = "quickSearch";
  static const String fancySearch = "fancySearch";
  static const String mySavedSearch = "mySavedSearch";
  static const String myDemand = "myDemand";
  static const String searchResult = "searchResult";
  static const String compare="compare";
  static const String showSelected="showSelected";
  static const String matchPair="matchPair";
  static const String iAmLucky="iAmLucky";
  static const String parcelList="parcelList";
  static const String newGoods="newGoods";
  static const String bestOfHK="bestOfHK";
  static const String upcomingDiamonds="upcomingDiamonds";
  static const String cart="cart";
  static const String reminder="reminder";
  static const String watchlist="watchlist";
  static const String comment="comment";
  static const String enquiry="enquiry";
  static const String order="order";
  static const String shipment="shipment";
  static const String transport="transport";
  static const String purchase="purchase";
  static const String hospitality="hospitality";
  static const String offlineStock="offlineStock";
  static const String pricecalculator="pricecalculator";
  static const String stoneoftheday="stoneoftheday";
  static const String appointment="appointment";
  static const String diamondHistory="diamondHistory";
  static const String inventory="inventory";
  static const String pricing="pricing";
  static const String RoughImage="RoughImage";
  static const String XRayZip="XRayZip";
  static const String printPdf="printPdf";
  static const String excelDownload="excelDownload";
}