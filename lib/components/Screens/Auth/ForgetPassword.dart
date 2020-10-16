import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';

import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPasswordScreen extends StatefulScreenWidget {
  static const route = "ForgetPasswordScreen";

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  var _focusEmail = FocusNode();
  bool isButtonEnabled = true;
  bool _autoValidate = false;

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
              "Forgot Password",
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
                              top: getSize(12)),
                          child: Image.asset(
                            forgetPassword,
                            height: getSize(200),
                            width: getSize(200),
                          ),
                        ),
                        Text(
                          "The OTP has been sent to your registered Email address. Please enter the OTP.",
                          style: appTheme.black14TextStyle,
                          textAlign: TextAlign.center,
                        ),
                        getEmailTextField(),
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
                            text: "Send OTP",
                            //isButtonEnabled: enableDisableSigninButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(getSize(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Remember Password?",
                      style: appTheme.grey16HintTextStyle),
                  Text(" Sign In", style: appTheme.darkBlue16TextStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getEmailTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: getSize(80), top: getSize(37)),
      child: CommonTextfield(
        focusNode: _focusEmail,
        textOption: TextFieldOption(
          hintText: R.string().authStrings.emaillbl,
          maxLine: 1,
          prefixWid: getCommonIconWidget(
              imageName: email,
              imageType: IconSizeType.small,
              color: Colors.black),
          fillColor: fromHex("#FFEFEF"),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(11)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          keyboardType: TextInputType.emailAddress,
          inputController: _emailController,
          formatter: [
            BlacklistingTextInputFormatter(new RegExp(spaceRegEx)),
            BlacklistingTextInputFormatter(new RegExp(RegexForEmoji))
          ],
          //isSecureTextField: false
        ),
        textCallback: (text) {},
        validation: (text) {
          if (text.trim().isEmpty) {
            return R.string().errorString.enterEmail;
          } else if (!validateEmail(text.trim())) {
            return R.string().errorString.enterValidEmail;
          } else {
            return null;
          }
        },
        inputAction: TextInputAction.done,
        onNextPress: () {
          _focusEmail.unfocus();
        },
      ),
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
