import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/Uploadmanager.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/material.dart';

class UploadKYCScreen extends StatefulScreenWidget {
  static const route = "uploadkyc";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends StatefulScreenWidgetState {
  File imgPhotoProof, imgBussinessProff;
  bool isFromDrawer = false;
  String photoErr, bussinessErr;
  List<Documents> document = List<Documents>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context,
        R.string().authStrings.uploadKYC,
        bgColor: appTheme.whiteColor,
        leadingButton: isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
        centerTitle: false,
      ),
      bottomNavigationBar: getBottomStickyButton(),
      body: new ListView(
        children: <Widget>[
          getUploadDocSection(R.string().authStrings.hintPhotoIdentityProof,
              DocumentType.PhotoProof, photoCard, imgPhotoProof, photoErr),
          getUploadDocSection(
            R.string().authStrings.hintBussinerssProof,
            DocumentType.BussinessProof,
            bussinessCard,
            imgBussinessProff,
            bussinessErr,
          ),
        ],
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
            if (imgPhotoProof == null) {
              setState(() {
                photoErr = R.string().authStrings.pleaseUploadPhotoProof;
              });
              return;
            }
            if (imgBussinessProff == null) {
              setState(() {
                bussinessErr =
                    R.string().authStrings.pleaseUploadBussinessProof;
              });
              return;
            }

            app.resolve<CustomDialogs>().confirmDialog(context,
                title: R.string().authStrings.kycSubmitted,
                desc: R.string().authStrings.kycSubmmittedDesc,
                positiveBtnTitle: R.string().authStrings.btnMoveToHome,
                onClickCallback: (click) {
              if (click == ButtonType.PositveButtonClick) {
                AppNavigation.shared.movetoHome(isPopAndSwitch: true);
              }
            });
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
                        Text(
                          title,
                          style: AppTheme.of(context)
                              .theme
                              .textTheme
                              .display2
                              .copyWith(
                                color: appTheme.bodyTextColor,
                                fontSize: getSize(14),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
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

  openImagePickerDocuments(DocumentType type) {
    openFilePicker(context, (image) {
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
}
