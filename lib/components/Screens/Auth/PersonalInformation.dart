import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/network/Uploadmanager.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImagePicker.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Auth/PersonalInformationModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalInformation extends StatefulWidget {
  static const route = "PersonalInformation";

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation>
    with AutomaticKeepAliveClientMixin<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _addressLineOneController =
      TextEditingController();
  final TextEditingController _addressLineTwoController =
      TextEditingController();
  final TextEditingController _addressLineThreeController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _skypeController = TextEditingController();
  final TextEditingController _whatsAppMobileController =
      TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool isProfileImageUpload = false;
  File profileImage;
  String image;
  Country selectedDialogCountryForMobile =
      CountryPickerUtils.getCountryByIsoCode("US");
  Country selectedDialogCountryForWhatsapp =
      CountryPickerUtils.getCountryByIsoCode("US");

  var _focusFirstName = FocusNode();
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
  var _focusMobile = FocusNode();
  var _focusSkype = FocusNode();
  var _focusWhatsAppMobile = FocusNode();

  List<CityList> cityList = List<CityList>();
  CityList selectedCityItem = CityList();
  List<CountryList> countryList = List<CountryList>();
  CountryList selectedCountryItem = CountryList();
  List<StateList> stateList = List<StateList>();
  StateList selectedStateItem = StateList();

  @override
  void initState() {
    super.initState();
    // _callApiForCountryList();
    getPersonalInformation();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            top: getSize(10),
            bottom: getSize(16),
            right: getSize(20),
            left: getSize(20),
          ),
          child: Container(
            child: AppButton.flat(
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (_mobileController.text.isNotEmpty ||
                      _whatsAppMobileController.text.isNotEmpty) {
                    if (await checkValidation()) {
                      if (isProfileImageUpload) {
                        await uploadDocument();
                      } else {
                        callPersonalInformationApi();
                      }
                    }
                  }
                } else {
                  setState(() {
                    _autoValidate = true;
                  });
                }
                // NavigationUtilities.push(ThemeSetting());
              },
              backgroundColor: appTheme.colorPrimary.withOpacity(0.1),
              textColor: appTheme.colorPrimary,
              borderRadius: getSize(5),
              fitWidth: true,
              text: R.string().authStrings.editProfileTitle,
              //isButtonEnabled: enableDisableSigninButton(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getSize(20), vertical: getSize(30)),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openImagePickerDocuments((img) {
                            setState(() {
                              isProfileImageUpload = true;
                              profileImage = img;
                            });
                          });
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
                                FocusScope.of(context).unfocus();
                                openImagePickerDocuments((img) async {
                                  setState(() {
                                    isProfileImageUpload = true;
                                    profileImage = img;
                                  });
                                  await uploadDocument();
                                });
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
                  getLastNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getMobileTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getAddressLineOneTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getWhatsAppTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getEmailTextField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getMobileTextField() {
    return CommonTextfield(
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
                selectedDialogCountry: selectedDialogCountryForMobile,
                isEnabled: true,
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
          return R.string().errorString.enterPhone;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusMobile.unfocus();
        fieldFocusChange(context, _focusSkype);
      },
    );
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
          callPersonalInformationApi(imagePath: imgPath);
        }
      }
      return;
    });
  }

  getWhatsAppTextField() {
    return CommonTextfield(
      //enable: enable,
      focusNode: _focusWhatsAppMobile,
      textOption: TextFieldOption(
        hintText: R.string().authStrings.whatsApp,
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
                isEnabled: true,
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
      // validation: (text) {
      //   if (text.isEmpty) {
      //     return R.string().errorString.enterPhone;
      //   } else {
      //     return null;
      //   }
      // },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusWhatsAppMobile.unfocus();
        fieldFocusChange(context, _focusMobile);
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
          return R.string().errorString.enterEmail;
        } else if (!validateEmail(text.trim())) {
          return R.string().errorString.enterValidEmail;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusEmail.unfocus();
      },
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
          return R.string().errorString.enterFirstName;
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
      textOption: TextFieldOption(
        hintText: R.string().authStrings.lastName,
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
          return R.string().errorString.enterLastName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusLastName.unfocus();
        fieldFocusChange(context, _focusAddressLineOne);
      },
    );
  }

  getAddressLineOneTextField() {
    return CommonTextfield(
      focusNode: _focusAddressLineOne,
      textOption: TextFieldOption(
        hintText: R.string().authStrings.address,
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
          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        //isSecureTextField: false
      ),
      textCallback: (text) {},
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

  checkValidation() async {
    if (await isValidMobile(_mobileController.text.trim(),
            selectedDialogCountryForMobile.isoCode) ==
        false) {
      showToast(R.string().errorString.enterValidPhone, context: context);
      return false;
    } else if (await isValidMobile(_whatsAppMobileController.text.trim(),
            selectedDialogCountryForWhatsapp.isoCode) ==
        false) {
      showToast(R.string().errorString.enterValidWhatsappPhone,
          context: context);
      return false;
    }
    return true;
  }

  callPersonalInformationApi({String imagePath}) async {
    PersonalInformationReq req = PersonalInformationReq();
    req.id = app.resolve<PrefUtils>().getUserDetails().id;
    req.address = _addressLineOneController.text.trim();
    req.firstName = _firstNameController.text.trim();
    req.lastName = _lastNameController.text.trim();
    req.mobile = _mobileController.text;
    req.countryCode = selectedDialogCountryForMobile.phoneCode;
    req.whatsapp = _whatsAppMobileController.text;
    req.whatsappCounCode = selectedDialogCountryForWhatsapp.phoneCode;
    req.email = _emailController.text.trim();
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
      if (resp.data.accountTerm == null) {
        var oldAccTerm = app.resolve<PrefUtils>().getUserDetails().accountTerm;
        resp.data.accountTerm = oldAccTerm;
      }
      String oldEmail = app.resolve<PrefUtils>().getUserDetails().email;

      app.resolve<PrefUtils>().saveUser(resp.data);
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.successfully,
            desc: resp.message,
            positiveBtnTitle: R.string().commonString.ok,
          );

      if (oldEmail != _emailController.text) {
        callLogout(context);
      }
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
          );
    });
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
      _lastNameController.text = resp.data.lastName;
      _addressLineOneController.text = resp.data.address;
      _mobileController.text = resp.data.mobile;
      selectedDialogCountryForMobile =
          CountryPickerUtils.getCountryByPhoneCode(resp.data.countryCode);
      _whatsAppMobileController.text = resp.data.whatsapp;
      selectedDialogCountryForWhatsapp =
          CountryPickerUtils.getCountryByPhoneCode(resp.data.whatsappCounCode);
      _emailController.text = resp.data.email;
      image = resp.data.profileImage;
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

  @override
  bool get wantKeepAlive => true;
}
