import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/AnalyticsModel/AnalyticsModel.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';

class AnalyticsReport {
  static final AnalyticsReport shared = AnalyticsReport._internal();
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  factory AnalyticsReport() {
    return shared;
  }

  AnalyticsReport._internal();

  Future<void> sendAnalyticsData({
    @required BuildContext buildContext,
    @required String page,
    @required String section,
    @required String action,
    @required String desc,
  }) async {
    AnalyticsReq req = AnalyticsReq();
    req.page = page;
    req.section = section;
    req.action = action;
    req.description = desc;

    await analytics.logEvent(
      name: req.page,
      parameters: req.toJson(),
    );

    await NetworkClient.getInstance.callApi(
      buildContext,
      baseURL,
      ApiConstants.uploadKyc,
      MethodType.Put,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {},
      params: req.toJson(),
      failureCallback: (status, message) {},
    );
  }
}
