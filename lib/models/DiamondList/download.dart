import 'dart:async';
import 'dart:io';
import 'package:diamnow/app/Helper/LocalNotification.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/Share/ShareThroughEmail.dart';
import 'package:diamnow/models/excel/ExcelApiResponse.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';

// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rxbus/rxbus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Download extends StatefulWidget {
  List<DiamondModel> diamondList;

  List<SelectionPopupModel> allDiamondPreviewThings =
      List<SelectionPopupModel>();

  Download({this.diamondList, this.allDiamondPreviewThings});

  @override
  DownloadState createState() => DownloadState(
      diamondList: this.diamondList,
      allDiamondPreviewThings: this.allDiamondPreviewThings);
}

class DownloadState extends State<Download> {
  List<DiamondModel> diamondList;

  List<SelectionPopupModel> allDiamondPreviewThings =
      List<SelectionPopupModel>();

  int totalDownloadableFilesForAllDiamonds = 0;
  int totalDownloadedFiles = 0;
  double finalDownloadProgress = 0;
  dynamic isPermissionStatusGranted;
  bool cancleDownload = false;
  int savePathLength = 0;

  // CancelToken cancelToken;
  Map<String, CancelToken> mapOfCancelToken = {};
  bool breakForLoop = false;
  bool cancel = false;

  DownloadState({this.diamondList, this.allDiamondPreviewThings});

  @override
  void initState() {
    super.initState();
    startDownload();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getSize(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    getTitleText(context, R.string.commonString.downloading,
                        color: ColorConstants.black, fontSize: getSize(20)),
                    SizedBox(
                      height: getSize(20),
                    ),
                    new LinearPercentIndicator(
                      // width:
                      //     MathUtilities.screenWidth(context) - getSize(150),
                      lineHeight: 14.0,
                      percent: this.finalDownloadProgress <= 100.0
                          ? (this.finalDownloadProgress.toDouble() / 100)
                          : 1 ?? 0,
                      center: getBodyText(
                          context,
                          this.finalDownloadProgress.toDouble() != null
                              ? (this.finalDownloadProgress)
                                      .toDouble()
                                      .toStringAsFixed(2) +
                                  "%"
                              : "0.0 %",
                          color: Colors.white),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      backgroundColor: ColorConstants.introgrey,
                      progressColor: appTheme.colorPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: getSize(15),
          ),
          Row(
            children: [
              Spacer(),
              Text(
                "${totalDownloadedFiles}/${totalDownloadableFilesForAllDiamonds}",
                style: appTheme.black14TextStyle,
              ),
            ],
          ),
          SizedBox(
            height: getSize(20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Spacer(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: appTheme.colorPrimary,
                      borderRadius: BorderRadius.circular(getSize(5)),
                      boxShadow: getBoxShadow(context)),
                  child: AppButton.flat(
                    onTap: () {
                      // Navigator.pop(context);
                      mapOfCancelToken.forEach((key, value) {
                        value.cancel();
                      });
                      cancel = true;
                      Navigator.pop(context);
                      setState(() {});
                      showToast(R.string.commonString.downloadingCanceled,
                          context: context);
                    },
                    // borderRadius: getSize(5),
                    text: R.string.commonString.cancel,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  startDownload() async {
    await doDownLoad();
  }

  doDownLoad() async {
    isPermissionStatusGranted = await _requestPermissions();
    for (int i = 0; i < diamondList.length; i++) {
      DiamondModel model = diamondList[i];

      allDiamondPreviewThings.forEach((element) {
        if (element.fileType == DownloadAndShareDialogueConstant.realImage1) {
          element.url = (DiamondUrls.image + (model.vStnId) + ".jpg");
          // element.url =
          //     "https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8ZGF3bnxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80";
        } else if (element.fileType ==
            DownloadAndShareDialogueConstant.plottingImg) {
          element.url = (DiamondUrls.plotting + (model.vStnId) + ".png");
        } else if (element.fileType ==
            DownloadAndShareDialogueConstant.propimage) {
          element.url = (DiamondUrls.proportion + model.vStnId + ".png");
        } else if (element.fileType ==
            DownloadAndShareDialogueConstant.naturalImage) {
          element.url = (DiamondUrls.naturalImage + (model.vStnId) + ".jpg");
        } else if (element.fileType ==
            DownloadAndShareDialogueConstant.flouresenceImg) {
          element.url = (DiamondUrls.flouresenceImg +
              (model.vStnId) +
              "/fluorescence.jpg");
        }

        // else if (element.fileType ==
        //     DownloadAndShareDialogueConstant.arrowImg) {
        //   element.url = DiamondUrls.heartImage +
        //       model.mfgStnId +
        //       "/" +
        //       "Arrow_Black_BG.jpg";
        // }
        //  else if (element.fileType ==
        //     DownloadAndShareDialogueConstant.assetScopeImg) {
        //   print("-----type----assetScopeImg");
        //   element.url = DiamondUrls.image +
        //       model.mfgStnId +
        //       "/" +
        //       "Office_Light_Black_BG.jpg";
        // }
        // else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.plottingImg &&
        //     model.pltFile) {
        //   element.url = DiamondUrls.plotting + model.rptNo + ".jpg";
        // }
        else if (element.fileType ==
            DownloadAndShareDialogueConstant.heartAndArrowImg) {
          element.url = (DiamondUrls.heartImage +
              (model.vStnId) +
              "/" +
              (model.vStnId) +
              "-Hearts-01.jpg");
          element.url = (DiamondUrls.heartImage +
              (model.vStnId) +
              "/" +
              (model.vStnId) +
              "-ASET%20white-01.jpg");
          element.url = (DiamondUrls.heartImage +
              (model.vStnId) +
              "/" +
              (model.vStnId) +
              "-Arrows-01.jpg");
          element.url = (DiamondUrls.heartImage +
              (model.vStnId) +
              "/" +
              (model.vStnId) +
              "-IdealScope-01.jpg");
        }
        // } else if (element.fileType ==
        //     DownloadAndShareDialogueConstant.heartAndArrowImg) {

        // } else if (element.fileType ==
        //     DownloadAndShareDialogueConstant.heartAndArrowImg) {

        // } else if (element.fileType ==
        //     DownloadAndShareDialogueConstant.heartAndArrowImg) {

        // }
        // else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.flouresenceImg &&
        //     model.img) {
        //   element.url = DiamondUrls.flouresenceImg + model.vStnId + ".jpg";
        // } else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.idealScopeImg &&
        //     model.img) {
        //   element.url = DiamondUrls.idealScopeImg + model.vStnId + ".jpg";
        // } else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.darkFieldImg &&
        //     model.img) {
        //   element.url = DiamondUrls.darkFieldImg + model.vStnId + ".jpg";
        // } else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.faceUpImg &&
        //     model.img) {
        //   element.url = DiamondUrls.faceUpImg + model.vStnId + ".jpg";
        // } else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.realImage2 &&
        //     model.img) {
        //   element.url = DiamondUrls.realImg2 + model.vStnId + ".jpg";
        // }
        else if (element.fileType == DownloadAndShareDialogueConstant.video1) {
          element.url = (DiamondUrls.natural + model.vStnId + ".mp4");
        } else if (element.fileType ==
            DownloadAndShareDialogueConstant.video2) {
          element.url = (DiamondUrls.roughVideo + model.vStnId + "video.mp4");
        }
        //  else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.video2 &&
        //     model.polVdo) {
        //   element.url = DiamondUrls.polVideo + model.vStnId + ".mp4";
        // }
        else if (element.fileType ==
            DownloadAndShareDialogueConstant.certificate) {
          print("-----type----certificate");
          element.url = (DiamondUrls.certificate + model.vStnId + ".pdf");
          //element.url = DiamondUrls.certificate + model.rptNo + ".pdf";
        }
        // else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.typeIIA &&
        //     model.certFile) {
        //   element.url = DiamondUrls.type2A + model.rptNo + ".pdf";
        // } else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.roughScope &&
        //     model.img) {
        //   element.url = DiamondUrls.roughScopeImg + model.vStnId + ".jpg";
        // } else if (element.fileType == DownloadAndShareDialogueConstant.img3D &&
        //     model.img) {
        //   element.url = DiamondUrls.image3D + model.vStnId + ".png";
        // } else if (element.fileType ==
        //         DownloadAndShareDialogueConstant.roughVideo &&
        //     model.roughVdo) {
        //   element.url = DiamondUrls.roughVideo + model.vStnId + ".html";
        // }
        print("-------------url-----------${element.url}");
      });

      //download code
      getDownloadPercentage(allDiamondPreviewThings);

      if (breakForLoop) break;
      await downloadFunction(allDiamondPreviewThings, diamondList[i],
          (value, isFromError) {
        print("download" + value.toString());
        if (mounted) {
          setState(() {
            if (!isFromError) {
              totalDownloadedFiles += 1;
            }
            finalDownloadProgress +=
                (100 / totalDownloadableFilesForAllDiamonds);

            print(
                "final download progress " + finalDownloadProgress.toString());
            if (finalDownloadProgress >= 99) {
              Navigator.pop(context);
              totalDownloadedFiles == totalDownloadableFilesForAllDiamonds
                  ? showToast(R.string.commonString.allfileshavebeendownloaded,
                      context: context)
                  : showToast(
                      "${totalDownloadedFiles} ${R.string.commonString.filesisdownloaded} \n ${totalDownloadableFilesForAllDiamonds - totalDownloadedFiles} ${R.string.commonString.filesisnotdownloadedbcz}",
                      context: context);
            }
          });
        }
        //else {
        //   print("----------------------------------...................drrrr");
        //   Navigator.pop(context);
        //   showToast(R.string.commonString.notYetAvailable, context: context);
        // }
      });
    }
  }

  getDownloadPercentage(List<SelectionPopupModel> allDiamondPreviewThings) {
    var totalFiles = allDiamondPreviewThings.where((element) {
      if (element.isSelected &&
          element.fileType != DownloadAndShareDialogueConstant.excel &&
          isUrlContainsImgOrVideo(element.url)) {
        return true;
      } else {
        return false;
      }
    });

    totalDownloadableFilesForAllDiamonds =
        totalFiles.length * diamondList.length;
    if (mounted) {
      if (totalDownloadableFilesForAllDiamonds == 0) {
        breakForLoop = true;
        //check whether excel is selected or not...
        for (int i = 0; i < allDiamondPreviewThings.length; i++) {
          if (allDiamondPreviewThings[i].isSelected &&
              allDiamondPreviewThings[i].fileType ==
                  DownloadAndShareDialogueConstant.excel) {
            Navigator.of(context).pop();
            SyncManager syncManager = SyncManager();
            syncManager.callApiForExcel(context, diamondList);
            return;
          }
        }
        Navigator.of(context).pop();
        // RxBus.post(true,tag:"breakforloop")
        // RxBus.register<bool>(tag: "breakforloop").listen((event) {

        // });
        showToast(R.string.commonString.filesarenotavailableonserver,
            context: context);
      } else
        setState(() {});
    }
  }

  Future<void> downloadFunction(
      List<SelectionPopupModel> allDiamondPreviewThings,
      DiamondModel diamondModel,
      void callBack(int val, bool isFromError)) async {
    //define map

    for (int i = 0; i < allDiamondPreviewThings.length; i++) {
      SelectionPopupModel element = allDiamondPreviewThings[i];
      // if(element.isSelected && element.fileType == DownloadAndShareDialogueConstant.excel){

      // }
      if (element.isSelected &&
          element.fileType != DownloadAndShareDialogueConstant.excel &&
          !isNullEmptyOrFalse(element.url) &&
          isUrlContainsImgOrVideo(element.url)) {
        CancelToken cancelTokens = CancelToken();
        mapOfCancelToken[element.url +
            element.title +
            diamondModel.id +
            "." +
            getExtensionOfUrl(element.url)] = cancelTokens;
        // {
        //   url:canceltokens
        // }
        await downloadFile(
          element.url,
          element.title +
              diamondModel.id +
              "." +
              getExtensionOfUrl(element.url),
          0,
          (value, isFromError) {
            callBack(value, isFromError);
          },
          element.url +
              element.title +
              diamondModel.id +
              "." +
              getExtensionOfUrl(element.url),
        );
      }
    }
  }

  // downloading logic is handled by this method

  Future<void> downloadFile(uri, fileName, int progress,
      void callBack(int val, bool isFromError), String key) async {
    final dir = await getDownloadDirectory();
    final savePath = path.join(dir.path, fileName);

    if (isPermissionStatusGranted ?? true) {
      Dio dio = Dio();

      dio.download(
        uri,
        savePath,
        onReceiveProgress: (rcv, total) {
          print(
              'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

          progress = ((rcv ~/ total) * 100);
        },
        deleteOnError: true,
        cancelToken: mapOfCancelToken[key],
      ).then((_) {
        savePathLength++;
        callBack(progress, false);

        if ((totalDownloadableFilesForAllDiamonds == savePathLength) &&
            (cancel == false)) {
          if ((progress >= 100)) {
            Navigator.pop(context);
            LocalNotificationManager.instance
                .showExcelDownloadNotification(savePath);
            if (Platform.isIOS) {
              isImage(savePath)
                  ? GallerySaver.saveImage(savePath)
                  : GallerySaver.saveVideo(savePath);
            }
          }
        }
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        savePathLength++;
        if ((totalDownloadableFilesForAllDiamonds == savePathLength) &&
            (cancel == false) &&
            (totalDownloadedFiles != 0)) {
          callBack(100, true);
          LocalNotificationManager.instance
              .showExcelDownloadNotification(savePath);
        } else if ((savePathLength == totalDownloadableFilesForAllDiamonds) &&
            (totalDownloadedFiles == 0) &&
            (cancel == false)) {
          Navigator.pop(context);
          app.resolve<CustomDialogs>().errorDialog(
                NavigationUtilities.key.currentState.overlay.context,
                "Oops!!!",
                "No Files Found!",
                btntitle: R.string.commonString.ok,
              );
        } else if (cancel == true) {
        } else {
          callBack(100, true);
        }
        if (mounted) {
          setState(() {});
        } //   notified = true;

        // } else if ((savePathLength == totalDownloadableFilesForAllDiamonds) &&
        //     (cancel == false)) {
        //   notified = true;
        //   LocalNotificationManager.instance
        //       .showExcelDownloadNotification(savePath);
        // }
      });
    } else {
      // handled the scenario when user declines the permissions
      showToast("you should have to allowed permission");
    }
  }

  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getExternalStorageDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

// Future<WebView> getWebView(BuildContext context, String url) async {
//   // if (!model.isImage) print(model.url);
//   print(url);
//   return WebView(
//       initialUrl: url,
//       // onPageStarted: (url) {
//       //   // app.resolve<CustomDialogs>().showProgressDialog(context, "");
//       //   setState(() {
//       //     isLoading = true;
//       //   });
//       // },
//       // onPageFinished: (finish) {
//       //   // app.resolve<CustomDialogs>().hideProgressDialog();
//       //   setState(() {
//       //     isLoading = false;
//       //   });
//       // },
//       onWebResourceError: (error) {
//         print(error);
//         setState(() {
//           // isErroWhileLoading = true;
//         });
//       },
//       javascriptMode: JavascriptMode.unrestricted);
// }
}
