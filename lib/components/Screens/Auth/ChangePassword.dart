
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePassword extends StatefulWidget {
  static const route = "ChangePassword";

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  var _focusOldPassword = FocusNode();
  var _focusNewPassword = FocusNode();
  var _focusConfirmPassword = FocusNode();

  bool isPasswordSame = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getSize(20), vertical: getSize(30)),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: getSize(40),
                ),
                getOldPasswordTextField(),
                SizedBox(
                  height: getSize(20),
                ),
                getNewPasswordTextField(),
                SizedBox(
                  height: getSize(20),
                ),
                getConfirmPasswordTextField(),
                SizedBox(
                  height: getSize(30),
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
                      if (_formKey.currentState.validate()) {
//                      if(  _confirmPasswordController.text.trim() != _newPasswordController.text.trim()) {
//                        _autoValidate = true;
//                        isPasswordSame = false;
//                      } else {
//                        isPasswordSame = true;
//                      }
//                      setState(() {});
                        _formKey.currentState.save();
//                      callLoginApi(context);
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
                    text: "Change Password",
                    //isButtonEnabled: enableDisableSigninButton(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getOldPasswordTextField() {
    return CommonTextfield(
      focusNode: _focusOldPassword,
      textOption: TextFieldOption(
          prefixWid: getCommonIconWidget(
              imageName: password, imageType: IconSizeType.small),
          hintText: "Old Password*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _oldPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string().errorString.enterPassword;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusOldPassword.unfocus();
        FocusScope.of(context).requestFocus(_focusNewPassword);
      },
    );
  }

  getNewPasswordTextField() {
    return CommonTextfield(
      focusNode: _focusNewPassword,
      textOption: TextFieldOption(
          prefixWid: getCommonIconWidget(
              imageName: password, imageType: IconSizeType.small),
          hintText: "New Password*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _newPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string().errorString.enterPassword;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusNewPassword.unfocus();
        FocusScope.of(context).requestFocus(_focusConfirmPassword);
      },
    );
  }

  getConfirmPasswordTextField() {
    return CommonTextfield(
      focusNode: _focusConfirmPassword,
      textOption: TextFieldOption(
          prefixWid: getCommonIconWidget(
              imageName: password, imageType: IconSizeType.small),
          hintText: "Confirm Password*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _confirmPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string().errorString.enterPassword;
        } else  if(text != _newPasswordController.text.trim())  {
          return "New Password And Confirm Password Should be same";
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.done,
      onNextPress: () {
        _focusConfirmPassword.unfocus();
      },
    );
  }
}
