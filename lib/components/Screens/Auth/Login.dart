import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/components/Screens/Auth/SignInAsGuestScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static const route = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _focusUserName = FocusNode();
  bool _isUserNameValid = true;
  var _focusPassword = FocusNode();
  bool _isPasswordValid = false;
  bool isButtonEnabled = true;
  bool _autoValidate = false;

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
                            bottom: getSize(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              R.string().authStrings.welcome,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appTheme.textBlackColor,
                                fontSize: getFontSize(24),
                              ),
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
                                              color: ColorConstants.colorPrimary
                                                  .withOpacity(0.1)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: getSize(20)),
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
                                    padding: EdgeInsets.only(top: getSize(20)),
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
//                                      NavigationUtilities.pushRoute(DemoScreen.route);

                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        callLoginApi(context);
                                      } else {
                                        setState(() {
                                          _autoValidate = true;
                                        });
                                      }
                                    },
                                    //  backgroundColor: appTheme.buttonColor,
                                    borderRadius: getSize(5),
                                    fitWidth: true,
                                    text: R.string().authStrings.signInCap,
                                    //isButtonEnabled: enableDisableSigninButton(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: getSize(10)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Or",
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
                                    backgroundColor:
                                        appTheme.colorPrimary.withOpacity(0.1),
                                    borderRadius: getSize(5),
                                    fitWidth: true,
                                    text: "Sign In as Guest",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(R.string().authStrings.haveRegisterCode,
                      style: appTheme.grey16HintTextStyle),
                  Text(" Sign Up", style: appTheme.darkBlue16TextStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
          hintText: R.string().authStrings.password + "*",
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
        } else {
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
//        NavigationUtilities.pushRoute(ForgotPassword.route,
//            type: RouteType.fade);
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
      }

      SyncManager.instance
          .callMasterSync(NavigationUtilities.key.currentContext, () async {
        //success
        
        NavigationUtilities.pushRoute(FilterScreen.route);
      }, () {},
              isNetworkError: false,
              isProgress: true,
              id: loginResp.data.user.id).then((value) {});
    }).catchError((onError) {
      print("Error " + onError);
    });
  }
}
