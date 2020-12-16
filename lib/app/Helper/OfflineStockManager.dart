import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:flutter/widgets.dart';

class OfflineStockManager {
  static final OfflineStockManager shared = OfflineStockManager();

  int page = 1;
  int totalCount = 0;
  String sortKey = "";
  int limit = 1000;
  double totalCarat = 0;
  String strDate = "";
  List<SelectionPopupModel> allDiamondPreviewThings;
  bool isCancel = false;

  int moduleType;
  String sortingKey;
  String filterId;

  DateTime selectedDate;

  downloadData({
    String sortKey,
    int moduleType,
    List<SelectionPopupModel> allDiamondPreviewThings,
    DateTime date,
    String filterId,
  }) {
    isCancel = false;
    strDate = DateTime.now().toString();
    page = 1;
    totalCount = 0;

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
      var expDate = DateTime.now().add(Duration(days: 5)).toString();

      //Adding Date in Diamond Model
      diamonds.forEach((element) {
        element.date = this.strDate;
        element.expiryDate = expDate;
      });

      if (this.allDiamondPreviewThings.length > 0) {
        for (var item in diamonds) {
          allDiamondPreviewThings.forEach((element) {
            //   if (this.isDownloadImage) {
            //   if (isNullEmptyOrFalse(item.getDiamondImage()) == false) {
            //     // SDWebImageManager.shared.loadImage(with: URL(string : item.getDiamondImage()) , options: .fromCacheOnly, progress: .none, completed: { (img, data, errr, cache, value, url) in

            //     // })
            //   }
            // }

            // if (this.isDownloadCertificate) {
            //   if (isNullEmptyOrFalse(item.getCertificateImage()) == false) {
            //     // SDWebImageManager.shared.loadImage(with: URL(string : item.getCertificateImage()) , options: .fromCacheOnly, progress: .none, completed: { (img, data, errr, cache, value, url) in

            //     // })
            //   }
            // }

            if (element.fileType ==
                DownloadAndShareDialogueConstant.realImage1) {
              element.url = DiamondUrls.image + item.vStnId + "/" + "still.jpg";
            } else if (element.fileType ==
                DownloadAndShareDialogueConstant.certificate) {
              element.url = DiamondUrls.certificate + item.rptNo + ".pdf";
            }
          });
        }
      }

      //Store History data
      /*var dict : [String:Any] = [:]
                        if self.page * self.limit < self.totalCount{
                            dict["pcs"] = self.page * self.limit
                        }else{
                            dict["pcs"] = self.totalCount
                        }
                        dict["date"] = self.strDate
                        self.totalCarat += arrData.map { $0.carat }.reduce(0.0, +)
                        dict["carat"] = self.totalCarat
                        dict["expiryDate"] = expDate
                        dict["filterParam"] = self.filterCriteria?.jsonStringRepresentation
                        
                        let arrHistory = Mapper<SearchHistoryModel>().mapArray(JSONArray: [dict])
                        */
      // realm.add(arrHistory, update: .all)
      // realm.add(arrData, update: .all)

      // print(await AppDatabase.instance.diamondDao.getAllSortedByName());

      await AppDatabase.instance.diamondDao.addOrUpdate(diamonds);
      debugPrint('Download Stock Page $page');

      if (this.page * this.limit < this.totalCount) {
        this.page += 1;
        this.getDataFromApi(sortKey: sortKey);
      } else {
        //Download complete
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.UserDefaultKey.DownloadProgress), object: nil, userInfo: nil)

        // self.fireNotification(title: "", body: LanguageManager.localizedString("KLblOfflineStockDownloaded"), data: nil, date: Date().addingTimeInterval(5), identifier: StringConstants.NotificationIdentifier.offlineStockDownload)
        return;
      }

      var progress = ((this.page * this.limit).toDouble()) /
          ((this.totalCount).toDouble());
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = DEFAULT_LIMIT;
    if (sortingKey != null) {
      dict["sort"] = sortingKey;
    }

    dict["filters"] = {};
    if (this.filterId != null)
      dict["filters"]["diamondSearchId"] = this.filterId;

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
      await _downloadAndStoreDiamond(
          diamondListResp.data.count, diamondListResp.data.diamonds);
    }).catchError((onError) {
      // NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.UserDefaultKey.DownloadProgress), object: nil, userInfo: nil)
    });

    // if let watchListName = responseDic["watchListName"] as? [String] {
    //     Defaults[.watchListName] = Utilities.jsonToString(json: watchListName)
    // }

    //Schedule notification
    // if self.page == 1 && self.selectedDate != nil {
    //     self.fireNotification(title: "", body: LanguageManager.localizedString("KLblReminderNotiMsg"), data: nil, date: self.selectedDate!,identifier: StringConstants.NotificationIdentifier.offlineStockDownload)
    // }

    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.UserDefaultKey.DownloadProgress), object: nil, userInfo: ["progress": Utilities.getDoubleValue(value: progress)])
    //self.progress.setProgress(Float((Double(self.page * self.limit)) / Double(self.totalCount))  , animated: true)
    //print(Float((Double(self.page * self.limit)) / Double(self.totalCount)))
  }
}
