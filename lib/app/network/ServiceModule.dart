import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';

import '../app.export.dart';

class ServiceModule {
  NetworkService networkService({String playerId, bool isKnowlarity}) {
    final dio = Dio(); // Provide a dio instance
    dio.options.validateStatus = (status) {
      return status < 500;
    };
    dio.options.connectTimeout = 50000; //5s
    dio.options.receiveTimeout = 50000;
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["devicetime"] =
        DateTime.now().toUtc().toIso8601String();
    if (Platform.isIOS) {
      dio.options.headers["deviceType"] = DEVICE_TYPE_IOS;
    } else if (Platform.isAndroid) {
      dio.options.headers["deviceType"] = DEVICE_TYPE_ANDROID;
    }
    if (app.resolve<PrefUtils>().isUserLogin()) {
      dio.options.headers["Authorization"] =
          "JWT " + app.resolve<PrefUtils>().getUserToken();
    }
    if (playerId != null) {
      dio.options.headers["playerId"] = playerId;
    }

    if (kDebugMode) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // config the http client
        client.findProxy = (uri) {
          return ApiConstants.PROXY_URL;
        };
        // you can also create a new HttpClient to dio
//            return new HttpClient();
      };
    }
    return NetworkService(dio);
  }
}
