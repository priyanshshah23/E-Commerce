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
import 'package:diamnow/components/Screens/Auth/PasswordResetSuccessfully.dart';
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
  bool isForReEnter = false;
  List<int> enteredPin = [];
  Function verifyPinCallback;
  // from mpin button on login screen.
  bool fromMpinButton = false;

  //reset mpin from otp
  bool resetMpin = false;
  String userName = "";
  String mPinOtp = "";

  //verifyMpin before enable mpin from myaccount.
  bool askForVerifyMpin = false;
  //enum for which screen you came from
  int enm;

  SignInWithMPINScreen(
      {this.isForReEnter,
      this.enteredPin,
      this.fromMpinButton,
      this.resetMpin,
      this.askForVerifyMpin,
      this.enm,
      Map<String, dynamic> arguments}) {
    if (!isNullEmptyOrFalse(arguments)) {
      if (!isNullEmptyOrFalse(arguments["resetMpin"])) {
        resetMpin = arguments["resetMpin"];
      }
      if (!isNullEmptyOrFalse(arguments["userName"])) {
        userName = arguments["userName"];
      }
      if (!isNullEmptyOrFalse(arguments["mPinOtp"])) {
        mPinOtp = arguments["mPinOtp"];
      }

      if (!isNullEmptyOrFalse(arguments["askForVerifyMpin"])) {
        askForVerifyMpin = arguments["askForVerifyMpin"];
      }
      if (!isNullEmptyOrFalse(arguments["enm"])) {
        enm = arguments["enm"];
      }
      if (!isNullEmptyOrFalse(arguments["verifyPinCallback"])) {
        verifyPinCallback = arguments["verifyPinCallback"];
      }
    }
  }

  @override
  _SignInWithMPINScreen createState() => _SignInWithMPINScreen(
      this.isForReEnter,
      this.enteredPin,
      this.fromMpinButton,
      this.resetMpin,
      this.userName,
      this.mPinOtp,
      this.askForVerifyMpin,
      this.enm,
      this.verifyPinCallback);
}

class _SignInWithMPINScreen extends StatefulScreenWidgetState {
  bool isFingerprint = false;
  String _userName;
  bool isForReEnter;
  List<int> enteredPin;
  bool fromMpinButton;
  bool resetMpin;
  String userName;
  String mPinOtp = "";
  bool askForVerifyMpin;
  int enm;
  Function verifyPinCallback;

  // String _lastLogin;
  _SignInWithMPINScreen(
      this.isForReEnter,
      this.enteredPin,
      this.fromMpinButton,
      this.resetMpin,
      this.userName,
      this.mPinOtp,
      this.askForVerifyMpin,
      this.enm,
      this.verifyPinCallback);

  LoginScreenState loginScreenObject = LoginScreenState();

  @override
  void initState() {
    super.initState();
    if (isNullEmptyOrFalse(isForReEnter)) {
      isForReEnter = false;
    }
    if (isNullEmptyOrFalse(enteredPin)) {
      enteredPin = [];
    }
    if (isNullEmptyOrFalse(fromMpinButton)) {
      fromMpinButton = false;
    }
    if (isNullEmptyOrFalse(resetMpin)) {
      resetMpin = false;
    }
    if (isNullEmptyOrFalse(askForVerifyMpin)) {
      askForVerifyMpin = false;
    }
    _userName = app.resolve<PrefUtils>().getString("userName") ?? "";
    if (!isNullEmptyOrFalse(_userName))
      loginScreenObject.userNameController.text = _userName;
    // _lastLogin = app.resolve<PrefUtils>().getUserDetails()
  }

  @override
  void dispose() {
    loginScreenObject.userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: true,
            appBar: getAppBar(context, R.string().authStrings.signInWithMPIN,
                bgColor: appTheme.whiteColor,
                leadingButton: getBackButton(context),
                centerTitle: false,
                actionItems: [
                  if (fromMpinButton == false)
                    InkWell(
                      onTap: () {
                        logoutFromApp(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: getSize(16.0)),
                        child: Container(
                            child: Image.asset(logout,
                                width: getSize(24), height: getSize(24))),
                      ),
                    )
                ]),
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
                                loginScreenObject.getMobileTextField(),
                                // !isNullEmptyOrFalse(_userName)
                                //     ? Text(
                                //         _userName,
                                //         style:
                                //             appTheme.black16TextStyle.copyWith(
                                //           fontWeight: FontWeight.w500,
                                //         ),
                                //       )
                                //     : loginScreenObject.getMobileTextField(),
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
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
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
                          wrongPassContent:
                              "Both Mpin should be same,\n Please Enter once again...",
                          wrongPassTitle: "Oops!",
                          wrongPassCancelButtonText: "Cancel",
                          passCodeVerify: (passcode) async {
                            print(passcode);

                            if (isForReEnter) {
                              for (int i = 0; i < enteredPin.length; i++) {
                                if (passcode[i] != enteredPin[i]) {
                                  return false;
                                }
                              }
                              return true;
                            } else {
                              enteredPin = passcode;
                              return true;
                            }
                          },
                          onSuccess: () {
                            if (!isForReEnter) {
                              if (fromMpinButton) {
                                // Focus.of(context).unfocus();
                                callApiForLoginUsingMpin(context);
                              } else if (askForVerifyMpin) {
                                callApiForVerifyMpin(context);
                              } else {
                                NavigationUtilities.push(SignInWithMPINScreen(
                                  enteredPin: this.enteredPin,
                                  isForReEnter: true,
                                ));
                              }
                            } else {
                              if (resetMpin) {
                                callApiForResetMpin(context);
                              } else {
                                callCreateMpApi(context);
                              }
                            }
                          },
                        ),
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
//      return showToast(R.string().errorString.enterValidPhone,context: context);
//    } else {
//      callApi(context);
//    }
  }

  Future callCreateMpApi(BuildContext context) async {
    CreateMpinReq req = CreateMpinReq();
    String enteredMpinInString = "";

    enteredPin.forEach((element) {
      enteredMpinInString += (element.toString());
    });

    int finalEnteredMpinInInt = int.parse(enteredMpinInString);

    req.mPin = finalEnteredMpinInInt;
    req.isMpinAdded = true;

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().createMpin(req),
            context,
            isProgress: true)
        .then((loginResp) {
      print("Api calling doneeeeeeeeeee");
      callLogout(context);
      // NavigationUtilities.pushRoute(LoginScreen.route);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: R.string().commonString.error,
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }

  Future callApiForResetMpin(BuildContext context) async {
    Map<String, dynamic> req = {};
    String enteredMpinInString = "";

    enteredPin.forEach((element) {
      enteredMpinInString += (element.toString());
    });

    req["username"] = userName;
    req["mPinOtp"] = int.parse(mPinOtp);
    req["mPin"] = int.parse(enteredMpinInString);

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .resetMpinByOtp(req),
            context,
            isProgress: true)
        .then((loginResp) {
      print("Api calling doneeeeeeeeeee");
      // callLogout(context);
      Map<String, dynamic> arguments = {};
      arguments["isForMpin"] = true;
      NavigationUtilities.pushRoute(PasswordResetSuccessfully.route,
          args: arguments);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: R.string().commonString.error,
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }

  Future callApiForVerifyMpin(BuildContext context) async {
    Map<String, dynamic> req = {};
    String enteredMpinInString = "";

    enteredPin.forEach((element) {
      enteredMpinInString += (element.toString());
    });

    req["username"] = loginScreenObject.userNameController.text;
    // req["mPin"] = int.parse(enteredMpinInString);
    req["mPin"] = enteredMpinInString;

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().verifyMpin(req),
            context,
            isProgress: true)
        .then((loginResp) {
      print("Api calling doneeeeeeeeeee");
      // callLogout(context);
      //here check from splash or from switch...
      if (enm == Mpin.myAccount) {
        Navigator.of(context).pop();
        this.verifyPinCallback();
      } else if (enm == Mpin.splash) {
        SyncManager().callVersionUpdateApi(context, VersionUpdateApi.splash,
            id: app.resolve<PrefUtils>().getUserDetails().id ?? "");
      } else if(enm == Mpin.login){
        loginScreenObject.saveUserResponse(LoginScreenState.globalloginResp);
      }
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: R.string().commonString.error,
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }

  callApiForLoginUsingMpin(BuildContext context) {
    Map<String, dynamic> req = {};

    String enteredMpinInString = "";

    enteredPin.forEach((element) {
      enteredMpinInString += (element.toString());
    });

    int finalEnteredMpinInInt = int.parse(enteredMpinInString);
    req["password"] = finalEnteredMpinInInt.toString();
    req["username"] = loginScreenObject.userNameController.text;
    req["mPinLogin"] = true;

    NetworkCall<LoginResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().login(req),
            context,
            isProgress: true)
        .then((loginResp) {
      saveUserResponse(loginResp);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: R.string().commonString.error,
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }

  saveUserResponse(LoginResp loginResp) async {
    // save Logged In user
    if (loginResp.data != null) {
      app.resolve<PrefUtils>().saveUser(loginResp.data.user);
      await app.resolve<PrefUtils>().saveUserToken(
            loginResp.data.token.jwt,
          );
      await app.resolve<PrefUtils>().saveUserPermission(
            loginResp.data.userPermissions,
          );
      if (loginResp.data.user.isMpinAdded == false) {
        NavigationUtilities.pushRoute(SignInWithMPINScreen.route);
      } else {
        //varify mpin
        SyncManager().callVersionUpdateApi(context, VersionUpdateApi.logIn,
            id: loginResp.data.user.id);
      }
    }
  }
}
