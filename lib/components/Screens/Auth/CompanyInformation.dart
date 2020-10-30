import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Auth/CompanyInformationModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompanyInformation extends StatefulWidget {
  static const route = "CompanyInformation";

  @override
  _CompanyInformationState createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation>
    with AutomaticKeepAliveClientMixin<CompanyInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _CompanyNameController = TextEditingController();
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
  final TextEditingController _companyCodeController = TextEditingController();
  final TextEditingController _whatsAppMobileController =
      TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  Country selectedDialogCountryForMobile =
      CountryPickerUtils.getCountryByIsoCode("US");
  Country selectedDialogCountryForWhatsapp =
      CountryPickerUtils.getCountryByIsoCode("US");

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
  List<CityList> cityList = List<CityList>();
  CityList selectedCityItem = CityList();
  List<CountryList> countryList = List<CountryList>();
  CountryList selectedCountryItem = CountryList();
  List<StateList> stateList = List<StateList>();
  StateList selectedStateItem = StateList();
  List<SelectionPopupModel> businessTypeList = List<SelectionPopupModel>();
  SelectionPopupModel selectedBusinessType;

  @override
  void initState() {
    super.initState();
    _callApiForCountryList();
    getBusinessType();
  }

  getBusinessType() async {
    var arrMaster = await AppDatabase.instance.masterDao
        .getSubMasterFromCode(BUSINESS_TYPE);
    for (var master in arrMaster) {
      businessTypeList.add(SelectionPopupModel(master.sId, master.getName(),
          isSelected: master.isDefault));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
//        appBar: getAppBar(
//          context,
//          "Company Information",
//          bgColor: appTheme.whiteColor,
//          leadingButton: getBackButton(context),
//          centerTitle: false,
//        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            top: getSize(10),
            bottom: getSize(16),
            right: getSize(20),
            left: getSize(20),
          ),
          child: Container(
            // padding: EdgeInsets.symmetric(vertical: getSize(30)),
//          margin: EdgeInsets.only(top: getSize(15), left: getSize(0)),
//          decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
            child: AppButton.flat(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (countrySelect()) {
                    if (stateSelect()) {
                      if (citySelect()) {
                        callCompanyInformationApi();
                      } else {
                        showToast(R.string().commonString.cityFirst,
                            context: context);
                      }
                    } else {
                      showToast(R.string().commonString.stateFirst,
                          context: context);
                    }
                  } else {
                    showToast(R.string().commonString.countryFirst,
                        context: context);
                  }

                  //isProfileImageUpload ? uploadDocument() : callApi();
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
              text: R.string().authStrings.saveCompanyDetails,
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
                  getCompanyNameTextField(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  popupList(businessTypeList, (value) {
                    _businessTypeController.text = value;
                  }),
//                  getBusinessTypeDropDown(),
                  SizedBox(
                    height: getSize(20),
                  ),
                  getAddressLineOneTextField(),
//                  SizedBox(
//                    height: getSize(20),
//                  ),
//                  getAddressLineTwoTextField(),
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
        hintText: R.string().authStrings.companyCode,
        maxLine: 1,
        prefixWid: getCommonIconWidget(
            imageName: pincode,
            imageType: IconSizeType.small,
            color: Colors.black),
        keyboardType: TextInputType.text,
        inputController: _companyCodeController,
      ),
      textCallback: (text) async {
//          await checkValidation();
      },
      validation: (text) {
        if (text.isEmpty) {
          return R.string().errorString.pleaseEnterCompanyCode;
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
            hintText: R.string().commonString.lblPinCode + "*",
            maxLine: 1,
            prefixWid: getCommonIconWidget(
                imageName: pincode,
                imageType: IconSizeType.small,
                color: Colors.black),
            formatter: [
              BlacklistingTextInputFormatter(new RegExp(RegexForTextField))
            ],
            keyboardType: TextInputType.number,
            inputController: _pinCodeController,
            isSecureTextField: false),
        textCallback: (text) {
//          setState(() {
//            checkValidation();
//          });
        },
        validation: (text) {
          if (text.isEmpty) {
            return R.string().errorString.enterPinCode;
          } else if (!validatePincode(text)) {
            return R.string().errorString.enterValidPinCode;
          } else {
            return null;
          }
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
        hintText: R.string().authStrings.companyName + R.string().authStrings.requiredField,
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
          return R.string().authStrings.enterCompanyName;
        } else {
          return null;
        }
        // }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusCompanyName.unfocus();
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
          //  WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
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
//        fieldFocusChange(context, _focusAddressLineTwo);
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
          // WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
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
        _focusAddressLineTwo.unfocus();
      },
    );
  }

  getCountryDropDown() {
    return InkWell(
      onTap: () {
        if (countryList == null || countryList.length == 0) {
          _callApiForCountryList(isShowDialogue: true);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(getSize(25)),
                ),
                child: DialogueList(
                  type: DialogueListType.Country,
                  selectedItem: selectedCountryItem,
                  duplicateItems: countryList,
                  applyFilterCallBack: (
                      {CityList cityList,
                      CountryList countryList,
                      StateList stateList,
                      SavedSearchModel savedSearchModel,}) {
                    if (_countryController.text != countryList.name) {
                      _stateController.text = "";
                      _cityController.text = "";
                      this.cityList.clear();
                      this.stateList.clear();
                    }
                    selectedCountryItem = countryList;
                    _countryController.text = countryList.name;
                    _callApiForStateList(countryId: countryList.id);
                  },
                ),
              );
            },
          );
        }
      },
      child: CommonTextfield(
          focusNode: _focusCountry,
          enable: false,
          textOption: TextFieldOption(
              hintText: R.string().commonString.lblCountry,
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
        if (countrySelect()) {
          if (stateList == null || stateList.length == 0) {
            _callApiForStateList(
                countryId: selectedCountryItem.id, isShowDialogue: true);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(getSize(25)),
                      ),
                      child: DialogueList(
                        type: DialogueListType.State,
                        selectedItem: selectedStateItem,
                        duplicateItems: stateList,
                        applyFilterCallBack: (
                            {CityList cityList,
                            CountryList countryList,
                            StateList stateList,
                            SavedSearchModel savedSearchModel,}) {
                          if (_stateController.text != stateList.name) {
                            _cityController.text = "";
                            this.cityList.clear();
                          }
                          selectedStateItem = stateList;
                          _stateController.text = stateList.name;
                          _callApiForCityList(
                              countryId: selectedCountryItem.id,
                              stateId: stateList.id);
                        },
                      ));
                });
          }
        } else {
          showToast(R.string().commonString.countryFirst, context: context);
        }
      },
      child: CommonTextfield(
          focusNode: _focusState,
          enable: false,
          textOption: TextFieldOption(
              hintText: R.string().commonString.lblState,
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
        FocusScope.of(context).unfocus();
        if (countrySelect()) {
          if (stateSelect()) {
            if (cityList == null || cityList.length == 0) {
              _callApiForCityList(
                  countryId: selectedCountryItem.id,
                  stateId: selectedStateItem.id,
                  isShowDialogue: true);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getSize(25)),
                        ),
                        child: DialogueList(
                          type: DialogueListType.City,
                          selectedItem: selectedCityItem,
                          duplicateItems: cityList,
                          applyFilterCallBack: (
                              {CityList cityList,
                              CountryList countryList,
                              StateList stateList,
                              SavedSearchModel savedSearchModel,}) {
                            selectedCityItem = cityList;
                            _cityController.text = cityList.name;
                          },
                        ));
                  });
            }
          } else {
            showToast(R.string().commonString.stateFirst, context: context);
          }
        } else {
          showToast(R.string().commonString.countryFirst, context: context);
        }
      },
      child: CommonTextfield(
          focusNode: _focusCity,
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: city, imageType: IconSizeType.small),
              hintText: R.string().commonString.lblCity,
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
    return AbsorbPointer(
      child: GestureDetector(
//        onTap: () {
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return Dialog(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(getSize(25)),
//                    ),
//                    child: DialogueList(
//                      type: DialogueListType.BusinessType,
//                      selectedItem: selectedBusinessType,
//                      duplicateItems: businessTypeList,
//                      applyFilterCallBack: (
//                          {CityList cityList,
//                            CountryList countryList,
//                            StateList stateList,
//                            SavedSearchModel savedSearchModel}) {
//                      _businessTypeController.text =
//                      },
//                    ));
//              });
//        },
        child: CommonTextfield(
            focusNode: _focusBusinessType,
            enable: false,
            textOption: TextFieldOption(
                prefixWid: getCommonIconWidget(
                    imageName: city, imageType: IconSizeType.small),
                hintText: R.string().commonString.selectBusinessType,
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
      ),
    );
  }

  Widget popupList(
          List<SelectionPopupModel> backPerList, Function(String) selectedValue,
          {bool isPer = false}) =>
      PopupMenuButton<String>(
        shape: TooltipShapeBorder(arrowArc: 0.5),
        onSelected: (newValue) {
          // add this property
          selectedValue(newValue);
        },
        itemBuilder: (context) => [
          for (var item in backPerList) getPopupItems(item.title),
          PopupMenuItem(
            height: getSize(30),
            value: "Start",
            child: SizedBox(),
          ),
        ],
        child: getBusinessTypeDropDown(),
        offset: Offset(25, 110),
      );

  getPopupItems(
    String per,
  ) {
    return PopupMenuItem(
      value: per,
      height: getSize(20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: getSize(10)),
        width: MathUtilities.screenWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              per,
              style: appTheme.black16TextStyle,
            )
          ],
        ),
      ),
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
      cityList.addAll(resp.data);
      if (isShowDialogue) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: DialogueList(
                    type: DialogueListType.City,
                    selectedItem: selectedCityItem,
                    duplicateItems: cityList,
                    applyFilterCallBack: (
                        {CityList cityList,
                        CountryList countryList,
                        StateList stateList,
                        SavedSearchModel savedSearchModel,}) {
                      selectedCityItem = cityList;
                      _cityController.text = cityList.name;
                    },
                  ));
            });
      }
    }).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
            onClickCallback: (PositveButtonClick) {
          _callApiForCityList(stateId: stateId, countryId: countryId);
        })
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
      countryList.addAll(resp.data);
      getCompanyInformation();
      if (isShowDialogue) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: DialogueList(
                    type: DialogueListType.Country,
                    selectedItem: selectedCountryItem,
                    duplicateItems: countryList,
                    applyFilterCallBack: (
                        {CityList cityList,
                        CountryList countryList,
                        StateList stateList,
                        SavedSearchModel savedSearchModel,}) {
                      if (_countryController.text != countryList.name) {
                        _stateController.text = "";
                        _cityController.text = "";
                        selectedStateItem = null;
                        selectedCityItem = null;
                        this.cityList.clear();
                        this.stateList.clear();
                      }
                      selectedCountryItem = countryList;
                      _countryController.text = countryList.name;
                      _callApiForStateList(countryId: countryList.id);
                    },
                  ));
            });
      }
    }).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(
          context,
          title: R.string().commonString.error,
          desc: onError.message,
          positiveBtnTitle: R.string().commonString.btnTryAgain,
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
      stateList.addAll(resp.data);
      if (isShowDialogue) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: DialogueList(
                    type: DialogueListType.State,
                    selectedItem: selectedStateItem,
                    duplicateItems: stateList,
                    applyFilterCallBack: (
                        {CityList cityList,
                        CountryList countryList,
                        StateList stateList,
                        SavedSearchModel savedSearchModel,}) {
                      if (_stateController.text != stateList.name) {
                        _cityController.text = "";
                        selectedCityItem = null;
                        this.cityList.clear();
                      }
                      selectedStateItem = stateList;
                      _stateController.text = stateList.name;
                      _callApiForCityList(
                          countryId: selectedCountryItem.id,
                          stateId: stateList.id);
                    },
                  ));
            });
      }
    }).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
            onClickCallback: (PositveButtonClick) {
          _callApiForStateList(countryId: countryId);
        })
      },
    );
  }

  callCompanyInformationApi() async {
    CompanyInformationReq req = CompanyInformationReq();
    req.companyName = _CompanyNameController.text;
    req.country = selectedCountryItem.id;
    req.state = selectedStateItem.id;
    req.city = selectedCityItem.id;
    req.address =
        _addressLineOneController.text + " " + _addressLineTwoController.text;
    req.vendorCode = _companyCodeController.text;
    businessTypeList.forEach((element) {
      if (element.title == _businessTypeController.text.trim()) {
        req.businessType = element.id;
      }
    });
    req.zipCode = _pinCodeController.text;
    req.sId = app.resolve<PrefUtils>().getUserDetails().id;

    NetworkCall<CompanyInformationViewResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .companyInformation(req),
            context,
            isProgress: true)
        .then((resp) async {
      User user = app.resolve<PrefUtils>().getUserDetails();
      user.account = resp.data;
      app.resolve<PrefUtils>().saveUser(user);
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.successfully,
            desc: resp.message,
            positiveBtnTitle: R.string().commonString.ok,
          );
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
          );
    });
  }

  getCompanyInformation() async {
    NetworkCall<CompanyInformationViewResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .companyInformationView(),
            context,
            isProgress: true)
        .then((resp) async {
      if (resp.data != null) {
        _CompanyNameController.text = resp.data.companyName;
        _addressLineOneController.text = resp.data.address;
        _companyCodeController.text = resp.data.vendorCode;
        businessTypeList.forEach((element) {
          if (element.id == resp.data.businessType) {
            _businessTypeController.text = element.title;
          }
        });
        _pinCodeController.text = resp.data.zipCode;
        _countryController.text = resp.data.country.name;
        _cityController.text = resp.data.city.name;
        _stateController.text = resp.data.state.name;
        selectedCountryItem = resp.data.country;
        selectedCityItem = resp.data.city;
        selectedStateItem = resp.data.state;
        setState(() {});
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

  @override
  bool get wantKeepAlive => true;
}
