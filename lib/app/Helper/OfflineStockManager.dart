import 'dart:convert';
import 'dart:math';
import 'package:diamnow/app/Helper/LocalNotification.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/OfflineSearchHistory/OfflineSearchHistoryModel.dart';
import 'package:diamnow/models/OfflineSearchHistory/OfflineStockTrack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rxbus/rxbus.dart';

import 'NetworkClient.dart';

class OfflineStockManager {
  static final OfflineStockManager shared = OfflineStockManager();

  Map<String, dynamic> filterCriteria;
  int page = 1;
  int totalCount = 0;
  String sortKey = "";
  int limit = 300;
  double totalCarat = 0;
  String strDate = "";
  List<SelectionPopupModel> allDiamondPreviewThings;
  bool isCancel = false;
  bool isDownloading = false;

  int moduleType;
  String sortingKey;
  String filterId;

  String selectedDate;

  double downloadProgress = 0;

  downloadData({
    String sortKey,
    int moduleType,
    List<SelectionPopupModel> allDiamondPreviewThings,
    String date,
    String filterId,
  }) {
    isCancel = false;
    isDownloading = true;
    strDate = DateUtilities().getFormattedDateString(DateTime.now(),
        formatter: DateUtilities.dd_mm_yyyy_hh_mm_a);
    page = 1;
    downloadProgress = 0;
    totalCount = 0;

    RxBus.post(isDownloading, tag: eventOfflineDiamond);

    this.sortKey = sortKey;
    this.moduleType = moduleType;
    this.allDiamondPreviewThings = allDiamondPreviewThings;
    this.filterId = filterId;

    this.selectedDate = date;
    getDataFromApi(sortKey: sortKey).then((value) {
      //s
    });
  }

  canelDownload() {
    this.isCancel = true;
    isDownloading = false;
    RxBus.post(isDownloading, tag: eventOfflineDiamond);

    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.UserDefaultKey.DownloadProgress), object: nil, userInfo: nil)
  }

  Future<void> getDataFromApi({String sortKey = ""}) async {
    if (this.isCancel) {
      return;
    }

    Future<void> _downloadAndStoreDiamond(
        int count, List<DiamondModel> diamonds) async {
      this.totalCount = count;

      //This expiry date is configurable, It will come from server side in user response
      var expDate = DateUtilities().getFormattedDateString(
          DateTime.now().add(Duration(days: 5)),
          formatter: DateUtilities.dd_mm_yyyy_hh_mm_a);

      //Adding Date in Diamond Model
      diamonds.forEach((element) {
        element.strDate = this.strDate;
        element.expiryDate = expDate;
      });

      if (this.allDiamondPreviewThings.length > 0) {
        for (var item in diamonds) {
          allDiamondPreviewThings.forEach((element) async {
            if (element.fileType ==
                    DownloadAndShareDialogueConstant.realImage1 &&
                isNullEmptyOrFalse(item.getDiamondImage()) == false) {
              DefaultCacheManager().getSingleFile(item.getDiamondImage());
            } else if (element.fileType ==
                DownloadAndShareDialogueConstant.certificate) {
              DefaultCacheManager()
                  .getSingleFile(item.getCertificateImage())
                  .then((value) async {
                print("Certificate Download File URL $value");
                // item.offlineCertificateFile = value.path;
                await AppDatabase.instance.diamondDao.addOrUpdate([item]);
              });
              print(
                  "Cache File path ${await DefaultCacheManager().getFilePath()}");
            }
          });
        }
      }

      //Store History data
      Map<String, dynamic> dict = {};
      if (page * limit < totalCount) {
        dict["pcs"] = page * limit;
      } else {
        dict["pcs"] = totalCount;
      }
      dict["date"] = strDate;

      totalCarat += diamonds
          .map((e) => e.crt)
          .reduce((value, element) => value + element);
      dict["carat"] = totalCarat;
      dict["expiryDate"] = expDate;
      dict["filterParam"] = jsonEncode(getRequest());

      await AppDatabase.instance.offlineSearchHistoryDao
          .addOrUpdate([OfflineSearchHistoryModel.fromJson(dict)]);

      await AppDatabase.instance.diamondDao.addOrUpdate(diamonds);
      debugPrint('Download Stock Page $page');

      if (this.page * this.limit < this.totalCount) {
        this.page += 1;
        this.getDataFromApi(sortKey: sortKey);
      } else {
        isDownloading = false;
        RxBus.post(isDownloading, tag: eventOfflineDiamond);

        //Download complete
        LocalNotificationManager.instance
            .showOfflineStockDownloadNotification();
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.UserDefaultKey.DownloadProgress), object: nil, userInfo: nil)
        return;
      }

      this.downloadProgress = min(
          1.0,
          ((this.page * this.limit).toDouble()) /
              ((this.totalCount).toDouble()));
      print('Download Progress $downloadProgress');
      RxBus.post(isDownloading, tag: eventOfflineDiamond);
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = this.limit;
    if (sortingKey != null) {
      dict["sort"] = sortingKey;
    }
    dict["isReturnMasterKey"] = true;
    dict["filters"] = {};
    if (this.filterId != null) {
      dict["filters"]["diamondSearchId"] = this.filterId;
    }

    NetworkCall<DiamondListResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .diamondListPaginate(dict),
      NavigationUtilities.key.currentState.overlay.context,
      isProgress: false,
      isNetworkError: false,
    )
        .then((diamondListResp) async {
      //Schedule notification
      if (this.page == 1 && this.selectedDate != null) {
        LocalNotificationManager.instance.fireNotification(
          DateUtilities().convertServerStringToFormatterDate(selectedDate),
          title: APPNAME,
          body: "Reminder about offline stock search",
        );
      }

      await _downloadAndStoreDiamond(
          diamondListResp.data.count, diamondListResp.data.diamonds);
    }).catchError((onError) {
      isDownloading = false;
      RxBus.post(isDownloading, tag: eventOfflineDiamond);
    });
  }

  downloadProgressText() {
    return "${(downloadProgress * 100).toStringAsFixed(0)}%";
  }

  Map<String, dynamic> getRequest() {
    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    if (sortingKey != null) {
      dict["sort"] = sortingKey;
    }

    dict["filters"] = {};
    if (this.filterId != null) {
      dict["filters"]["diamondSearchId"] = this.filterId;
    }

    return dict;
  }

  //call Api for sync offline data
  callApiForSyncOfflineData(BuildContext context) async {
    var arrStock =
        await AppDatabase.instance.offlineStockTracklDao.getOfflineStockTrack();
    if (isNullEmptyOrFalse(arrStock)) {
      return;
    }
    for (var item in arrStock) {
      var map = json.decode(item.request);
      if (item.trackType != DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER) {
        callApiForTrackOfflineData(map, context, callBack: () async {
          OfflineStockTrackModel trackModel = item;
          trackModel.isSync = true;
          await AppDatabase.instance.offlineStockTracklDao
              .addOrUpdate([trackModel]);
        });
      } else {
        callApiForOrderOffline(map, context, callBack: () async {
          OfflineStockTrackModel trackModel = item;
          trackModel.isSync = true;
          await AppDatabase.instance.offlineStockTracklDao
              .addOrUpdate([trackModel]);
        });
      }
    }
  }

  callApiForTrackOfflineData(Map<String, dynamic> req, BuildContext context,
      {Function callBack}) {
    print("Diamonds found for offline track");
    NetworkClient.getInstance.callApi(
        context, baseURL, ApiConstants.dimaondTrackCreate, MethodType.Post,
        params: req, headers: NetworkClient.getInstance.getAuthHeaders(),
        successCallback: (response, message) {
      callBack();
    }, failureCallback: (status, message) {
      print(message);
    });
  }

  callApiForOrderOffline(Map<String, dynamic> req, BuildContext context,
      {Function callBack}) {
    print("Diamonds found for offline order");
    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      ApiConstants.placeOrderOffline,
      MethodType.Post,
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {
        callBack();
      },
      failureCallback: (status, message) {
        print(message);
      },
    );
  }
}
