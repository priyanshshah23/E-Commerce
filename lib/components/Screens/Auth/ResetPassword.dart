import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/PasswordResetSuccessfully.dart';

import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/decoration/pin_decoration.dart';
import 'package:diamnow/components/widgets/pinView_textFields/pin_widget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/style/obscure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulScreenWidget {
  static const route = "ResetPassword";

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  var _focusNewPassword = FocusNode();
  var _focusConfirmPassword = FocusNode();

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
              R.string().authStrings.resetPwd,
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
                              bottom: getSize(52),),
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
                            R.string().authStrings.setNewPassword,
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

                                if (_confirmPasswordController.text.trim() !=
                                    _newPasswordController.text.trim()) {
                                  app.resolve<CustomDialogs>().confirmDialog(
                                        context,
                                    title: R.string().authStrings.passwordNotChange,
                                    desc: R.string().errorString.enterSamePassword,
                                    positiveBtnTitle: R.string().commonString.btnTryAgain,
                                      );
                                } else {
                                  _formKey.currentState.save();
                                  NavigationUtilities.pushRoute(PasswordResetSuccessfully.route);
                                }
//                                callLoginApi(context);
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
                            text: R.string().commonString.save,
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
          hintText: R.string().authStrings.password + "*",
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
          hintText: R.string().authStrings.confirmPassword + "*",
          maxLine: 1,
          formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
          keyboardType: TextInputType.text,
          inputController: _confirmPasswordController,
          isSecureTextField: true),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string().errorString.enterPassword;
        } else if(!validateStructure(text)) {
          return R.string().errorString.wrongPassword;
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

//  Future callLoginApi(BuildContext context) async {
//    LoginReq req = LoginReq();
//    req.username = _userNameController.text;
//    req.password = _passwordController.text;
//
//    NetworkCall<LoginResp>()
//        .makeCall(
//            () => app.resolve<ServiceModule>().networkService().login(req),
//        context,
//        isProgress: true)
//        .then((loginResp) async {
//      // save Logged In user
//      if (loginResp.data != null) {
//        app.resolve<PrefUtils>().saveUser(loginResp.data.user);
//        await app.resolve<PrefUtils>().saveUserToken(
//          loginResp.data.token.jwt,
//        );
//      }
//      print("Erroer ");
//
//      SyncManager.instance
//          .callMasterSync(NavigationUtilities.key.currentContext, () async {
//        //success
//
//        NavigationUtilities.pushRoute(DiamondListScreen.route);
//      }, () {},
//          isNetworkError: false,
//          isProgress: true,
//          id: loginResp.data.user.id).then((value) {});
//    }).catchError((onError) {
//      print("Error " + onError);
//    });
//  }

}
