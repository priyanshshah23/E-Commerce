import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/ForgetMPIN.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/Signup.dart';
import 'package:diamnow/components/Screens/Version/VersionUpdate.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/FlutterCustomPinView.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/components/widgets/shared/app_background.dart';
import 'package:diamnow/models/Auth/SignInAsGuestModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
//import 'package:local_auth/local_auth.dart';

class SignInWithMPINScreen extends StatefulScreenWidget {
  static const route = "SignInWithMPINScreen";

  @override
  _SignInWithMPINScreen createState() => _SignInWithMPINScreen();
}

class _SignInWithMPINScreen extends StatefulScreenWidgetState {
  bool isFingerprint = false;
  String _userName;
  // String _lastLogin;
  LoginScreenState loginScreenObject = LoginScreenState();

  @override
  void initState() {
    super.initState();
    _userName = app.resolve<PrefUtils>().getString("userName");
    // _lastLogin = app.resolve<PrefUtils>().getUserDetails()
  }

  @override
  void dispose() { 
    loginScreenObject.userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var myPass = [1, 2, 3, 4, 5, 6];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: true,
            appBar: getAppBar(
              context,
              R.string.authStrings.signInWithMPIN,
              bgColor: appTheme.whiteColor,
              leadingButton: getBackButton(context),
              centerTitle: false,
            ),
            body: Container(
              padding: EdgeInsets.only(
                left: getSize(20),
                right: getSize(20),
                top: getSize(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // circle avatar
                          Container(
                            height: getSize(54),
                            width: getSize(54),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(getSize(25))),
                              child: getImageView(
                                "",
                                placeHolderImage: userTemp,
                                fit: BoxFit.fill,
                                height: getSize(50),
                                width: getSize(50),
                              ),
                            ),
                          ),
                          SizedBox(width: getSize(10)),
                          //username
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !isNullEmptyOrFalse(_userName) ? Text(
                                  _userName,
                                  style: appTheme.black16TextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ) :
                                loginScreenObject.getMobileTextField(),
                                // SizedBox(height: getSize(6)),
                                // Text(
                                //   "Last login: 28 October 2020 | 11:37pm",
                                //   style: appTheme.black12TextStyle,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getSize(54)),
                    Text(
                      "Enter your 6 digit MPIN",
                      style: appTheme.black16MediumTextStyle,
                    ),
                    SizedBox(height: getSize(32)),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        Container(
//                          height: getSize(20),
//                          width: getSize(20),
//                          decoration: BoxDecoration(
//                            color: appTheme.textGreyColor,
//                            borderRadius: BorderRadius.circular(getSize(30)),
//                          ),
//                        ),
//                        SizedBox(width: getSize(9)),
//                        Container(
//                          height: getSize(20),
//                          width: getSize(20),
//                          decoration: BoxDecoration(
//                            color: appTheme.textGreyColor,
//                            borderRadius: BorderRadius.circular(getSize(30)),
//                          ),
//                        ),
//                        SizedBox(width: getSize(9)),
//                        Container(
//                          height: getSize(20),
//                          width: getSize(20),
//                          decoration: BoxDecoration(
//                            color: appTheme.textGreyColor,
//                            borderRadius: BorderRadius.circular(getSize(30)),
//                          ),
//                        ),
//                        SizedBox(width: getSize(9)),
//                        Container(
//                          height: getSize(20),
//                          width: getSize(20),
//                          decoration: BoxDecoration(
//                            color: appTheme.textGreyColor,
//                            borderRadius: BorderRadius.circular(getSize(30)),
//                          ),
//                        ),
//                        SizedBox(width: getSize(9)),
//                        Container(
//                          height: getSize(20),
//                          width: getSize(20),
//                          decoration: BoxDecoration(
//                            color: appTheme.textGreyColor,
//                            borderRadius: BorderRadius.circular(getSize(30)),
//                          ),
//                        ),
//                        SizedBox(width: getSize(9)),
//                        Container(
//                          height: getSize(20),
//                          width: getSize(20),
//                          decoration: BoxDecoration(
//                            color: appTheme.textGreyColor,
//                            borderRadius: BorderRadius.circular(getSize(30)),
//                          ),
//                        ),
//                      ],
//                    ),
                    Container(
                      height: 800,
                      child: FlutterCustomPinView(
                        title: "This is Screet ",
                        passLength: 6,
                        bgImage: "",
                        showFingerPass: true,
                        fingerPrintImage: "",
                        //fingerFunction: biometrics,
                        fingerVerify: isFingerprint,
                        borderColor: appTheme.whiteColor,
                        foregroundColor: appTheme.textGreyColor,
                        showWrongPassDialog: true,
                        wrongPassContent: "Wrong pass please try again.",
                        wrongPassTitle: "Oops!",
                        wrongPassCancelButtonText: "Cancel",
                        passCodeVerify: (passcode) async {
                          print(passcode);
                          // for (int i = 0; i < myPass.length; i++) {
                          //   if (passcode[i] != myPass[i]) {
                          //     return false;
                          //   }
                          // }
                          return true;
                        },
                        onSuccess: () {
                          print("success");
                          print(loginScreenObject.userNameController.text);
                          // SyncManager().callVersionUpdateApi(
                          //   context,
                          //   VersionUpdateApi.signInWithMpin,
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
//              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(getSize(15)),
              child: InkWell(
                onTap: () {
                  NavigationUtilities.pushRoute(ForgetMPIN.route);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Forgot MPIN?",
                        style: appTheme.black16MediumTextStyle
                            .copyWith(color: appTheme.greenColor)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkValidation() async {
//    if (await isValidMobile(
//        _mobileController.text.trim(), selectedDialogCountry.isoCode) ==
//        false) {
//      return showToast(R.string.errorString.enterValidPhone,context: context);
//    } else {
//      callApi(context);
//    }
  }

  callApi(BuildContext context) async {
    SignInAsGuestReq req = SignInAsGuestReq();

    NetworkCall<LoginResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .signInAsGuest(req),
            context,
            isProgress: true)
        .then((loginResp) async {
//      if (loginResp.data != null) {
//        app.resolve<PrefUtils>().saveUser(loginResp.data.user);
//        await app.resolve<PrefUtils>().saveUserToken(
//          loginResp.data.token.jwt,
//        );
//        await app.resolve<PrefUtils>().saveUserPermission(
//          loginResp.data.userPermissions,
//        );
//      }
      // callVersionUpdateApi(id: loginResp.data.user.id);
      SyncManager().callVersionUpdateApi(
          context, VersionUpdateApi.signInWithMpin,
          id: loginResp.data.user.id);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: R.string.commonString.error,
              desc: onError.message,
              positiveBtnTitle: R.string.commonString.ok,
            );
      }
    });
  }
  // void callVersionUpdateApi({String id}) {
  //   NetworkCall<VersionUpdateResp>()
  //       .makeCall(
  //           () => app
  //           .resolve<ServiceModule>()
  //           .networkService()
  //           .getVersionUpdate(),
  //       context,
  //       isProgress: true)
  //       .then(
  //         (resp) {
  //       if (resp.data != null) {
  //         PackageInfo.fromPlatform().then(
  //               (PackageInfo packageInfo) {
  //             print(packageInfo.buildNumber);
  //             String appName = packageInfo.appName;
  //             String packageName = packageInfo.packageName;
  //             String version = packageInfo.version;
  //             String buildNumber = packageInfo.buildNumber;

  //             if (Platform.isIOS) {
  //               if (resp.data.ios != null) {
  //                 num respVersion = resp.data.ios.number;
  //                 if (num.parse(version) < respVersion) {
  //                   bool hardUpdate = resp.data.ios.isHardUpdate;
  //                   Map<String, dynamic> dict = new HashMap();
  //                   dict["isHardUpdate"] = hardUpdate;
  //                   dict["oncomplete"] = () {
  //                     Navigator.pop(context);
  //                   };
  //                   print(hardUpdate);
  //                   if (hardUpdate == true) {
  //                     NavigationUtilities.pushReplacementNamed(
  //                       VersionUpdate.route,
  //                       args: dict,
  //                     );
  //                   }
  //                 } else {
  //                   SyncManager.instance.callMasterSync(
  //                       NavigationUtilities.key.currentContext, () async {
  //                     //success
  //                     AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                   }, () {},
  //                       isNetworkError: false,
  //                       isProgress: true,
  //                       id: id).then((value) {});
  //                 }
  //               } else {
  //                 SyncManager.instance.callMasterSync(
  //                     NavigationUtilities.key.currentContext, () async {
  //                   //success
  //                   AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                 }, () {},
  //                     isNetworkError: false,
  //                     isProgress: true,
  //                     id: id).then((value) {});
  //               }
  //             } else {
  //               if (resp.data.android != null) {
  //                 num respVersion = resp.data.android.number;
  //                 if (num.parse(buildNumber) < respVersion) {
  //                   bool hardUpdate = resp.data.android.isHardUpdate;
  //                   if (hardUpdate == true) {
  //                     NavigationUtilities.pushReplacementNamed(
  //                       VersionUpdate.route,
  //                     );
  //                   }
  //                 } else {
  //                   SyncManager.instance.callMasterSync(
  //                       NavigationUtilities.key.currentContext, () async {
  //                     //success
  //                     AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                   }, () {},
  //                       isNetworkError: false,
  //                       isProgress: true,
  //                       id: id).then((value) {});
  //                 }
  //               } else {
  //                 SyncManager.instance.callMasterSync(
  //                     NavigationUtilities.key.currentContext, () async {
  //                   //success
  //                   AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                 }, () {},
  //                     isNetworkError: false,
  //                     isProgress: true,
  //                     id: id).then((value) {});
  //               }
  //             }
  //           },
  //         );
  //       }
  //     },
  //   ).catchError(
  //         (onError) => {
  //       app.resolve<CustomDialogs>().confirmDialog(context,
  //           title: R.string.errorString.versionError,
  //           desc: onError.message,
  //           positiveBtnTitle: R.string.commonString.btnTryAgain,
  //           onClickCallback: (PositveButtonClick) {
  //             callVersionUpdateApi(id: id);
  //           }),
  //     },
  //   );
  // }

}
