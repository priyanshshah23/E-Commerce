import 'dart:async';
import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/ResetPassword.dart';

import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/decoration/pin_decoration.dart';
import 'package:diamnow/components/widgets/pinView_textFields/pin_widget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/style/obscure.dart';
import 'package:diamnow/models/Auth/ForgetPassword.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  bool isApiCall = false;
  var _focusPinTextField = FocusNode();
  // bool isButtonEnabled = false;
  bool isOtpCheck = true; // true when screen load first time for grey color
  bool isOtpTrue = false; // to manage error color and success color
  final GlobalKey<FormFieldState<String>> _formKeyPin =
      GlobalKey<FormFieldState<String>>(debugLabel: '_formkey');
  TextEditingController _pinEditingController = TextEditingController(text: '');

  String showOTPMsg = "";
  Timer _timer;
  int _start = 30;
  bool isTimerCompleted = false;

  bool autoFocus = true;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _emailController.text = "mobileuser";
    }
    _pinEditingController.clear();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            isTimerCompleted = true;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
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
              R.string().authStrings.forgotPasswordTitle,
              bgColor: appTheme.whiteColor,
              leadingButton: isApiCall
                  ? getBackButton(context, ontap: () {
                      isApiCall = false;
                      _timer.cancel();
                      setState(() {});
                    })
                  : getBackButton(context),
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
                          isApiCall
                              ? R.string().authStrings.enterOTP
                              : R.string().authStrings.sendOTPToEmail,
                          style: appTheme.black14TextStyle,
                          textAlign: TextAlign.center,
                        ),
                        isApiCall ? getPinViewOTP() : getEmailTextField(),
                        isApiCall
                            ? Container(
                                margin: EdgeInsets.all(getSize(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        R.string().authStrings.didNotReceiveOTP,
                                        style: appTheme.grey16HintTextStyle),
                                    GestureDetector(
                                        onTap: () {
                                          if (isTimerCompleted) {
                                            callForgetPasswordApi(
                                                isResend: true);
                                          }
                                        },
                                        child: Text(
                                            isTimerCompleted
                                                ? " " +
                                                    R
                                                        .string()
                                                        .authStrings
                                                        .resendNow
                                                : " ${_printDuration(Duration(seconds: _start))}",
                                            style:
                                                appTheme.darkBlue16TextStyle)),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                    top: getSize(15), left: getSize(0)),
                                decoration: BoxDecoration(
                                    boxShadow: getBoxShadow(context)),
                                child: AppButton.flat(
                                  onTap: () {
                                    // NavigationUtilities.pushRoute(TabBarDemo.route);
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      callForgetPasswordApi();
//                                callLoginApi(context);
                                    } else {
                                      setState(() {
                                        _autoValidate = true;
//                                  showOTPMsg = R
//                                      .string()
//                                      .errorString
//                                      .enteredCodeNotMatching;
                                      });
                                    }
                                    // NavigationUtilities.push(ThemeSetting());
                                  },
                                  //  backgroundColor: appTheme.buttonColor,
                                  borderRadius: getSize(5),
                                  fitWidth: true,
                                  text: R.string().authStrings.sendOTP,
                                  //isButtonEnabled: enableDisableSigninButton(),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: isApiCall
                ? SizedBox()
                : Container(
                    margin: EdgeInsets.all(getSize(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(R.string().authStrings.rememberPassword,
                            style: appTheme.grey16HintTextStyle),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                LoginScreen.route,
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(" " + R.string().authStrings.signInCap,
                                style: appTheme.darkBlue16TextStyle)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(30));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(30));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  getEmailTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: getSize(80), top: getSize(37)),
      child: CommonTextfield(
        focusNode: _focusEmail,
        textOption: TextFieldOption(
          hintText: R.string().authStrings.emailAndUname,
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
            return R.string().errorString.enterUsername;
          } /*else if (!validateEmail(text.trim())) {
            return R.string().errorString.enterValidEmail;
          }*/
          else {
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

  getPinViewOTP() {
    return Padding(
        padding: EdgeInsets.only(
          top: getSize(50),
          bottom: getSize(50),
        ),
        child: PinInputTextFormField(
          key: _formKeyPin,
          autoFocus: autoFocus,
          pinLength: 4,
          decoration: UnderlineDecoration(
            color: isOtpCheck
                ? ColorConstants.lightgrey
                : isOtpTrue
                    ? ColorConstants.otpSuccessBorderColor
                    : ColorConstants.errorText,
            gapSpace: getSize(40),
            textStyle: AppTheme.of(context).theme.textTheme.subtitle,
            errorTextStyle:
                AppTheme.of(context).theme.textTheme.display1.copyWith(
                      color: isOtpCheck
                          ? ColorConstants.lightgrey
                          : isOtpTrue
                              ? ColorConstants.otpSuccessBorderColor
                              : ColorConstants.errorText,
                    ),
            obscureStyle: ObscureStyle(
              isTextObscure: false,
            ),
            hintText: '    ',
          ),
          controller: _pinEditingController,
          textInputAction: TextInputAction.done,
          enabled: true,
          inputFormatter: [
            BlacklistingTextInputFormatter(RegExp(RegexForEmoji)),
            ValidatorInputFormatter(
                editingValidator: DecimalNumberEditingRegexValidator(4)),
          ],
          keyboardType: TextInputType.number,
          focusNode: _focusPinTextField,
          autovalidate: true,
          onSubmit: (pin) {
            setState(() {});
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              if (pin.trim().length != 4) {
                isOtpTrue = false;
                isOtpCheck = false;
                showOTPMsg = R.string().errorString.pleaseEnterOTP;
              } else if (pin.trim().length == 4) {
                FocusScope.of(context).unfocus();
                callApiForVerifyOTP();
              }
            } else {
              setState(() {
                isOtpCheck = false;
                isOtpTrue = false;
              });
            }
          },
          onChanged: (pin) {
            if (pin.trim().length < 4) {
              showOTPMsg = null;
              isOtpTrue = false;
            } else if (pin.trim().length == 4) {
              callApiForVerifyOTP();
            }
            setState(() {});
          },
          validator: (text) {
            return showOTPMsg ?? "";
          },
        )
        /*
      child: PinEntryTextField(
        enable: true,
        errorBorder: isOtpCheck
            ? isOtpTrue
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    borderSide: BorderSide(width: 1, color: Colors.green))
                : null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
        fillColor: isOtpCheck ? null : fromHex("#FFEFEF"),

        fontSize: getFontSize(30),
        fieldWidth: (MathUtilities.screenWidth(context) - 52) / 5,
        onSubmit: (String pin) {
          if (pin.length == 4) {
            setState(() {
              strOtp = pin;
            });
            callApiForVerifyMobile(context);

            */ /*Map<String, dynamic> dict = new HashMap();
            dict["otp"] = strOtp;
            NavigationUtilities.pushRoute(PasswordScreen.route,
                type: RouteType.fade, args: dict);*/ /*
          } else {
            setState(() {});
          }
        }, // end onSubmit
      ),*/
        );
  }

  callForgetPasswordApi({bool isResend = false}) async {
    ForgotPasswordReq req = ForgotPasswordReq();
    req.value = _emailController.text;

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .forgetPassword(req),
            context,
            isProgress: true)
        .then((resp) async {
      FocusScope.of(context).unfocus();
      if (isResend) {
        if (isTimerCompleted) {
          _start = 30;
          isTimerCompleted = false;
          autoFocus = false;
        }
      }
      isTimerCompleted = false;
      isApiCall = true;
      _start = 30;
      startTimer();
      setState(() {});
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
          );
    });
  }

  callApiForVerifyOTP() async {
    VerifyOTPReq req = VerifyOTPReq();
    req.email = _emailController.text;
    req.otpNumber = _pinEditingController.text.trim();

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().verifyOTP(req),
            context,
            isProgress: true)
        .then((resp) async {
      FocusScope.of(context).unfocus();
      isOtpTrue = true;
      isOtpCheck = false;
      showOTPMsg = null;
      Map<String, dynamic> dict = new HashMap();
      dict["value"] = _emailController.text;
      dict["otpNumber"] = _pinEditingController.text.trim();
      NavigationUtilities.pushRoute(ResetPassword.route, args: dict);
    }).catchError((onError) {
      isOtpTrue = false;
      isOtpCheck = false;
      setState(() {});
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
          );
    });
  }
}
