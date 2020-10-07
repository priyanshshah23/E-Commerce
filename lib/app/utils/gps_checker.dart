import 'package:flutter/services.dart';

class GpsChecker {
  static const MethodChannel _channel = const MethodChannel('GPS_CHANNEL');

  static Future<bool> isGpsEnabled() async {
    try {
      bool isEnabled = await _channel.invokeMethod("isGPSEnabled");
      print("is GPS $isEnabled");
      return isEnabled;
    } catch (error) {
      print(error);
      return false;
    }
  }

  static Future<bool> checkAndShowDialog() async {
    try {
      bool isEnabled = await _channel.invokeMethod("checkAndShowGpsDialog");
      print("is GPS check $isEnabled");
      return isEnabled;
    } catch (error) {
      print(error);
      return false;
    }
  }

  static Future<int> checkPermissionStatus() async {
    try {
      int status = await _channel.invokeMethod("checkPermissionStatus");
      return status;
    } catch (error) {
      print(error);
      return 0;
    }
  }
}
