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
import 'package:package_info/package_info.dart';

import '../../../app/utils/navigator.dart';
import '../../../modules/ThemeSetting.dart';
import 'SignInWithMPINScreen.dart';

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
    "English",
    "French",
    "Chinese",
    "Japanese",
    "Italian",
    "Spanish",
    "Germany",
    "Hebrew",
    "Arabic",
  ];

  String selectedLanguage = R.string().commonString.language;
  bool isCheckBoxSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (kDebugMode) {
    getUserNameAndPassword();
    // }
  }

  getUserNameAndPassword() {
    if (app.resolve<PrefUtils>().getBool("rememberMe") == true) {
      isCheckBoxSelected = app.resolve<PrefUtils>().getBool("rememberMe");
      _userNameController.text = app.resolve<PrefUtils>().getString("userName");
      _passwordController.text = app.resolve<PrefUtils>().getString("passWord");
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
                              bottom: getSize(10),
                            ),
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
                                                    style: appTheme
                                                        .black14TextStyle,
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
                                                child:
                                                    Image.asset(languageIcon)),
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
                                                    ? appTheme
                                                        .grey14HintTextStyle
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
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: getSize(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  isCheckBoxSelected =
                                                      !isCheckBoxSelected;
                                                  setState(() {});
                                                },
                                                child: Container(
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
                                              ),
                                              SizedBox(
                                                width: getSize(6),
                                              ),
                                              Text("Remember Me",
                                                  style: appTheme
                                                      .blackMedium16TitleColorblack
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold))
                                            ],
                                          ),
                                          Container(
                                            // alignment: Alignment.centerRight,
                                            child: getForgotPassword(),
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
                                              callLoginApi(context);
                                            } else {
                                              setState(() {
                                                _autoValidate = true;
                                              });
                                            }
                                          },
                                          borderRadius: getSize(5),
                                          fitWidth: true,
                                          text:
                                              R.string().authStrings.signInCap,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: getSize(60)),
                                      child: Row(
                                        children: [
                                          Expanded(
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
                                                    "Touch ID",
                                                    style: appTheme
                                                        .primary16TextStyle,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                NavigationUtilities.pushRoute(
                                                    SignInWithMPINScreen.route);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                  top: getSize(10),
                                                  left: getSize(0),
                                                ),
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
                                                      "MPIN",
                                                      style: appTheme
                                                          .primary16TextStyle,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                          Text("Don't have an account?",
                              style: appTheme.grey16HintTextStyle),
                          Text(" " + R.string().authStrings.signUp,
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

        hintText: R.string().authStrings.name,
        inputController: _userNameController,
        errorBorder: _isUserNameValid
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),

        formatter: [],
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
          hintText: R.string().authStrings.password +
              R.string().authStrings.requiredField,
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
        await app
            .resolve<PrefUtils>()
            .saveBoolean("rememberMe", isCheckBoxSelected);
        await app
            .resolve<PrefUtils>()
            .saveString("userName", _userNameController.text);
        await app
            .resolve<PrefUtils>()
            .saveString("passWord", _passwordController.text);
      }

      SyncManager.instance
          .callMasterSync(NavigationUtilities.key.currentContext, () async {
        //success
        AppNavigation.shared.movetoHome(isPopAndSwitch: true);
      }, () {},
              isNetworkError: false,
              isProgress: true,
              id: loginResp.data.user.id).then((value) {});
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

  Future<bool> onWillPop() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
