import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();

  SyncManager._internal();

  static SyncManager get instance {
    return _instance;
  }

  factory SyncManager() {
    return _instance;
  }

  Future callMasterSync(
    BuildContext context,
    Function success,
    Function failure, {
    bool isNetworkError = true,
    bool isProgress = true,
    String id,
  }) async {
    MasterReq req = MasterReq();

//    req.serverLastSync = app.resolve<PrefUtils>().getMasterSyncDate();

    req.user = id;
    NetworkCall<MasterResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().getMaster(req),
            context,
            isProgress: isProgress,
            isNetworkError: isNetworkError)
        .then((masterResp) async {
      // save Logged In user
      if (masterResp.data.loggedInUser != null) {
        app.resolve<PrefUtils>().saveUser(masterResp.data.loggedInUser);
      }

      //Append static data masters
      List<Master> arrLocalData = await Config().getLocalDataJson();
      masterResp.data.masters.list.addAll(arrLocalData);

      await AppDatabase.instance.masterDao
          .addOrUpdate(masterResp.data.masters.list);

      await AppDatabase.instance.masterDao
          .delete(masterResp.data.masters.deleted);

      await AppDatabase.instance.sizeMasterDao
          .addOrUpdate(masterResp.data.sizeMaster.list);

      await AppDatabase.instance.sizeMasterDao
          .delete(masterResp.data.sizeMaster.deleted);

      // // save master sync date
      // app.resolve<PrefUtils>().saveMasterSyncDate(masterResp.data.lastSyncDate);

      // success block
      success();
      // callHandler()
    }).catchError((onError) => {
              failure(),
              if (isNetworkError)
                {
                  // showToast((onError is ErrorResp)
                  //     ? onError.message
                  //     : onError.toString()),
                },
            });
  }

  Future callApiForDiamondList(
    BuildContext context,
    DiamondListReq req,
    Function(DiamondListResp) success,
    Function failure, {
    bool isProgress = true,
  }) async {
    NetworkCall<DiamondListResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().diamondList(req),
      context,
      isProgress: isProgress,
    )
        .then((diamondListResp) async {
      success(diamondListResp);
    }).catchError((onError) => {
              print(onError),
              //failure()
            });
  }

  List<num> getTotalCaratRapAmount(List<DiamondModel> diamondList) {
    double carat = 0.0;
    double calcAmount = 0.0;
    double rapAvg = 0.0;
    double fancyCarat = 0.0;
    double fancyAmt = 0.0;

    for (var item in diamondList) {
      if (item.rap > 0) {
        carat += item.crt;
        calcAmount += item.ctPr;
        rapAvg += item.rap * item.crt;
      } else {
        fancyCarat += item.crt;
        fancyAmt += item.amt;
      }
    }
    return [carat, calcAmount, rapAvg, fancyCarat, fancyAmt];
  }

  List<num> getTotalCaratAvgRapAmount(List<DiamondModel> diamondList) {
    double carat = 0.0;
    double calcAmount = 0.0;
    double rapAvg = 0.0;
    double priceCrt = 0.0;
    double avgRapAmt = 0.0;
    double avgPriceCrt = 0.0;
//    double fancyCarat = 0.0;
//    double fancyAmt = 0.0;

    for (var item in diamondList) {
      if (item.rap > 0) {
        carat += item.crt;
        calcAmount += item.ctPr;
        rapAvg += item.rap * item.crt;
        priceCrt += item.crt * item.ctPr;
      } else {
        carat += item.crt;
        calcAmount += item.ctPr;
        rapAvg += item.rap * item.crt;
        priceCrt += item.crt * item.ctPr;
      }
    }

    avgRapAmt = rapAvg / carat;
    avgPriceCrt = priceCrt / carat;
    return [carat, calcAmount, rapAvg, avgRapAmt, avgPriceCrt];
  }
}
