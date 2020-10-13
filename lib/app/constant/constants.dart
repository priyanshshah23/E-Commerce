import 'package:diamnow/app/utils/BottomSheet.dart';

const String baseURL = "http://fndevelopapi.democ.in/";

const DEVICE_TYPE_ANDROID = 1; //Android
const DEVICE_TYPE_IOS = 2; //IOS
const DEFAULT_PAGE = 1;
const DEFAULT_LIMIT = 8;
const SUCCESS = 1;
const FAIL = 2;

var IMAGEFILESIZE = 10.0;

const APPNAME = "3eco SPro";
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

const termConditionUrl = "https://loremipsum.io/";
const privacyPolicyUrl = "https://loremipsum.io/";
const aboutUsUrl = "https://loremipsum.io/";

const eventBusTag = "EventBus";
const eventBusSocket = "EventBusSocket";
const eventBusLogout = "EventBusLogout";

const imagePath = "assest/icon.png";

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
  static const String blackTable = "BLACK_INCLUSION";
  static const String blackCrown = "BLACK_INCLUSION_CROWN";
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
}
