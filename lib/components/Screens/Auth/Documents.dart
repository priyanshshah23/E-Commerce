import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/network/Uploadmanager.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImagePicker.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/widgets/shared/CountryPickerWidget.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Auth/PersonalInformationModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Documents extends StatefulWidget {
  static const route = "Documents";

  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents>
    with AutomaticKeepAliveClientMixin<Documents> {
  List<Kyc> kycList = List<Kyc>();
  BaseList kycBaseList;

  @override
  void initState() {
    super.initState();
    // _callApiForCountryList();
    kycBaseList = BaseList(BaseListState(
//      imagePath: noRideHistoryFound,
      noDataMsg: APPNAME,
      noDataDesc: R.string.commonString.noDocument,
      refreshBtn: R.string.commonString.refresh,
      enablePullDown: true,
      enablePullUp: true,
      onPullToRefress: () {
        getDocuments(true);
      },
      onRefress: () {
        getDocuments(true);
      },
      onLoadMore: () {
        getDocuments(false, isLoading: true);
      },
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDocuments(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kycList.length <= 0) {
      getDocuments(false);
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
//        appBar: getAppBar(
//          context,
//          "Personal Information",
//          bgColor: appTheme.whiteColor,
//          leadingButton: getBackButton(context),
//          centerTitle: false,
//        ),
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: false,
//        bottomNavigationBar:  Padding(
//          padding: EdgeInsets.only(top: getSize(10), bottom: getSize(16), right: getSize(20), left: getSize(20),),
//          child: Container(
//            // padding: EdgeInsets.symmetric(vertical: getSize(30)),
////          margin: EdgeInsets.only(top: getSize(15), left: getSize(0)),
////          decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
//            child: AppButton.flat(
//              onTap: () async {
//                FocusScope.of(context).unfocus();
//                if (_formKey.currentState.validate()) {
//                  _formKey.currentState.save();
//                  if(_mobileController.text.isNotEmpty || _whatsAppMobileController.text.isNotEmpty){
//                    if(await checkValidation()) {
//                      if(isProfileImageUpload) {
//                        uploadDocument();
//                      } else {
//                        callDocumentsApi();
//                      }
//                    }
//                  }
//                  //isProfileImageUpload ? uploadDocument() : callApi();
//                } else {
//                  setState(() {
//                    _autoValidate = true;
//                  });
//                }
//                // NavigationUtilities.push(ThemeSetting());
//              },
//              backgroundColor: appTheme.colorPrimary.withOpacity(0.1),
//              textColor: appTheme.colorPrimary,
//              borderRadius: getSize(5),
//              fitWidth: true,
//              text: R.string.authStrings.editProfileTitle,
//              //isButtonEnabled: enableDisableSigninButton(),
//            ),
//          ),
//        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getSize(20), vertical: getSize(30)),
          child: kycBaseList,
        ),
      ),
    );
  }

  uploadProfileImage(File imgFile, Function imagePath) async {
    await uploadFile(
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
          //  callDocumentsApi(imagePath: imgPath);
        }
      }
      return;
    });
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

//  callDocumentsApi({String imagePath}) async {
//    PersonalInformationReq req = PersonalInformationReq();
//    req.id = app.resolve<PrefUtils>().getUserDetails().id;
//    req.address = _addressLineOneController.text;
//    req.firstName = _firstNameController.text;
//    req.lastName = _lastNameController.text;
//    req.mobile = _mobileController.text;
//    req.countryCode = selectedDialogCountryForMobile.phoneCode;
//    req.whatsapp = _whatsAppMobileController.text;
//    req.whatsappCounCode = selectedDialogCountryForWhatsapp.phoneCode;
//    req.email = _emailController.text.trim();
//    if(imagePath != null) {
//      req.profileImage = imagePath;
//    }
//
//    NetworkCall<PersonalInformationViewResp>()
//        .makeCall(
//            () => app.resolve<ServiceModule>().networkService().personalInformation(req),
//        context,
//        isProgress: true)
//        .then((resp) async {
//      app.resolve<PrefUtils>().saveUser(resp.data);
//      app.resolve<CustomDialogs>().confirmDialog(
//        context,
//        title: R.string.commonString.successfully,
//        desc: resp.message,
//        positiveBtnTitle: R.string.commonString.ok,
//      );
//    }).catchError((onError) {
//      app.resolve<CustomDialogs>().confirmDialog(
//        context,
//        title: R.string.commonString.error,
//        desc: onError.message,
//        positiveBtnTitle: R.string.commonString.btnTryAgain,
//      );
//    });
//  }

  getDocuments(bool isRefress, {bool isLoading = false}) async {
    if (isRefress) {
      kycList.clear();
    }

    NetworkCall<PersonalInformationViewResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .personalInformationView(),
            context,
            isProgress: true)
        .then((resp) async {
      if (resp.data != null &&
          resp.data.account != null &&
          resp.data.account.kyc != null) {
        kycList.clear();
        kycList.addAll(resp.data.account.kyc);
        kycBaseList.state.listCount = resp.data.account.kyc.length;
        kycBaseList.state.totalCount = resp.data.account.kyc.length;
        fillArrayList();
        kycBaseList.state.setApiCalling(false);
        setState(() {});
      }
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
           
            desc: onError.message,
            positiveBtnTitle: R.string.commonString.btnTryAgain,
          );
    });
  }

  fillArrayList() {
    User userDetail = app.resolve<PrefUtils>().getUserDetails();
    kycBaseList.state.listItems = ListView.builder(
      itemCount: kycList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: getSize(20)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              getSize(10),
            ),
            border: Border.all(color: appTheme.textGreyColor),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: getSize(16), vertical: getSize(16)),
          child: userDetail.account.isApproved == KYCStatus.rejected
              ? Stack(
                  // fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Container(
                        child: getImageView(
                          kycList[index].path ?? "",
                          placeHolderImage: documentPlaceHolder,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("Rejected",
                            style:
                                appTheme.redPrimaryNormal14TitleColor.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: getFontSize(16),
                            )),
                      ),
                    ),
                  ],
                )
              : getImageView(kycList[index].path ?? "",
                  placeHolderImage: documentPlaceHolder,
                  fit: BoxFit.cover,
                  isFitApply: false),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
