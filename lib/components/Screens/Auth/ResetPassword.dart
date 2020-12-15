import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/PasswordResetSuccessfully.dart';

import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/decoration/pin_decoration.dart';
import 'package:diamnow/components/widgets/pinView_textFields/pin_widget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/style/obscure.dart';
import 'package:diamnow/models/Auth/ResetPasswordModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulScreenWidget {
  static const route = "ResetPassword";
  String value;
  String otpNumber;

  ResetPassword(Map<String, dynamic> arguments) {
    this.value = arguments["value"];
    this.otpNumber = arguments["otpNumber"];
  }

  @override
  _ResetPasswordState createState() =>
      _ResetPasswordState(value: value, otpNumber: otpNumber);
}

class _ResetPasswordState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String value;
  String otpNumber;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  var _focusNewPassword = FocusNode();
  var _focusConfirmPassword = FocusNode();

  _ResetPasswordState({this.value, this.otpNumber});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            appBar: getAppBar(
              context,
              R.string.authStrings.resetPwd,
              bgColor: appTheme.whiteColor,
              leadingButton: getBackButton(context),
              centerTitle: false,
            ),
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: getSize(20),
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            right: getSize(50),
                            left: getSize(82),
                            bottom: getSize(52),
                          ),
                          child: Image.asset(
                            resetPassword,
                            height: getSize(150),
                            width: getSize(200),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: getSize(30), bottom: getSize(40)),
                          child: Text(
                            R.string.authStrings.setNewPassword,
                            style: appTheme.black14TextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        getNewPasswordTextField(),
                        SizedBox(
                          height: getSize(20),
                        ),
                        getConfirmPasswordTextField(),
                        SizedBox(
                          height: getSize(60),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: getSize(15), left: getSize(0)),
                          decoration:
                              BoxDecoration(boxShadow: getBoxShadow(context)),
                          child: AppButton.flat(
                            onTap: () {
                              // NavigationUtilities.pushRoute(TabBarDemo.route);
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                callResetPasswordApi();
                              } else {
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            },
                            borderRadius: getSize(5),
                            fitWidth: true,
                            text: R.string.commonString.save,
                            //isButtonEnabled: enableDisableSigninButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getNewPasswordTextField() {
    return CommonTextfield(
      focusNode: _focusNewPassword,
      textOption: TextFieldOption(
          prefixWid: getCommonIconWidget(
              imageName: password, imageType: IconSizeType.small),
          hintText: R.string.authStrings.password + "*",
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

  Future callResetPasswordApi() async {
    ResetPasswordReq req = ResetPasswordReq();
    req.newPassword = _newPasswordController.text.trim();
    req.value = value;
    req.otpNumber = otpNumber;

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .resetPassword(req),
            context,
            isProgress: true)
        .then((Resp) async {
      NavigationUtilities.pushRoute(PasswordResetSuccessfully.route);
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string.commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
          );
    });
  }
}
