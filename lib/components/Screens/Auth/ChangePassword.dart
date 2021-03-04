import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/Auth/ChangePasswordModel.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  var _focusOldPassword = FocusNode();
  var _focusNewPassword = FocusNode();
  var _focusConfirmPassword = FocusNode();

  bool isPasswordSame = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: getAppBar(
          context,
          R.string.authStrings.changePassword,
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getSize(20), vertical: getSize(30)),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      right: getSize(30),
                      left: getSize(82),
                      bottom: getSize(28),
                    ),
                    child: Image.asset(
                      resetPassword,
                      height: getSize(150),
                      width: getSize(200),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        R.string.authStrings.setNewPassword,
                        textAlign: TextAlign.center,
                        style: appTheme.black14TextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getSize(36),
                  ),
                  getOldPasswordTextField(),
                  SizedBox(
                    height: getSize(16),
                  ),
                  getNewPasswordTextField(),
                  SizedBox(
                    height: getSize(16),
                  ),
                  getConfirmPasswordTextField(),
                  SizedBox(
                    height: getSize(30),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: getSize(15), left: getSize(0)),
                    decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
                    child: AppButton.flat(
                      onTap: () {
                        // NavigationUtilities.pushRoute(TabBarDemo.route);
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          callChangePasswordApi();
//                      callLoginApi(context);
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                        // NavigationUtilities.push(ThemeSetting());
                      },
                      //  backgroundColor: appTheme.buttonColor,
                      // borderRadius: getSize(5),
                      fitWidth: true,
                      text: R.string.authStrings.changePassword,
                      //isButtonEnabled: enableDisableSigninButton(),
                    ),
                  ),
                ],
              ),
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
          hintText: R.string.authStrings.oldPassword + "*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _oldPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string.errorString.enterPassword;
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
          hintText: R.string.authStrings.newPassword,
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _newPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string.errorString.enterPassword;
        } else if (!validateStructure(text)) {
          return R.string.errorString.wrongPassword;
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
          hintText: R.string.authStrings.confirmPassword + "*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _confirmPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string.errorString.enterPassword;
        } else if (text != _newPasswordController.text.trim()) {
          return R.string.errorString.enterSamePassword;
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

  callChangePasswordApi({bool isResend = false}) async {
    ChangePasswordReq req = ChangePasswordReq();
    req.currentPassword = _oldPasswordController.text.trim();
    req.newPassword = _newPasswordController.text.trim();

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .changePassword(req),
            context,
            isProgress: true)
        .then((resp) async {
      FocusScope.of(context).unfocus();

      app.resolve<CustomDialogs>().confirmDialog(context,
          title: "",
          desc: resp.message,
          positiveBtnTitle: R.string.commonString.ok,
          onClickCallback: (buttonType) {
        if (buttonType == ButtonType.PositveButtonClick) {
          app.resolve<PrefUtils>().resetAndLogout(context);
        }
      });
      // showToast(resp.message,context: context);
      // Navigator.pop(context);
      // setState(() {});
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
          );
    });
  }
}
