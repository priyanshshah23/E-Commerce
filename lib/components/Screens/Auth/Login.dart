import 'dart:collection';
import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/ForgetPassword.dart';
import 'package:diamnow/components/Screens/Auth/SignInAsGuestScreen.dart';
import 'package:diamnow/components/Screens/Auth/Signup.dart';
import 'package:diamnow/components/Screens/Auth/TabBarDemo.dart';
import 'package:diamnow/components/Screens/Auth/SignInAsGuestScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:diamnow/components/Screens/Notification/Notifications.dart';
import 'package:diamnow/components/Screens/Version/VersionUpdate.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

import '../../../app/utils/navigator.dart';
import '../../../modules/ThemeSetting.dart';

class LoginScreen extends StatefulScreenWidget {
  static const route = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _focusUserName = FocusNode();
  bool _isUserNameValid = true;
  var _focusPassword = FocusNode();
  bool _isPasswordValid = false;
  bool isButtonEnabled = true;
  bool _autoValidate = false;
  List<String> language = <String>[
    "English", "French", "Chinese", "Japanese", "Italian", "Spanish", "Germany", "Hebrew", "Arabic",
  ];

  String selectedLanguage = R.string().commonString.language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (kDebugMode) {
      _userNameController.text = "mobileUser";
      _passwordController.text = "Test@12345";
    }
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
                    autovalidate: _autoValidate,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: getSize(20),
                                left: getSize(20),
                                right: getSize(20),
                                bottom: getSize(10),),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      R.string().authStrings.welcome,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appTheme.textBlackColor,
                                        fontSize: getFontSize(24),
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    PopupMenuButton<String>(
                                      onSelected: (newValue) {
                                        // add this property
                                        selectedLanguage = newValue;
                                        setState(() {});
                                      },
                                      itemBuilder: (context) => [
                                        for (var item in language)
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
                                                    style: appTheme.black14TextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                      child: Container(
                                        width: getSize(170),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: getSize(10),
                                            vertical: getSize(5)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: appTheme.textGreyColor)),
                                        child: Row(
                                          children: [
                                            Container(
                                                height: getSize(10),
                                                width: getSize(10),
                                                child: Image.asset(languageIcon)),
                                            SizedBox(
                                              width: getSize(10),
                                            ),
                                            Expanded(
                                              child: Text(
                                                selectedLanguage,
                                                style: selectedLanguage ==
                                                        R
                                                            .string()
                                                            .commonString
                                                            .language
                                                    ? appTheme.grey14HintTextStyle
                                                    : appTheme.black14TextStyle,
                                              ),
                                            ),
                                            Container(
                                                height: getSize(10),
                                                width: getSize(10),
                                                child: Image.asset(dropDown)),
                                          ],
                                        ),
                                      ),
                                      offset: Offset(25, 110),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: getSize(25)),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: getSize(90),
                                            width: getSize(90),
                                            padding: EdgeInsets.only(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: appTheme.colorPrimary
                                                      .withOpacity(0.1)),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getSize(20)),
                                            child: Image.asset(
                                              diamond,
                                              height: getSize(130),
                                              width: getSize(140),
                                            ),
                                          )
                                        ],
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
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(top: getSize(20)),
                                        child: getForgotPassword(),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: getSize(15), left: getSize(0)),
                                      decoration: BoxDecoration(
                                          boxShadow: getBoxShadow(context)),
                                      child: AppButton.flat(
                                        onTap: () {
                                          // NavigationUtilities.pushRoute(TabBarDemo.route);
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            callLoginApi(context);
                                          } else {
                                            setState(() {
                                              _autoValidate = true;
                                            });
                                          }
                                          // NavigationUtilities.push(ThemeSetting());
                                        },
                                        //  backgroundColor: appTheme.buttonColor,
                                        borderRadius: getSize(5),
                                        fitWidth: true,
                                        text: R.string().authStrings.signInCap,
                                        //isButtonEnabled: enableDisableSigninButton(),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: getSize(10)),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          R.string().commonString.lblOr,
                                          style: appTheme.grey16HintTextStyle,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: getSize(10), left: getSize(0)),
                                      child: AppButton.flat(
                                        onTap: () {
                                          NavigationUtilities.pushRoute(
                                              GuestSignInScreen.route);
                                        },
                                        textColor: appTheme.colorPrimary,
                                        backgroundColor: appTheme.colorPrimary
                                            .withOpacity(0.1),
                                        borderRadius: getSize(5),
                                        fitWidth: true,
                                        text: R.string().authStrings.signInAsGuest,
                                        //isButtonEnabled: enableDisableSigninButton(),
                                      ),
                                    ),
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
//              alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.all(getSize(15)),
                  child: InkWell(
                    onTap: () {
                      NavigationUtilities.pushRoute(SignupScreen.route);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(R.string().authStrings.haveRegisterCode,
                            style: appTheme.grey16HintTextStyle),
                        Text(" " + R.string().authStrings.signUp, style: appTheme.darkBlue16TextStyle),
                      ],
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

        hintText: R.string().authStrings.name,
//        keyboardType: TextInputType.number,
        inputController: _userNameController,
//        fillColor: _isUserNameValid ? null : fromHex("#FFEFEF"),
        errorBorder: _isUserNameValid
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),

        formatter: [
//          ValidatorInputFormatter(
//              editingValidator: DecimalNumberEditingRegexValidator(10)),
        ],
      ),
      textCallback: (text) {
        if (_autoValidate) {
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

          return R.string().errorString.enterUsername;
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
          hintText: R.string().authStrings.password + R.string().authStrings.requiredField,
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _passwordController,
          isSecureTextField: true),
      textCallback: (text) {
        if (_autoValidate) {
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
          return R.string().errorString.enterPassword;
        }
        /* else if(!validateStructure(text)) {
          return R.string().errorString.wrongPassword;
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
        R.string().authStrings.forgotPassword,
        textAlign: TextAlign.left,
        style: appTheme.darkBlue16TextStyle,
      ),
      onTap: () {
        NavigationUtilities.pushRoute(ForgetPasswordScreen.route,
            type: RouteType.fade);
      },
    );
  }

  Future callLoginApi(BuildContext context) async {
    LoginReq req = LoginReq();
    req.username = _userNameController.text;
    req.password = _passwordController.text;

    NetworkCall<LoginResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().login(req),
            context,
            isProgress: true)
        .then((loginResp) async {
      // save Logged In user
      if (loginResp.data != null) {
        app.resolve<PrefUtils>().saveUser(loginResp.data.user);
        await app.resolve<PrefUtils>().saveUserToken(
              loginResp.data.token.jwt,
            );
        await app.resolve<PrefUtils>().saveUserPermission(
              loginResp.data.userPermissions,
            );
      }
//      NavigationUtilities.pushRoute(Notifications.route);
      callVersionUpdateApi(id: loginResp.data.user.id);
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

  void callVersionUpdateApi({String id}) {
    NetworkCall<VersionUpdateResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .getVersionUpdate(),
            context,
            isProgress: true)
        .then(
      (resp) {
        if (resp.data != null) {
          PackageInfo.fromPlatform().then(
            (PackageInfo packageInfo) {
              print(packageInfo.buildNumber);
              String appName = packageInfo.appName;
              String packageName = packageInfo.packageName;
              String version = packageInfo.version;
              String buildNumber = packageInfo.buildNumber;

              if (Platform.isIOS) {
                if (resp.data.ios != null) {
                  num respVersion = resp.data.ios.number;
                  if (num.parse(version) < respVersion) {
                    bool hardUpdate = resp.data.ios.isHardUpdate;
                    Map<String, dynamic> dict = new HashMap();
                    dict["isHardUpdate"] = hardUpdate;
                    dict["oncomplete"] = () {
                      Navigator.pop(context);
                    };
                    print(hardUpdate);
                    if (hardUpdate == true) {
                      NavigationUtilities.pushReplacementNamed(
                        VersionUpdate.route,
                        args: dict,
                      );
                    }
                  } else {
                    SyncManager.instance.callMasterSync(
                        NavigationUtilities.key.currentContext, () async {
                      //success
                      AppNavigation().movetoHome(isPopAndSwitch: true);
                    }, () {},
                        isNetworkError: false,
                        isProgress: true,
                        id: id).then((value) {});
                  }
                } else {
                  SyncManager.instance.callMasterSync(
                      NavigationUtilities.key.currentContext, () async {
                    //success
                    AppNavigation().movetoHome(isPopAndSwitch: true);
                  }, () {},
                      isNetworkError: false,
                      isProgress: true,
                      id: id).then((value) {});
                }
              } else {
                if (resp.data.android != null) {
                  num respVersion = resp.data.android.number;
                  if (num.parse(buildNumber) < respVersion) {
                    bool hardUpdate = resp.data.android.isHardUpdate;
                    if (hardUpdate == true) {
                      NavigationUtilities.pushReplacementNamed(
                        VersionUpdate.route,
                      );
                    }
                  } else {
                    SyncManager.instance.callMasterSync(
                        NavigationUtilities.key.currentContext, () async {
                      //success
                      AppNavigation().movetoHome(isPopAndSwitch: true);
                    }, () {},
                        isNetworkError: false,
                        isProgress: true,
                        id: id).then((value) {});
                  }
                } else {
                  SyncManager.instance.callMasterSync(
                      NavigationUtilities.key.currentContext, () async {
                    //success
                    AppNavigation().movetoHome(isPopAndSwitch: true);
                  }, () {},
                      isNetworkError: false,
                      isProgress: true,
                      id: id).then((value) {});
                }
              }
            },
          );
        }
      },
    ).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: R.string().errorString.versionError,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
            onClickCallback: (PositveButtonClick) {
          callVersionUpdateApi(id: id);
        }),
      },
    );
  }

  Future<bool> onWillPop() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
