import 'dart:async';
import 'dart:io';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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
  int finalDownloadProgress = 0;
  dynamic isPermissionStatusGranted;

  _DownloadState({this.diamondList, this.allDiamondPreviewThings});

  @override
  void initState() {
    super.initState();
    startDownload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Downloading....${finalDownloadProgress}"),
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
      downloadFunction(allDiamondPreviewThings, (value) {
        print("final download progrss" + value.toString());
         setState(() {
           finalDownloadProgress +=
              (100 ~/ totalDownloadableFilesForAllDiamonds);
         });
         
      });
    }
  }

  getDownloadPercentage(List<SelectionPopupModel> allDiamondPreviewThings) {
    var totalFiles = allDiamondPreviewThings.where((element) {
      if (element.isSelected && isUrlContainsImgOrVideo(element.url)) {
        return true;
      } else {
        return false;
      }
    });

    totalDownloadableFilesForAllDiamonds =
        totalFiles.length * diamondList.length;
  }

  Future<void> downloadFunction(
      List<SelectionPopupModel> allDiamondPreviewThings,
      void callBack(int val)) async {
    for (int i = 0; i < allDiamondPreviewThings.length; i++) {
      SelectionPopupModel element = allDiamondPreviewThings[i];
      if (element.isSelected && isUrlContainsImgOrVideo(element.url)) {
        await downloadFile(
            element.url, element.title + await FlutterUdid.udid +"."+ getExtensionOfUrl(element.url), 0,
            (value) {
          callBack(value);
        });
      }
    }
  }

  // downloading logic is handled by this method

  Future<void> downloadFile(
      uri, fileName, int progress, void callBack(int val)) async {
    final dir = await _getDownloadDirectory();
    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, fileName);
      Dio dio = Dio();

      dio.download(
        uri,
        savePath,
        onReceiveProgress: (rcv, total) {
          // print(
          //     'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

          progress = ((rcv ~/ total) * 100);
        },
        deleteOnError: true,
      ).then((_) {
        print("download completed");
        print("download completed" + progress.toString());
        if (progress >= 100) {
         
          callBack(progress);
        }
        
      });
    } else {
      // handle the scenario when user declines the permissions
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
    return await getApplicationDocumentsDirectory();
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
}
