import '../app.export.dart';

class ApiConstants {
  static const String PROXY_URL = "PROXY 192.168.0.170:8888";
  static const String imageBaseURL = baseURL;
  static const String apiUrl = baseURL;
  static const String commonUrl = apiUrl + "common/";

  static const String documentUpload = "/api/v1/upload-file";

  static const String masterSync = commonUrl + "user/sync";
}
