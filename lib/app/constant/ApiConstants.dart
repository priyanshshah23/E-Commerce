import '../app.export.dart';

class ApiConstants {
  //  static const String PROXY_URL = "PROXY 192.168.2.124:8888";
  static const String PROXY_URL = "PROXY 192.168.0.114:8888";
// static const String PROXY_URL = "PROXY 192.168.0.116:8888";
  // static const String PROXY_URL = "PROXY 192.168.225.188:8888";

  // static const String PROXY_URL = "PROXY 192.168.225.121:8888"; // Brijesh

  static const String imageBaseURL = baseURL;
  static const String apiUrl = baseURL;
  static const String commonUrl = apiUrl + "device/v1/";

  static const String countryList = commonUrl + "country/paginate";
  static const String stateList = commonUrl + "state/paginate";
  static const String cityList = commonUrl + "city/paginate";

  static const String documentUpload = "/api/v1/upload-file";

  static const String masterSync = commonUrl + "masterSync";

  static const String login = commonUrl + "auth/login";

  static const String diamondList = commonUrl + "diamond/paginate";

  static const String staticPage = apiV1 + "static-page/{id}";
  static const String createDiamondTrack = commonUrl + "diamond-track/create";
  static const String upsetComment = commonUrl + "diamond-comment/upsert";

  static const String placeOrder = commonUrl + "diamond-confirm/request";
  static const String forgetPassword = commonUrl + "forgot-password";
  static const String resetPassword = commonUrl + "reset-password-by-user";
}

class DiamondUrls {
  static const String commonUrl =
      "https://s3.ap-south-1.amazonaws.com/finestargroup/";

  static const String image = commonUrl + "RealImages/";
  static const String video = commonUrl + "viewer3/html/";
  static const String heartImage = commonUrl + "HeartImages/";
  static const String plotting = commonUrl + "PlottingImages/";
  static const String certificate = commonUrl + "PlottingImages/";
  static const String arroImage = commonUrl + "ArrowImages/";
}
