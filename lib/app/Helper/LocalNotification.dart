import 'dart:collection';
import 'dart:convert';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationManager {
  LocalNotificationManager._() {
    print('Init Local Notification');
    localNotiInit();
  }

  static final LocalNotificationManager _singleton =
      LocalNotificationManager._();

  static LocalNotificationManager get instance => _singleton;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  localNotiInit() async {
    requestPermissions();
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

  void requestPermissions() {
    flutterLocalNotificationsPlugin
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
      if (dict["moduleType"] ==
          DiamondModuleConstant.MODULE_TYPE_FILTER_OFFLINE_NOTI_CLICK) {
        SyncManager.instance.callApiForDiamondList(
          NavigationUtilities.key.currentState.overlay.context,
          dict["payload"].cast<Map<String, dynamic>>(),
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
    }
  }

  /// fire a notification that specifies a different icon, sound and vibration pattern
  Future<void> showOfflineStockDownloadNotification() async {
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(subtitle: 'the subtitle');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'title of notification with a subtitle',
        'body of notification with a subtitle',
        platformChannelSpecifics,
        payload: 'item x');

    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //   NotificationIdentifier.offlineStockDownload.toString(),
    //   AndroidNotificationIdentifier.offlineStockDownloadChannelName,
    //   AndroidNotificationIdentifier.offlineStockDownloadChannelDescription,
    //   icon: '@mipmap/ic_launcher',
    // );

    // var iOSPlatformChannelSpecifics =
    //     IOSNotificationDetails(sound: "slow_spring_board.aiff");

    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics,
    //     iOS: iOSPlatformChannelSpecifics);

    // // DateTime newGenDate;
    // // newGenDate = DateTime.now().add(Duration(days: 60));

    // await flutterLocalNotificationsPlugin.show(
    //   NotificationIdentifier.offlineStockDownload,
    //   APPNAME,
    //   "Your offline stock downloaded successfully",
    //   platformChannelSpecifics,
    // );
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
      fireNotification(DateTime.now(),
          title: "Search diamonds",
          body: "Do you want to continue your search?",
          dictPayload: dictFilter);
      app.resolve<PrefUtils>().saveFilterOffline(null);
    }
  }
}
