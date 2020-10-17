import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Auth/ResetPassword.dart';

import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/decoration/pin_decoration.dart';
import 'package:diamnow/components/widgets/pinView_textFields/pin_widget.dart';
import 'package:diamnow/components/widgets/pinView_textFields/style/obscure.dart';
import 'package:flutter/foundation.dart';
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
  bool isApiCall = false;
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

  @override
  void initState() {
    super.initState();
    _pinEditingController.clear();
    if (kDebugMode) {
      _emailController.text = "honeyspatel98@gmail.com";
    }
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
              "Forgot Password",
              bgColor: appTheme.whiteColor,
              leadingButton: isApiCall
                  ? getBackButton(context, ontap: () {
                      isApiCall = false;
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
                              ? "The OTP has been sent to your registered Email address. Please enter the OTP."
                              : "We will send an OTP to your entered email address. Please enter the email address.",
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
                                    Text("If you didn't receive an OTP!",
                                        style: appTheme.grey16HintTextStyle),
                                    GestureDetector(
                                        onTap: () {
                                          if (isTimerCompleted) {
                                            _start = 30;
                                            startTimer();
                                            isTimerCompleted = false;
                                          }
                                        },
                                        child: Text(
                                            isTimerCompleted
                                                ? " Resend Now"
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
                                      startTimer();
                                      isApiCall = true;
                                      setState(() {});
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
            bottomNavigationBar: isApiCall
                ? SizedBox()
                : Container(
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

  getPinViewOTP() {
    return Padding(
        padding: EdgeInsets.only(
          top: getSize(50),
          bottom: getSize(50),
        ),
        child: PinInputTextFormField(
          key: _formKeyPin,
          autoFocus: true,
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
                showOTPMsg = null;
                isOtpTrue = true;
//                isOtpCheck = true;
                FocusScope.of(context).unfocus();
                NavigationUtilities.pushRoute(ResetPassword.route);
              }
              //   callApiForEditVerifyMobile(context, pin);
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
              isOtpTrue = true;
              isOtpCheck = false;
              NavigationUtilities.pushRoute(ResetPassword.route);
              showOTPMsg = null;
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
}
