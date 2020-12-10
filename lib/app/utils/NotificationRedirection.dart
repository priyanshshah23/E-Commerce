import 'dart:async';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/utils/navigator.dart';
import 'package:diamnow/app/utils/pref_utils.dart';
import 'package:diamnow/components/Screens/Notification/NotificationManager.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class NotificationRedirection {
  NotificationDetail notificationDetail;
  bool isRecursion = false;

  NotificationRedirection(this.notificationDetail);

  manageNotification() {
    redirectToScreen();
  }

  redirectToScreen({BuildContext context}) {
    if (NavigationUtilities.key != null) {
      app.resolve<NotificationManger>().switchCaseMethod(notificationDetail.type);
    }
  }
}

class NotificationDetail {
  int type;
  String id;

  NotificationDetail({this.type, this.id});

  NotificationDetail.fromJson(Map<String, dynamic> json) {
    type = json['payload_type'];
    id = json['payload_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payload_type'] = this.type;
    data['payload_id'] = this.id;
    return data;
  }
}
