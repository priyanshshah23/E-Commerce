import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/Share/ShareThroughEmail.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownLoadAndShareDialogue extends StatefulWidget {
  String title = "";

  DownLoadAndShareDialogue({
    this.title,
  });

  @override
  _DownLoadAndShareDialogueState createState() =>
      _DownLoadAndShareDialogueState(
        title,
      );
}

class _DownLoadAndShareDialogueState extends State<DownLoadAndShareDialogue> {
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

  bool isAllImageSelected = false;
  bool isAllVideoSelected = false;
  bool isAllCertificateSelected = false;
  bool isAllExcelSelected = false;
  bool isAllRoughSelected = false;

  _DownLoadAndShareDialogueState(
    this.title,
  );

  @override
  void initState() {
    setDataInList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getSize(20), vertical: getSize(30)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text(
                title,
                style: appTheme.blackMedium20TitleColorblack,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  cancel,
                  height: getSize(18),
                  width: getSize(18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getSize(15),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 50,
                  maxHeight: MathUtilities.screenHeight(context) - 200),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
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
                  getRowWithTitle(
                      title: "Rough",
                      type: DownloadDataType.Rough,
                      firstList: firstRoughList,
                      secondList: secondRoughList),
                ],
              ),
            ),
          ),
          title == R.string().commonString.share
              ? Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (checkValidation()) {
                            openURLWithApp(
                                "whatsapp://send?phone=&text=Hello!", context);
                          } else {
                            showToast("Please select any", context: context);
                          }
                        },
                        child: Container(
                          height: getSize(46),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: appTheme.whatsAppColor,
                            borderRadius: BorderRadius.circular(getSize(5)),
                          ),
                          child: Text(
                            "WhatsApp",
                            textAlign: TextAlign.center,
                            style: appTheme.white16TextStyle,
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
                                "mailto:?subject=DiamNow&body=DiamNow",
                                context);
                          } else {
                            showToast("Please select any", context: context);
                          }
                        },
                        child: Container(
                          height: getSize(46),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: appTheme.gmailColor,
                            borderRadius: BorderRadius.circular(getSize(5)),
                          ),
                          child: Text(
                            "Gmail",
                            textAlign: TextAlign.center,
                            style: appTheme.white16TextStyle,
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
                            openURLWithApp("skype:", context);
                          } else {
                            showToast("Please select any", context: context);
                          }
                        },
                        child: Container(
                          height: getSize(46),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: appTheme.skypeColor,
                            borderRadius: BorderRadius.circular(getSize(5)),
                          ),
                          child: Text(
                            "Skype",
                            textAlign: TextAlign.center,
                            style: appTheme.white16TextStyle,
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
                            color: appTheme.colorPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(getSize(5)),
                          ),
                          child: Text(
                            R.string().commonString.cancel,
                            textAlign: TextAlign.center,
                            style: appTheme.blue14TextStyle
                                .copyWith(fontSize: getFontSize(16)),
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
                        },
                        child: Container(
                          height: getSize(46),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: appTheme.colorPrimary,
                              borderRadius: BorderRadius.circular(getSize(5)),
                              boxShadow: getBoxShadow(context)),
                          child: Text(
                            R.string().commonString.download,
                            textAlign: TextAlign.center,
                            style: appTheme.white16TextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  checkValidation() {
    var totalList =( firstImageList +
        secondImageList +
        firstVideoList +
        secondVideoList +
        firstCertificateList + secondCertificateList +
        firstExcelList +
    firstRoughList + secondRoughList).where((element) {
      return element.isSelected;
    }).toList();


    return !isNullEmptyOrFalse(totalList);
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
//        title: R.string().commonString.error,
//        desc: onError.message,
//        positiveBtnTitle: R.string().commonString.btnTryAgain,
//      );
//    });
//  }

  getRowWithTitle(
      {String title,
      DownloadDataType type,
      List<SelectionPopupModel> firstList,
      List<SelectionPopupModel> secondList}) {
    bool titleBool;
    return Column(
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
          child: Row(
            children: [
              Container(
                height: getSize(16),
                width: getSize(16),
                child: Image.asset(getConditionValue(type)
                    ? selectedFilter
                    : unselectedFilter),
              ),
              SizedBox(
                width: getSize(8),
              ),
              Text(
                title,
                style: appTheme.black16MediumTextStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: getSize(15), top: getSize(8), bottom: getSize(19)),
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
                                  var containFirst = firstList.where(
                                      (element) => element.isSelected == false);
                                  var containSecond = secondList.where(
                                      (element) => element.isSelected == false);
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
                                            firstList[index].isSelected
                                                ? selectedFilter
                                                : unselectedFilter),
                                      ),
                                      SizedBox(
                                        width: getSize(8),
                                      ),
                                      Text(
                                        firstList[index].title,
                                        style: appTheme.black14W300TextStyle,
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
                                      (element) => element.isSelected == false);
                                  var containSecond = secondList.where(
                                      (element) => element.isSelected == false);
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
                                        style: appTheme.black14W300TextStyle,
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
    );
  }

  void setDataInList() {
    firstImageList.add(SelectionPopupModel(
      "1",
      "Real Image - 1",
    ));
    firstImageList.add(SelectionPopupModel(
      "2",
      "Plotting",
    ));
    firstImageList.add(SelectionPopupModel(
      "3",
      "Asset Scope",
    ));
    firstImageList.add(SelectionPopupModel(
      "4",
      "Face Up Image",
    ));
    firstImageList.add(SelectionPopupModel(
      "5",
      "Ideal Scope Image",
    ));
    secondImageList.add(SelectionPopupModel(
      "6",
      "Real Image - 2",
    ));
    secondImageList.add(SelectionPopupModel(
      "7",
      "Heart & Arrow",
    ));
    secondImageList.add(SelectionPopupModel(
      "8",
      "Arrow Image",
    ));
    secondImageList.add(SelectionPopupModel(
      "9",
      "Dark - Field Image",
    ));
    secondImageList.add(SelectionPopupModel(
      "10",
      "Flouresence Image",
    ));
    firstVideoList.add(SelectionPopupModel(
      "1",
      "Video 1",
    ));
    secondVideoList.add(SelectionPopupModel(
      "2",
      "Video 2",
    ));
    firstCertificateList.add(SelectionPopupModel(
      "1",
      "Certificate",
    ));
    secondCertificateList.add(SelectionPopupModel(
      "2",
      "Type IIA",
    ));
    firstExcelList.add(SelectionPopupModel(
      "1",
      "Excel",
    ));
    firstRoughList.add(SelectionPopupModel(
      "1",
      "Rough Scope",
    ));
    firstRoughList.add(SelectionPopupModel(
      "2",
      "Rough Video",
    ));
    secondRoughList.add(SelectionPopupModel(
      "3",
      "3D Image",
    ));
  }

  getConditionValue(DownloadDataType type) {
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
}
