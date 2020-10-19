import '../app.export.dart';

class ApiConstants {
    static const String PROXY_URL = "PROXY 192.168.2.124:8888";
//  static const String PROXY_URL = "PROXY 192.168.0.114:8888";
// static const String PROXY_URL = "PROXY 192.168.225.188:8888";
// static const String PROXY_URL = "PROXY 192.168.0.116:8888";
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
}
