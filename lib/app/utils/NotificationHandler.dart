import 'dart:convert';
import 'dart:io';
import 'package:diamnow/app/utils/NotificationRedirection.dart';
import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../app.export.dart';

notificationInit() async {
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  // OneSignal.shared.setRequiresUserPrivacyConsent(true);

  // var settings = {
  //   OSiOSSettings.autoPrompt: true,
  //   OSiOSSettings.promptBeforeOpeningPushUrl: true
  // };

  // OneSignal.shared
  //     .setNotificationReceivedHandler((OSNotification notification) {
  //   print(
  //       "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
  // });

  // OneSignal.shared
  //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
  //   print(
  //       "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
  //   try {
  //     if (result.notification.payload.additionalData != null) {
  //       var notiData = NotificationDetail.fromJson(
  //           result.notification.payload.additionalData);

  //       NotificationRedirection(notiData).manageNotification();
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // });

  // OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {
  //   print(
  //       "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}");
  // });

  // await OneSignal.shared.init(
  //   ONE_SIGNAL_KEY,
  //   iOSSettings: settings,
  // );

  // OneSignal.shared
  //     .setInFocusDisplayType(OSNotificationDisplayType.notification);

  // await OneSignal.shared.consentGranted(true);

  // _getTokens() async {
  //   OneSignal.shared.getPermissionSubscriptionState().then((status) {
  //     var playerId = status.subscriptionStatus.userId;
  //     print('Player id $playerId');

  //     app
  //         .resolve<PrefUtils>()
  //         .setPlayerID(playerId, app.resolve<PrefUtils>().keyPlayerID);

  //     print('getPlayerID :: ${app.resolve<PrefUtils>().getPlayerId()}');
  //   });
  // }

  // if (Platform.isAndroid) {
  //   _getTokens();
  // } else if (Platform.isIOS) {
  //   OneSignal.shared.setPermissionObserver(
  //     (OSPermissionStateChanges changes) {
  //       if (changes.to.status == OSNotificationPermission.authorized) {
  //         OneSignal.shared
  //             .promptUserForPushNotificationPermission()
  //             .then((accepted) async {
  //           print("Accepted permission: $accepted");

  //           _getTokens();
  //         });
  //       }
  //     },
  //   );
  // }
}
