import 'dart:io';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownLoadAndShareScreen extends StatefulWidget {
  String title = "";
  List<DiamondModel> diamondList;
  bool isFromDetailScreen = false;

  Function(List<SelectionPopupModel>) onDownload;

  DownLoadAndShareScreen({
    this.title,
    this.diamondList,
    this.onDownload,
    this.isFromDetailScreen = false,
  });

  @override
  _DownLoadAndShareScreenState createState() => _DownLoadAndShareScreenState(
        title,
        diamondList: this.diamondList,
        onDownload: onDownload,
      );
}

class _DownLoadAndShareScreenState extends State<DownLoadAndShareScreen> {
  List<DiamondModel> diamondList;
  Function onDownload;

  String title = "";
  List<SelectionPopupModel> firstImageList = List<SelectionPopupModel>();
  List<SelectionPopupModel> secondImageList = List<SelectionPopupModel>();
  List<SelectionPopupModel> firstVideoList = List<SelectionPopupModel>();
  List<SelectionPopupModel> secondVideoList = List<SelectionPopupModel>();
  List<SelectionPopupModel> firstCertificateList = List<SelectionPopupModel>();
  List<SelectionPopupModel> firstExcelList = List<SelectionPopupModel>();
  List<SelectionPopupModel> secondCertificateList = List<SelectionPopupModel>();
  List<SelectionPopupModel> firstRoughList = List<SelectionPopupModel>();
  List<SelectionPopupModel> secondRoughList = List<SelectionPopupModel>();
  List<SelectionPopupModel> totalList;

  bool isAllImageSelected = false;
  bool isAllVideoSelected = false;
  bool isAllCertificateSelected = false;
  bool isAllExcelSelected = false;
  bool isAllRoughSelected = false;
  bool isAllSelected = false;
  bool isImageExpanded = true;
  bool isVideoExpanded = true;
  bool isCertificateExpanded = true;
  bool isExcelExpanded = true;
  bool isRoughExpanded = true;

  List<String> selectMenuString;

  _DownLoadAndShareScreenState(
    this.title, {
    this.diamondList,
    this.onDownload,
  });

  @override
  void initState() {
    setDataInList();
    super.initState();
  }

  checkValidation() {
    totalList = (firstImageList +
            secondImageList +
            firstVideoList +
            secondVideoList +
            firstCertificateList +
            secondCertificateList +
            firstExcelList)
        .where((element) {
      return element.isSelected;
    }).toList();
    List<String> data = [];
    diamondList.forEach(
      (element) async {
        await totalList.forEach(
          (v) {
            data.add(v.url + element.vStnId);
          },
        );
      },
    );
    selectMenuString = data;
    debugPrint("------------------------------${selectMenuString.toString()}");
    return !isNullEmptyOrFalse(totalList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(context, title,
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
          textalign: TextAlign.left,
          actionItems: [
            GestureDetector(
              onTap: () {
                isAllSelected = !isAllSelected;
                isAllImageSelected = isAllSelected;
                isAllVideoSelected = isAllSelected;
                isAllCertificateSelected = isAllSelected;
                isAllExcelSelected = isAllSelected;
                isAllRoughSelected = isAllSelected;
                firstImageList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                secondImageList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                firstVideoList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                secondVideoList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                firstExcelList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                firstCertificateList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                secondCertificateList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                firstRoughList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                secondRoughList.forEach((element) {
                  element.isSelected = isAllSelected;
                });
                setState(() {});
              },
              child: Padding(
                  padding:
                      EdgeInsets.only(right: getSize(8), left: getSize(16)),
                  child: Row(
                    children: [
                      Image.asset(
                        isAllSelected ? selectedCheckbox : unSelectedCheckbox,
                        height: getSize(20),
                        width: getSize(20),
                      ),
                      SizedBox(
                        width: getSize(5),
                      ),
                      Text(
                        "Select All",
                        style: appTheme.black12TextStyleBold,
                      ),
                    ],
                  )),
            )
          ]),
      bottomNavigationBar: Container(
        color: title == R.string.screenTitle.shareStone
            ? appTheme.whiteColor
            : appTheme.colorPrimary,
        padding: EdgeInsets.symmetric(
          horizontal: getSize(16),
          vertical: getSize(8),
        ),
        child: title == R.string.screenTitle.shareStone
            ? Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (checkValidation()) {
//                          whatsAppOpen();
                          openURLWithApp(
                              "whatsapp://send?phone=&text=${selectMenuString.map((e) => e.toString()).toList().join("\n\n")}",
                              context,
                              isPop: true);
                        } else {
                          app.resolve<CustomDialogs>().errorDialog(
                              context, title, "Please select any",
                              btntitle: R.string.commonString.ok);
//                          showToast("Please select any", context: context);
                        }
                      },
                      child: Container(
                        height: getSize(46),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(getSize(5)),
                        ),
                        child: Text(
                          "WhatsApp",
                          textAlign: TextAlign.center,
                          style: appTheme.white16TextStyle.copyWith(
                            color: appTheme.whatsAppColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(16),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        //callEmailApi();
                        if (checkValidation()) {
                          openURLWithApp(
                              "mailto:?subject=Diamond%20Details&body= Dear Sir / Madam Greetings of the day from Finestar Team. Please have a look at below stock file.\n\n${selectMenuString.map((e) => e.toString()).toList().join("\n\n")}",
//                              "mailto:?subject=DiamNow&body=DiamNow",
                              context,
                              isPop: true);
                          Navigator.pop(context);
                        } else {
                          app.resolve<CustomDialogs>().errorDialog(
                              context, title, "Please select any",
                              btntitle: R.string.commonString.ok);
                        }
                      },
                      child: Container(
                        height: getSize(46),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(getSize(5)),
                        ),
                        child: Text(
                          "Gmail",
                          textAlign: TextAlign.center,
                          style: appTheme.white16TextStyle.copyWith(
                            color: appTheme.gmailColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(16),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (checkValidation()) {
                          print(
                              "------------------skype:?chat=${selectMenuString.map((e) => e.toString()).toList().join("\n\n")}");
                          openURLWithApp(
                              "skype:?chat=${selectMenuString.map((e) => e.toString()).toList().join("\n\n")}",
                              context,
                              isPop: true);
                        } else {
                          app.resolve<CustomDialogs>().errorDialog(
                              context, title, "Please select any",
                              btntitle: R.string.commonString.ok);
                        }
                      },
                      child: Container(
                        height: getSize(46),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(getSize(5)),
                        ),
                        child: Text(
                          "Skype",
                          textAlign: TextAlign.center,
                          style: appTheme.white16TextStyle.copyWith(
                            color: appTheme.skypeColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getSize(46),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: appTheme.colorPrimary, width: getSize(1)),
                          borderRadius: BorderRadius.circular(getSize(5)),
                        ),
                        child: Text(
                          R.string.commonString.cancel,
                          textAlign: TextAlign.center,
                          style: appTheme.blue14TextStyle.copyWith(
                            fontSize: getFontSize(16),
                            color: appTheme.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(20),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onDownload((firstImageList +
                                secondImageList +
                                firstVideoList +
                                secondVideoList +
                                firstCertificateList +
                                secondCertificateList +
                                firstExcelList +
                                firstRoughList +
                                secondRoughList)
                            .where((element) {
                          return element.isSelected;
                        }).toList());
                      },
                      child: Container(
                        height: getSize(46),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: appTheme.whiteColor,
                            borderRadius: BorderRadius.circular(getSize(60)),
                            boxShadow: getBoxShadow(context)),
                        child: Text(
                          R.string.commonString.download,
                          textAlign: TextAlign.center,
                          style: appTheme.white16TextStyle
                              .copyWith(color: appTheme.colorPrimary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          getRowWithTitle(
              title: "Images",
              type: DownloadDataType.Images,
              firstList: firstImageList,
              secondList: secondImageList),
          getRowWithTitle(
              title: "Video",
              type: DownloadDataType.Video,
              firstList: firstVideoList,
              secondList: secondVideoList),
          getRowWithTitle(
              title: "Certificate",
              type: DownloadDataType.Certificate,
              firstList: firstCertificateList,
              secondList: secondCertificateList),
          getRowWithTitle(
              title: "Excel",
              type: DownloadDataType.Excel,
              firstList: firstExcelList),
          // getRowWithTitle(
          //     title: "Rough",
          //     type: DownloadDataType.Rough,
          //     firstList: firstRoughList,
          //     secondList: secondRoughList),
        ],
      ),
    );
  }

  _openMail() async {
    String uri = 'mailto:?subject=DiamNow&body=DiamNow';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string.commonString.error,
            desc: "Could not launch $uri",
            positiveBtnTitle: R.string.commonString.ok,
          );
    }
  }

//  callEmailApi() async {
//    ShareThroughEmailReq req = ShareThroughEmailReq();
//
//    NetworkCall<BaseApiResp>()
//        .makeCall(
//            () => app.resolve<ServiceModule>().networkService().shareThroughEmail(req),
//        context,
//        isProgress: true)
//        .then((resp) async {
//          showToast("Email Send Successfully");
//      Navigator.pop(context);
//    }).catchError((onError) {
//      app.resolve<CustomDialogs>().confirmDialog(
//        context,
//        title: R.string.commonString.error,
//        desc: onError.message,
//        positiveBtnTitle: R.string.commonString.btnTryAgain,
//      );
//    });
//  }

  getRowWithTitle(
      {String title,
      DownloadDataType type,
      List<SelectionPopupModel> firstList,
      List<SelectionPopupModel> secondList}) {
    bool titleBool;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getSize(16),
        vertical: getSize(10),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          getSize(15),
        ),
        border: Border.all(
          // horizontal: BorderSide(
          color: appTheme.borderColor,
          width: getSize(1),
          // ),
        ),
      ),
      // color: Colors.red,
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              if (type == DownloadDataType.Images) {
                this.isAllImageSelected = !this.isAllImageSelected;
                titleBool = isAllImageSelected;
              } else if (type == DownloadDataType.Video) {
                this.isAllVideoSelected = !this.isAllVideoSelected;
                titleBool = isAllVideoSelected;
              } else if (type == DownloadDataType.Excel) {
                this.isAllExcelSelected = !this.isAllExcelSelected;
                titleBool = isAllExcelSelected;
              } else if (type == DownloadDataType.Rough) {
                this.isAllRoughSelected = !this.isAllRoughSelected;
                titleBool = isAllRoughSelected;
              } else if (type == DownloadDataType.Certificate) {
                this.isAllCertificateSelected = !this.isAllCertificateSelected;
                titleBool = isAllCertificateSelected;
              }
              if (titleBool) {
                if (firstList != null)
                  firstList.forEach((element) {
                    element.isSelected = true;
                  });
                if (secondList != null)
                  secondList.forEach((element) {
                    element.isSelected = true;
                  });
              } else {
                if (firstList != null)
                  firstList.forEach((element) {
                    element.isSelected = false;
                  });
                if (secondList != null)
                  secondList.forEach((element) {
                    element.isSelected = false;
                  });
              }

              setState(() {});
            },
            child: Container(
              height: getSize(46),
              padding: EdgeInsets.symmetric(
                horizontal: getSize(16),
              ),
              // decoration: BoxDecoration(
              //   // color: appTheme.extraLightBGColor,
              //   border: Border.symmetric(
              //     horizontal: BorderSide(
              //       color: appTheme.borderColor,
              //       width: getSize(1),
              //     ),
              //   ),
              // ),
              child: Row(
                children: [
                  Container(
                    height: getSize(20),
                    width: getSize(20),
                    child: Image.asset(getConditionValue(type)
                        ? selectedFilter
                        : unselectedFilter),
                  ),
                  SizedBox(
                    width: getSize(10),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: appTheme.black16MediumTextStyle,
                    ),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        if (type == DownloadDataType.Images) {
                          this.isImageExpanded = !this.isImageExpanded;
                        } else if (type == DownloadDataType.Video) {
                          this.isVideoExpanded = !this.isVideoExpanded;
                        } else if (type == DownloadDataType.Excel) {
                          this.isExcelExpanded = !this.isExcelExpanded;
                        } else if (type == DownloadDataType.Rough) {
                          this.isRoughExpanded = !this.isRoughExpanded;
                        } else if (type == DownloadDataType.Certificate) {
                          this.isCertificateExpanded =
                              !this.isCertificateExpanded;
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getSize(10),
                      ),
                      child: Container(
                        height: getSize(16),
                        width: getSize(16),
                        child: Image.asset(
                            getExpandedValue(type) ? upArrow : downArrow),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (getExpandedValue(type))
            Padding(
              padding: EdgeInsets.only(
                  left: getSize(16), top: getSize(8), bottom: getSize(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  firstList != null
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount: firstList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      firstList[index].isSelected =
                                          !firstList[index].isSelected;
                                      if (!firstList[index].isSelected) {
                                        enableDisableValue(type, false);
                                      }
                                      var containFirst;
                                      var containSecond;
                                      if (firstList != null) {
                                        containFirst = firstList.where(
                                            (element) =>
                                                element.isSelected == false);
                                      }
                                      if (secondList != null) {
                                        containSecond = secondList.where(
                                            (element) =>
                                                element.isSelected == false);
                                      }
                                      if (containFirst != null &&
                                          containSecond != null) {
                                        if (containFirst.isEmpty &&
                                            containSecond.isEmpty) {
                                          enableDisableValue(type, true);
                                        }
                                      } else if (containFirst != null) {
                                        if (containFirst.isEmpty) {
                                          enableDisableValue(type, true);
                                        }
                                      } else if (containSecond != null) {
                                        if (containSecond.isEmpty) {
                                          enableDisableValue(type, true);
                                        }
                                      }
//                                    if (containFirst.isEmpty &&
//                                        containSecond.isEmpty) {
//                                      enableDisableValue(type, true);
//                                    }
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: getSize(6)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: getSize(20),
                                            width: getSize(20),
                                            child: Image.asset(
                                                firstList[index].isSelected
                                                    ? selectedFilter
                                                    : unselectedFilter),
                                          ),
                                          SizedBox(
                                            width: getSize(11),
                                          ),
                                          Text(
                                            firstList[index].title,
                                            style:
                                                appTheme.black14W400TextStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  secondList != null
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount: secondList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      secondList[index].isSelected =
                                          !secondList[index].isSelected;
                                      if (!secondList[index].isSelected) {
                                        enableDisableValue(type, false);
                                      }
                                      var containFirst = firstList.where(
                                          (element) =>
                                              element.isSelected == false);
                                      var containSecond = secondList.where(
                                          (element) =>
                                              element.isSelected == false);
                                      if (containFirst.isEmpty &&
                                          containSecond.isEmpty) {
                                        enableDisableValue(type, true);
                                      }
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: getSize(6)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: getSize(16),
                                            width: getSize(16),
                                            child: Image.asset(
                                                secondList[index].isSelected
                                                    ? selectedFilter
                                                    : unselectedFilter),
                                          ),
                                          SizedBox(
                                            width: getSize(8),
                                          ),
                                          Text(
                                            secondList[index].title,
                                            style:
                                                appTheme.black14W300TextStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void whatsAppOpen(String phoneNo, {String message = ""}) async {
    phoneNo = "91" + phoneNo;
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phoneNo/?text=${message}";
      } else {
        return "whatsapp://send?phone=$phoneNo&text=${message}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw showToast("whatspp is not installed in this device",
          context: context);
    }
  }

  void setDataInList() {
    //

    firstImageList.add(
      SelectionPopupModel(
        "1",
        "Ideal Image",
        fileType: DownloadAndShareDialogueConstant.realImage1,
        url: DiamondUrls.image,
      ),
    );
    firstImageList.add(
      SelectionPopupModel(
        "2",
        "Natural Image",
        fileType: DownloadAndShareDialogueConstant.naturalImage,
        url: DiamondUrls.naturalImage,
      ),
    );
    firstImageList.add(
      SelectionPopupModel(
        "3",
        "Fluorescence Image",
        fileType: DownloadAndShareDialogueConstant.flouresenceImg,
        url: DiamondUrls.flouresenceImg,
      ),
    );

    //

    // firstImageList.add(
    //   SelectionPopupModel(
    //     "3",
    //     "Asset Scope",
    //     fileType: DownloadAndShareDialogueConstant.assetScopeImg,
    //     url: DiamondUrls.share_assetScopeImg,
    //   ),
    // );
    // secondImageList.add(
    //   SelectionPopupModel(
    //     "7",
    //     "Heart & Arrow",
    //     fileType: DownloadAndShareDialogueConstant.heartAndArrowImg,
    //     url: DiamondUrls.share_heartImg,
    //   ),
    // );
    firstImageList.add(
      SelectionPopupModel(
        "4",
        "Heart & Arrow Image",
        fileType: DownloadAndShareDialogueConstant.heartAndArrowImg,
        url: DiamondUrls.heartImage,
      ),
    );

    firstImageList.add(
      SelectionPopupModel(
        "5",
        "Plot Image",
        fileType: DownloadAndShareDialogueConstant.plottingImg,
        url: DiamondUrls.plotting,
      ),
    );
    firstImageList.add(
      SelectionPopupModel(
        "6",
        "Propotion Image",
        fileType: DownloadAndShareDialogueConstant.propimage,
        url: DiamondUrls.proportion,
      ),
    );
    // firstImageList.add(
    //   SelectionPopupModel(
    //     "4",
    //     "Ideal Scope Image",
    //     fileType: DownloadAndShareDialogueConstant.idealScopeImg,
    //     url: DiamondUrls.proportion,
    //   ),
    // );
    // secondImageList.add(
    //   SelectionPopupModel(
    //     "6",
    //     "Real Image - 2",
    //     fileType: DownloadAndShareDialogueConstant.realImage2,
    //     url: DiamondUrls.share_realImg,
    //   ),
    // );
    // secondImageList.add(
    //   SelectionPopupModel(
    //     "7",
    //     "Heart & Arrow",
    //     fileType: DownloadAndShareDialogueConstant.heartAndArrowImg,
    //     url: DiamondUrls.share_heartImg,
    //   ),
    // );
    // secondImageList.add(
    //   SelectionPopupModel(
    //     "8",
    //     "Arrow Image",
    //     fileType: DownloadAndShareDialogueConstant.arrowImg,
    //     url: DiamondUrls.share_arrowImg,
    //   ),
    // );
    // secondImageList.add(
    //   SelectionPopupModel(
    //     "9",
    //     "Dark - Field Image",
    //     fileType: DownloadAndShareDialogueConstant.darkFieldImg,
    //     url: DiamondUrls.share_dartFieldImg,
    //   ),
    // );
    // secondImageList.add(
    //   SelectionPopupModel(
    //     "10",
    //     "Flouresence Image",
    //     fileType: DownloadAndShareDialogueConstant.flouresenceImg,
    //     url: DiamondUrls.share_flouresenceImg,
    //   ),
    // );
    firstVideoList.add(
      SelectionPopupModel(
        "1",
        "Natural Video",
        fileType: DownloadAndShareDialogueConstant.video1,
        url: DiamondUrls.natural,
      ),
    );
    firstVideoList.add(
      SelectionPopupModel(
        "2",
        "HD Video",
        fileType: DownloadAndShareDialogueConstant.video2,
        url: DiamondUrls.videomp4,
      ),
    );
    firstCertificateList.add(
      SelectionPopupModel(
        "1",
        "Certificate",
        fileType: DownloadAndShareDialogueConstant.certificate,
        url: DiamondUrls.certificate,
      ),
    );
    // secondCertificateList.add(
    //   SelectionPopupModel(
    //     "2",
    //     "Type IIA",
    //     fileType: DownloadAndShareDialogueConstant.typeIIA,
    //     url: DiamondUrls.share_typeIIAImg,
    //   ),
    // );
    firstExcelList.add(
      SelectionPopupModel(
        "1",
        "Excel",
        fileType: DownloadAndShareDialogueConstant.excel,
      ),
    );
    // firstRoughList.add(
    //   SelectionPopupModel(
    //     "1",
    //     "Rough Scope",
    //     fileType: DownloadAndShareDialogueConstant.roughScope,
    //     url: DiamondUrls.share_realImg,
    //   ),
    // );
    // firstRoughList.add(
    //   SelectionPopupModel(
    //     "2",
    //     "Rough Video",
    //     fileType: DownloadAndShareDialogueConstant.roughVideo,
    //     url: DiamondUrls.share_roughVideoImg,
    //   ),
    // );
    // secondRoughList.add(
    //   SelectionPopupModel(
    //     "3",
    //     "3D Image",
    //     fileType: DownloadAndShareDialogueConstant.img3D,
    //     url: DiamondUrls.share_planImg,
    //   ),
    // );
  }

  getConditionValue(DownloadDataType type) {
    // print("..............................");
    if (type == DownloadDataType.Images) {
      return isAllImageSelected;
    } else if (type == DownloadDataType.Video) {
      return isAllVideoSelected;
    } else if (type == DownloadDataType.Excel) {
      return isAllExcelSelected;
    } else if (type == DownloadDataType.Rough) {
      return isAllRoughSelected;
    } else if (type == DownloadDataType.Certificate) {
      return isAllCertificateSelected;
    }
  }

  getExpandedValue(DownloadDataType type) {
    if (type == DownloadDataType.Images) {
      return isImageExpanded;
    } else if (type == DownloadDataType.Video) {
      return this.isVideoExpanded;
    } else if (type == DownloadDataType.Excel) {
      return isExcelExpanded;
    } else if (type == DownloadDataType.Rough) {
      return isRoughExpanded;
    } else if (type == DownloadDataType.Certificate) {
      return isCertificateExpanded;
    }
  }

  void enableDisableValue(DownloadDataType type, bool value) {
    if (type == DownloadDataType.Images) {
      isAllImageSelected = value;
    } else if (type == DownloadDataType.Video) {
      isAllVideoSelected = value;
    } else if (type == DownloadDataType.Excel) {
      isAllExcelSelected = value;
    } else if (type == DownloadDataType.Rough) {
      isAllRoughSelected = value;
    } else if (type == DownloadDataType.Certificate) {
      isAllCertificateSelected = value;
    }
  }

  isShareOrDownload(String title) {
    if (title == "Share") {
      return false;
    }
  }
}
