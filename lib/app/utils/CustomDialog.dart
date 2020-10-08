import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxbus/rxbus.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/widgets/rounded_datePicker/rounded_picker.dart';
import "package:diamnow/components/widgets/rounded_datePicker/src/material_rounded_date_picker_style.dart";
import "package:diamnow/components/widgets/rounded_datePicker/src/material_rounded_year_picker_style.dart";
import 'package:webview_flutter/webview_flutter.dart';

import 'ImageUtils.dart';

class CustomDialogs {
  void showToast(String msg) {
    showToast(msg);
  }

  void showProgressDialog(
    BuildContext context,
    String message,
  ) {
    ProgressDialog2.showLoadingDialog(
        NavigationUtilities.key.currentState.overlay.context, message,
        isCancellable: false);
  }

  void hideProgressDialog() {
    Navigator.pop(NavigationUtilities.key.currentState.overlay.context);
  }

  Future openConfirmationDialog(BuildContext context,
      {OnClickCallback onClickCallback}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(8)))),
            content: Container(
              width: MathUtilities.screenWidth(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    R.string().authStrings.logout,
                    textAlign: TextAlign.center,
                    style: AppTheme.of(context).theme.textTheme.body1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: appTheme.colorPrimary),
                  ),
                  SizedBox(
                    height: getSize(20),
                  ),
                  Text(
                    R.string().authStrings.logoutConfirmationMsg,
                    textAlign: TextAlign.center,
                    style: AppTheme.of(context)
                        .theme
                        .textTheme
                        .display2
                        .copyWith(color: appTheme.dividerColor),
                  ),
                  // SizedBox(height: getSize(20),),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          child: Text(
                            R.string().commonString.no,
                            textAlign: TextAlign.center,
                            style: AppTheme.of(context)
                                .theme
                                .textTheme
                                .display2
                                .copyWith(color: appTheme.dividerColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MathUtilities.screenWidth(context) / 2,
                        margin: EdgeInsets.only(top: getSize(30)),
                        child: AppButton.flat(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          borderRadius: 14,
                          fitWidth: true,
                          text: R.string().commonString.yes,
                          //isButtonEnabled: enableDisableSigninButton(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void logoutDialog(BuildContext context, VoidCallback callback) {
    openConfirmationDialog(context, onClickCallback: (type) {
      if (type == ButtonType.PositveButtonClick) {
        callback();
      }
    });
  }

  void errorDialog(BuildContext context, String title, String disc,
      {String btntitle, VoidCallback voidCallBack}) {
    OpenErrorDialog(context, title, disc,
        btntitle: btntitle, voidCallback: voidCallBack ?? null);
  }

  void confirmDialog(BuildContext context,
      {String title,
      String desc,
      String positiveBtnTitle,
      String negativeBtnTitle,
      OnClickCallback onClickCallback,
      bool dismissPopup: true,
      bool barrierDismissible: false,
      RichText richText}) {
    OpenConfirmationPopUp(context,
        title: title,
        desc: desc,
        positiveBtnTitle: positiveBtnTitle,
        negativeBtnTitle: negativeBtnTitle,
        onClickCallback: onClickCallback,
        dismissPopup: dismissPopup,
        barrierDismissible: barrierDismissible,
        richText: richText);
  }
}

class ProgressDialog2 {
  static Future<void> showLoadingDialog(BuildContext context, String message,
      {bool isCancellable = true}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: isCancellable,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return isCancellable;
            },
            child: Loader(),
          );
        });
  }
}

Future OpenErrorDialog(BuildContext context, String title, String disc,
    {String btntitle, VoidCallback voidCallback}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        //SystemChrome.setEnabledSystemUIOverlays([]);

        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(getSize(8)))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.of(context).theme.textTheme.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appTheme.colorPrimary),
              ),
              SizedBox(
                height: getSize(20),
              ),
              Text(
                disc,
                textAlign: TextAlign.center,
                style: AppTheme.of(context).theme.textTheme.display1.copyWith(
                    color: appTheme.dividerColor,
                    fontWeight: FontWeight.normal),
              ),
              // SizedBox(height: getSize(20),),
              btntitle != null
                  ? Container(
                      margin: EdgeInsets.only(top: getSize(30)),
                      child: AppButton.flat(
                        onTap: voidCallback ??
                            () {
                              Navigator.pop(context);
                            },
                        borderRadius: 14,
                        fitWidth: true,
                        text: btntitle,
                        //isButtonEnabled: enableDisableSigninButton(),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      });
}

Future<String> get _localPath async {
  //get local directory path
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String filename) async {
  //save as local file
  final path = await _localPath;
  return File('$path/' + filename + '.pdf');
}

Future<File> writeCounter(Uint8List stream, String filename) async {
  //create file from response
  final file = await _localFile(filename);

  // Write the file
  return file.writeAsBytes(stream);
}

Future<bool> existsFile(String filename) async {
  final file = await _localFile(filename);
  return file.exists();
}

Future<Uint8List> fetchPost(String url) async {
  //get data from url
  final response = await http.get(url);
  final responseJson = response.bodyBytes;

  return responseJson;
}

Future<String> loadPdf(String url, String filename) async {
  await writeCounter(await fetchPost(url), filename);
  await existsFile(filename);
  return (await _localFile(filename)).path;
}

bool isFilePDF(String url) {
  if (url != null && url.split('.').last == 'pdf') return true;

  return false;
}

Future OpenConfirmationPopUp(BuildContext context,
    {String title,
    String desc,
    String positiveBtnTitle,
    String negativeBtnTitle,
    OnClickCallback onClickCallback,
    bool dismissPopup: true,
    bool barrierDismissible: false,
    RichText richText}) {
  Future<bool> _onBackPressed() {
    if (dismissPopup) {
      Navigator.pop(context);
    }
  }

  return showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: StatefulBuilder(
          builder: (context, setState) {
            //SystemChrome.setEnabledSystemUIOverlays([]);

            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(getSize(8)))),
              child: Container(
                width: MathUtilities.screenWidth(context),
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(10), vertical: getSize(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTheme.of(context)
                          .theme
                          .textTheme
                          .body1
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: appTheme.colorPrimary),
                    ),
                    SizedBox(
                      height: getSize(15),
                    ),
                    desc.isEmpty
                        ? richText
                        : Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: AppTheme.of(context)
                                .theme
                                .textTheme
                                .display1
                                .copyWith(
                                    color: appTheme.dividerColor,
                                    fontWeight: FontWeight.normal),
                          ),
                    // SizedBox(height: getSize(20),),
                    Container(
                      margin: EdgeInsets.only(top: getSize(30)),
                      child: Row(
                        children: <Widget>[
                          negativeBtnTitle != null
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (onClickCallback != null) {
                                      onClickCallback(
                                          ButtonType.NagativeButtonClick);
                                    }
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(getSize(16)),
                                      child: Text(
                                        negativeBtnTitle,
                                        style: AppTheme.of(context)
                                            .theme
                                            .textTheme
                                            .display2
                                            .copyWith(
                                              color:
                                                  appTheme.colorPrimary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          negativeBtnTitle != null
                              ? SizedBox(
                                  width: getSize(20),
                                )
                              : SizedBox(),
                          Expanded(
                            child: AppButton.flat(
                              onTap: () {
                                if (dismissPopup) {
                                  Navigator.pop(context);
                                }
                                if (onClickCallback != null) {
                                  onClickCallback(
                                      ButtonType.PositveButtonClick);
                                }
                              },
                              borderRadius: 14,
                              fitWidth: true,
                              text: positiveBtnTitle,
                              //isButtonEnabled: enableDisableSigninButton(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
