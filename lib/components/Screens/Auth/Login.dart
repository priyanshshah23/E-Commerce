import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
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
                          top: getSize(50),
                          left: getSize(20),
                          right: getSize(20),
                        ),
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
                                  padding: EdgeInsets.symmetric(vertical: getSize(50)),
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
                                        padding: EdgeInsets.only(left: getSize(20)),
                                        child: Image.asset(
                                          diamond,
                                          height: getSize(130),
                                          width: getSize(140),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getSize(20), left: getSize(0)),
                                  child: getMobileTextField(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getSize(20), left: getSize(0)),
                                  child: getPasswordTextField(),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: getSize(30)),
                                    child: getForgotPassword(),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: getSize(30), left: getSize(0)),
                                  child: AppButton.flat(
                                    onTap: () {
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
                                    borderRadius: 14,
                                    fitWidth: true,
                                    text: R.string().authStrings.signInCap,
                                    //isButtonEnabled: enableDisableSigninButton(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: getSize(20)),
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
                                      top: getSize(30), left: getSize(0)),
                                  child: AppButton.flat(
                                    onTap: () {

                                    },
                                    textColor: appTheme.colorPrimary,
                                    backgroundColor:
                                        appTheme.colorPrimary.withOpacity(0.1),
                                    borderRadius: 14,
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
                  Text("Sign Up", style: appTheme.darkBlue16TextStyle),
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
        print(text.toString());
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
    print("test ${_userNameController.text}");
    req.username = _userNameController.text;
    req.password = _passwordController.text;
    print("test ${req.username}");

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().login(req),
        context,
        isProgress: true)
        .then((masterResp) async {
      // save Logged In user
      // if (masterResp.data.loggedInUser != null) {
      //   app.resolve<PrefUtils>().saveUser(masterResp.data.loggedInUser);
      // }

    }).catchError((onError) => {
      print("Error "+onError)
    });
  }
}
