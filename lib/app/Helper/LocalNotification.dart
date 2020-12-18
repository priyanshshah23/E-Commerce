import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationManager {
  // static final LocalNotificationManager shared = LocalNotificationManager();

  static final LocalNotificationManager _instance =
      LocalNotificationManager._internal();
  LocalNotificationManager shared;

  factory LocalNotificationManager() {
    return _instance;
  }

  Future<void> init() async {
    if (shared != null) {
      return;
    }
    print('Init Local Notification');
    localNotiInit();
  }

  LocalNotificationManager._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  localNotiInit() {
    shared = LocalNotificationManager();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
      debugPrint('notification payload: ' + payload);
    }
  }

  /// fire a notification that specifies a different icon, sound and vibration pattern
  Future<void> showOfflineStockDownloadNotification() async {
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

    // DateTime newGenDate;
    // newGenDate = DateTime.now().add(Duration(days: 60));

    await flutterLocalNotificationsPlugin.show(
      NotificationIdentifier.offlineStockDownload,
      APPNAME,
      "Your offline stock downloaded successfully",
      platformChannelSpecifics,
    );
  }

  /// fire a notification that specifies a different icon, sound and vibration pattern
  Future<void> fireNotification(DateTime scheduleDate,
      {String title, String body}) async {
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
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
