
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompanyInformation extends StatefulWidget {
  static const route = "CompanyInformation";

  @override
  _CompanyInformationState createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _CompanyNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _addressLineOneController = TextEditingController();
  final TextEditingController _addressLineTwoController = TextEditingController();
  final TextEditingController _addressLineThreeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _companyCodeController = TextEditingController();
  final TextEditingController _whatsAppMobileController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  Country selectedDialogCountryForMobile = CountryPickerUtils.getCountryByIsoCode("US");
  Country selectedDialogCountryForWhatsapp = CountryPickerUtils.getCountryByIsoCode("US");

  var _focusCompanyName = FocusNode();
  var _focusLastName = FocusNode();
  var _focusMiddleName = FocusNode();
  var _focusAddressLineOne = FocusNode();
  var _focusAddressLineTwo = FocusNode();
  var _focusAddressLineThree = FocusNode();
  var _focusEmail = FocusNode();
  var _focusPinCode = FocusNode();
  var _focusCountry = FocusNode();
  var _focusState = FocusNode();
  var _focusCity = FocusNode();
  var _focusBusinessType = FocusNode();
  var _focusMobile = FocusNode();
  var _focuscompanyCode = FocusNode();
  var _focusWhatsAppMobile = FocusNode();

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
          "Company Information",
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(20), vertical: getSize(30)),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getCompanyNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getBusinessTypeDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getAddressLineOneTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getAddressLineTwoTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getCountryDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getStateDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getCityDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getPinCodeTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getCompanyCodeTextField(),
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
                      text: "Save Company Details",
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

  getCompanyCodeTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focuscompanyCode,
      textOption: TextFieldOption(
        hintText: "Company Code",
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: pincode,
            imageType: IconSizeType.small,
            color: Colors.black),
        keyboardType: TextInputType.number,
        inputController: _companyCodeController,
        formatter: [
          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator(10)),
        ],
      ),
      textCallback: (text) async {
//          await checkValidation();
      },
      validation: (text) {
        if (text.isEmpty) {
          return "Please Enter Company Code.";
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
      inputAction: TextInputAction.done,
      onNextPress: () {
        _focuscompanyCode.unfocus();
      },
    );
  }

  getPinCodeTextField() {
    return CommonTextfield(
        focusNode: _focusPinCode,
        textOption: TextFieldOption(
            hintText: "ZipCode*",
            maxLine: 1,
            prefixWid: getCommonIconWidget(
                imageName: pincode,
                imageType: IconSizeType.small,
                color: Colors.black),
            formatter: [
              BlacklistingTextInputFormatter(
                  new RegExp(RegexForTextField))
            ],
            keyboardType: TextInputType.number,
            inputController: _pinCodeController,
            isSecureTextField: false),
        textCallback: (text) {
//          setState(() {
//            checkValidation();
//          });
        },
        inputAction: TextInputAction.next,
        onNextPress: () {
          _focusPinCode.unfocus();
          fieldFocusChange(context, _focuscompanyCode);
        });
  }

  getCompanyNameTextField() {
    return CommonTextfield(
      autoFocus: false,
      focusNode: _focusCompanyName,
      textOption: TextFieldOption(
        hintText: "Company Name*",
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: user,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: fromHex("#FFEFEF"),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        inputController: _CompanyNameController,
        formatter: [
          WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) { },
      validation: (text) {
        if (text.trim().isEmpty) {
          return "Please enter Company Name.";
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusCompanyName.unfocus();
        fieldFocusChange(context, _focusMiddleName);
      },
    );
  }

  getAddressLineOneTextField() {
    return CommonTextfield(
      focusNode: _focusAddressLineOne,
      textOption: TextFieldOption(
        hintText: R.string().authStrings.addressLineOne,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: company,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: fromHex("#FFEFEF"),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        inputController: _addressLineOneController,
        formatter: [
          WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) { },
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string().errorString.enterAddress;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusAddressLineOne.unfocus();
        fieldFocusChange(context, _focusAddressLineTwo);
      },
    );
  }

  getAddressLineTwoTextField() {
    return CommonTextfield(
      focusNode: _focusAddressLineTwo,
      textOption: TextFieldOption(
        hintText: R.string().authStrings.addressLineTwo,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: company,
            imageType: IconSizeType.small,
            color: Colors.black),
        fillColor: fromHex("#FFEFEF"),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        inputController: _addressLineTwoController,
        formatter: [
          WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) { },
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string().errorString.enterAddress;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusAddressLineTwo.unfocus();
        fieldFocusChange(context, _focusAddressLineThree);
      },
    );
  }

  getCountryDropDown() {
    return InkWell(
      onTap: () {
        /*   showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: DialogueList(
                    duplicateItems: countryList,
                    selectedItem: _countryController.text.trim(),
                    applyFilterCallBack: (result) {
                      if(_countryController.text != result) {
                       _stateController.text = "";
                       _cityController.text = "";
                      }
                      _countryController.text = result;
                    },
                  ));
            });*/
      },
      child: CommonTextfield(
          focusNode: _focusCountry,
          enable: false,
          textOption: TextFieldOption(
              hintText: "Select Country",
              maxLine: 1,
              prefixWid: getCommonIconWidget(
                  imageName: country, imageType: IconSizeType.small),
              type: TextFieldType.DropDown,
              keyboardType: TextInputType.text,
              inputController: _countryController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getStateDropDown() {
    return InkWell(
      onTap: () {
        /*   if (countrySelect()) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(getSize(25)),
                    ),
                    child: DialogueList(
                      duplicateItems: countryList,
                      selectedItem: _stateController.text.trim(),
                      applyFilterCallBack: (result) {
                        if(_stateController.text != result) {
                          _cityController.text = "";
                        }
                        _stateController.text = result;
                      },
                    ));
              });
        } else {
          showToast("Please Select Country First");
        }*/
      },
      child: CommonTextfield(
          focusNode: _focusState,
          enable: false,
          textOption: TextFieldOption(
              hintText: "Select State",
              maxLine: 1,
              prefixWid: getCommonIconWidget(
                  imageName: state, imageType: IconSizeType.small),
              keyboardType: TextInputType.text,
              type: TextFieldType.DropDown,
              inputController: _stateController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getCityDropDown() {
    return InkWell(
      onTap: () {
//              FocusScope.of(context).unfocus();
//              showDialog(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return Dialog(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(getSize(25)),
//                        ),
//                        child: DialogueList(
//                          selectedItem: selectedItem,
//                          duplicateItems: cityList,
//                          applyFilterCallBack: (result) {
//                            selectedItem = result;
//                            _cityController.text = result.name;
//                          },
//                        ));
//                  });
        /*    if (countrySelect()) {
          if (stateSelect()) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(getSize(25)),
                      ),
                      child: DialogueList(
                        selectedItem: _cityController.text.trim(),
                        duplicateItems: countryList,
                        applyFilterCallBack: (result) {
                          _cityController.text = result;
                        },
                      ));
                });
          } else {
            showToast("Please Select State First");
          }
        } else {
          showToast("Please Select Country First");
        }*/
      },
      child: CommonTextfield(
          focusNode: _focusCity,
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: city, imageType: IconSizeType.small),
              hintText: "Select City",
              maxLine: 1,
              keyboardType: TextInputType.text,
              type: TextFieldType.DropDown,
              inputController: _cityController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getBusinessTypeDropDown() {
    return InkWell(
      onTap: () {
//              FocusScope.of(context).unfocus();
//              showDialog(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return Dialog(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(getSize(25)),
//                        ),
//                        child: DialogueList(
//                          selectedItem: selectedItem,
//                          duplicateItems: cityList,
//                          applyFilterCallBack: (result) {
//                            selectedItem = result;
//                            _cityController.text = result.name;
//                          },
//                        ));
//                  });
        /*    if (countrySelect()) {
          if (stateSelect()) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(getSize(25)),
                      ),
                      child: DialogueList(
                        selectedItem: _cityController.text.trim(),
                        duplicateItems: countryList,
                        applyFilterCallBack: (result) {
                          _cityController.text = result;
                        },
                      ));
                });
          } else {
            showToast("Please Select State First");
          }
        } else {
          showToast("Please Select Country First");
        }*/
      },
      child: CommonTextfield(
          focusNode: _focusBusinessType,
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: city, imageType: IconSizeType.small),
              hintText: "Select Business Type",
              maxLine: 1,
              keyboardType: TextInputType.text,
              type: TextFieldType.DropDown,
              inputController: _businessTypeController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }


}
