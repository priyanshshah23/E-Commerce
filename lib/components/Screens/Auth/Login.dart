import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
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


  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _focusMobile = FocusNode();
  bool _isMobileValid = true;
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
                          left: getSize(26),
                          top: getSize(60),
                          right: getSize(26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                            Container(
//                              margin: EdgeInsets.only(
//                                top: getSize(10),
//                                bottom: getSize(10),
//                              ),
//                              child: Text(
//                                "",
//                                textAlign: TextAlign.center,
//                                style: AppTheme.of(context)
//                                    .theme
//                                    .textTheme
//                                    .subtitle
//                                    .copyWith(
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: EdgeInsets.only(left: getSize(0)),
//                              child: Image.asset(
//                                user,
//                                height: getSize(83),
//                                width: getSize(80),
//                              ),
//                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getSize(60), left: getSize(0)),
                              child: getMobileTextField(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getSize(15), left: getSize(0)),
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
                                    app.resolve<CustomDialogs>().confirmDialog(context,
                                      title: "Invalid Username/Password",
                                      desc: "Please enter valid Username/Password.",
                                      positiveBtnTitle: "Try Again",
                                      onClickCallback: (PositveButtonClick) {
                                     // Navigator.pop(context);
                                      }
                                    );
//                                    callApiForLogin(context);
                                    //AppNavigation.shared.movetoHome(isPopAndSwitch: false);
                                  } else {
                                    setState(() {
                                      _autoValidate = true;
                                    });
                                  }
                                },
                                foregroundColor: colorConstants.colorPrimary,
                                backgroundColor: colorConstants.colorPrimary,
                                borderRadius: 14,
                                fitWidth: true,
                                isButtonEnabled: true,
                                text: R.string().authStrings.signInCap,
                                //isButtonEnabled: enableDisableSigninButton(),
                              ),
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
              margin: EdgeInsets.all(getSize(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(R.string().authStrings.haveRegisterCode,
                      style: AppTheme.of(context)
                          .theme
                          .textTheme
                          .display1
                          .copyWith(
                        fontWeight: FontWeight.w200,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // NavigationUtilities.pushRoute(UploadDrivingLicence.route,type: RouteType.fade);

//                          NavigationUtilities.pushRoute(RegisterCode.route,
//                              type: RouteType.fade);
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              R.string().authStrings.clickHere,
                              style: AppTheme.of(context)
                                  .theme
                                  .textTheme
                                  .display1
                                  .copyWith(
                                decoration: TextDecoration.underline,
                                color:
                                AppTheme.of(context).theme.accentColor,
                              ),
                            ),
                            /*Container(
                              height: getSize(1),
                              width: getSize(75),
                              color: AppTheme.of(context).theme.accentColor,
                            )*/
                          ],
                        ),
                      ),
                      Text(R.string().authStrings.dontHaveAnAccount,
                          style: AppTheme.of(context)
                              .theme
                              .textTheme
                              .display1
                              .copyWith(
                            fontWeight: FontWeight.w200,
                          )),
                      //  for space between create account and don't have account
                    ],
                  ),
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
      focusNode: _focusMobile,
      textOption: TextFieldOption(
        prefixWid:getCommonIconWidget(
            imageName: user, imageType: IconSizeType.small),
        //Image.asset(profileEmail,),

        hintText:R.string().authStrings.mobileNumber,
        keyboardType: TextInputType.number,
        inputController: _mobileController,
        fillColor: _isMobileValid ? null : fromHex("#FFEFEF"),
        errorBorder: _isMobileValid
            ? null
            : OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),

        formatter: [
          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator(10)),
        ],
      ),
      textCallback: (text) {
        if (_autoValidate) {
          if (text.isEmpty) {
            setState(() {
              _isMobileValid = false;
            });
          } else if (!validateMobile(text)) {
            setState(() {
              _isMobileValid = false;
            });
          } else {
            setState(() {
              _isMobileValid = true;
            });
          }
        }
      },
      validation: (text) {
        //String validateName(String value) {
        if (text.isEmpty) {
          _isMobileValid = false;

          return R.string().errorString.enterPhone;
        } else if (!validateMobile(text)) {
          _isMobileValid = false;

          return R.string().errorString.enterValidPhone;
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
          prefixWid:getCommonIconWidget(
              imageName: user, imageType: IconSizeType.small),
//          fillColor: _isPasswordValid ? null : fromHex("#FFEFEF"),
//          errorBorder: _isPasswordValid
//              ? null
//              : OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(11)),
//            borderSide: BorderSide(width: 1, color: Colors.red),
//          ),
          hintText: R.string().authStrings.password,
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
        //String validateName(String value) {
        if (text.isEmpty) {
          //
          _isPasswordValid = false;
          return R.string().errorString.enterPassword;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.done,
      onNextPress: () {
        _focusMobile.unfocus();
      },
    );
  }

  getForgotPassword() {
    return InkWell(
      child: Text(
        R.string().authStrings.forgotPassword,
        textAlign: TextAlign.left,
        style: AppTheme.of(context).theme.textTheme.display1.copyWith(
          color: colorConstants.colorPrimary,
        ),
      ),
      onTap: () {
//        NavigationUtilities.pushRoute(ForgotPassword.route,
//            type: RouteType.fade);
      },
    );
  }
}
