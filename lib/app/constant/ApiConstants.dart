import '../app.export.dart';

class ApiConstants {
//  static const String PROXY_URL = "PROXY 192.168.2.124:8888";
  static const String PROXY_URL = "PROXY 192.168.0.114:8888";

  static const String imageBaseURL = baseURL;
  static const String apiUrl = baseURL;
  static const String commonUrl = apiUrl + "device/v1/";

  static const String documentUpload = "/api/v1/upload-file";

  static const String masterSync = commonUrl + "masterSync";

  static const String login = commonUrl + "auth/login";
}
