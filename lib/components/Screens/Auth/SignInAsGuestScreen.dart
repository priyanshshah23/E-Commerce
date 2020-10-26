import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/components/widgets/shared/app_background.dart';
import 'package:diamnow/models/Auth/SignInAsGuestModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              R.string().authStrings.signInAsGuest,
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
                        padding: EdgeInsets.only(top: getSize(10)),
                        child: getLastNameTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(10)),
                        child: getEmailTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(10)),
                        child: getMobileTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getSize(10)),
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
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(
                  top: getSize(10),
                  bottom: getSize(16),
                  left: getSize(20),
                  right: getSize(20)),
              decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
              child: AppButton.flat(
                onTap: () {
                  if (termCondition == false) {
                    showTermValidation = true;
                  }
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState.validate()) {
                    if(_mobileController.text.isNotEmpty){
                      checkValidation();
                    }
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });

                  }
                },
                fitWidth: true,
                borderRadius: getSize(5),
                text: R.string().authStrings.signInAsGuest,
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
        hintText: R.string().authStrings.firstName,
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

          return R.string().errorString.enterFirstName;
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
        hintText: R.string().authStrings.lastName,
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

          return R.string().errorString.enterLastName;
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
        hintText: R.string().authStrings.emaillbl,
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
        print('test ${text.isEmpty}');
        if (text.trim().isEmpty) {
          return R.string().errorString.enterEmail;
        } else if (!validateEmail(text.trim())) {
          return R.string().errorString.enterValidEmail;
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
          hintText: R.string().authStrings.mobileNumber + "*",
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
            return R.string().errorString.enterPhone;
          }
//          else if (await isValidMobile(_mobileController.text.trim(),
//                  selectedDialogCountry.isoCode) ==
//              false) {
//            isMobilevalid = false;
//
//            return R.string().errorString.enterValidPhone;
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
      return showToast(R.string().errorString.enterValidPhone,context: context);
    } else {
      callApi(context);
    }
  }

  getCompanyTextField() {
    return CommonTextfield(
      focusNode: _focusAddress,
      textOption: TextFieldOption(
        hintText: "Company Name*",
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

          return "Please enter Company Name.";
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
                  showTermValidation = false;
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
              "Terms and Condition*",
              style: appTheme.black14TextStyle,
            )
          ],
        ),
        Visibility(
          visible: showTermValidation,
          child: Padding(
            padding: EdgeInsets.only(top: getSize(10)),
            child: Text(
              "You must agree to terms and condition to Sign In as Guest User",
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
          "Promotional offers, newsletters and stock updates",
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
            () => app.resolve<ServiceModule>().networkService().signInAsGuest(req),
        context,
        isProgress: true)
        .then((loginResp) async {
          print(loginResp.message);
      // save Logged In user
//      if (loginResp.data != null) {
//        app.resolve<PrefUtils>().saveUser(loginResp.data.user);
//        await app.resolve<PrefUtils>().saveUserToken(
//          loginResp.data.token.jwt,
//        );
//      }
//      SyncManager.instance
//          .callMasterSync(NavigationUtilities.key.currentContext, () async {
//        //success
//        AppNavigation().movetoHome(isPopAndSwitch: true);
//      }, () {},
//          isNetworkError: false,
//          isProgress: true,
//          id: loginResp.data.user.id).then((value) {});
//      callVersionUpdateApi(id: loginResp.data.user.id);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
          context,
          title: "",
          desc: onError.message,
          positiveBtnTitle: R.string().commonString.ok,
        );
      }
    });
  }

}
