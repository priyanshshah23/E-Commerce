import '../app.export.dart';

class ApiConstants {
    static const String PROXY_URL = "PROXY 192.168.2.124:8888";
//   static const String PROXY_URL = "PROXY 192.168.0.117:8888";
// static const String PROXY_URL = "PROXY 192.168.0.116:8888";
//  static const String PROXY_URL = "PROXY 192.168.225.188:8888";

// static const String PROXY_URL = "PROXY 192.168.225.121:8888"; // Brijesh

  static const String imageBaseURL = baseURL;
  static const String apiUrl = baseURL;
  static const String commonUrl = apiUrl + "device/v1/";
  static const String authUrl = apiUrl + "web/v1/auth/";

  static const String countryList = commonUrl + "country/paginate";
  static const String stateList = commonUrl + "state/paginate";
  static const String cityList = commonUrl + "city/paginate";

  static const String documentUpload = "/api/v1/upload-file";

  static const String masterSync = commonUrl + "masterSync";

  static const String login = commonUrl + "auth/login";

  static const String diamondList = commonUrl + "diamond/paginate";
  static const String diamondMatchPair = commonUrl + "match-pair/diamond/filter";
  static const String diamondTrackList = commonUrl + "diamond-track/paginate";
  static const String diamondCommentList =
      commonUrl + "diamond-comment/by-user";
  static const String diamondBidList = commonUrl + "diamond-bid/paginate";

  static const String createDiamondTrack = commonUrl + "diamond-track/create";
  static const String upsetComment = commonUrl + "diamond-comment/upsert";
  static const String createDiamondBid = commonUrl + "diamond-bid/create";

  static const String placeOrder = commonUrl + "diamond-confirm/request";
  static const String staticPage = apiV1 + "static-page/{id}";
  static const String forgetPassword =
      apiUrl + "web/v1/auth/forgot-password"; //done
  static const String resetPassword = apiUrl + "admin/v1/reset-password";
  static const String changePassword =
      apiUrl + "web/v1/auth/reset-password-by-user"; //done
  static const String personalInformation = commonUrl + "user/update"; //done
  static const String companyInformation =
      commonUrl + "user/profile/update"; //done
  static const String quickSearch = commonUrl + "diamond/quick-search";
  static const String personalInformationView = commonUrl + "user/view";
  static const String companyInformationView = commonUrl + "user/profile";

}

class DiamondUrls {
  static const String commonUrl =
      "https://s3.ap-south-1.amazonaws.com/finestargroup/";

  static const String image = commonUrl + "RealImages/";
  static const String video = commonUrl + "viewer3/html/";
  static const String heartImage = commonUrl + "HeartImages/";
  static const String plotting = commonUrl + "PlottingImages/";
  static const String certificate = commonUrl + "CertiImages/";
  static const String arroImage = commonUrl + "ArrowImages/";
  static const String videomp4 = commonUrl + "Mov/";
}
// https://s3.ap-south-1.amazonaws.com/finestargroup/CertiImages/<report_no>.pdf
