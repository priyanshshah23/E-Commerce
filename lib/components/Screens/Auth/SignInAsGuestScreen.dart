import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/widgets/shared/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuestSignInScreen extends StatefulWidget {
  @override
  _GuestSignInScreenState createState() => _GuestSignInScreenState();
}

class _GuestSignInScreenState extends State<GuestSignInScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _focusFirstName = FocusNode();
  var _focusLastName = FocusNode();
  var _focusEmail = FocusNode();
  var _focusMobile = FocusNode();
  var _focusAddress = FocusNode();
  var _focusPostalCode = FocusNode();
  var _focusPassword = FocusNode();

  bool isButtonEnabled = false;
  bool isFirstnamevalid = true;
  bool isLastnamevalid = true;
  bool isAddressvalid = true;
  bool isMobilevalid = true;
  bool isEmailvalid = true;
  bool isPostalCodevalid = true;
  bool isPasswordvalid = true;

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
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: getSize(26),
                      right: getSize(26),
                      top: getSize(10),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: getSize(10)),
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
                              padding: EdgeInsets.only(
                                  top: getSize(10), bottom: getSize(5)),
                              child: getPasswordTextField(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(
                  top: getSize(10),
                  bottom: getSize(16),
                  left: getSize(20),
                  right: getSize(20)),
              child: AppButton.flat(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                backgroundColor: AppTheme.of(context).theme.accentColor,
                borderRadius: 14,
                fitWidth: true,
                text: R.string().commonString.btnNextCap,
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
          isEmailvalid = true;
          if (_mobileController.text.isEmpty) {
            isEmailvalid = false;
            return R.string().errorString.enterValidEmail;
          }
        } else if (!validateEmail(text.trim())) {
          isEmailvalid = false;
          return R.string().errorString.enterValidEmail;
        } else {
          return null;
        }

        return null;

        // }
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
            padding: EdgeInsets.only(left: getSize(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: getSize(23),
                  child: Image.asset(
                    india,
                  ),
                ),
                SizedBox(
                  width: getSize(5),
                ),
                SizedBox(
                  width: getSize(15),
                ),
              ],
            ),
          ),
          maxLine: 1,
          fillColor: isMobilevalid ? null : fromHex("#FFEFEF"),
          errorBorder: isMobilevalid
              ? null
              : OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(11)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          keyboardType: TextInputType.number,
          inputController: _mobileController,
          formatter: [
            ValidatorInputFormatter(
                editingValidator: DecimalNumberEditingRegexValidator(10)),
          ],
        ),
        textCallback: (text) {
          if (_autoValidate) {
            if (text.isEmpty) {
              setState(() {
                isMobilevalid = false;
              });
            } else if (!validateMobile(text)) {
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
          //String validateName(String value) {
          if (text.isEmpty) {
//            isMobilevalid = true;
//            if(_emailController.text.isNotEmpty)
//            {
//              isMobilevalid = false;
//              return R.string().errorString.enterPhone;
//
//            }
            isMobilevalid = false;
            return R.string().errorString.enterPhone;
          } else if (!validateMobile(text)) {
            isMobilevalid = false;

            return R.string().errorString.enterValidPhone;
          } else {
            return null;
          }

          // }
        },
        inputAction: TextInputAction.next,
        onNextPress: () {
          fieldFocusChange(context, _focusAddress);
        },
      ),
    );
  }

  getCompanyTextField() {
    return CommonTextfield(
      focusNode: _focusAddress,
      textOption: TextFieldOption(
        hintText: R.string().authStrings.address,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: company,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: isAddressvalid ? null : fromHex("#FFEFEF"),
        errorBorder: isAddressvalid
            ? null
            : OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        inputController: _addressController,
        formatter: [BlacklistingTextInputFormatter(new RegExp(RegexForEmoji))],
        //isSecureTextField: false
      ),
      textCallback: (text) {
        if (_autoValidate) {
          if (text.trim().isEmpty) {
            setState(() {
              isAddressvalid = false;
            });
          } else if (text.trim().length < 10) {
            setState(() {
              isAddressvalid = false;
            });
          } else {
            setState(() {
              isAddressvalid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          isAddressvalid = false;

          return R.string().errorString.enterAddress;
        } else if (text.trim().length < 10) {
          isAddressvalid = false;

          return R.string().errorString.enterValidAddress;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        fieldFocusChange(context, _focusPostalCode);
      },
    );
  }

  getPasswordTextField() {
    return CommonTextfield(
      focusNode: _focusPassword,
      textOption: TextFieldOption(
        hintText: R.string().authStrings.password + "*",
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: password,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: isPasswordvalid ? null : fromHex("#FFEFEF"),
        errorBorder: isPasswordvalid
            ? null
            : OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        isSecureTextField: true,
        inputController: _passwordController,
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
              isPasswordvalid = false;
            });
          } else if (text.trim().length < 6) {
            setState(() {
              isPasswordvalid = false;
            });
          } else {
            setState(() {
              isPasswordvalid = true;
            });
          }
        }
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          isPasswordvalid = false;

          return R.string().errorString.enterPassword;
        } else if (text.trim().length < 6) {
          isPasswordvalid = false;

          return R.string().errorString.enterValidPassword;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.done,
      onNextPress: () {
        _focusPostalCode.unfocus();
      },
    );
  }
}
