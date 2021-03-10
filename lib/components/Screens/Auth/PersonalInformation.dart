//import 'dart:io';
//
//import 'package:country_pickers/country.dart';
//import 'package:country_pickers/country_pickers.dart';
//import 'package:diamnow/app/app.export.dart';
//import 'package:diamnow/app/constant/EnumConstant.dart';
//import 'package:diamnow/app/localization/app_locales.dart';
//import 'package:diamnow/app/network/NetworkCall.dart';
//import 'package:diamnow/app/network/ServiceModule.dart';
//import 'package:diamnow/app/network/Uploadmanager.dart';
//import 'package:diamnow/app/utils/BaseDialog.dart';
//import 'package:diamnow/app/utils/BaseDialog.dart';
//import 'package:diamnow/app/utils/BaseDialog.dart';
//import 'package:diamnow/app/utils/BottomSheet.dart';
//import 'package:diamnow/app/utils/CustomDialog.dart';
//import 'package:diamnow/app/utils/ImagePicker.dart';
//import 'package:diamnow/app/utils/ImageUtils.dart';
//import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
//import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
//import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
//import 'package:diamnow/models/Address/CityListModel.dart';
//import 'package:diamnow/models/Address/CountryListModel.dart';
//import 'package:diamnow/models/Address/StateListModel.dart';
//import 'package:diamnow/models/Auth/PersonalInformationModel.dart';
//import 'package:diamnow/models/LoginModel.dart';
//import 'package:diamnow/models/Master/Master.dart';
//import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//
//class PersonalInformation extends StatefulWidget {
//  static const route = "PersonalInformation";
//
//  @override
//  _PersonalInformationState createState() => _PersonalInformationState();
//}
//
//class _PersonalInformationState extends State<PersonalInformation> {
//  final TextEditingController _firstNameController = TextEditingController();
//  final TextEditingController _lastNameController = TextEditingController();
//  final TextEditingController _middleNameController = TextEditingController();
//  final TextEditingController _addressLineOneController =
//      TextEditingController();
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _mobileController = TextEditingController();
//  final TextEditingController _skypeController = TextEditingController();
//  final TextEditingController _whatsAppMobileController =
//      TextEditingController();
//  final TextEditingController companyController = TextEditingController();
//  final TextEditingController _countryController = TextEditingController();
//  final TextEditingController _stateController = TextEditingController();
//  final TextEditingController _cityController = TextEditingController();
//  final TextEditingController _documentController = TextEditingController();
//  bool isProfileImageUpload = false;
//  File profileImage;
//  String image;
//  Country selectedDialogCountryForMobile =
//      CountryPickerUtils.getCountryByIsoCode("US");
//  Country selectedDialogCountryForWhatsapp =
//      CountryPickerUtils.getCountryByIsoCode("US");
//  final TextEditingController _pinCodeController = TextEditingController();
//
//  var _focusFirstName = FocusNode();
//  var _focusSkype = FocusNode();
//  var _focusLastName = FocusNode();
//  var _focusMiddleName = FocusNode();
//  var _focusAddressLineOne = FocusNode();
//  var _focusEmail = FocusNode();
//  var _focusPinCode = FocusNode();
//  var _focusCountry = FocusNode();
//  var _focusState = FocusNode();
//  var _focusCity = FocusNode();
//  var _focusMobile = FocusNode();
//  var _focusDocument = FocusNode();
//  // var _focusSkype = FocusNode();
//  var _focusWhatsAppMobile = FocusNode();
//  String pickeFile = "";
//  bool imageUpload = false;
//
//  List<SelectionPopupModel> cityList = List<SelectionPopupModel>();
//  // SelectionPopupModel selectedCityItem;
//  List<SelectionPopupModel> countryList = List<SelectionPopupModel>();
//  // SelectionPopupModel selectedCountryItem;
//  List<SelectionPopupModel> stateList = List<SelectionPopupModel>();
//  // SelectionPopupModel selectedStateItem;
//  List<SelectionPopupModel> arrPhotos = [];
//
//  PersonalInformationViewResp userAccount;
//  var selectedCityItem = -1;
//  var selectedCountryItem = -1;
//  var selectedStateItem = -1;
//  var selectedDocument = -1;
//
//  CompanyInformationState companyInformationState = CompanyInformationState();
//  //Boolean for readonly while edit profile.
//
//  @override
//  void initState() {
//    super.initState();
//    // _callApiForCountryList();
//    getPersonalInformation();
//    getMasters();
//  }
//
//  @override
//  void dispose() {
//    companyInformationState.pinCodeController.dispose();
//    super.dispose();
//  }
//
//  getMasters() async {
//    Master.getSubMaster(MasterCode.docTypePersonal).then((arrMaster) {
//      arrMaster.forEach((element) {
//        arrPhotos.add(SelectionPopupModel(
//          element.sId,
//          element.name,
//        ));
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      child: Scaffold(
//        body: SingleChildScrollView(
//          child: Padding(
//            padding: EdgeInsets.symmetric(
//                horizontal: getSize(20), vertical: getSize(00)),
//            child: Form(
//              key: _formKey,
//              autovalidate: _autoValidate,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.only(
//                      bottom: getSize(20),
//                    ),
//                    child: Text(
//                      "Personal Information",
//                      style: appTheme.black16MediumTextStyle,
//                    ),
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      InkWell(
//                        onTap: () {
//                          if (!readOnly) {
//                            FocusScope.of(context).unfocus();
//                            openImagePickerDocuments((img) {
//                              setState(() {
//                                isProfileImageUpload = true;
//                                profileImage = img;
//                              });
//                            });
//                          }
//                        },
//                        child: Stack(
//                          alignment: Alignment.bottomRight,
//                          children: <Widget>[
//                            ClipRRect(
//                              borderRadius: BorderRadius.all(
//                                Radius.circular(
//                                  getSize(60),
//                                ),
//                              ),
//                              child: Stack(
//                                children: <Widget>[
//                                  ClipRRect(
//                                    borderRadius: BorderRadius.all(
//                                      Radius.circular(
//                                        getSize(60),
//                                      ),
//                                    ),
//                                    child: isProfileImageUpload
//                                        ? Image.file(
//                                            profileImage,
//                                            width: getSize(120),
//                                            height: getSize(120),
//                                            fit: BoxFit.cover,
//                                          )
//                                        : getImageView(
//                                            image ?? "",
//                                            width: getSize(120),
//                                            height: getSize(120),
//                                            placeHolderImage: placeHolder,
//                                            fit: BoxFit.cover,
//                                          ),
//                                  ),
//                                  Container(
//                                    color: isProfileImageUpload || image != ""
//                                        ? Colors.transparent
//                                        : appTheme.colorPrimary
//                                            .withOpacity(0.5),
//                                  ),
//                                ],
//                              ),
//                            ),
//                            InkWell(
//                              onTap: () {
//                                if (!readOnly) {
//                                  FocusScope.of(context).unfocus();
//                                  openImagePickerDocuments((img) async {
//                                    setState(() {
//                                      isProfileImageUpload = true;
//                                      profileImage = img;
//                                    });
//                                    await uploadDocument();
//                                  });
//                                }
//                              },
//                              child: Image.asset(
//                                editProfile,
//                                height: getSize(33),
//                                width: getSize(27),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                  SizedBox(
//                    height: getSize(30),
//                  ),
//                  getFirstNameTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getMiddleNameTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getLastNameTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getAddressLineOneTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getEmailTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  //country
//                  getCountryDropDown(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getStateDropDown(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getCityDropDown(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  companyInformationState.getPinCodeTextField(
//                      zipCodeTitle: "ZipCode *", rd: this.readOnly),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getMobileTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getWhatsAppTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getSkypeTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getDocumentDropDown(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getDocumentView(),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  getCountryDropDown() {
//    return InkWell(
//      onTap: () {
//        if (!readOnly) {
//          if (countryList == null || countryList.length == 0) {
//            _callApiForCountryList(isShowDialogue: true);
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
//                    title: R.string.commonString.selectCountry,
//                    hintText: R.string.commonString.searchCountry,
//                    selectionOptions: countryList,
//                    applyFilterCallBack: (
//                        {SelectionPopupModel selectedItem,
//                        List<SelectionPopupModel> multiSelectedItem}) {
//                      if (_countryController.text.toLowerCase() !=
//                          selectedItem.title.toLowerCase()) {
//                        _stateController.text = "";
//                        _cityController.text = "";
//                        this.cityList.clear();
//                        this.stateList.clear();
//                        cityList.forEach((element) {
//                          element.isSelected = false;
//                        });
//                        stateList.forEach((element) {
//                          element.isSelected = false;
//                        });
//                        selectedCityItem = -1;
//                        selectedStateItem = -1;
//                      }
//                      countryList.forEach((value) => value.isSelected = false);
//                      countryList
//                          .firstWhere((value) => value == selectedItem)
//                          .isSelected = true;
//                      selectedCountryItem = countryList.indexOf(selectedItem);
//                      _countryController.text = selectedItem.title;
//                      _callApiForStateList(countryId: selectedItem.id);
//                    },
//                  ),
//                );
//              },
//            );
//          }
//        }
//      },
//      child: CommonTextfield(
//          focusNode: _focusCountry,
//          readOnly: this.readOnly ? true : false,
//          enable: false,
//          textOption: TextFieldOption(
//              hintText: R.string.commonString.lblCountry,
//              maxLine: 1,
//              prefixWid: getCommonIconWidget(
//                  imageName: country, imageType: IconSizeType.small),
//              type: TextFieldType.DropDown,
//              keyboardType: TextInputType.text,
//              inputController: _countryController,
//              isSecureTextField: false),
//          textCallback: (text) {
////                  setState(() {
////                    checkValidation();
////                  });
//          },
//          inputAction: TextInputAction.next,
//          onNextPress: () {
//            FocusScope.of(context).unfocus();
//          }),
//    );
//  }
//
//  bool countrySelect() {
//    if (isStringEmpty(_countryController.text.trim())) {
//      return false;
//    }
//    return true;
//  }
//
//  getStateDropDown() {
//    return InkWell(
//      onTap: () {
//        if (!readOnly) {
//          if (countrySelect()) {
//            if (stateList == null || stateList.length == 0) {
//              _callApiForStateList(
//                  countryId: countryList[selectedCountryItem].id,
//                  isShowDialogue: true);
//            } else {
//              showDialog(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return Dialog(
//                        insetPadding: EdgeInsets.symmetric(
//                            horizontal: getSize(20), vertical: getSize(20)),
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(getSize(25)),
//                        ),
//                        child: SelectionDialogue(
//                          title: R.string.commonString.selectState,
//                          hintText: R.string.commonString.searchState,
//                          selectionOptions: stateList,
//                          applyFilterCallBack: (
//                              {SelectionPopupModel selectedItem,
//                              List<SelectionPopupModel> multiSelectedItem}) {
//                            if (_stateController.text != selectedItem.title) {
//                              _cityController.text = "";
//                              this.cityList.clear();
//                              selectedCityItem = -1;
//                              cityList.forEach((element) {
//                                element.isSelected = false;
//                              });
//                            }
//                            stateList
//                                .forEach((value) => value.isSelected = false);
//                            stateList
//                                .firstWhere((value) => value == selectedItem)
//                                .isSelected = true;
//                            selectedStateItem = stateList.indexOf(selectedItem);
//                            _stateController.text = selectedItem.title;
//                            _callApiForCityList(
//                                countryId: countryList[selectedCountryItem].id,
//                                stateId: selectedItem.id);
//                          },
//                        ));
//                  });
//            }
//          } else {
//            showToast(R.string.commonString.countryFirst, context: context);
//          }
//        }
//      },
//      child: CommonTextfield(
//          focusNode: _focusState,
//          readOnly: this.readOnly ? true : false,
//          enable: false,
//          textOption: TextFieldOption(
//              hintText: R.string.commonString.lblState,
//              maxLine: 1,
//              prefixWid: getCommonIconWidget(
//                  imageName: state, imageType: IconSizeType.small),
//              keyboardType: TextInputType.text,
//              type: TextFieldType.DropDown,
//              inputController: _stateController,
//              isSecureTextField: false),
//          textCallback: (text) {
////                  setState(() {
////                    checkValidation();
////                  });
//          },
//          inputAction: TextInputAction.next,
//          onNextPress: () {
//            FocusScope.of(context).unfocus();
//          }),
//    );
//  }
//
//  void _callApiForCityList({
//    String stateId,
//    String countryId,
//    bool isShowDialogue = false,
//  }) {
//    CityListReq req = CityListReq();
//    req.state = stateId;
//    req.country = countryId;
//
//    NetworkCall<CityListResp>()
//        .makeCall(
//            () => app.resolve<ServiceModule>().networkService().cityList(req),
//            context,
//            isProgress: true)
//        .then((resp) {
//      cityList.clear();
//      for (var item in resp.data) {
//        if (userAccount.data.account.city != null) {
//          cityList.add(SelectionPopupModel(item.id, item.name,
//              isSelected: (userAccount.data.account.city.id == item.id)
//                  ? true
//                  : false));
//        } else {
//          cityList
//              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
//        }
//      }
//      ;
//      if (isShowDialogue) {
//        showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return Dialog(
//                  insetPadding: EdgeInsets.symmetric(
//                      horizontal: getSize(20), vertical: getSize(20)),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(getSize(25)),
//                  ),
//                  child: SelectionDialogue(
//                    title: R.string.commonString.selectCity,
//                    hintText: R.string.commonString.searchCity,
//                    selectionOptions: cityList,
//                    applyFilterCallBack: (
//                        {SelectionPopupModel selectedItem,
//                        List<SelectionPopupModel> multiSelectedItem}) {
//                      cityList.forEach((value) => value.isSelected = false);
//                      cityList
//                          .firstWhere((value) => value == selectedItem)
//                          .isSelected = true;
//                      selectedCityItem = cityList.indexOf(selectedItem);
//                      _cityController.text = selectedItem.title;
//                    },
//                  ));
//            });
//      }
//    }).catchError(
//      (onError) => {
//        app.resolve<CustomDialogs>().confirmDialog(context,
//            desc: onError.message,
//            positiveBtnTitle: R.string.commonString.btnTryAgain,
//            onClickCallback: (PositveButtonClick) {
//          _callApiForCityList(stateId: stateId, countryId: countryId);
//        })
//      },
//    );
//  }
//
//  bool stateSelect() {
//    if (isStringEmpty(_stateController.text.trim())) {
//      return false;
//    }
//    return true;
//  }
//
//  getCityDropDown() {
//    return InkWell(
//      onTap: () {
//        if (!readOnly) {
//          FocusScope.of(context).unfocus();
//          if (countrySelect()) {
//            if (stateSelect()) {
//              if (cityList == null || cityList.length == 0) {
//                _callApiForCityList(
//                    countryId: countryList[selectedCountryItem].id,
//                    stateId: selectedStateItem == -1
//                        ? userAccount.data.account.state.id
//                        : stateList[selectedStateItem].id,
//                    isShowDialogue: true);
//              } else {
//                showDialog(
//                    context: context,
//                    builder: (BuildContext context) {
//                      return Dialog(
//                          insetPadding: EdgeInsets.symmetric(
//                              horizontal: getSize(20), vertical: getSize(20)),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(getSize(25)),
//                          ),
//                          child: SelectionDialogue(
//                            title: R.string.commonString.selectCity,
//                            hintText: R.string.commonString.searchCity,
//                            selectionOptions: cityList,
//                            applyFilterCallBack: (
//                                {SelectionPopupModel selectedItem,
//                                List<SelectionPopupModel> multiSelectedItem}) {
//                              cityList
//                                  .forEach((value) => value.isSelected = false);
//                              cityList
//                                  .firstWhere((value) => value == selectedItem)
//                                  .isSelected = true;
//                              selectedCityItem = cityList.indexOf(selectedItem);
//                              _cityController.text = selectedItem.title;
//                            },
//                          ));
//                    });
//              }
//            } else {
//              showToast(R.string.commonString.stateFirst, context: context);
//            }
//          } else {
//            showToast(R.string.commonString.countryFirst, context: context);
//          }
//        }
//      },
//      child: CommonTextfield(
//          focusNode: _focusCity,
//          readOnly: this.readOnly ? true : false,
//          enable: false,
//          textOption: TextFieldOption(
//              prefixWid: getCommonIconWidget(
//                  imageName: city, imageType: IconSizeType.small),
//              hintText: R.string.commonString.lblCity,
//              maxLine: 1,
//              keyboardType: TextInputType.text,
//              type: TextFieldType.DropDown,
//              inputController: _cityController,
//              isSecureTextField: false),
//          textCallback: (text) {
////                  setState(() {
////                    checkValidation();
////                  });
//          },
//          inputAction: TextInputAction.next,
//          onNextPress: () {
//            FocusScope.of(context).unfocus();
//          }),
//    );
//  }
//
//  void _callApiForCountryList({bool isShowDialogue = false}) {
//    NetworkCall<CountryListResp>()
//        .makeCall(
//            () => app.resolve<ServiceModule>().networkService().countryList(),
//            context,
//            isProgress: true)
//        .then((resp) {
//      countryList.clear();
//      for (var item in resp.data) {
//        if (userAccount != null && userAccount.data.account.country != null) {
//          countryList.add(SelectionPopupModel(item.id, item.name,
//              isSelected: (userAccount.data.account.country.id == item.id)
//                  ? true
//                  : false));
//        } else {
//          countryList
//              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
//        }
//      }
//      ;
//      getPersonalInformation();
//      if (isShowDialogue) {
//        showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return Dialog(
//                  insetPadding: EdgeInsets.symmetric(
//                      horizontal: getSize(20), vertical: getSize(20)),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(getSize(25)),
//                  ),
//                  child: SelectionDialogue(
//                    title: R.string.commonString.selectCountry,
//                    hintText: R.string.commonString.searchCountry,
//                    selectionOptions: countryList,
//                    applyFilterCallBack: (
//                        {SelectionPopupModel selectedItem,
//                        List<SelectionPopupModel> multiSelectedItem}) {
//                      if (_countryController.text != selectedItem.title) {
//                        _stateController.text = "";
//                        _cityController.text = "";
//                        this.cityList.clear();
//                        this.stateList.clear();
//                      }
//                      countryList.forEach((value) => value.isSelected = false);
//                      countryList
//                          .firstWhere((value) => value == selectedItem)
//                          .isSelected = true;
//                      selectedCountryItem = countryList.indexOf(selectedItem);
//                      _countryController.text = selectedItem.title;
//                      _callApiForStateList(countryId: selectedItem.id);
//                    },
//                  ));
//            });
//      }
//    }).catchError(
//      (onError) => {
//        app.resolve<CustomDialogs>().confirmDialog(
//          context,
//          desc: onError.message,
//          positiveBtnTitle: R.string.commonString.btnTryAgain,
//          onClickCallback: (buttonType) {
//            _callApiForCountryList();
//          },
//        )
//      },
//    );
//  }
//
//  void _callApiForStateList({
//    String countryId,
//    bool isShowDialogue = false,
//  }) {
//    StateListReq req = StateListReq();
//    req.country = countryId;
//
//    NetworkCall<StateListResp>()
//        .makeCall(
//            () => app.resolve<ServiceModule>().networkService().stateList(req),
//            context,
//            isProgress: true)
//        .then((resp) {
//      stateList.clear();
//      for (var item in resp.data) {
//        if (userAccount.data.account.state != null) {
//          stateList.add(SelectionPopupModel(item.id, item.name,
//              isSelected: (userAccount.data.account.state.id == item.id)
//                  ? true
//                  : false));
//        } else {
//          stateList
//              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
//        }
//      }
//      ;
//      if (isShowDialogue) {
//        showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return Dialog(
//                  insetPadding: EdgeInsets.symmetric(
//                      horizontal: getSize(20), vertical: getSize(20)),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(getSize(25)),
//                  ),
//                  child: SelectionDialogue(
//                    title: R.string.commonString.selectState,
//                    hintText: R.string.commonString.searchState,
//                    selectionOptions: stateList,
//                    applyFilterCallBack: (
//                        {SelectionPopupModel selectedItem,
//                        List<SelectionPopupModel> multiSelectedItem}) {
//                      if (_stateController.text != selectedItem.title) {
//                        _cityController.text = "";
//                        this.cityList.clear();
//                      }
//                      stateList.forEach((value) => value.isSelected = false);
//                      stateList
//                          .firstWhere((value) => value == selectedItem)
//                          .isSelected = true;
//                      selectedStateItem = stateList.indexOf(selectedItem);
//                      _stateController.text = selectedItem.title;
//                      _callApiForCityList(
//                          countryId: countryList[selectedCountryItem].id,
//                          stateId: selectedItem.id);
//                    },
//                  ));
//            });
//      }
//    }).catchError(
//      (onError) => {
//        app.resolve<CustomDialogs>().confirmDialog(context,
//            desc: onError.message,
//            positiveBtnTitle: R.string.commonString.btnTryAgain,
//            onClickCallback: (PositveButtonClick) {
//          _callApiForStateList(countryId: countryId);
//        })
//      },
//    );
//  }
//
//  getDocumentDropDown() {
//    return InkWell(
//      onTap: () {
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
//                        List<SelectionPopupModel> multiSelectedItem}) {
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
//      },
//      child: CommonTextfield(
//          focusNode: _focusDocument,
//          readOnly: this.readOnly ? true : false,
//          enable: false,
//          textOption: TextFieldOption(
//              hintText: "Select Document",
//              maxLine: 1,
//              prefixWid: getCommonIconWidget(
//                  imageName: documentPlaceHolder,
//                  imageType: IconSizeType.small),
//              type: TextFieldType.DropDown,
//              keyboardType: TextInputType.text,
//              inputController: _documentController,
//              isSecureTextField: false),
//          textCallback: (text) {
////                  setState(() {
////                    checkValidation();
////                  });
//          },
//          inputAction: TextInputAction.done,
//          onNextPress: () {
//            FocusScope.of(context).unfocus();
//          }),
//    );
//  }
//
//  getDocumentView() {
//    return InkWell(
//      onTap: () {
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
//      },
//      child: Container(
//        height: getSize(130),
//        width: getSize(230),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(
//            getSize(30),
//          ),
//          border: Border.all(
//            color: appTheme.textGreyColor.withOpacity(0.3),
//          ),
//        ),
//        child: readOnly
//            ? SizedBox()
//            : Icon(
//                Icons.add,
//                size: getSize(40),
//                color: appTheme.textGreyColor.withOpacity(0.3),
//              ),
//      ),
//    );
//  }
//
//  uploadDocument() async {
//    var imgProfile = profileImage.path;
//    if (isProfileImageUpload) {
//      await uploadProfileImage(profileImage, (imagePath) {
//        imgProfile = imagePath;
//      });
//    }
//  }
//
//  uploadProfileImage(File imgFile, Function imagePath) async {
//    uploadFile(
//      context,
//      "",
//      file: imgFile,
//    ).then((result) {
//      if (result.code == CODE_OK) {
//        String imgPath =
//            result.detail.files != null && result.detail.files.length > 0
//                ? result.detail.files.first.absolutePath
//                : "";
//        if (isNullEmptyOrFalse(imgPath) == false) {
//          imagePath(imgPath);
//          callPersonalInformationApi(imagePath: imgPath);
//        }
//      }
//      return;
//    });
//  }
//
//  getSkypeTextField() {
//    return CommonTextfield(
//      autoFocus: false,
//      focusNode: _focusSkype,
//      readOnly: this.readOnly ? true : false,
//      textOption: TextFieldOption(
//        hintText: R.string.authStrings.skype,
//        maxLine: 1,
//        prefixWid: getCommonIconWidget(
//            imageName: skypeIcon,
//            imageType: IconSizeType.small,
//            color: Colors.black),
//        fillColor: fromHex("#FFEFEF"),
//        errorBorder: OutlineInputBorder(
//          borderRadius: BorderRadius.all(Radius.circular(11)),
//          borderSide: BorderSide(width: 1, color: Colors.red),
//        ),
//        inputController: _skypeController,
//        formatter: [
//          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
//          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
//        ],
//        //isSecureTextField: false
//      ),
//      textCallback: (text) {
//        // _firstNameController.text = _firstNameController.text.trim();
//      },
//      validation: (text) {
//        if (text.trim().isEmpty) {
//          return R.string.authStrings.skype;
//        } else {
//          return null;
//        }
//        // }
//      },
//      inputAction: TextInputAction.next,
//      onNextPress: () {
//        _focusFirstName.unfocus();
//        // fieldFocusChange(context, _focusMiddleName);
//      },
//    );
//  }
//
//  getMiddleNameTextField() {
//    return CommonTextfield(
//      focusNode: _focusMiddleName,
//      readOnly: this.readOnly ? true : false,
//      textOption: TextFieldOption(
//        hintText: R.string.authStrings.middleName,
//        maxLine: 1,
//        prefixWid: getCommonIconWidget(
//            imageName: user,
//            imageType: IconSizeType.small,
//            color: Colors.black),
//        fillColor: fromHex("#FFEFEF"),
//        errorBorder: OutlineInputBorder(
//          borderRadius: BorderRadius.all(Radius.circular(11)),
//          borderSide: BorderSide(width: 1, color: Colors.red),
//        ),
//        inputController: _middleNameController,
//        formatter: [
//          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
//          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
//        ],
//        //isSecureTextField: false
//      ),
//      textCallback: (text) {},
//      validation: (text) {
//        if (text.trim().isEmpty) {
//          return R.string.errorString.enterMiddleName;
//        } else {
//          return null;
//        }
//        // }
//      },
//      inputAction: TextInputAction.next,
//      onNextPress: () {
//        _focusMiddleName.unfocus();
//        fieldFocusChange(context, _focusLastName);
//      },
//    );
//  }
//
//  getAddressLineOneTextField() {
//    return CommonTextfield(
//      focusNode: _focusAddressLineOne,
//      readOnly: this.readOnly ? true : false,
//      textOption: TextFieldOption(
//        hintText: R.string.authStrings.address,
//        maxLine: 1,
//        prefixWid: getCommonIconWidget(
//            imageName: company,
//            imageType: IconSizeType.small,
//            color: Colors.black),
//        fillColor: fromHex("#FFEFEF"),
//        errorBorder: OutlineInputBorder(
//          borderRadius: BorderRadius.all(Radius.circular(11)),
//          borderSide: BorderSide(width: 1, color: Colors.red),
//        ),
//        inputController: _addressLineOneController,
//        formatter: [
//          //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
//          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
//        ],
//        //isSecureTextField: false
//      ),
//      textCallback: (text) {},
//      validation: (text) {
//        if (text.trim().isEmpty) {
//          return R.string.errorString.enterAddress;
//        } else {
//          return null;
//        }
//        // }
//      },
//      inputAction: TextInputAction.next,
//      onNextPress: () {
//        _focusAddressLineOne.unfocus();
//        fieldFocusChange(context, _focusEmail);
//      },
//    );
//  }
//
//  openImagePickerDocuments(Function imgFile) {
////    getImage();
//    openImagePicker(context, (image) {
//      if (image == null) {
//        return;
//      }
//      imgFile(image);
//      setState(() {});
//      return;
//    });
//  }
//
//  checkValidation() async {
//    if (await isValidMobile(_mobileController.text.trim(),
//            selectedDialogCountryForMobile.isoCode) ==
//        false) {
//      showToast(R.string.errorString.enterValidPhone, context: context);
//      return false;
//    }
//    return true;
//  }
//
//  callPersonalInformationApi({String imagePath}) async {
//    PersonalInformationReq req = PersonalInformationReq();
//    req.id = app.resolve<PrefUtils>().getUserDetails().id;
//    req.address = _addressLineOneController.text.trim();
//    req.firstName = _firstNameController.text.trim();
//    req.middleName = _middleNameController.text.trim();
//    req.lastName = _lastNameController.text.trim();
//    req.mobile = _mobileController.text;
//    req.countryCode = selectedDialogCountryForMobile.phoneCode;
//    req.whatsapp = _whatsAppMobileController.text;
//    req.whatsappCounCode = selectedDialogCountryForWhatsapp.phoneCode;
//    req.email = _emailController.text.trim();
//    req.skype = _skypeController.text.trim();
//    req.pincode = companyInformationState.pinCodeController.text.trim();
//    countryList.forEach((element) {
//      if (element.title == _countryController.text.trim()) {
//        req.country = element.id;
//      }
//    });
//    stateList.forEach((element) {
//      if (element.title == _stateController.text.trim()) {
//        req.state = element.id;
//      }
//    });
//    cityList.forEach((element) {
//      if (element.title == _cityController.text.trim()) {
//        req.city = element.id;
//      }
//    });
//    if (imagePath != null) {
//      req.profileImage = imagePath;
//    }
//
//    NetworkCall<PersonalInformationViewResp>()
//        .makeCall(
//            () => app
//                .resolve<ServiceModule>()
//                .networkService()
//                .personalInformation(req),
//            context,
//            isProgress: true)
//        .then((resp) async {
//      setState(() {});
//      if (resp.data.accountTerm == null) {
//        var oldAccTerm = app.resolve<PrefUtils>().getUserDetails().accountTerm;
//        resp.data.accountTerm = oldAccTerm;
//      }
//      String oldEmail = app.resolve<PrefUtils>().getUserDetails().email;
//
//      app.resolve<PrefUtils>().saveUser(resp.data);
//      app.resolve<CustomDialogs>().confirmDialog(
//            context,
//            title: R.string.commonString.successfully,
//            desc: resp.message,
//            positiveBtnTitle: R.string.commonString.ok,
//          );
//
//      if (oldEmail != _emailController.text) {
//        callLogout(context);
//      }
//    }).catchError((onError) {
//      app.resolve<CustomDialogs>().confirmDialog(
//            context,
//            desc: onError.message,
//            positiveBtnTitle: R.string.commonString.btnTryAgain,
//          );
//    });
//  }
//
//  getPersonalInformation() async {
//    NetworkCall<PersonalInformationViewResp>()
//        .makeCall(
//            () => app
//                .resolve<ServiceModule>()
//                .networkService()
//                .personalInformationView(),
//            context,
//            isProgress: true)
//        .then((resp) async {
//      userAccount = resp;
//      _firstNameController.text = resp.data.firstName;
//      _lastNameController.text = resp.data.lastName;
//      _middleNameController.text = resp.data.middleName;
//      _addressLineOneController.text = resp.data.address;
//      _mobileController.text = resp.data.mobile;
//      selectedDialogCountryForMobile =
//          CountryPickerUtils.getCountryByPhoneCode(resp.data.countryCode);
//      _whatsAppMobileController.text = resp.data.whatsapp;
//      if (!isNullEmptyOrFalse(resp.data.whatsappCounCode)) {
//        selectedDialogCountryForWhatsapp =
//            CountryPickerUtils.getCountryByPhoneCode(
//                resp.data.whatsappCounCode);
//      }
//
//      _emailController.text = resp.data.email;
//      image = resp.data.profileImage;
//      _countryController.text = resp.data.country;
//      _stateController.text = resp.data.state;
//      _cityController.text = resp.data.city;
//      companyInformationState.pinCodeController.text = resp.data.zipcode;
//      _skypeController.text = resp.data.skype;
//      setState(() {});
//    }).catchError((onError) {
//      app.resolve<CustomDialogs>().confirmDialog(
//            context,
//            desc: onError.message,
//            positiveBtnTitle: R.string.commonString.btnTryAgain,
//          );
//    });
//  }
//}
