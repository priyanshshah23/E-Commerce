import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/network/Uploadmanager.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/material.dart';

class UploadKYCScreen extends StatefulScreenWidget {
  static const route = "uploadkyc";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;

  @override
  _UploadKYCScreenState createState() => _UploadKYCScreenState(
        moduleType,
        isFromDrawer,
      );

  UploadKYCScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }
}

class _UploadKYCScreenState extends StatefulScreenWidgetState {
  int moduleType;
  File imgPhotoProof, imgBussinessProff;
  bool isFromDrawer = false;
  String photoErr, bussinessErr;
  List<Documents> document = List<Documents>();

  TextEditingController _photoProofTextField = TextEditingController();
  TextEditingController _businessProofTextField = TextEditingController();

  FocusNode _focusPhotoProof = FocusNode();
  FocusNode _focusBusinessProof = FocusNode();

  bool _isPhotoSelected = false;
  bool _isBusinessProofSelected = true;
  bool _autoValidate = false;

  final _formKey = GlobalKey<FormState>();

  List<SelectionPopupModel> arrPhotos = [];
  List<SelectionPopupModel> arrBusiness = [];

  _UploadKYCScreenState(this.moduleType, this.isFromDrawer);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMasters();
    });
  }

  getMasters() async {
    Master.getSubMaster(MasterCode.docTypePersonal).then((arrMaster) {
      arrMaster.forEach((element) {
        arrPhotos.add(SelectionPopupModel(
          element.sId,
          element.name,
        ));
      });
    });
    Master.getSubMaster(MasterCode.docTypeBusiness).then((arrMaster) {
      arrMaster.forEach((element) {
        arrBusiness.add(SelectionPopupModel(
          element.sId,
          element.name,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, R.string().authStrings.uploadKYC,
          bgColor: appTheme.whiteColor,
          leadingButton: isFromDrawer ? null : getBackButton(context),
          centerTitle: false,
          actionItems: [
            isFromDrawer
                ? InkWell(
                    onTap: () {
                      logoutFromApp(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: getSize(16.0)),
                      child: Container(
                          child: Image.asset(logout,
                              width: getSize(24), height: getSize(24))),
                    ))
                : SizedBox()
          ]),
      bottomNavigationBar: getBottomStickyButton(),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: getSize(16)),
            Padding(
              padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
              child: Text(R.string().authStrings.hintPhotoIdentityProof,
                  style: appTheme.black18TextStyle),
            ),
            SizedBox(height: getSize(16)),
            getPhotoProofTextField(),
            getUploadDocSection(R.string().authStrings.hintPhotoIdentityProof,
                DocumentType.PhotoProof, photoCard, imgPhotoProof, photoErr),
            Divider(height: getSize(1), color: appTheme.borderColor),
            SizedBox(height: getSize(16)),
            Padding(
              padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
              child: Text(R.string().authStrings.hintBussinerssProof,
                  style: appTheme.black18TextStyle),
            ),
            SizedBox(height: getSize(16)),
            getBusinessProofTextField(),
            getUploadDocSection(
              R.string().authStrings.hintBussinerssProof,
              DocumentType.BussinessProof,
              bussinessCard,
              imgBussinessProff,
              bussinessErr,
            ),
          ],
        ),
      ),
    );
  }

  getBottomStickyButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(10),
        bottom: getSize(16),
        right: getSize(20),
        left: getSize(20),
      ),
      child: Container(
        child: AppButton.flat(
          onTap: () async {
            bool isValid = true;
            if (!_formKey.currentState.validate()) {
              isValid = false;
              setState(() {
                _autoValidate = true;
              });
            }

            if (imgPhotoProof == null) {
              isValid = false;
              setState(() {
                photoErr = R.string().authStrings.pleaseUploadPhotoProof;
              });
            }
            if (imgBussinessProff == null) {
              isValid = false;
              setState(() {
                bussinessErr =
                    R.string().authStrings.pleaseUploadBussinessProof;
              });
            }
            if (isValid == true) {
              callApiForUploadKyc();
            }
          },
          backgroundColor: appTheme.colorPrimary.withOpacity(0.1),
          textColor: appTheme.colorPrimary,
          borderRadius: getSize(5),
          fitWidth: true,
          text: R.string().commonString.save,
          //isButtonEnabled: enableDisableSigninButton(),
        ),
      ),
    );
  }

  getUploadDocSection(String title, DocumentType type, String imageIcon,
      File imageFile, String errorMsg) {
    return GestureDetector(
      onTap: () async {
        openImagePickerDocuments(type);
      },
      child: Padding(
        padding: EdgeInsets.all(
          getSize(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: getSize(116),
                  width: (MathUtilities.screenWidth(context) / 2) - getSize(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        getSize(5),
                      ),
                    ),
                    border: Border.all(
                      color: !isNullEmptyOrFalse(errorMsg)
                          ? appTheme.redColor
                          : appTheme.borderColor,
                      width: getSize(1),
                    ),
                  ),
                  child: imageFile != null && isImageFile(imageFile)
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              getSize(5),
                            ),
                          ),
                          child: Image.file(
                            imageFile,
                            height: getSize(116),
                            width: (MathUtilities.screenWidth(context) / 2) -
                                getSize(0),
                            fit: BoxFit.fill,
                          ),
                        )
                      : imageFile != null
                          ? Center(
                              child: Image.asset(
                              pdfIcon,
                              width: getSize(60),
                              height: getSize(60),
                              fit: BoxFit.contain,
                            ))
                          : Center(
                              child: Image.asset(
                              imageIcon,
                              width: getSize(40),
                              height: getSize(40),
                              fit: BoxFit.contain,
                            )),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: getSize(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   title,
                        //   style: AppTheme.of(context)
                        //       .theme
                        //       .textTheme
                        //       .display2
                        //       .copyWith(
                        //         color: appTheme.bodyTextColor,
                        //         fontSize: getSize(14),
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        // ),
                        Container(
                          height: getSize(32),
                          margin: EdgeInsets.only(
                            top: getSize(8),
                          ),
                          decoration: BoxDecoration(
                              color: appTheme.colorPrimary,
                              borderRadius: BorderRadius.circular(
                                getSize(5),
                              ),
                              boxShadow: getBoxShadow(context)),
                          child: Center(
                            child: Text(
                              R.string().authStrings.btnFileUpload,
                              textAlign: TextAlign.center,
                              style: appTheme.white16TextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isNullEmptyOrFalse(errorMsg))
              Padding(
                padding: EdgeInsets.only(
                  top: getSize(5),
                ),
                child: Text(
                  errorMsg,
                  style: AppTheme.of(context).theme.textTheme.display2.copyWith(
                        color: appTheme.redColor,
                        fontSize: getSize(14),
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  getPhotoProofTextField() {
    return Padding(
      padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
      child: CommonTextfield(
          focusNode: _focusPhotoProof,
          readOnly: true,
          textOption: TextFieldOption(
              errorBorder: _isPhotoSelected
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
              hintText: R.string().commonString.selectPhotoProof,
              maxLine: 1,
              prefixWid: getCommonIconWidget(
                  imageName: country, imageType: IconSizeType.small),
              type: TextFieldType.DropDown,
              keyboardType: TextInputType.text,
              inputController: _photoProofTextField,
              isSecureTextField: false),
          inputAction: TextInputAction.next,
          tapCallback: () {
            print("Tapped");
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
                    title: R.string().commonString.selectPhotoProof,
                    isSearchEnable: false,
                    selectionOptions: arrPhotos,
                    applyFilterCallBack: (
                        {SelectionPopupModel selectedItem,
                        List<SelectionPopupModel> multiSelectedItem}) {
                      arrPhotos.forEach((value) => value.isSelected = false);
                      arrPhotos
                          .firstWhere((value) => value == selectedItem)
                          .isSelected = true;
                      _photoProofTextField.text = selectedItem.title;
                    },
                  ),
                );
              },
            );
          },
          textCallback: (String text) {},
          validation: (text) {
            if (text.isEmpty) {
              _isPhotoSelected = false;
              return R.string().commonString.pleaseSelectPhotoProof;
            }
            /* else if(!validateStructure(text)) {
          return R.string().errorString.wrongPassword;
        } */
            else {
              return null;
            }
          },
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getBusinessProofTextField() {
    return Padding(
      padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
      child: CommonTextfield(
        focusNode: _focusBusinessProof,
        readOnly: true,
        textOption: TextFieldOption(
            errorBorder: _isBusinessProofSelected
                ? null
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
            hintText: R.string().commonString.selectBusinessProof,
            maxLine: 1,
            prefixWid: getCommonIconWidget(
                imageName: country, imageType: IconSizeType.small),
            type: TextFieldType.DropDown,
            keyboardType: TextInputType.text,
            inputController: _businessProofTextField,
            isSecureTextField: false),
        inputAction: TextInputAction.next,
        onNextPress: () {
          FocusScope.of(context).unfocus();
        },
        tapCallback: () {
          print("Tapped");
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
                  title: R.string().commonString.selectBusinessProof,
                  selectionOptions: arrBusiness,
                  isSearchEnable: false,
                  applyFilterCallBack: (
                      {SelectionPopupModel selectedItem,
                      List<SelectionPopupModel> multiSelectedItem}) {
                    arrBusiness.forEach((value) => value.isSelected = false);
                    arrBusiness
                        .firstWhere((value) => value == selectedItem)
                        .isSelected = true;
                    _businessProofTextField.text = selectedItem.title;
                  },
                ),
              );
            },
          );
        },
        validation: (text) {
          if (text.isEmpty) {
            _isBusinessProofSelected = false;
            return R.string().commonString.pleaseSelectBusinessProof;
          }
          /* else if(!validateStructure(text)) {
          return R.string().errorString.wrongPassword;
        } */
          else {
            return null;
          }
        },
        textCallback: (String text) {},
      ),
    );
  }

  openImagePickerDocuments(DocumentType type) {
    openImagePicker(context, (image) {
      if (image == null) {
        return;
      }

      if (isSupportedFile(image)) {
        uploadFile(context, "", file: image).then((result) {
          if (result.code == CODE_OK) {
            String imgPath =
                result.detail.files != null && result.detail.files.length > 0
                    ? result.detail.files.first.absolutePath
                    : "";
            if (isNullEmptyOrFalse(imgPath) == false) {
              //
              if (type == DocumentType.PhotoProof) {
                var filter = document?.firstWhere(
                    (value) => value.type == DocumentsConstants.PhotoProof,
                    orElse: () => null);

                if (filter == null) {
                  document.add(Documents(
                      type: DocumentsConstants.PhotoProof,
                      fileUrl: imgPath,
                      fileImage: imgPath));
                } else {
                  var filter = document.firstWhere(
                      (value) => value.type == DocumentsConstants.PhotoProof);
                  filter.fileUrl = imgPath;
                  filter.fileImage = imgPath;
                }

                setState(() {
                  imgPhotoProof = image;
                  photoErr = null;
                });
              } else if (type == DocumentType.BussinessProof) {
                var filter = document?.firstWhere(
                    (value) => value.type == DocumentsConstants.BussinessProof,
                    orElse: () => null);

                if (filter == null) {
                  document.add(Documents(
                      type: DocumentsConstants.BussinessProof,
                      fileUrl: imgPath,
                      fileImage: imgPath));
                } else {
                  var filter = document.firstWhere((value) =>
                      value.type == DocumentsConstants.BussinessProof);
                  filter.fileUrl = imgPath;
                  filter.fileImage = imgPath;
                }

                setState(() {
                  imgBussinessProff = image;
                  bussinessErr = null;
                });
              }
            }
          }
        });
      } else {
        setState(() {
          if (type == DocumentType.PhotoProof) {
            imgPhotoProof = null;
            photoErr = !isSupportedFile(image)
                ? R.string().authStrings.pleaseSelectFileFormat
                : null;
          } else if (type == DocumentType.BussinessProof) {
            imgBussinessProff = null;
            bussinessErr = !isSupportedFile(image)
                ? R.string().authStrings.pleaseSelectFileFormat
                : null;
          }
        });
      }
    });
  }

  isImageFile(File file) {
    var fileExt = file.path.split('/').last?.split('.')?.last;

    return (fileExt != null &&
        ['png', 'jpg', 'jpeg'].contains(fileExt.toLowerCase()));
  }

  isSupportedFile(File file) {
    var fileExt = file.path.split('/').last?.split('.')?.last;

    return (fileExt != null &&
        ['png', 'jpg', 'jpeg', 'pdf'].contains(fileExt.toLowerCase()));
  }

  callApiForUploadKyc() {
    Map<String, dynamic> dict = {};
    var filter = document
        .firstWhere((value) => value.type == DocumentsConstants.PhotoProof);
    var filter2 = document
        .firstWhere((value) => value.type == DocumentsConstants.BussinessProof);

    dict["kyc"] = [
      {
        "docType": arrPhotos.singleWhere((element) => element.isSelected).id,
        "path": filter.fileUrl,
      },
      {
        "docType": arrBusiness.singleWhere((element) => element.isSelected).id,
        "path": filter2.fileUrl,
      }
    ];
    dict["isKycUploaded"] = true;

    User userData = app.resolve<PrefUtils>().getUserDetails();
    app.resolve<CustomDialogs>().showProgressDialog(context, "");

    NetworkClient.getInstance.callApi(context, baseURL,
        ApiConstants.uploadKyc + userData.account.id ?? "", MethodType.Put,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        params: dict, successCallback: (response, message) {
      app.resolve<CustomDialogs>().hideProgressDialog();
      userData.account = Account.fromJson(response);

      app.resolve<PrefUtils>().saveUser(userData);
      app.resolve<CustomDialogs>().confirmDialog(context,
          title: R.string().authStrings.kycSubmitted,
          desc: R.string().authStrings.kycSubmmittedDesc,
          positiveBtnTitle: R.string().authStrings.btnMoveToHome,
          onClickCallback: (click) {
        if (click == ButtonType.PositveButtonClick) {
          AppNavigation.shared.movetoHome(isPopAndSwitch: true);
        }
      });
    }, failureCallback: (status, message) {
      app.resolve<CustomDialogs>().hideProgressDialog();
      print(message);
      app.resolve<CustomDialogs>().confirmDialog(context,
          title: R.string().commonString.error,
          desc: message,
          positiveBtnTitle: R.string().commonString.ok,
          onClickCallback: (click) {});
    });
  }
}
