import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
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

      if (masterResp.data.permission != null) {
        await app.resolve<PrefUtils>().saveUserPermission(
              masterResp.data.permission,
            );
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
    Map<String, dynamic> req,
    Function(DiamondListResp) success,
    Function failure, {
    bool isProgress = true,
  }) async {
    Map<String, dynamic> dict = {};
    dict["isNotReturnTotal"] = true;
    dict["isReturnCountOnly"] = true;
    dict["filters"] = req;

    NetworkCall<DiamondListResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .diamondListPaginate(dict),
      context,
      isProgress: isProgress,
    )
        .then((diamondListResp) async {
      success(diamondListResp);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future callApiForCreateDiamondTrack(
    BuildContext context,
    int trackType,
    CreateDiamondTrackReq req,
    Function(BaseApiResp) success,
    Function(ErrorResp) failure, {
    bool isProgress = true,
  }) async {
    NetworkCall<BaseApiResp>()
        .makeCall(
      () => getTrackTypeCall(trackType, req),
      context,
      isProgress: isProgress,
    )
        .then((resp) async {
      success(resp);
    }).catchError((onError) => {if (onError is ErrorResp) failure(onError)});
  }

  Future callApiForDeleteDiamondTrack(
    BuildContext context,
    int trackType,
    TrackDelReq req,
    Function(BaseApiResp) success,
    Function(ErrorResp) failure, {
    bool isProgress = true,
  }) async {
    NetworkCall<BaseApiResp>()
        .makeCall(
      () => getTrackDelTypeCall(trackType, req),
      context,
      isProgress: isProgress,
    )
        .then((resp) async {
      success(resp);
    }).catchError((onError) => {if (onError is ErrorResp) failure(onError)});
  }

  Future<BaseApiResp> getTrackTypeCall(
      int trackType, CreateDiamondTrackReq req) {
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_COMMENT:
        return app.resolve<ServiceModule>().networkService().upsetComment(req);
      case DiamondTrackConstant.TRACK_TYPE_BID:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .createDiamondBid(req);
      default:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .createDiamondTrack(req);
    }
  }

  Future<BaseApiResp> getTrackDelTypeCall(int trackType, TrackDelReq req) {
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_COMMENT:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondComentDelete(req);
        break;
      case DiamondTrackConstant.TRACK_TYPE_BID:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondBidDelete(req);
        break;
      default:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondTrackDelete(req);
    }
  }

  Future callApiForPlaceOrder(
    BuildContext context,
    PlaceOrderReq req,
    Function(BaseApiResp) success,
    Function(ErrorResp) failure, {
    bool isProgress = true,
  }) async {
    NetworkCall<BaseApiResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().placeOrder(req),
      context,
      isProgress: isProgress,
    )
        .then((resp) async {
      success(resp);
    }).catchError((onError) => {if (onError is ErrorResp) failure(onError)});
  }

  Future callApiForBlock(
    BuildContext context,
    TrackDataReq req,
    Function(TrackBlockResp) success,
    Function(ErrorResp) failure, {
    bool isProgress = false,
  }) async {
    NetworkCall<TrackBlockResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().diamondBlockList(req),
      context,
      isProgress: isProgress,
    )
        .then((resp) async {
      success(resp);
    }).catchError((onError) => {if (onError is ErrorResp) failure(onError)});
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
    double discount = 0.0;

    for (var item in diamondList) {
      if (item.rap > 0) {
        carat += item.crt;
        calcAmount += item.amt;
        rapAvg += item.rap * item.crt;
        priceCrt += item.ctPr * item.crt;
      } else {
        carat += item.crt;
        calcAmount += item.amt;
        rapAvg += item.rap * item.crt;
        priceCrt += item.ctPr * item.crt;
      }
    }
    avgRapAmt = rapAvg / carat;
    avgPriceCrt = priceCrt / carat;
    return [carat, calcAmount, rapAvg, avgRapAmt, avgPriceCrt, discount];
  }

  List<num> getFinalCalculations(List<DiamondModel> diamondList) {
    num totalFinalValue = 0;
    num totalCarat = 0;
    num totalRapPrice = 0;

    for (var item in diamondList) {
      totalFinalValue += item.getFinalAmount();
      totalCarat += item.crt;
      totalRapPrice += (item.rap * item.crt);
    }

    num avgFinalValue = totalFinalValue / totalCarat;
    num avgRap = totalRapPrice / totalCarat;

    return [
      avgFinalValue,
      totalFinalValue,
      (1 - (avgFinalValue / avgRap)) * -100
    ];
  }

  //Delete Saved search
  callApiForDeleteSavedSearch(BuildContext context, String id,
      {Function(BaseApiResp) success}) {
    Map<String, dynamic> dict = {};
    dict["id"] = id;

    NetworkCall<BaseApiResp>()
        .makeCall(
      () =>
          app.resolve<ServiceModule>().networkService().deleteSavedSearch(dict),
      context,
      isProgress: true,
    )
        .then((resp) async {
      success(resp);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: R.string().commonString.error,
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }
}
