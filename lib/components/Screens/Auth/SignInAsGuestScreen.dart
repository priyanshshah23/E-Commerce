import 'dart:collection';
import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/Signup.dart';
import 'package:diamnow/components/Screens/Version/VersionUpdate.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/components/widgets/shared/app_background.dart';
import 'package:diamnow/models/Auth/SignInAsGuestModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class GuestSignInScreen extends StatefulScreenWidget {
  static const route = "Guest SignIn Screen";

  @override
  _GuestSignInScreenState createState() => _GuestSignInScreenState();
}

class _GuestSignInScreenState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Country selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode("US");

  var _focusFirstName = FocusNode();
  var _focusLastName = FocusNode();
  var _focusEmail = FocusNode();
  var _focusMobile = FocusNode();
  var _focusAddress = FocusNode();

  bool isFirstnamevalid = true;
  bool isLastnamevalid = true;
  bool isCompanyValid = true;
  bool isMobilevalid = true;
  bool isEmailvalid = true;
  bool termCondition = false;
  bool showTermValidation = false;
  bool order = false;
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
            appBar: getAppBar(
              context,
              R.string.authStrings.signInAsGuest,
              bgColor: appTheme.whiteColor,
              leadingButton: getBackButton(context),
              centerTitle: false,
            ),
            body: Container(
              padding: EdgeInsets.only(
                left: getSize(20),
                right: getSize(20),
                top: getSize(10),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: getSize(50)),
                        child: getFirstNameTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(15)),
                        child: getLastNameTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(15)),
                        child: getEmailTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(15)),
                        child: getMobileTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(15)),
                        child: getCompanyTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getSize(20),
                        ),
                        child: getConditionCheckBox(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: getSize(20),
                        ),
                        child: getOrderCheckBox(),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: getSize(10),
                          bottom: getSize(16),
                        ),
                        decoration:
                            BoxDecoration(boxShadow: getBoxShadow(context)),
                        child: AppButton.flat(
                          onTap: () {
                            if (termCondition == false) {
                              showTermValidation = true;
                            }
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState.validate()) {
                              if (_mobileController.text.isNotEmpty &&
                                  termCondition) {
                                checkValidation();
                              }
                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          },
                          fitWidth: true,
                          // borderRadius: getSize(5),
                          text: R.string.authStrings.signInAsGuest,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getSize(4), bottom: getSize(20)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            R.string.commonString.lblOr.toLowerCase(),
                            style: appTheme.grey16HintTextStyle,
                          ),
                        ),
                      ),
                      Container(
                        // margin:
                        //     EdgeInsets.only(top: getSize(10), left: getSize(0)),
                        child: AppButton.flat(
                          onTap: () {
                            NavigationUtilities.pushRoute(LoginScreen.route);
                          },
                          textColor: appTheme.colorPrimary,
                          backgroundColor: appTheme.whiteColor.withOpacity(0.1),
                          // borderRadius: getSize(5),
                          fitWidth: true,
                          text: R.string.authStrings.signInCap,
                          //isButtonEnabled: enableDisableSigninButton(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
//              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(getSize(15)),
              child: InkWell(
                onTap: () {
                  NavigationUtilities.pushRoute(SignupScreen.route);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(R.string.authStrings.haveRegisterCode,
                        style: appTheme.grey16HintTextStyle),
                    Text(" " + R.string.authStrings.signUp,
                        style: appTheme.darkgray16TextStyle),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getFirstNameTextField() {
    return CommonTextfield(
      autoFocus: false,
      focusNode: _focusFirstName,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.firstName,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: user,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: isFirstnamevalid ? null : fromHex("#FFEFEF"),
        errorBorder: isFirstnamevalid
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
        inputController: _firstNameController,
        formatter: [
          WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {
        if (_autoValidate) {
          if (text.trim().isEmpty) {
            setState(() {
              isFirstnamevalid = false;
            });
          } else {
            setState(() {
              isFirstnamevalid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          isFirstnamevalid = false;

          return R.string.errorString.enterFirstName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        fieldFocusChange(context, _focusLastName);
      },
    );
  }

  getLastNameTextField() {
    return CommonTextfield(
      focusNode: _focusLastName,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.lastName,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: user,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: isLastnamevalid ? null : fromHex("#FFEFEF"),
        errorBorder: isLastnamevalid
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
        inputController: _lastNameController,
        formatter: [
          WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {
        if (_autoValidate) {
          if (text.trim().isEmpty) {
            setState(() {
              isLastnamevalid = false;
            });
          } else {
            setState(() {
              isLastnamevalid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          isLastnamevalid = false;

          return R.string.errorString.enterLastName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        fieldFocusChange(context, _focusEmail);
      },
    );
  }

  getEmailTextField() {
    return CommonTextfield(
      focusNode: _focusEmail,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.emailAddress,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: email,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: isEmailvalid ? null : fromHex("#FFEFEF"),
        errorBorder: isEmailvalid
            ? null
            : OutlineInputBorder(
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
      textCallback: (text) {
        if (_autoValidate) {
          if (text.trim().isEmpty) {
            setState(() {
              isEmailvalid = true;
            });
          } else if (!validateEmail(text.trim())) {
            setState(() {
              isEmailvalid = false;
            });
          } else {
            setState(() {
              isEmailvalid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string.errorString.enterEmail;
        } else if (!validateEmail(text.trim())) {
          return R.string.errorString.enterValidEmail;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        fieldFocusChange(context, _focusMobile);
      },
    );
  }

  getMobileTextField() {
    return Padding(
      padding: EdgeInsets.only(left: getSize(0), right: getSize(0)),
      child: CommonTextfield(
        //enable: enable,
        focusNode: _focusMobile,
        textOption: TextFieldOption(
          hintText: R.string.authStrings.mobileNumber + "*",
          prefixWid: Padding(
            padding: EdgeInsets.only(left: getSize(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getCommonIconWidget(
                    imageName: phone,
                    imageType: IconSizeType.small,
                    color: Colors.black),
                CountryPickerWidget(
                  selectedDialogCountry: selectedDialogCountry,
                  isEnabled: true,
                  onSelectCountry: (Country country) async {
                    selectedDialogCountry = country;
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: getSize(5),
                ),
              ],
            ),
          ),
          maxLine: 1,
          keyboardType: TextInputType.number,
          inputController: _mobileController,
          formatter: [
            ValidatorInputFormatter(
                editingValidator: DecimalNumberEditingRegexValidator(10)),
          ],
        ),
        textCallback: (text) async {
          if (_autoValidate) {
            if (text.isEmpty) {
              setState(() {
                isMobilevalid = false;
              });
            } else if (text.length < 7 || text.length > 15) {
              setState(() {
                isMobilevalid = false;
              });
            } else {
              setState(() {
                isMobilevalid = true;
              });
            }
          }
        },
        validation: (text) {
          if (text.isEmpty) {
            isMobilevalid = false;
            return R.string.errorString.enterPhone;
          } else if (text.length < 7 || text.length > 15) {
            isMobilevalid = false;
            return R.string.errorString.enterPhone;
          }
//          else if (await isValidMobile(_mobileController.text.trim(),
//                  selectedDialogCountry.isoCode) ==
//              false) {
//            isMobilevalid = false;
//
//            return R.string.errorString.enterValidPhone;
//          }
          else {
            return null;
          }
        },
        inputAction: TextInputAction.next,
        onNextPress: () {
          fieldFocusChange(context, _focusAddress);
        },
      ),
    );
  }

  checkValidation() async {
    if (await isValidMobile(
            _mobileController.text.trim(), selectedDialogCountry.isoCode) ==
        false) {
      return showToast(R.string.errorString.enterValidPhone, context: context);
    } else {
      callApi(context);
    }
  }

  getCompanyTextField() {
    return CommonTextfield(
      focusNode: _focusAddress,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.companyName + "*",
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: company,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: isCompanyValid ? null : fromHex("#FFEFEF"),
        errorBorder: isCompanyValid
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
        inputController: _companyController,
        formatter: [BlacklistingTextInputFormatter(new RegExp(RegexForEmoji))],
        //isSecureTextField: false
      ),
      textCallback: (text) {
        if (_autoValidate) {
          if (text.trim().isEmpty) {
            setState(() {
              isCompanyValid = false;
            });
          } else {
            setState(() {
              isCompanyValid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          isCompanyValid = false;
          return R.string.authStrings.enterCompanyName;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.done,
      onNextPress: () {
        _focusAddress.unfocus();
      },
    );
  }

  getConditionCheckBox() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  termCondition = !termCondition;
                  if (termCondition) {
                    showTermValidation = false;
                  } else {
                    showTermValidation = true;
                  }
                });
              },
              child: Image.asset(
                termCondition ? selectedCheckbox : unSelectedCheckbox,
                height: getSize(20),
                width: getSize(20),
              ),
            ),
            SizedBox(
              width: getSize(10),
            ),
            Text(
              R.string.authStrings.termsAndCondition + "*",
              style: appTheme.black14TextStyle,
            )
          ],
        ),
        Visibility(
          visible: showTermValidation,
          child: Padding(
            padding: EdgeInsets.only(top: getSize(10)),
            child: Text(
              R.string.authStrings.mustAgreeTermsAndCondition,
              style: appTheme.error16TextStyle,
            ),
          ),
        )
      ],
    );
  }

  getOrderCheckBox() {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              order = !order;
            });
          },
          child: Image.asset(
            order ? selectedCheckbox : unSelectedCheckbox,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
        SizedBox(
          width: getSize(10),
        ),
        Text(
          R.string.authStrings.promotionText,
          style: appTheme.black14TextStyle,
        )
      ],
    );
  }

  callApi(BuildContext context) async {
    SignInAsGuestReq req = SignInAsGuestReq();
    req.firstName = _firstNameController.text.trim();
    req.lastName = _lastNameController.text.trim();
    req.email = _emailController.text.trim();
    req.mobile = _mobileController.text.trim();
    req.companyName = _companyController.text.trim();

    NetworkCall<LoginResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .signInAsGuest(req),
            context,
            isProgress: true)
        .then((loginResp) async {
      if (loginResp.data != null) {
        app.resolve<PrefUtils>().saveUser(loginResp.data.user);
        await app.resolve<PrefUtils>().saveUserToken(
              loginResp.data.token.jwt,
            );
        await app.resolve<PrefUtils>().saveUserPermission(
              loginResp.data.userPermissions,
            );
      }
      // callVersionUpdateApi(id: loginResp.data.user.id);
      SyncManager().callVersionUpdateApi(
          context, VersionUpdateApi.signInAsGuest,
          id: loginResp.data.user.id);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              desc: onError.message,
              positiveBtnTitle: R.string.commonString.ok,
            );
      }
    });
  }

  // void callVersionUpdateApi({String id}) {
  //   NetworkCall<VersionUpdateResp>()
  //       .makeCall(
  //           () => app
  //               .resolve<ServiceModule>()
  //               .networkService()
  //               .getVersionUpdate(),
  //           context,
  //           isProgress: true)
  //       .then(
  //     (resp) {
  //       if (resp.data != null) {
  //         PackageInfo.fromPlatform().then(
  //           (PackageInfo packageInfo) {
  //             print(packageInfo.buildNumber);
  //             String appName = packageInfo.appName;
  //             String packageName = packageInfo.packageName;
  //             String version = packageInfo.version;
  //             String buildNumber = packageInfo.buildNumber;

  //             if (Platform.isIOS) {
  //               if (resp.data.ios != null) {
  //                 num respVersion = resp.data.ios.number;
  //                 if (num.parse(version) < respVersion) {
  //                   bool hardUpdate = resp.data.ios.isHardUpdate;
  //                   Map<String, dynamic> dict = new HashMap();
  //                   dict["isHardUpdate"] = hardUpdate;
  //                   dict["oncomplete"] = () {
  //                     Navigator.pop(context);
  //                   };
  //                   print(hardUpdate);
  //                   if (hardUpdate == true) {
  //                     NavigationUtilities.pushReplacementNamed(
  //                       VersionUpdate.route,
  //                       args: dict,
  //                     );
  //                   }
  //                 } else {
  //                   SyncManager.instance.callMasterSync(
  //                       NavigationUtilities.key.currentContext, () async {
  //                     //success
  //                     AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                   }, () {},
  //                       isNetworkError: false,
  //                       isProgress: true,
  //                       id: id).then((value) {});
  //                 }
  //               } else {
  //                 SyncManager.instance.callMasterSync(
  //                     NavigationUtilities.key.currentContext, () async {
  //                   //success
  //                   AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                 }, () {},
  //                     isNetworkError: false,
  //                     isProgress: true,
  //                     id: id).then((value) {});
  //               }
  //             } else {
  //               if (resp.data.android != null) {
  //                 num respVersion = resp.data.android.number;
  //                 if (num.parse(buildNumber) < respVersion) {
  //                   bool hardUpdate = resp.data.android.isHardUpdate;
  //                   if (hardUpdate == true) {
  //                     NavigationUtilities.pushReplacementNamed(
  //                       VersionUpdate.route,
  //                     );
  //                   }
  //                 } else {
  //                   SyncManager.instance.callMasterSync(
  //                       NavigationUtilities.key.currentContext, () async {
  //                     //success
  //                     AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                   }, () {},
  //                       isNetworkError: false,
  //                       isProgress: true,
  //                       id: id).then((value) {});
  //                 }
  //               } else {
  //                 SyncManager.instance.callMasterSync(
  //                     NavigationUtilities.key.currentContext, () async {
  //                   //success
  //                   AppNavigation.shared.movetoHome(isPopAndSwitch: true);
  //                 }, () {},
  //                     isNetworkError: false,
  //                     isProgress: true,
  //                     id: id).then((value) {});
  //               }
  //             }
  //           },
  //         );
  //       }
  //     },
  //   ).catchError(
  //     (onError) => {
  //       app.resolve<CustomDialogs>().confirmDialog(context,
  //           title: R.string.errorString.versionError,
  //           desc: onError.message,
  //           positiveBtnTitle: R.string.commonString.btnTryAgain,
  //           onClickCallback: (PositveButtonClick) {
  //         callVersionUpdateApi(id: id);
  //       }),
  //     },
  //   );
  // }
}
