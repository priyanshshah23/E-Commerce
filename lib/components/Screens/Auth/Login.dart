import 'dart:collection';
import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/localization/LocalizationHelper.dart';
import 'package:diamnow/components/Screens/Auth/ForgetPassword.dart';
import 'package:diamnow/components/Screens/Auth/Signup.dart';
import 'package:diamnow/components/Screens/Version/VersionUpdate.dart';

import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/Auth/SignInAsGuestModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info/package_info.dart';

import '../../../app/utils/navigator.dart';
import '../../../modules/ThemeSetting.dart';
import 'SignInWithMPINScreen.dart';

class LoginScreen extends StatefulScreenWidget {
  static const route = "login";

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _focusUserName = FocusNode();
  bool _isUserNameValid = true;
  var _focusPassword = FocusNode();
  bool _isPasswordValid = false;
  bool isButtonEnabled = true;
  bool autoValidate = false;
  Map<String, String> language = <String, String>{
    "English": English.languageCode,
    "French": French.languageCode,
    "Chinese": Chinese.languageCode,
    "Japanese": Japan.languageCode,
    "Italian": Italian.languageCode,
    "Spanish": Spanish.languageCode,
    "Germany": Germany.languageCode,
    // "Hebrew",
    // "Arabic",
  };

  String selectedLanguage = R.string.commonString.language;
  bool isCheckBoxSelected = false;
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics;
  bool canCheckBiometrics = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (kDebugMode) {
    getUserNameAndPassword();

    // }
  }

  getUserNameAndPassword() async {
    if (app.resolve<PrefUtils>().getBool("rememberMe") == true) {
      isCheckBoxSelected = app.resolve<PrefUtils>().getBool("rememberMe");
      userNameController.text = app.resolve<PrefUtils>().getString("userName");
      _passwordController.text = app.resolve<PrefUtils>().getString("passWord");
    }

    availableBiometrics = await auth.getAvailableBiometrics();
    canCheckBiometrics = await auth.canCheckBiometrics;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AppBackground(
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidate: autoValidate,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: getSize(20),
                              left: getSize(20),
                              right: getSize(20),
                              bottom: getSize(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: getSize(3)),
                                        child: Text(
                                          R.string.authStrings.welcome,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appTheme.textBlackColor,
                                            fontSize: getFontSize(24),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        width: getSize(120),
                                        child: PopupMenuButton<String>(
                                          onSelected: (newValue) {
                                            // add this property
                                            selectedLanguage = newValue;
                                            LocalizationHelper.changeLocale(
                                                language[newValue]);
                                            app
                                                .resolve<PrefUtils>()
                                                .setLocalization(
                                                    language[newValue]);
                                            setState(() {});
                                          },
                                          itemBuilder: (context) => [
                                            for (var item in language.keys)
                                              PopupMenuItem(
                                                value: item,
                                                height: getSize(20),
                                                child: Container(
                                                  width: getSize(85),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        item,
                                                        style: appTheme
                                                            .black14TextStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getSize(10),
                                                vertical: getSize(5)),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: appTheme
                                                        .textGreyColor)),
                                            child: Row(
                                              children: [
                                                Container(
                                                    height: getSize(10),
                                                    width: getSize(10),
                                                    child: Image.asset(
                                                        languageIcon)),
                                                SizedBox(
                                                  width: getSize(10),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    selectedLanguage,
                                                    style: selectedLanguage ==
                                                            R
                                                                .string
                                                                .commonString
                                                                .language
                                                        ? appTheme
                                                            .grey14HintTextStyle
                                                        : appTheme
                                                            .black14TextStyle,
                                                  ),
                                                ),
                                                Container(
                                                  height: getSize(10),
                                                  width: getSize(10),
                                                  child: Image.asset(dropDown),
                                                ),
                                              ],
                                            ),
                                          ),
                                          offset: Offset(25, 110),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: getSize(30)),
                                      child: Image.asset(
                                        splashLogo,
                                        height: Platform.isAndroid
                                            ? getSize(160)
                                            : getSize(130),
                                        width: Platform.isAndroid
                                            ? getSize(160)
                                            : getSize(140),
                                      ),
                                    ),
//                                Padding(
//                                  padding: EdgeInsets.only(
//                                      top: getSize(20), left: getSize(0)),
//                                  child: getMobileTextField(),
//                                ),
                                    getMobileTextField(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: getSize(15), left: getSize(0)),
                                      child: getPasswordTextField(),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: getSize(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              isCheckBoxSelected =
                                                  !isCheckBoxSelected;
                                              setState(() {});
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getSize(3))),
                                                  width: getSize(21),
                                                  height: getSize(21),
                                                  child: Image.asset(
                                                    isCheckBoxSelected
                                                        ? selectedCheckbox
                                                        : unSelectedCheckbox,
                                                    height: getSize(20),
                                                    width: getSize(20),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getSize(6),
                                                ),
                                                Text(
                                                    R.string.commonString
                                                        .rememberme,
                                                    style: appTheme
                                                        .blackMedium16TitleColorblack
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              // alignment: Alignment.centerRight,
                                              child: getForgotPassword(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: getSize(70)),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: getSize(15), left: getSize(0)),
                                        decoration: BoxDecoration(
                                            boxShadow: getBoxShadow(context)),
                                        child: AppButton.flat(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();

                                              Map<String, dynamic> req = {};
                                              req["username"] =
                                                  userNameController.text;
                                              req["password"] =
                                                  _passwordController.text;
                                              callLoginApi(context, req);
                                            } else {
                                              setState(() {
                                                autoValidate = true;
                                              });
                                            }
                                          },
                                          borderRadius: getSize(5),
                                          fitWidth: true,
                                          text: R.string.authStrings.signInCap,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: getSize(50)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                top: getSize(10),
                                                left: getSize(0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    fingurePrint,
                                                    width: getSize(15),
                                                    height: getSize(15),
                                                  ),
                                                  SizedBox(
                                                    width: getSize(10),
                                                  ),
                                                  Text(
                                                    R.string.commonString
                                                        .touchId,
                                                    style: appTheme
                                                        .primary16TextStyle,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: InkWell(
                                              onTap: () {
                                                // NavigationUtilities.pushRoute(
                                                //     SignInWithMPINScreen.route,);
                                                NavigationUtilities.push(
                                                    SignInWithMPINScreen(
                                                  fromMpinButton: true,
                                                ));
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                  top: getSize(10),
                                                  left: getSize(0),
                                                ),
                                                child: InkWell(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        mpin,
                                                        width: getSize(15),
                                                        height: getSize(15),
                                                      ),
                                                      SizedBox(
                                                        width: getSize(10),
                                                      ),
                                                      Text(
                                                        R.string.commonString
                                                            .mPin,
                                                        style: appTheme
                                                            .primary16TextStyle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*Container(
                                      margin: EdgeInsets.only(
                                          top: getSize(10), left: getSize(0)),
                                      child: AppButton.flat(
                                        onTap: () {
                                          // NavigationUtilities.pushRoute(
                                          //     GuestSignInScreen.route);
                                        },
                                        textColor: appTheme.colorPrimary,
                                        backgroundColor: appTheme.colorPrimary
                                            .withOpacity(0.1),
                                        borderRadius: getSize(5),
                                        fitWidth: true,
                                        text: R
                                            .string()
                                            .authStrings
                                            .signInAsGuest,
                                        //isButtonEnabled: enableDisableSigninButton(),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(child: Container()),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  child: InkWell(
                    onTap: () {
                      NavigationUtilities.pushRoute(SignupScreen.route);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: getSize(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(R.string.authStrings.dontHaveAnAccount,
                              style: appTheme.grey16HintTextStyle),
                          Text(" " + R.string.authStrings.signUp,
                              style: appTheme.darkBlue16TextStyle),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  getMobileTextField() {
    return CommonTextfield(
      focusNode: _focusUserName,
      textOption: TextFieldOption(
        prefixWid:
            getCommonIconWidget(imageName: user, imageType: IconSizeType.small),
        //Image.asset(profileEmail,),

        hintText: R.string.authStrings.name,
        inputController: userNameController,
        errorBorder: _isUserNameValid
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),

        formatter: [],
      ),
      textCallback: (text) {
        if (autoValidate) {
          if (text.isEmpty) {
            setState(() {
              _isUserNameValid = false;
            });
          } else if (!validateMobile(text)) {
            setState(() {
              _isUserNameValid = false;
            });
          } else {
            setState(() {
              _isUserNameValid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.isEmpty) {
          _isUserNameValid = false;

          return R.string.errorString.enterUsername;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        fieldFocusChange(context, _focusPassword);
      },
    );
  }

  getPasswordTextField() {
    return CommonTextfield(
      focusNode: _focusPassword,
      textOption: TextFieldOption(
          prefixWid: getCommonIconWidget(
              imageName: password, imageType: IconSizeType.small),
          hintText: R.string.authStrings.password + "*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _passwordController,
          isSecureTextField: true),
      textCallback: (text) {
        if (autoValidate) {
          if (text.isEmpty) {
            setState(() {
              _isPasswordValid = false;
            });
          } else {
            setState(() {
              _isPasswordValid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.isEmpty) {
          _isPasswordValid = false;
          return R.string.errorString.enterPassword;
        }
        /* else if(!validateStructure(text)) {
          return R.string.errorString.wrongPassword;
        } */
        else {
          return null;
        }
      },
      inputAction: TextInputAction.done,
      onNextPress: () {
        _focusUserName.unfocus();
      },
    );
  }

  getForgotPassword() {
    return InkWell(
      child: Text(
        R.string.authStrings.forgotPassword,
        textAlign: TextAlign.right,
        style: appTheme.darkBlue16TextStyle,
      ),
      onTap: () {
        NavigationUtilities.pushRoute(ForgetPasswordScreen.route,
            type: RouteType.fade);
      },
    );
  }

  Future callLoginApi(BuildContext context, Map<String, dynamic> req) async {
    // LoginReq req = LoginReq();
    // req.username = userNameController.text;
    // req.password = _passwordController.text;

    NetworkCall<LoginResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().login(req),
            context,
            isProgress: true)
        .then((loginResp) {
      navigateToPopUpBox(context, loginResp);
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

  navigateToPopUpBox(BuildContext context, LoginResp loginResp) {
    app.resolve<CustomDialogs>().confirmDialog(context,
        title: APPNAME,
        desc:
            "Do you want to enable Touch Id/MPin to unlock $APPNAME? Please choose an option to unlock app",
        positiveBtnTitle2: !isNullEmptyOrFalse(availableBiometrics)
            ? R.string.commonString.usertouchid
            : null,
        positiveBtnTitle: R.string.commonString.usempin,
        negativeBtnTitle: R.string.commonString.btnSkip,
        onClickCallback: (buttonType) async {
      if (buttonType == ButtonType.PositveButtonClick) {
        if (loginResp.data.user.isMpinAdded == false) {
          Map<String, dynamic> arguments = {};
          arguments["enm"] = Mpin.createMpin;
          arguments["userName"] = loginResp.data.user.username;
          NavigationUtilities.pushRoute(SignInWithMPINScreen.route,
              args: arguments);
        } else {
          Map<String, dynamic> args = {};
          args["askForVerifyMpin"] = true;
          args["enm"] = Mpin.login;
          args["userName"] = loginResp.data.user.username;
          args["verifyPinCallback"] = () {
            saveUserResponse(loginResp);
            app.resolve<PrefUtils>().setMpinisUsage(true);
          };
          NavigationUtilities.pushRoute(SignInWithMPINScreen.route, args: args);
        }
      } else if (buttonType == ButtonType.PositveButtonClick2) {
        askForBioMetrics(loginResp)();
      } else {
        saveUserResponse(loginResp);
      }
    });
  }

  askForBioMetrics(LoginResp loginResp) async {
    try {
      bool isAuthenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'authenticate to access',
        useErrorDialogs: false,
        stickyAuth: false,
      );
      print(isAuthenticated);
      if (isAuthenticated) {
        app.resolve<PrefUtils>().setBiometrcisUsage(true);
        saveUserResponse(loginResp);
      } else {
        saveUserResponse(loginResp);
      }
    } on PlatformException catch (e) {
      print(e.message);
      saveUserResponse(loginResp);
    }
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
      await app
          .resolve<PrefUtils>()
          .saveBoolean("rememberMe", isCheckBoxSelected);
      await app
          .resolve<PrefUtils>()
          .saveString("userName", userNameController.text);
      await app
          .resolve<PrefUtils>()
          .saveString("passWord", _passwordController.text);

      // print(app.resolve<PrefUtils>().getBool("rememberMe"));
      // print(app.resolve<PrefUtils>().getString("userName"));
      // print(app.resolve<PrefUtils>().getString("passWord"));
    }
//      NavigationUtilities.pushRoute(Notifications.route);
    // callVersionUpdateApi(id: loginResp.data.user.id); //for local
    // isMpinAdded==false mpin swith added
    SyncManager().callVersionUpdateApi(context, VersionUpdateApi.logIn,
        id: loginResp.data.user.id);
  }

  // void callVersionUpdateApi({String id}) {
  //   NetworkCall<VersionUpdateResp>()
  //       .makeCall(
  //           () => app
  //               .resolve<ServiceModule>()
  //               .networkService()
  //               .getVersionUpdate(),
  //           context,
  //           isProgress: true)
  //       .then(
  //     (resp) {
  //       if (resp.data != null) {
  //         PackageInfo.fromPlatform().then(
  //           (PackageInfo packageInfo) {
  //             String appName = packageInfo.appName;
  //             String packageName = packageInfo.packageName;
  //             String version = packageInfo.version;
  //             String buildNumber = packageInfo.buildNumber;
  //             if (Platform.isIOS) {
  //               print("iOS");
  //               if (resp.data.ios != null) {
  //                 num respVersion = resp.data.ios.number;

  //                 if (num.parse(version) < respVersion) {
  //                   bool hardUpdate = resp.data.ios.isHardUpdate;

  //                   Map<String, dynamic> dict = new HashMap();
  //                   dict["isHardUpdate"] = hardUpdate;
  //                   dict["oncomplete"] = () {
  //                     SyncManager.instance.callMasterSync(
  //                         NavigationUtilities.key.currentContext, () async {
  //                       //success
  //                       AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                     }, () {},
  //                         isNetworkError: false,
  //                         isProgress: true,
  //                         id: id).then((value) {});
  //                   };
  //                   if (hardUpdate == true) {
  //                     app.resolve<PrefUtils>().saveSkipUpdate(false);
  //                     NavigationUtilities.pushReplacementNamed(
  //                         VersionUpdate.route,
  //                         args: dict);
  //                   } else {
  //                     if (app.resolve<PrefUtils>().getSkipUpdate() == false) {
  //                       NavigationUtilities.pushReplacementNamed(
  //                           VersionUpdate.route,
  //                           args: dict);
  //                     } else {
  //                       SyncManager.instance.callMasterSync(
  //                           NavigationUtilities.key.currentContext, () async {
  //                         //success
  //                         AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                       }, () {},
  //                           isNetworkError: false,
  //                           isProgress: true,
  //                           id: id).then((value) {});
  //                     }
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
  //               }
  //             } else {
  //               print("Android");
  //               if (resp.data.android != null) {
  //                 num respVersion = resp.data.android.number;
  //                 if (num.parse(buildNumber) < respVersion) {
  //                   bool hardUpdate = resp.data.android.isHardUpdate;
  //                   Map<String, dynamic> dict = new HashMap();
  //                   dict["isHardUpdate"] = hardUpdate;
  //                   dict["oncomplete"] = () {
  //                     SyncManager.instance.callMasterSync(
  //                         NavigationUtilities.key.currentContext, () async {
  //                       //success
  //                       AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                     }, () {},
  //                         isNetworkError: false,
  //                         isProgress: true,
  //                         id: id).then((value) {});
  //                   };
  //                   if (hardUpdate == true) {
  //                     app.resolve<PrefUtils>().saveSkipUpdate(false);
  //                     NavigationUtilities.pushReplacementNamed(
  //                         VersionUpdate.route,
  //                         args: dict);
  //                   } else {
  //                     if (app.resolve<PrefUtils>().getSkipUpdate() == false) {
  //                       NavigationUtilities.pushReplacementNamed(
  //                           VersionUpdate.route,
  //                           args: dict);
  //                     } else {
  //                       SyncManager.instance.callMasterSync(
  //                           NavigationUtilities.key.currentContext, () async {
  //                         //success
  //                         AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                       }, () {},
  //                           isNetworkError: false,
  //                           isProgress: true,
  //                           id: id).then((value) {});
  //                     }
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
  //               }
  //             }
  //           },
  //         );
  //       }
  //     },
  //   ).catchError(
  //     (onError) => {
  //       app.resolve<CustomDialogs>().confirmDialog(context,
  //           title: R.string.errorString.versionError,
  //           desc: onError.message,
  //           positiveBtnTitle: R.string.commonString.btnTryAgain,
  //           onClickCallback: (PositveButtonClick) {
  //         callVersionUpdateApi(id: id);
  //       }),
  //     },
  //   );
  // }

  Future<bool> onWillPop() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
