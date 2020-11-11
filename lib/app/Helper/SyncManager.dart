import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Version/VersionUpdate.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:diamnow/models/excel/ExcelApiResponse.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

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

    req.user = id ?? app.resolve<PrefUtils>().getUserDetails().id;
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
    String searchText,
  }) async {
    Map<String, dynamic> dict = {};
    dict["isNotReturnTotal"] = true;
    dict["isReturnCountOnly"] = true;
    dict["filters"] = req;
    dict["search"] = searchText;

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

  void callVersionUpdateApi(BuildContext context, String screenConstant,
      {String id}) {
    NetworkCall<VersionUpdateResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .getVersionUpdate(),
            context,
            isProgress: true)
        .then(
      (resp) {
        if (resp.data != null) {
          PackageInfo.fromPlatform().then(
            (PackageInfo packageInfo) {
              String appName = packageInfo.appName;
              String packageName = packageInfo.packageName;
              String version = packageInfo.version;
              String buildNumber = packageInfo.buildNumber;
              if (Platform.isIOS) {
                print("iOS");
                if (resp.data.ios != null) {
                  num respVersion = resp.data.ios.number;

                  if (num.parse(version) < respVersion) {
                    bool hardUpdate = resp.data.ios.isHardUpdate;
                    Map<String, dynamic> dict = new HashMap();
                    dict["isHardUpdate"] = hardUpdate;
                    dict["oncomplete"] = () {
                      if (screenConstant == VersionUpdateApi.logIn) {
                        SyncManager.instance.callMasterSync(
                            NavigationUtilities.key.currentContext, () async {
                          //success
                          AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                        }, () {},
                            isNetworkError: false,
                            isProgress: true,
                            id: id).then((value) {});
                      }

                      //for splash
                      if (screenConstant == VersionUpdateApi.splash) {
                        AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                      }

                      //signinasguest and signinwithmpin
                      if (screenConstant == VersionUpdateApi.signInAsGuest ||
                          screenConstant == VersionUpdateApi.signInWithMpin)
                        Navigator.pop(context);
                    };
                    if (hardUpdate == true) {
                      if (screenConstant == VersionUpdateApi.logIn ||
                          screenConstant == VersionUpdateApi.splash) {
                        app.resolve<PrefUtils>().saveSkipUpdate(false);
                        NavigationUtilities.pushReplacementNamed(
                            VersionUpdate.route,
                            args: dict);
                      }

                      //for signinwithmpin / signinwithguest
                      if (screenConstant == VersionUpdateApi.signInAsGuest ||
                          screenConstant == VersionUpdateApi.signInWithMpin) {
                        NavigationUtilities.pushReplacementNamed(
                          VersionUpdate.route,
                          args: dict,
                        );
                      }
                    } else {
                      if (app.resolve<PrefUtils>().getSkipUpdate() == false) {
                        NavigationUtilities.pushReplacementNamed(
                            VersionUpdate.route,
                            args: dict);
                      } else {
                        //for login
                        if (screenConstant == VersionUpdateApi.logIn) {
                          SyncManager.instance.callMasterSync(
                              NavigationUtilities.key.currentContext, () async {
                            //success
                            AppNavigation.shared
                                .movetoHome(isPopAndSwitch: true);
                          }, () {},
                              isNetworkError: false,
                              isProgress: true,
                              id: id).then((value) {});
                        }

                        //for spalsh
                        if (screenConstant == VersionUpdateApi.splash)
                          AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                      }
                    }
                  } else {
                    //for login / signinasguest / signinwithmpin
                    if (screenConstant == VersionUpdateApi.logIn ||
                        screenConstant == VersionUpdateApi.signInAsGuest ||
                        screenConstant == VersionUpdateApi.signInWithMpin) {
                      SyncManager.instance.callMasterSync(
                          NavigationUtilities.key.currentContext, () async {
                        //success
                        AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                      }, () {},
                          isNetworkError: false,
                          isProgress: true,
                          id: id).then((value) {});
                    }

                    //for splash
                    if (screenConstant == VersionUpdateApi.splash)
                      AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                  }
                } else {
                  //for signinwithmpin / signwithguest
                  if (screenConstant == VersionUpdateApi.logIn ||
                      screenConstant == VersionUpdateApi.signInWithMpin ||
                      screenConstant == VersionUpdateApi.signInAsGuest) {
                    SyncManager.instance.callMasterSync(
                        NavigationUtilities.key.currentContext, () async {
                      //success
                      AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                    }, () {},
                        isNetworkError: false,
                        isProgress: true,
                        id: id).then((value) {});
                  }

                  //for splash
                  if (screenConstant == VersionUpdateApi.splash)
                    AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                }
              } else {
                print("Android");
                if (resp.data.android != null) {
                  num respVersion = resp.data.android.number;
                  if (num.parse(buildNumber) < respVersion) {
                    bool hardUpdate = resp.data.android.isHardUpdate;
                    Map<String, dynamic> dict = new HashMap();
                    dict["isHardUpdate"] = hardUpdate;
                    dict["oncomplete"] = () {
                      //only for login
                      if (screenConstant == VersionUpdateApi.logIn) {
                        SyncManager.instance.callMasterSync(
                            NavigationUtilities.key.currentContext, () async {
                          //success
                          AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                        }, () {},
                            isNetworkError: false,
                            isProgress: true,
                            id: id).then((value) {});
                      }

                      //for splash
                      if (screenConstant == VersionUpdateApi.splash)
                        AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                    };
                    if (hardUpdate == true) {
                      if (screenConstant == VersionUpdateApi.signInAsGuest ||
                          screenConstant == VersionUpdateApi.signInWithMpin) {
                        NavigationUtilities.pushReplacementNamed(
                          VersionUpdate.route,
                        );
                      } else {
                        app.resolve<PrefUtils>().saveSkipUpdate(false);
                        NavigationUtilities.pushReplacementNamed(
                            VersionUpdate.route,
                            args: dict);
                      }
                    } else {
                      if (app.resolve<PrefUtils>().getSkipUpdate() == false) {
                        NavigationUtilities.pushReplacementNamed(
                            VersionUpdate.route,
                            args: dict);
                      } else {
                        if (screenConstant == VersionUpdateApi.logIn) {
                          SyncManager.instance.callMasterSync(
                              NavigationUtilities.key.currentContext, () async {
                            //success
                            AppNavigation.shared
                                .movetoHome(isPopAndSwitch: true);
                          }, () {},
                              isNetworkError: false,
                              isProgress: true,
                              id: id).then((value) {});
                        }

                        //for splash
                        if (screenConstant == VersionUpdateApi.splash) {
                          AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                        }
                      }
                    }

                    // //signinasguest / signinwithmpin
                    // bool hardUpdate = resp.data.android.isHardUpdate;
                    // if (hardUpdate == true) {

                    // }
                  } else {
                    //for signinguest and login and signinwithmpin

                    if (screenConstant == VersionUpdateApi.logIn ||
                        screenConstant == VersionUpdateApi.signInWithMpin ||
                        screenConstant == VersionUpdateApi.signInAsGuest) {
                      SyncManager.instance.callMasterSync(
                          NavigationUtilities.key.currentContext, () async {
                        //success
                        AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                      }, () {},
                          isNetworkError: false,
                          isProgress: true,
                          id: id).then((value) {});
                    }

                    //for splash
                    if (screenConstant == VersionUpdateApi.splash)
                      AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                  }
                } else {
                  //for signinwithmpin / signinwithguest
                  if (screenConstant == VersionUpdateApi.signInWithMpin ||
                      screenConstant == VersionUpdateApi.signInAsGuest) {
                    SyncManager.instance.callMasterSync(
                        NavigationUtilities.key.currentContext, () async {
                      //success
                      AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                    }, () {},
                        isNetworkError: false,
                        isProgress: true,
                        id: id).then((value) {});
                  }

                  //for splash
                  if (screenConstant == VersionUpdateApi.splash)
                    AppNavigation.shared.movetoHome(isPopAndSwitch: true);
                }
              }
            },
          );
        }
      },
    ).catchError(
      (onError) => {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: R.string().errorString.versionError,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
            onClickCallback: (PositveButtonClick) {
          if (screenConstant == VersionUpdateApi.splash) {
            //for splash
            callVersionUpdateApi(context, screenConstant);
          } else {
            callVersionUpdateApi(context, screenConstant, id: id);
          }
        }),
      },
    );
  }

  callApiForExcel(BuildContext context, List<DiamondModel> diamondList) {
    List<String> stoneId = [];
    diamondList.forEach((element) {
      stoneId.add(element.id);
    });
    Map<String, dynamic> dict = {};
    dict["id"] = stoneId;

    NetworkCall<ExcelApiResponse>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().getExcel(dict),
      context,
    )
        .then((excelApiResponse) async {
      // success(diamondListResp);
      String url = baseURL + excelApiResponse.data.data;
      //navigate to static page...

      // getWebView(context, url);
    }).catchError((onError) {
      print(onError);
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
