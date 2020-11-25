import 'dart:async';
import 'dart:io';
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
  _DownloadState createState() => _DownloadState(
      diamondList: this.diamondList,
      allDiamondPreviewThings: this.allDiamondPreviewThings);
}

class _DownloadState extends State<Download> {
  List<DiamondModel> diamondList;

  List<SelectionPopupModel> allDiamondPreviewThings =
      List<SelectionPopupModel>();

  int totalDownloadableFilesForAllDiamonds = 0;
  int totalDownloadedFiles = 0;
  double finalDownloadProgress = 0;
  dynamic isPermissionStatusGranted;
  bool cancleDownload = false;
  // CancelToken cancelToken;
  Map<String, CancelToken> mapOfCancelToken = {};
  bool breakForLoop = false;

  _DownloadState({this.diamondList, this.allDiamondPreviewThings});

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
                    getTitleText(context, "Downloading...",
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
                      Navigator.pop(context);

                      mapOfCancelToken.forEach((key, value) {
                        value.cancel();
                      });

                      showToast("Downloading canceled", context: context);
                    },
                    borderRadius: getSize(5),
                    text: R.string().commonString.cancel,
                  ),
                ),
              )
            ],
          )
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
        if (element.fileType == DownloadAndShareDialogueConstant.realImage1 &&
            model.img) {
          element.url = DiamondUrls.image + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.arrowImg &&
            model.arrowFile) {
          element.url = DiamondUrls.arroImage + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.assetScopeImg &&
            model.assetFile) {
          element.url = DiamondUrls.assetImage + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.plottingImg &&
            model.pltFile) {
          element.url = DiamondUrls.plotting + model.rptNo + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.heartAndArrowImg &&
            model.hAFile) {
          element.url = DiamondUrls.heartImage + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.flouresenceImg &&
            model.img) {
          element.url = DiamondUrls.flouresenceImg + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.idealScopeImg &&
            model.img) {
          element.url = DiamondUrls.idealScopeImg + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.darkFieldImg &&
            model.img) {
          element.url = DiamondUrls.darkFieldImg + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.faceUpImg &&
            model.img) {
          element.url = DiamondUrls.faceUpImg + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.realImage2 &&
            model.img) {
          element.url = DiamondUrls.realImg2 + model.vStnId + ".jpg";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.video1 &&
            model.videoFile) {
          element.url = DiamondUrls.videomp4 + model.vStnId + ".mp4";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.video2 &&
            model.polVdo) {
          element.url = DiamondUrls.polVideo + model.vStnId + ".mp4";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.certificate &&
            model.certFile) {
          element.url = DiamondUrls.certificate + model.rptNo + ".pdf";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.typeIIA &&
            model.certFile) {
          element.url = DiamondUrls.type2A + model.rptNo + ".pdf";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.roughScope &&
            model.img) {
          element.url = DiamondUrls.roughScopeImg + model.vStnId + ".jpg";
        } else if (element.fileType == DownloadAndShareDialogueConstant.img3D &&
            model.img) {
          element.url = DiamondUrls.image3D + model.vStnId + ".png";
        } else if (element.fileType ==
                DownloadAndShareDialogueConstant.roughVideo &&
            model.roughVdo) {
          element.url = DiamondUrls.roughVideo + model.vStnId + ".html";
        }
      });

      //download code
      getDownloadPercentage(allDiamondPreviewThings);

      if(breakForLoop)
       break;
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
            // finalDownloadProgress=finalDownloadProgress();
            print(
                "final download progress " + finalDownloadProgress.toString());
            if (finalDownloadProgress >= 99) {
              Navigator.pop(context);
              totalDownloadedFiles == totalDownloadableFilesForAllDiamonds
                  ? showToast("All files has been downloaded.",
                      context: context)
                  : showToast(
                      "${totalDownloadedFiles} files is downloaded \n ${totalDownloadableFilesForAllDiamonds - totalDownloadedFiles} files is not downloaded because it's not exist in the server.",
                      context: context);
              allDiamondPreviewThings.forEach((element) {
                if (element.fileType ==
                        DownloadAndShareDialogueConstant.excel &&
                    element.isSelected) {
                  SyncManager syncManager = SyncManager();
                  syncManager.callApiForExcel(context, diamondList);
                }
              });
            }
          });
        }
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
      if(totalDownloadableFilesForAllDiamonds==0){
        breakForLoop = true;
        Navigator.of(context).pop();
        // RxBus.post(true,tag:"breakforloop")
        // RxBus.register<bool>(tag: "breakforloop").listen((event) { 

        // });
        showToast("Files are not available on server,Please try again later",context: context);
      
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
          element.fileType != DownloadAndShareDialogueConstant.excel && !isNullEmptyOrFalse(element.url) &&
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
            0, (value, isFromError) {
          callBack(value, isFromError);
        },
            element.url +
                element.title +
                diamondModel.id +
                "." +
                getExtensionOfUrl(element.url));
      }
    }
  }

  // downloading logic is handled by this method

  Future<void> downloadFile(uri, fileName, int progress,
      void callBack(int val, bool isFromError), String key) async {
    final dir = await _getDownloadDirectory();
    final savePath = path.join(dir.path, fileName);

    if (isPermissionStatusGranted) {
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
        // print("download completed");
        // print("download completed" + progress.toString());
        if (progress >= 100) {
          callBack(progress, false);
          if (Platform.isIOS) {
            isImage(savePath)
                ? GallerySaver.saveImage(savePath)
                : GallerySaver.saveVideo(savePath);
          }
        }
      }).catchError((error) {
        callBack(100, true);

        if (mounted) {
          setState(() {});
        }
      });
    } else {
      // handled the scenario when user declines the permissions
      showToast("you should have to allowed permission");
    }
  }

  Future<Directory> _getDownloadDirectory() async {
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
