import 'dart:collection';
import 'dart:convert';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationManager {
  LocalNotificationManager._() {
    print('Init Local Notification');
    localNotiInit();
  }

  static const platform = MethodChannel('com.base/notification');
  static const GET_NOTIFICATION = "getNotification";

  static final LocalNotificationManager _singleton =
      LocalNotificationManager._();

  static LocalNotificationManager get instance => _singleton;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  localNotiInit() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> getNotification() async {
    print("getnotifiactioncall");
    try {
      var result = await platform.invokeMethod(GET_NOTIFICATION);
      if (result != null) {
        SyncManager.instance.callApiForDiamondList(
          NavigationUtilities.key.currentState.overlay.context,
          result,
          (diamondListResp) {
            Map<String, dynamic> dict = new HashMap();
            dict["filterId"] = diamondListResp.data.filter.id;
            dict["filters"] = dict["payload"];
            dict[ArgumentConstant.ModuleType] =
                DiamondModuleConstant.MODULE_TYPE_SEARCH;
            NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
          },
          (onError) {
            //print("Error");
          },
        );
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    app.resolve<CustomDialogs>().errorDialog(
          NavigationUtilities.key.currentState.overlay.context,
          title,
          body,
          btntitle: R.string.commonString.ok,
        );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      Map<String, dynamic> dict = json.decode(payload);
      if (dict["moduleType"] == NotificationIdentifier.offlineStockDownload) {
        Map<String, dynamic> dict = new HashMap();
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH;
        dict[ArgumentConstant.IsFromDrawer] = true;

        NavigationUtilities.pushRoute(FilterScreen.route, args: dict);
      }
    }
  }

  /// fire a notification that specifies a different icon, sound and vibration pattern
  Future<void> showOfflineStockDownloadNotification(
      {String title, String desc}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      NotificationIdentifier.offlineStockDownload.toString(),
      AndroidNotificationIdentifier.offlineStockDownloadChannelName,
      AndroidNotificationIdentifier.offlineStockDownloadChannelDescription,
      icon: '@mipmap/ic_launcher',
    );

    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    Map<String, dynamic> payload = {};
    payload["moduleType"] = NotificationIdentifier.offlineStockDownload;

    await flutterLocalNotificationsPlugin.show(
      title ?? NotificationIdentifier.offlineStockDownload,
      APPNAME,
      desc ?? "Your offline stock downloaded successfully",
      platformChannelSpecifics,
      payload: json.encode(payload) ?? "",
    );
  }

  /// fire a notification that specifies a different icon, sound and vibration pattern
  Future<void> fireNotification(
    DateTime scheduleDate, {
    String title,
    String body,
    Map<String, dynamic> dictPayload,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      NotificationIdentifier.offlineStockDownload.toString(),
      AndroidNotificationIdentifier.offlineStockDownloadChannelName,
      AndroidNotificationIdentifier.offlineStockDownloadChannelDescription,
      icon: '@mipmap/ic_launcher',
    );

    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    var fireDate = tz.TZDateTime.from(scheduleDate, tz.local);
    print("Noti Reminder Date $fireDate");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        NotificationIdentifier.offlineStockDownload,
        title,
        body,
        fireDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        payload: json.encode(dictPayload) ?? "",
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  fireNotificationForFilterOffline() {
    Map<String, dynamic> dictFilter =
        app.resolve<PrefUtils>().getFilterOffline();

    if (!isNullEmptyOrFalse(dictFilter)) {
      fireNotification(
          DateTime.now().add(
            Duration(seconds: 5),
          ),
          title: "Search diamonds",
          body: "Do you want to continue your search?",
          dictPayload: dictFilter);
      app.resolve<PrefUtils>().saveFilterOffline(null);
    }
  }
}
