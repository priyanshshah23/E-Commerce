import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rxbus/rxbus.dart';

import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';

import '../app.export.dart';

class NetworkCall<T extends BaseApiResp> {
  static final Logger _log = Logger("Network Call");

  Future<T> makeCall(ApiCall<T> apiCall, BuildContext context,
      {bool isNetworkError = true, bool isProgress = true}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (isProgress && context != null) {
        app.resolve<CustomDialogs>().showProgressDialog(context, "");
      }
      try {
        BaseApiResp resp = await apiCall();

        if (resp != null) {
          hideDialog(isProgress);
          if (resp.code == CODE_OK || resp.code == CODE_SUCCESS)
            return resp;
          else if (resp.code == CODE_UNAUTHORIZED) {
            print(app.resolve<PrefUtils>().isUserLogin());
            if (app.resolve<PrefUtils>().isUserLogin()) {
              showToast(resp.message, context: context);
              app.resolve<PrefUtils>().resetAndLogout(context);
            } else {
              return Future.error(ErrorResp(resp.message, resp.code, false));
            }
          } else {
            return Future.error(ErrorResp(resp.message, resp.code, false));
          }
        } else {
          hideDialog(isProgress);
          return Future.error(
              ErrorResp(SOMETHING_WENT_WRONG, CODE_ERROR, false));
        }
      } catch (e) {
        hideDialog(isProgress);
        _log.warning(e);
        print('e ${e}');
        return Future.error(ErrorResp(PARSING_WRONG, CODE_ERROR, false));
      }
    } else {
      if (isNetworkError && context != null) {
        View.showMessage(context, NO_CONNECTION);
      }
      return Future.error(ErrorResp(INTERNET_UNAWAILABLE, NO_CONNECTION, true));
    }
  }

  void hideDialog(bool isProgress) {
    if (isProgress) {
      app.resolve<CustomDialogs>().hideProgressDialog();
    }
  }
}
