import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/network/Uploadmanager.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/Auth/Documents.dart';
import 'package:diamnow/components/Screens/Auth/PersonalInformation.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Auth/PersonalInformationModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileList extends StatefulWidget {
  static const route = "ProfileList";
  bool isFromDrawer;

  ProfileList(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _ProfileListState createState() =>
      _ProfileListState(isFromDrawer: isFromDrawer);
}

class _ProfileListState extends State<ProfileList> {
  bool isFromDrawer = false;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool readOnly = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _skypeController = TextEditingController();
  final TextEditingController _whatsAppMobileController =
      TextEditingController();
  final TextEditingController _CompanyNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _addressLineOneController =
      TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _natureOfOrgController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController _companyMobileController =
      TextEditingController();
  final TextEditingController _faxNumberController = TextEditingController();

  var _focusFirstName = FocusNode();
  var _focusMiddleName = FocusNode();
  var _focusLastName = FocusNode();
  var _focusEmail = FocusNode();
  var _focusMobile = FocusNode();
  var _focusWhatsAppMobile = FocusNode();
  var _focusSkypeNumber = FocusNode();
  var _focusCompanyName = FocusNode();
  var _focusDesignation = FocusNode();
  var _focusAddressLineOne = FocusNode();
  var _focusBusinessType = FocusNode();
  var _focusNatureOfOrg = FocusNode();
  var _focusCountry = FocusNode();
  var _focusState = FocusNode();
  var _focusCity = FocusNode();
  var _focusPinCode = FocusNode();
  var _focusCompanyMobile = FocusNode();
  var _focusFaxNumber = FocusNode();

  Country selectedDialogCountryForMobile =
      CountryPickerUtils.getCountryByIsoCode("US");
  Country selectedDialogCountryForWhatsapp =
      CountryPickerUtils.getCountryByIsoCode("US");
  Country selectedDialogCountryForCompanyMobile =
      CountryPickerUtils.getCountryByIsoCode("US");

  List<SelectionPopupModel> businessTypeList = List<SelectionPopupModel>();
  List<SelectionPopupModel> natureOfOrgList = List<SelectionPopupModel>();
  List<SelectionPopupModel> cityList = List<SelectionPopupModel>();
  List<SelectionPopupModel> countryList = List<SelectionPopupModel>();
  List<SelectionPopupModel> stateList = List<SelectionPopupModel>();
  PersonalInformationViewResp userAccount;

  var selectedCityItem = -1;
  var selectedCountryItem = -1;
  var selectedStateItem = -1;
  var selectedBusinessItem = -1;
  var selectedNatureOfOrg = -1;

  bool isProfileImageUpload = false;
  File profileImage;
  String image;

  _ProfileListState({this.isFromDrawer});

  @override
  void initState() {
    super.initState();
    // _callApiForCountryList();
    getPersonalInformation();
    //  getMasters();
  }

  getPersonalInformation() async {
    NetworkCall<PersonalInformationViewResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .personalInformationView(),
            context,
            isProgress: true)
        .then((resp) async {
      _firstNameController.text = resp.data.firstName;
      _middleNameController.text = resp.data.middleName;
      _lastNameController.text = resp.data.lastName;
      _emailController.text = resp.data.email;
      _CompanyNameController.text = resp.data.companyName;
      _designationController.text = resp.data.designation;
      _businessTypeController.text = resp.data.businessType;
      pinCodeController.text = resp.data.zipcode;
      _skypeController.text = resp.data.skype;
      _companyMobileController.text = resp.data.mobile;
      _faxNumberController.text = resp.data.fax;
      // _natureOfOrgController.text = resp.data.
      //  _middleNameController.text = resp.data.middleName;
      _addressLineOneController.text = resp.data.address;
      _mobileController.text = resp.data.mobile;
      selectedDialogCountryForMobile =
          CountryPickerUtils.getCountryByPhoneCode(resp.data.countryCode);
      _whatsAppMobileController.text = resp.data.whatsapp;
      if (!isNullEmptyOrFalse(resp.data.whatsappCounCode)) {
        selectedDialogCountryForWhatsapp =
            CountryPickerUtils.getCountryByPhoneCode(
                resp.data.whatsappCounCode);
      }

      _emailController.text = resp.data.email;
      image = resp.data.profileImage;
      _countryController.text = resp.data.country;
      _stateController.text = resp.data.state;
      _cityController.text = resp.data.city;
      //  companyInformationState.pinCodeController.text = resp.data.zipcode;
      //  _skypeController.text = resp.data.skype;
      setState(() {});
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(context, R.string.commonString.profile,
          bgColor: appTheme.whiteColor,
          leadingButton: isFromDrawer
              ? getDrawerButton(context, true)
              : getBackButton(context),
          centerTitle: false,
          actionItems: [
            readOnly
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          readOnly = !readOnly;
                          setState(() {});
                        },
                        child: Text(
                          "Edit",
                          style: appTheme.black16MediumTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: getSize(20),
                      ),
                    ],
                  )
                : SizedBox(),
          ]),
      bottomNavigationBar: !readOnly
          ? Padding(
              padding: EdgeInsets.only(
                top: getSize(10),
                bottom: getSize(16),
                right: getSize(20),
                left: getSize(20),
              ),
              child: Container(
                child: AppButton.flat(
                  onTap: () async {
                    readOnly = !readOnly;
                    if (readOnly) {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (_mobileController.text.isNotEmpty) {
                          if (await checkValidation()) {
                            if (isProfileImageUpload) {
                              await uploadDocument();
                            } else {
                              callPersonalInformationApi();
                            }
                          } else {
                            showToast("Please add valid phone number.",
                                context: context);
                          }
                        }
                      } else {
                        setState(() {
                          _autoValidate = true;
                          readOnly = false;
                        });
                      }
                    }
                    setState(() {});
                    // NavigationUtilities.push(ThemeSetting());
                  },
                  backgroundColor: appTheme.colorPrimary,
                  textColor: appTheme.whiteColor,
                  //borderRadius: getSize(5),
                  fitWidth: true,
                  text: R.string.commonString.save,
                  //isButtonEnabled: enableDisableSigninButton(),
                ),
              ),
            )
          : SizedBox(),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getSize(16),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getSize(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: getSize(20),
                    ),
                    child: Text(
                      "Personal Information",
                      style: appTheme.black16MediumTextStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
//                          if (!readOnly) {
//                            FocusScope.of(context).unfocus();
//                            openImagePickerDocuments((img) {
//                              setState(() {
//                                isProfileImageUpload = true;
//                                profileImage = img;
//                              });
//                            });
//                          }
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  getSize(60),
                                ),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        getSize(60),
                                      ),
                                    ),
                                    child: isProfileImageUpload
                                        ? Image.file(
                                            profileImage,
                                            width: getSize(120),
                                            height: getSize(120),
                                            fit: BoxFit.cover,
                                          )
                                        : getImageView(
                                            image ?? "",
                                            width: getSize(120),
                                            height: getSize(120),
                                            placeHolderImage: placeHolder,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Container(
                                    color: isProfileImageUpload || image != ""
                                        ? Colors.transparent
                                        : appTheme.colorPrimary
                                            .withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (!readOnly) {
                                  FocusScope.of(context).unfocus();
                                  openImagePickerDocuments((img) async {
                                    setState(() {
                                      isProfileImageUpload = true;
                                      profileImage = img;
                                    });
                                    await uploadDocument();
                                  });
                                }
                              },
                              child: Image.asset(
                                editProfile,
                                height: getSize(33),
                                width: getSize(27),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getSize(30),
                  ),
                  getFirstNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getMiddleNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getLastNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getEmailTextField(),
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
                  getWhatsAppTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getMobileTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getSkypeTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  // getCompanyNameTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getDesignationDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: getSize(20),
                    ),
                    child: Text(
                      "Business Information",
                      style: appTheme.black16MediumTextStyle,
                    ),
                  ),
                  getCompanyNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getDesignationDropDown(),
                  SizedBox(
                    height: getSize(30),
                  ),
                  getBusinessTypeDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  // getNatureOfOrgDropDown(),
                  // SizedBox(
                  //   height: getSize(20),
                  // ),
                  getAddressLineOneTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getCompanyMobileTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getFaxNumberTextField(),
                  SizedBox(
                    height: getSize(30),
                  ),
                  getPhotoIdentityProofView(),
                  SizedBox(
                    height: getSize(30),
                  ),
                  getBusinessIdentityProofView(),
                  SizedBox(
                    height: getSize(20),
                  ),
                ],
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
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.firstName,
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
        inputController: _firstNameController,
        formatter: [
          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {
        // _firstNameController.text = _firstNameController.text.trim();
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string.errorString.enterFirstName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusFirstName.unfocus();
        fieldFocusChange(context, _focusMiddleName);
      },
    );
  }

  getMiddleNameTextField() {
    return CommonTextfield(
      autoFocus: false,
      focusNode: _focusMiddleName,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.middleName,
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
        inputController: _middleNameController,
        formatter: [
          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {
        // _firstNameController.text = _firstNameController.text.trim();
      },
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string.errorString.enterMiddleName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusFirstName.unfocus();
        fieldFocusChange(context, _focusMiddleName);
      },
    );
  }

  getLastNameTextField() {
    return CommonTextfield(
      focusNode: _focusLastName,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.lastName,
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
        inputController: _lastNameController,
        formatter: [
          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {},
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string.errorString.enterLastName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusLastName.unfocus();
        fieldFocusChange(context, _focusEmail);
      },
    );
  }

  getEmailTextField() {
    return CommonTextfield(
      focusNode: _focusEmail,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.emailAddress,
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
          // BlacklistingTextInputFormatter(new RegExp(spaceRegEx)),
          BlacklistingTextInputFormatter(new RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {},
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
        _focusEmail.unfocus();
        fieldFocusChange(context, _focusMobile);
      },
    );
  }

  getMobileTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focusMobile,
      readOnly: this.readOnly ? true : false,
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
                selectedDialogCountry: selectedDialogCountryForMobile,
                isEnabled: !this.readOnly,
                onSelectCountry: (Country country) async {
                  selectedDialogCountryForMobile = country;
                  // await checkValidation();
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
//          await checkValidation();
      },
      validation: (text) {
        if (text.isEmpty) {
          return R.string.errorString.enterPhone;
        } else if (!validateMobile(text)) {
          return R.string.errorString.enterValidPhone;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusMobile.unfocus();
        fieldFocusChange(context, _focusWhatsAppMobile);
      },
    );
  }

  getWhatsAppTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focusWhatsAppMobile,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.whatsApp,
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
                selectedDialogCountry: selectedDialogCountryForWhatsapp,
                isEnabled: !this.readOnly,
                onSelectCountry: (Country country) async {
                  selectedDialogCountryForWhatsapp = country;
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
        inputController: _whatsAppMobileController,
        formatter: [
          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator(10)),
        ],
      ),
      textCallback: (text) async {
//            await checkValidation();
      },
      validation: (text) {
        if (text.isEmpty) {
          return R.string.errorString.enterTelePhone;
        } else if (!validateMobile(text)) {
          return R.string.errorString.enterValidTelePhone;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusWhatsAppMobile.unfocus();
        fieldFocusChange(context, _focusCompanyName);
      },
    );
  }

  getSkypeTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focusSkypeNumber,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.skype + "*",
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
                selectedDialogCountry: selectedDialogCountryForMobile,
                isEnabled: !this.readOnly,
                onSelectCountry: (Country country) async {
                  selectedDialogCountryForMobile = country;
                  // await checkValidation();
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
        inputController: _skypeController,
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
          return R.string.errorString.enterPhone;
        } else if (!validateMobile(text)) {
          return R.string.errorString.enterValidPhone;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusMobile.unfocus();
        fieldFocusChange(context, _focusWhatsAppMobile);
      },
    );
  }

  getCompanyNameTextField() {
    return CommonTextfield(
      autoFocus: false,
      focusNode: _focusCompanyName,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.companyName + "*",
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
          // WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {},
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string.authStrings.enterCompanyName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusCompanyName.unfocus();
        fieldFocusChange(context, _focusAddressLineOne);
      },
    );
  }

  getDesignationDropDown() {
    return InkWell(
      onTap: () {
//        if (!readOnly) {
//          if (arrPhotos == null || arrPhotos.length == 0) {
//            getMasters();
//          } else {
//            showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return Dialog(
//                  insetPadding: EdgeInsets.symmetric(
//                      horizontal: getSize(20), vertical: getSize(20)),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(getSize(25)),
//                  ),
//                  child: SelectionDialogue(
//                    title: "Document Type",
//                    selectionOptions: arrPhotos,
//                    isMultiSelectionEnable: false,
//                    isSearchEnable: false,
//                    applyFilterCallBack: (
//                        {SelectionPopupModel selectedItem,
//                          List<SelectionPopupModel> multiSelectedItem}) {
//                      arrPhotos.forEach((element) {
//                        if (element == selectedItem) {
//                          selectedDocument = arrPhotos.indexOf(element);
//                          _documentController.text = element.title;
//                        }
//                      });
//                    },
//                  ),
//                );
//              },
//            );
//          }
//        }
      },
      child: CommonTextfield(
          focusNode: _focusDesignation,
          readOnly: this.readOnly ? true : false,
          enable: false,
          textOption: TextFieldOption(
              hintText: R.string.authStrings.designation + "*",
              maxLine: 1,
              prefixWid: getCommonIconWidget(
                  imageName: documentPlaceHolder,
                  imageType: IconSizeType.small),
              type: TextFieldType.DropDown,
              keyboardType: TextInputType.text,
              inputController: _designationController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          validation: (text) {
//            if (text.trim().isEmpty) {
//              return R.string.errorString.enterDesignation;
//            } else {
//              return null;
//            }
          },
          inputAction: TextInputAction.done,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getBusinessTypeDropDown() {
    return InkWell(
      onTap: () {
        if (!readOnly) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    insetPadding: EdgeInsets.symmetric(
                        horizontal: getSize(20), vertical: getSize(20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(getSize(25)),
                    ),
                    child: SelectionDialogue(
                        title: R.string.commonString.selectBusinessType,
                        hintText: R.string.commonString.searchBusinessType,
                        selectionOptions: businessTypeList,
                        applyFilterCallBack: (
                            {SelectionPopupModel selectedItem,
                            List<SelectionPopupModel> multiSelectedItem}) {
                          businessTypeList
                              .forEach((value) => value.isSelected = false);
                          businessTypeList
                              .firstWhere((value) => value == selectedItem)
                              .isSelected = true;
                          selectedBusinessItem =
                              businessTypeList.indexOf(selectedItem);
                          _businessTypeController.text = selectedItem.title;
                        }));
              });
        }
      },
      child: CommonTextfield(
          focusNode: _focusBusinessType,
          readOnly: this.readOnly ? true : false,
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: city, imageType: IconSizeType.small),
              hintText: R.string.commonString.selectBusinessType,
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
          validation: (text) {
            if (text.trim().isEmpty) {
              return R.string.errorString.enterBusinessType;
            } else {
              return null;
            }
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getNatureOfOrgDropDown() {
    return InkWell(
      onTap: () {
        if (!readOnly) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    insetPadding: EdgeInsets.symmetric(
                        horizontal: getSize(20), vertical: getSize(20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(getSize(25)),
                    ),
                    child: SelectionDialogue(
                        title: R.string.authStrings.selectNatureOfOrganization,
                        hintText:
                            R.string.authStrings.selectNatureOfOrganization,
                        selectionOptions: natureOfOrgList,
                        applyFilterCallBack: (
                            {SelectionPopupModel selectedItem,
                            List<SelectionPopupModel> multiSelectedItem}) {
                          natureOfOrgList
                              .forEach((value) => value.isSelected = false);
                          natureOfOrgList
                              .firstWhere((value) => value == selectedItem)
                              .isSelected = true;
                          selectedNatureOfOrg =
                              natureOfOrgList.indexOf(selectedItem);
                          _natureOfOrgController.text = selectedItem.title;
                        }));
              });
        }
      },
      child: CommonTextfield(
          focusNode: _focusNatureOfOrg,
          readOnly: this.readOnly ? true : false,
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: city, imageType: IconSizeType.small),
              hintText: R.string.authStrings.selectNatureOfOrganization,
              maxLine: 1,
              keyboardType: TextInputType.text,
              type: TextFieldType.DropDown,
              inputController: _natureOfOrgController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          validation: (text) {
            if (text.trim().isEmpty) {
              return R.string.errorString.selectNatureOfOrganization;
            } else {
              return null;
            }
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getAddressLineOneTextField() {
    return CommonTextfield(
      focusNode: _focusAddressLineOne,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.addressLineOne,
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
          //  WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {},
      validation: (text) {
        if (text.trim().isEmpty) {
          return R.string.errorString.enterAddress;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusAddressLineOne.unfocus();
        fieldFocusChange(context, _focusPinCode);
      },
    );
  }

  void _callApiForCountryList({bool isShowDialogue = false}) {
    NetworkCall<CountryListResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().countryList(),
            context,
            isProgress: true)
        .then((resp) {
      countryList.clear();
      for (var item in resp.data) {
        if (userAccount != null && userAccount.data.account.country != null) {
          countryList.add(SelectionPopupModel(item.id, item.name,
              isSelected: (userAccount.data.account.country.id == item.id)
                  ? true
                  : false));
        } else {
          countryList
              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
        }
      }
      ;
      getPersonalInformation();
      if (isShowDialogue) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: getSize(20), vertical: getSize(20)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: SelectionDialogue(
                    title: R.string.commonString.selectCountry,
                    hintText: R.string.commonString.searchCountry,
                    selectionOptions: countryList,
                    applyFilterCallBack: (
                        {SelectionPopupModel selectedItem,
                        List<SelectionPopupModel> multiSelectedItem}) {
                      if (_countryController.text != selectedItem.title) {
                        _stateController.text = "";
                        _cityController.text = "";
                        this.cityList.clear();
                        this.stateList.clear();
                      }
                      countryList.forEach((value) => value.isSelected = false);
                      countryList
                          .firstWhere((value) => value == selectedItem)
                          .isSelected = true;
                      selectedCountryItem = countryList.indexOf(selectedItem);
                      _countryController.text = selectedItem.title;
                      _callApiForStateList(countryId: selectedItem.id);
                    },
                  ));
            });
      }
    }).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(
          context,
          desc: onError.message,
          positiveBtnTitle: R.string.commonString.btnTryAgain,
          onClickCallback: (buttonType) {
            _callApiForCountryList();
          },
        )
      },
    );
  }

  void _callApiForStateList({
    String countryId,
    bool isShowDialogue = false,
  }) {
    StateListReq req = StateListReq();
    req.country = countryId;

    NetworkCall<StateListResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().stateList(req),
            context,
            isProgress: true)
        .then((resp) {
      stateList.clear();
      for (var item in resp.data) {
        if (userAccount.data.account.state != null) {
          stateList.add(SelectionPopupModel(item.id, item.name,
              isSelected: (userAccount.data.account.state.id == item.id)
                  ? true
                  : false));
        } else {
          stateList
              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
        }
      }
      ;
      if (isShowDialogue) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: getSize(20), vertical: getSize(20)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: SelectionDialogue(
                    title: R.string.commonString.selectState,
                    hintText: R.string.commonString.searchState,
                    selectionOptions: stateList,
                    applyFilterCallBack: (
                        {SelectionPopupModel selectedItem,
                        List<SelectionPopupModel> multiSelectedItem}) {
                      if (_stateController.text != selectedItem.title) {
                        _cityController.text = "";
                        this.cityList.clear();
                      }
                      stateList.forEach((value) => value.isSelected = false);
                      stateList
                          .firstWhere((value) => value == selectedItem)
                          .isSelected = true;
                      selectedStateItem = stateList.indexOf(selectedItem);
                      _stateController.text = selectedItem.title;
                      _callApiForCityList(
                          countryId: countryList[selectedCountryItem].id,
                          stateId: selectedItem.id);
                    },
                  ));
            });
      }
    }).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(context,
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
            onClickCallback: (PositveButtonClick) {
          _callApiForStateList(countryId: countryId);
        })
      },
    );
  }

  void _callApiForCityList({
    String stateId,
    String countryId,
    bool isShowDialogue = false,
  }) {
    CityListReq req = CityListReq();
    req.state = stateId;
    req.country = countryId;

    NetworkCall<CityListResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().cityList(req),
            context,
            isProgress: true)
        .then((resp) {
      cityList.clear();
      for (var item in resp.data) {
        if (userAccount.data.account.city != null) {
          cityList.add(SelectionPopupModel(item.id, item.name,
              isSelected: (userAccount.data.account.city.id == item.id)
                  ? true
                  : false));
        } else {
          cityList
              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
        }
      }
      ;
      if (isShowDialogue) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: getSize(20), vertical: getSize(20)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: SelectionDialogue(
                    title: R.string.commonString.selectCity,
                    hintText: R.string.commonString.searchCity,
                    selectionOptions: cityList,
                    applyFilterCallBack: (
                        {SelectionPopupModel selectedItem,
                        List<SelectionPopupModel> multiSelectedItem}) {
                      cityList.forEach((value) => value.isSelected = false);
                      cityList
                          .firstWhere((value) => value == selectedItem)
                          .isSelected = true;
                      selectedCityItem = cityList.indexOf(selectedItem);
                      _cityController.text = selectedItem.title;
                    },
                  ));
            });
      }
    }).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(context,
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
            onClickCallback: (PositveButtonClick) {
          _callApiForCityList(stateId: stateId, countryId: countryId);
        })
      },
    );
  }

  // getPersonalInformation() async {
  //   NetworkCall<PersonalInformationViewResp>()
  //       .makeCall(
  //           () => app
  //               .resolve<ServiceModule>()
  //               .networkService()
  //               .personalInformationView(),
  //           context,
  //           isProgress: true)
  //       .then((resp) async {
  //     userAccount = resp;
  //     _firstNameController.text = resp.data.firstName;
  //     _lastNameController.text = resp.data.lastName;
  //     // _middleNameController.text = resp.data.middleName;
  //     _addressLineOneController.text = resp.data.address;
  //     _mobileController.text = resp.data.mobile;
  //     selectedDialogCountryForMobile =
  //         CountryPickerUtils.getCountryByPhoneCode(resp.data.countryCode);
  //     _whatsAppMobileController.text = resp.data.whatsapp;
  //     if (!isNullEmptyOrFalse(resp.data.whatsappCounCode)) {
  //       selectedDialogCountryForWhatsapp =
  //           CountryPickerUtils.getCountryByPhoneCode(
  //               resp.data.whatsappCounCode);
  //     }

  //     _emailController.text = resp.data.email;
  //     image = resp.data.profileImage;
  //     _countryController.text = resp.data.country;
  //     _stateController.text = resp.data.state;
  //     _cityController.text = resp.data.city;
  //     // companyInformationState.pinCodeController.text = resp.data.zipcode;
  //     // _skypeController.text = resp.data.skype;
  //     setState(() {});
  //   }).catchError((onError) {
  //     app.resolve<CustomDialogs>().confirmDialog(
  //           context,
  //           desc: onError.message,
  //           positiveBtnTitle: R.string.commonString.btnTryAgain,
  //         );
  //   });
  // }

  getCountryDropDown() {
    return InkWell(
      onTap: () {
        if (!readOnly) {
          if (countryList == null || countryList.length == 0) {
            _callApiForCountryList(isShowDialogue: true);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: getSize(20), vertical: getSize(20)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: SelectionDialogue(
                    title: R.string.commonString.selectCountry,
                    hintText: R.string.commonString.searchCountry,
                    selectionOptions: countryList,
                    applyFilterCallBack: (
                        {SelectionPopupModel selectedItem,
                        List<SelectionPopupModel> multiSelectedItem}) {
                      if (_countryController.text.toLowerCase() !=
                          selectedItem.title.toLowerCase()) {
                        _stateController.text = "";
                        _cityController.text = "";
                        this.cityList.clear();
                        this.stateList.clear();
                        cityList.forEach((element) {
                          element.isSelected = false;
                        });
                        stateList.forEach((element) {
                          element.isSelected = false;
                        });
                        selectedCityItem = -1;
                        selectedStateItem = -1;
                      }
                      countryList.forEach((value) => value.isSelected = false);
                      countryList
                          .firstWhere((value) => value == selectedItem)
                          .isSelected = true;
                      selectedCountryItem = countryList.indexOf(selectedItem);
                      _countryController.text = selectedItem.title;
                      _callApiForStateList(countryId: selectedItem.id);
                    },
                  ),
                );
              },
            );
          }
        }
      },
      child: CommonTextfield(
          focusNode: _focusCountry,
          readOnly: this.readOnly ? true : false,
          enable: false,
          textOption: TextFieldOption(
              hintText: R.string.commonString.lblCountry + "*",
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
          validation: (text) {
            if (text.trim().isEmpty) {
              return R.string.errorString.selectCountry;
            } else {
              return null;
            }
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
        if (!readOnly) {
          if (countrySelect()) {
            if (stateList == null || stateList.length == 0) {
              _callApiForStateList(
                  countryId: countryList[selectedCountryItem].id,
                  isShowDialogue: true);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        insetPadding: EdgeInsets.symmetric(
                            horizontal: getSize(20), vertical: getSize(20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getSize(25)),
                        ),
                        child: SelectionDialogue(
                          title: R.string.commonString.selectState,
                          hintText: R.string.commonString.searchState,
                          selectionOptions: stateList,
                          applyFilterCallBack: (
                              {SelectionPopupModel selectedItem,
                              List<SelectionPopupModel> multiSelectedItem}) {
                            if (_stateController.text != selectedItem.title) {
                              _cityController.text = "";
                              this.cityList.clear();
                              selectedCityItem = -1;
                              cityList.forEach((element) {
                                element.isSelected = false;
                              });
                            }
                            stateList
                                .forEach((value) => value.isSelected = false);
                            stateList
                                .firstWhere((value) => value == selectedItem)
                                .isSelected = true;
                            selectedStateItem = stateList.indexOf(selectedItem);
                            _stateController.text = selectedItem.title;
                            _callApiForCityList(
                                countryId: countryList[selectedCountryItem].id,
                                stateId: selectedItem.id);
                          },
                        ));
                  });
            }
          } else {
            showToast(R.string.commonString.countryFirst, context: context);
          }
        }
      },
      child: CommonTextfield(
          focusNode: _focusState,
          readOnly: this.readOnly ? true : false,
          enable: false,
          textOption: TextFieldOption(
              hintText: R.string.commonString.lblState + "*",
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
          validation: (text) {
            if (text.trim().isEmpty) {
              return R.string.errorString.selectState;
            } else {
              return null;
            }
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
        if (!readOnly) {
          FocusScope.of(context).unfocus();
          if (countrySelect()) {
            if (stateSelect()) {
              if (cityList == null || cityList.length == 0) {
                _callApiForCityList(
                    countryId: countryList[selectedCountryItem].id,
                    stateId: selectedStateItem == -1
                        ? userAccount.data.account.state.id
                        : stateList[selectedStateItem].id,
                    isShowDialogue: true);
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          insetPadding: EdgeInsets.symmetric(
                              horizontal: getSize(20), vertical: getSize(20)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(getSize(25)),
                          ),
                          child: SelectionDialogue(
                            title: R.string.commonString.selectCity,
                            hintText: R.string.commonString.searchCity,
                            selectionOptions: cityList,
                            applyFilterCallBack: (
                                {SelectionPopupModel selectedItem,
                                List<SelectionPopupModel> multiSelectedItem}) {
                              cityList
                                  .forEach((value) => value.isSelected = false);
                              cityList
                                  .firstWhere((value) => value == selectedItem)
                                  .isSelected = true;
                              selectedCityItem = cityList.indexOf(selectedItem);
                              _cityController.text = selectedItem.title;
                            },
                          ));
                    });
              }
            } else {
              showToast(R.string.commonString.stateFirst, context: context);
            }
          } else {
            showToast(R.string.commonString.countryFirst, context: context);
          }
        }
      },
      child: CommonTextfield(
          focusNode: _focusCity,
          readOnly: this.readOnly ? true : false,
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: city, imageType: IconSizeType.small),
              hintText: R.string.commonString.lblCity + "*",
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
          validation: (text) {
            if (text.trim().isEmpty) {
              return R.string.errorString.selectCity;
            } else {
              return null;
            }
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getPinCodeTextField({String zipCodeTitle = "", bool rd}) {
    return CommonTextfield(
        focusNode: _focusPinCode,
        readOnly: rd == null
            ? this.readOnly
                ? true
                : false
            : rd,
        textOption: TextFieldOption(
            hintText: isNullEmptyOrFalse(zipCodeTitle)
                ? R.string.commonString.lblPinCode + "*"
                : zipCodeTitle,
            maxLine: 1,
            prefixWid: getCommonIconWidget(
                imageName: pincode,
                imageType: IconSizeType.small,
                color: Colors.black),
            formatter: [
              BlacklistingTextInputFormatter(new RegExp(RegexForTextField))
            ],
            keyboardType: TextInputType.number,
            inputController: pinCodeController,
            isSecureTextField: false),
        textCallback: (text) {
//          setState(() {
//            checkValidation();
//          });
        },
        validation: (text) {
          if (text.isEmpty) {
            return R.string.errorString.enterPinCode;
          } else if (!validatePincode(text)) {
            return R.string.errorString.enterValidZipCode;
          } else {
            return null;
          }
        },
        inputAction: TextInputAction.next,
        onNextPress: () {
          _focusPinCode.unfocus();
          fieldFocusChange(context, _focusCompanyMobile);
        });
  }

  getCompanyMobileTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focusCompanyMobile,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.authStrings.whatsApp,
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
                selectedDialogCountry: selectedDialogCountryForCompanyMobile,
                isEnabled: !this.readOnly,
                onSelectCountry: (Country country) async {
                  selectedDialogCountryForCompanyMobile = country;
                  // await checkValidation();
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
        inputController: _companyMobileController,
        formatter: [
          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator(10)),
        ],
      ),
      textCallback: (text) async {
//          await checkValidation();
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusCompanyMobile.unfocus();
        fieldFocusChange(context, _focusFaxNumber);
      },
    );
  }

  getFaxNumberTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focusFaxNumber,
      readOnly: this.readOnly ? true : false,
      textOption: TextFieldOption(
        hintText: R.string.commonString.lblFaxNumber,
        maxLine: 1,
        keyboardType: TextInputType.number,
        inputController: _faxNumberController,
        formatter: [
          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator(10)),
        ],
      ),
      textCallback: (text) async {
//          await checkValidation();
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusFaxNumber.unfocus();
//        fieldFocusChange(context, _focusWhatsAppMobile);
      },
    );
  }

  bool countrySelect() {
    if (isStringEmpty(_countryController.text.trim())) {
      return false;
    }
    return true;
  }

  bool citySelect() {
    if (isStringEmpty(_cityController.text.trim())) {
      return false;
    }
    return true;
  }

  bool stateSelect() {
    if (isStringEmpty(_stateController.text.trim())) {
      return false;
    }
    return true;
  }

  openImagePickerDocuments(Function imgFile) {
//    getImage();
    openImagePicker(context, (image) {
      if (image == null) {
        return;
      }
      imgFile(image);
      setState(() {});
      return;
    });
  }

  uploadDocument() async {
    var imgProfile = profileImage.path;
    if (isProfileImageUpload) {
      await uploadProfileImage(profileImage, (imagePath) {
        imgProfile = imagePath;
      });
    }
  }

  uploadProfileImage(File imgFile, Function imagePath) async {
    uploadFile(
      context,
      "",
      file: imgFile,
    ).then((result) {
      if (result.code == CODE_OK) {
        String imgPath =
            result.detail.files != null && result.detail.files.length > 0
                ? result.detail.files.first.absolutePath
                : "";
        if (isNullEmptyOrFalse(imgPath) == false) {
          imagePath(imgPath);
//          callPersonalInformationApi(imagePath: imgPath);
        }
      }
      return;
    });
  }

  getPhotoIdentityProofView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: getSize(8),
            right: getSize(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Photo Identity Proof",
                  style: appTheme.black16MediumTextStyle,
                ),
              ),
              !readOnly
                  ? Container(
                      height: getSize(11),
                      width: getSize(9),
                      child: Image.asset(
                        home_delete,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                width: !readOnly ? getSize(4) : getSize(0),
              ),
              !readOnly
                  ? Text(
                      "Remove",
                      style: appTheme.error12MediumTextStyle,
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(
          height: getSize(16),
        ),
        InkWell(
          onTap: () {
//        if (!readOnly) {
//          pickPDFfile(context, pickeFile, (pickedFile, isUploaded) {
//            pickeFile = pickedFile;
//            setState(() {
//              imageUpload = isUploaded;
//            });
//            print("-----file------$pickedFile");
//            print("-----imageUpload------$imageUpload");
//          });
//        }
          },
          child: Container(
            height: getSize(150),
            width: MediaQuery.of(context).size.width - getSize(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                getSize(30),
              ),
              border: Border.all(
                color: appTheme.dividerColor,
              ),
            ),
            child: readOnly
                ? SizedBox()
                : Icon(
                    Icons.add,
                    size: getSize(40),
                    color: appTheme.textGreyColor.withOpacity(0.3),
                  ),
          ),
        ),
      ],
    );
  }

  getBusinessIdentityProofView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: getSize(8),
            right: getSize(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Business Identity Proof",
                  style: appTheme.black16MediumTextStyle,
                ),
              ),
              !readOnly
                  ? Container(
                      height: getSize(11),
                      width: getSize(9),
                      child: Image.asset(
                        home_delete,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                width: !readOnly ? getSize(4) : getSize(0),
              ),
              !readOnly
                  ? Text(
                      "Remove",
                      style: appTheme.error12MediumTextStyle,
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(
          height: getSize(16),
        ),
        InkWell(
          onTap: () {
//        if (!readOnly) {
//          pickPDFfile(context, pickeFile, (pickedFile, isUploaded) {
//            pickeFile = pickedFile;
//            setState(() {
//              imageUpload = isUploaded;
//            });
//            print("-----file------$pickedFile");
//            print("-----imageUpload------$imageUpload");
//          });
//        }
          },
          child: Container(
            height: getSize(150),
            width: MediaQuery.of(context).size.width - getSize(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                getSize(30),
              ),
              border: Border.all(
                color: appTheme.dividerColor,
              ),
            ),
            child: readOnly
                ? SizedBox()
                : Icon(
                    Icons.add,
                    size: getSize(40),
                    color: appTheme.textGreyColor.withOpacity(0.3),
                  ),
          ),
        ),
      ],
    );
  }

  checkValidation() async {
    if (await isValidMobile(_mobileController.text.trim(),
            selectedDialogCountryForMobile.isoCode) ==
        false) {
      showToast(R.string.errorString.enterValidPhone, context: context);
      return false;
    }
    return true;
  }

  callPersonalInformationApi({String imagePath}) async {
    PersonalInformationReq req = PersonalInformationReq();
    req.id = app.resolve<PrefUtils>().getUserDetails().id;
    req.address = _addressLineOneController.text.trim();
    req.firstName = _firstNameController.text.trim();
    req.middleName = _middleNameController.text.trim();
    req.lastName = _lastNameController.text.trim();
    req.mobile = _mobileController.text;
    req.countryCode = selectedDialogCountryForMobile.phoneCode;
    req.whatsapp = _whatsAppMobileController.text;
    req.whatsappCounCode = selectedDialogCountryForWhatsapp.phoneCode;
    req.email = _emailController.text.trim();
//    req.skype = _skypeController.text.trim();
    req.pincode = pinCodeController.text.trim();
    countryList.forEach((element) {
      if (element.title == _countryController.text.trim()) {
        req.country = element.id;
      }
    });
    stateList.forEach((element) {
      if (element.title == _stateController.text.trim()) {
        req.state = element.id;
      }
    });
    cityList.forEach((element) {
      if (element.title == _cityController.text.trim()) {
        req.city = element.id;
      }
    });
    if (imagePath != null) {
      req.profileImage = imagePath;
    }

    NetworkCall<PersonalInformationViewResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .personalInformation(req),
            context,
            isProgress: true)
        .then((resp) async {
      setState(() {});
      if (resp.data.accountTerm == null) {
        var oldAccTerm = app.resolve<PrefUtils>().getUserDetails().accountTerm;
        resp.data.accountTerm = oldAccTerm;
      }
      String oldEmail = app.resolve<PrefUtils>().getUserDetails().email;

      app.resolve<PrefUtils>().saveUser(resp.data);
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string.commonString.successfully,
            desc: resp.message,
            positiveBtnTitle: R.string.commonString.ok,
          );

      if (oldEmail != _emailController.text) {
        callLogout(context);
      }
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
          );
    });
  }
}
