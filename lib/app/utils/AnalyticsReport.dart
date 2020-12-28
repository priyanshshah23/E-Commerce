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
  FirebaseAnalytics analytics = FirebaseAnalytics();

//  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
//    analytics: analytics,
//  );

  Future<void> sendAnalyticsData({
    @required BuildContext buildContext,
    @required AnalyticsReq req,
  }) async {
    await analytics.logEvent(
      name: req.page,
      parameters: req.toJson(),
//          parameters: <String, dynamic>{
//            'string': 'string',
//            'int': 42,
//            'long': 12345678910,
//            'double': 42.0,
//            'bool': true,
//          },
    );
    NetworkClient.getInstance.callApi(
      buildContext,
      baseURL,
      ApiConstants.uploadKyc,
      MethodType.Put,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {},
      params: req.toJson(),
      failureCallback: (status, message) {
        print(message);
        app.resolve<CustomDialogs>().confirmDialog(
              buildContext,
              title: R.string.commonString.error,
              desc: message,
              positiveBtnTitle: R.string.commonString.ok,
              onClickCallback: (click) {},
            );
      },
    );
  }
}
