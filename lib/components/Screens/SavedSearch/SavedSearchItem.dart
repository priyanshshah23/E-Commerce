import 'dart:collection';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/main.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedSearchItemWidget extends StatefulWidget {
  int searchType;

  SavedSearchItemWidget(this.searchType);

  @override
  _SavedSearchItemWidgetState createState() => _SavedSearchItemWidgetState();
}

class _SavedSearchItemWidgetState extends State<SavedSearchItemWidget>
    with AutomaticKeepAliveClientMixin<SavedSearchItemWidget> {
  int page = DEFAULT_PAGE;
  BaseList savedSearchBaseList;
  BaseList recentSearchList;
  List<SavedSearchModel> arrList = [];

  @override
  void initState() {
    super.initState();
    callBaseList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi(false);
    });
  }

  callBaseList() {
    savedSearchBaseList = BaseList(BaseListState(
      noDataMsg: APPNAME,
      noDataDesc: R.string.noDataStrings.noDataFound,
      refreshBtn: R.string.commonString.refresh,
      enablePullDown: true,
      enablePullUp: true,
      isApiCalling: true,
      onPullToRefress: () {
        callApi(true);
      },
      onRefress: () {
        callApi(true);
      },
      onLoadMore: () {
        callApi(false, isLoading: true);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return savedSearchBaseList;
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    if (isRefress) {
      arrList.clear();
      page = DEFAULT_PAGE;
    }

    Map<String, dynamic> dict = {};
    dict["page"] = page;
    dict["limit"] = 25;
    dict["type"] = widget.searchType == SavedSearchType.savedSearch
        ? SavedSearchType.savedSearch
        : SavedSearchType.recentSearch;
    dict["isAppendMasters"] = true;

    NetworkCall<SavedSearchResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().mySavedSearch(dict),
      context,
      isProgress: !isRefress && !isLoading,
    )
        .then((savedSearchResp) async {
      print("sucess");
      savedSearchBaseList.state.listCount = savedSearchResp.data.list.length;
      savedSearchBaseList.state.totalCount = savedSearchResp.data.count;
      arrList.addAll(savedSearchResp.data.list);
      fillArrayList();
      page = page + 1;
      savedSearchBaseList.state.setApiCalling(false);
    }).catchError((onError) {
      if (isRefress) {
        arrList.clear();
        savedSearchBaseList.state.listCount = arrList.length;
        savedSearchBaseList.state.totalCount = arrList.length;
      }
      savedSearchBaseList.state.setApiCalling(false);
    });
  }

  fillArrayList() {
    savedSearchBaseList.state.listItems = ListView.builder(
      itemCount: arrList.length,
      itemBuilder: (BuildContext context, int index) {
        SavedSearchModel savedSearchModel = arrList[index];
        List<Map<String, dynamic>> arrData =
            getDisplayData(savedSearchModel.displayData);
        if (widget.searchType == SavedSearchType.savedSearch) {
          return getItemWidget(savedSearchModel, arrData);
        } else {
          return InkWell(
              onTap: () {
                Map<String, dynamic> dict = Map<String, dynamic>();
                dict[ArgumentConstant.ModuleType] =
                    DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH;
                dict[ArgumentConstant.IsFromDrawer] = false;
                dict["filterId"] = arrList[index].id;
                NavigationUtilities.pushRoute(DiamondListScreen.route,
                    args: dict);
              },
              child: getItemWidget(savedSearchModel, arrData));
        }
      },
    );
  }

  getItemWidget(SavedSearchModel model, List<Map<String, dynamic>> arr) {
    return Padding(
      padding: EdgeInsets.only(
          left: getSize(20),
          top: getSize(8),
          right: getSize(20),
          bottom: getSize(8)),
      child: Column(
        children: [
          Material(
            // elevation: 10,
            // shadowColor: appTheme.shadowColor,
            borderRadius: BorderRadius.circular(getSize(5)),
            child: Container(
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(
                  color: appTheme.textFieldBorderColor,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: getSize(10),
                  // left: getSize(16),
                  // right: getSize(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.searchType == SavedSearchType.savedSearch
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: getSize(16),
                                            // bottom: getSize(5.0),
                                          ),
                                          child: Text(model.name ?? "-",
                                              style: appTheme
                                                  .blackMedium16TitleColorblack),
                                        ),
                                      ],
                                    )
                                  : widget.searchType ==
                                          SavedSearchType.recentSearch
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                            left: getSize(16),
                                            // bottom: getSize(5.0),
                                          ),
                                          child: Text(
                                              DateUtilities()
                                                      .convertServerDateToFormatterString(
                                                          model.createdAt ?? "",
                                                          formatter: DateUtilities
                                                              .dd_mmm_yy_h_mm_a) ??
                                                  "-",
                                              style: appTheme
                                                  .blackMedium16TitleColorblack),
                                        )
                                      : SizedBox(),
                              widget.searchType == SavedSearchType.savedSearch
                                  ? Spacer()
                                  : SizedBox(
                                      width: getSize(16),
                                    ),
                              // widget.searchType ==
                              //             SavedSearchType.savedSearch &&
                              //         arr.length > 3
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           model.isExpand ^= true;
                              //           savedSearchBaseList.state
                              //               .setApiCalling(false);
                              //           fillArrayList();
                              //         },
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //               border: Border(
                              //                   bottom: BorderSide(
                              //             color: appTheme.colorPrimary,
                              //             width: 1.0,
                              //           ))),
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: [
                              //               Padding(
                              //                 padding: EdgeInsets.only(
                              //                     right: getSize(3)),
                              //                 child: Text(
                              //                   R.string.commonString
                              //                       .viewDetails,
                              //                   textAlign: TextAlign.center,
                              //                   style: appTheme
                              //                       .primaryColor14TextStyle,
                              //                 ),
                              //               ),
                              //               model.isExpand
                              //                   ? Image.asset(
                              //                       showLess,
                              //                       width: getSize(12),
                              //                     )
                              //                   : Image.asset(
                              //                       showMore,
                              //                       width: getSize(12),
                              //                     ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     : SizedBox(),
                              widget.searchType == SavedSearchType.savedSearch
                                  ? getPreviewItem(
                                      // R.string.commonString.modify,
                                      edit_icon,
                                      appTheme.blackPrimaryNormal14TitleColor,
                                      ()  {
                                      Map<String, dynamic> dict = {};
                                      dict["searchData"] = model.searchData;
                                      dict["savedSearchModel"] = model;
                                      dict[ArgumentConstant.IsFromDrawer] =
                                          false;
                                      NavigationUtilities.pushRoute(
                                          FilterScreen.route,
                                          args: dict);
                                    })
                                  : SizedBox(),
                              widget.searchType == SavedSearchType.savedSearch
                                  ? getPreviewItem(
                                      // R.string.commonString.delete,
                                      delete_icon_medium,
                                      appTheme.redPrimaryNormal14TitleColor,
                                      () {
                                      SyncManager.instance.callAnalytics(
                                          context,
                                          page: PageAnalytics.MYSAVED_SEARCH,
                                          section: SectionAnalytics.DELETE,
                                          action: ActionAnalytics.LIST);

                                      app
                                          .resolve<CustomDialogs>()
                                          .confirmDialog(
                                        context,
                                        barrierDismissible: true,
                                        title: "",
                                        desc: R.string.commonString.deleteItem,
                                        positiveBtnTitle:
                                            R.string.commonString.ok,
                                        negativeBtnTitle:
                                            R.string.commonString.cancel,
                                        onClickCallback: (buttonType) {
                                          if (buttonType ==
                                              ButtonType.PositveButtonClick) {
                                            SyncManager.instance
                                                .callApiForDeleteSavedSearch(
                                                    context, model.id ?? "",
                                                    success: (resp) {
                                              callApi(true);
                                            });
                                          }
                                        },
                                      );
                                    })
                                  : SizedBox(),
                              widget.searchType == SavedSearchType.savedSearch
                                  ? getPreviewItem(
                                      // R.string.commonString.search,
                                      search,
                                      appTheme.primaryColor14TextStyle, () {
                                      Map<String, dynamic> dict = new HashMap();
                                      dict["filterId"] = model.id;
                                      dict[ArgumentConstant.ModuleType] =
                                          DiamondModuleConstant
                                              .MODULE_TYPE_MY_SAVED_SEARCH;
                                      NavigationUtilities.pushRoute(
                                          DiamondListScreen.route,
                                          args: dict);
                                    })
                                  : SizedBox(),
                              widget.searchType == SavedSearchType.savedSearch
                                  ? SizedBox(
                                      width: getSize(10),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          // widget.searchType == SavedSearchType.savedSearch
                          //     ? SizedBox(
                          //         height: getSize(8),
                          //       )
                          //     : SizedBox(),
                          widget.searchType == SavedSearchType.savedSearch
                              ? Divider(
                                  color: appTheme.dividerColor,
                                )
                              : SizedBox(),
                          // widget.searchType == SavedSearchType.savedSearch
                          //     ? SizedBox(
                          //         height: getSize(6),
                          //       )
                          //     : SizedBox(),
                          if (widget.searchType == SavedSearchType.savedSearch)
                            listOfSelectedFilter(arr, model, arr.length),
                          // if (arr.length <= 3 &&
                          //     widget.searchType == SavedSearchType.savedSearch)
                          //   listOfSelectedFilter(arr, model, arr.length),
                          // if (arr.length > 3 &&
                          //     model.isExpand &&
                          //     widget.searchType == SavedSearchType.savedSearch)
                          //   listOfSelectedFilter(arr, model, arr.length),
                          // if (arr.length > 3 &&
                          //     !model.isExpand &&
                          //     widget.searchType == SavedSearchType.savedSearch)
                          //   listOfSelectedFilter(arr, model, 3),
                          if (widget.searchType == SavedSearchType.recentSearch)
                            listOfSelectedFilter(arr, model, arr.length),
                          // widget.searchType == SavedSearchType.savedSearch
                          //     ? Padding(
                          //         padding: EdgeInsets.only(
                          //           // left: getSize(15),
                          //           // right: getSize(15),
                          //           top: getSize(11),
                          //           // bottom: getSize(11),
                          //         ),
                          //         child: Container(
                          //           padding: EdgeInsets.only(
                          //               top: getSize(8), bottom: getSize(8)),
                          //           decoration: BoxDecoration(
                          //               // color: Colors.red,
                          //               border: Border(
                          //             top: BorderSide(
                          //                 color: appTheme.dividerColor),
                          //           )),
                          //           child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceAround,
                          //             children: [
                          //               getPreviewItem(
                          //                   R.string.commonString.modify,
                          //                   edit_icon,
                          //                   appTheme
                          //                       .greenPrimaryNormal14TitleColor,
                          //                   () {
                          //                 Map<String, dynamic> dict = {};
                          //                 dict["searchData"] = model.searchData;
                          //                 dict["savedSearchModel"] = model;
                          //                 dict[ArgumentConstant.IsFromDrawer] =
                          //                     false;
                          //                 NavigationUtilities.pushRoute(
                          //                     FilterScreen.route,
                          //                     args: dict);
                          //               }),
                          //               getPreviewItem(
                          //                   R.string.commonString.delete,
                          //                   delete_icon_medium,
                          //                   appTheme
                          //                       .redPrimaryNormal14TitleColor,
                          //                   () {
                          //                 SyncManager.instance.callAnalytics(
                          //                     context,
                          //                     page:
                          //                         PageAnalytics.MYSAVED_SEARCH,
                          //                     section: SectionAnalytics.DELETE,
                          //                     action: ActionAnalytics.LIST);

                          //                 app
                          //                     .resolve<CustomDialogs>()
                          //                     .confirmDialog(
                          //                   context,
                          //                   barrierDismissible: true,
                          //                   title: "",
                          //                   desc: R
                          //                       .string.commonString.deleteItem,
                          //                   positiveBtnTitle:
                          //                       R.string.commonString.ok,
                          //                   negativeBtnTitle:
                          //                       R.string.commonString.cancel,
                          //                   onClickCallback: (buttonType) {
                          //                     if (buttonType ==
                          //                         ButtonType
                          //                             .PositveButtonClick) {
                          //                       SyncManager.instance
                          //                           .callApiForDeleteSavedSearch(
                          //                               context, model.id ?? "",
                          //                               success: (resp) {
                          //                         callApi(true);
                          //                       });
                          //                     }
                          //                   },
                          //                 );
                          //               }),
                          //               getPreviewItem(
                          //                   R.string.commonString.search,
                          //                   saved_medium,
                          //                   appTheme.primaryColor14TextStyle,
                          //                   () {
                          //                 Map<String, dynamic> dict =
                          //                     new HashMap();
                          //                 dict["filterId"] = model.id;
                          //                 dict[ArgumentConstant.ModuleType] =
                          //                     DiamondModuleConstant
                          //                         .MODULE_TYPE_MY_SAVED_SEARCH;
                          //                 NavigationUtilities.pushRoute(
                          //                     DiamondListScreen.route,
                          //                     args: dict);
                          //               }),
                          //             ],
                          //           ),
                          //         ),
                          //       )
                          //     : Padding(
                          //         padding:
                          //             EdgeInsets.only(bottom: getSize(12.0)),
                          //         child: SizedBox(),
                          //       ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getPreviewItem(String img, TextStyle textStyle, Function onTap,
      {String txt}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: getSize(40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(getSize(4)),
              width: getSize(30),
              height: getSize(30),
              alignment: Alignment.center,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(getSize(15)),
              //     border: Border.all(color: appTheme.borderColor)),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Image.asset(
                  img,
                ),
              ),
            ),
            // SizedBox(
            //   width: getSize(8),
            // ),
            if (txt != null)
              Text(
                txt,
                style: textStyle,
              )
          ],
        ),
      ),
    );
  }

  listOfSelectedFilter(List<Map<String, dynamic>> arr,
      SavedSearchModel savedSearchModel, int length) {
    return Padding(
      padding: EdgeInsets.only(
          top: getSize(5),
          bottom: getSize(8),
          left: getSize(16),
          right: getSize(16)),
      child: Wrap(
        children: [
          for (int i = 0; i < length; i++)
            Container(
              // color: Colors.blue,
              width: (MathUtilities.screenWidth(context) / 2) - getSize(38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getSize(7)),
                  Text(
                    isNullEmptyOrFalse(arr[i]["value"])
                        ? "${arr[i]["key"] ?? ""}"
                        : "${arr[i]["key"] ?? ""}",
                    textAlign: TextAlign.left,
                    style: appTheme.grey14HintTextStyle,
                  ),
                  SizedBox(height: getSize(4)),
                  // SizedBox(width: getSize(16)),
                  Text(arr[i]["value"] ?? "",
                      textAlign: TextAlign.left,
                      style: appTheme.blackMedium14TitleColorblack),
                  SizedBox(height: getSize(7)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  getDisplayData(DisplayDataClass displayDataClass) {
    List<Map<String, String>> arrData = [];

    if (!isNullEmptyOrFalse(displayDataClass)) {
      if (!isNullEmptyOrFalse(displayDataClass.shp)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Shape";
        for (int i = 0; i < displayDataClass.shp.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.shp.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.or)) {
        Map<String, String> displayDataKeyValue = {};
        List<String> tempList = [];
        for (int i = 0; i < displayDataClass.or.length; i++) {
          if (!isNullEmptyOrFalse(displayDataClass.or[i].crt)) {
            String temp = displayDataClass.or[i].crt.back.toString() +
                "-" +
                displayDataClass.or[i].crt.empty.toString();
            tempList.add(temp);
          }
        }
        displayDataKeyValue["key"] = "Carat Range";
        displayDataKeyValue["value"] = tempList.join(", ");

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.col)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Color";
        for (int i = 0; i < displayDataClass.col.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.col.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.shd)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Color Shade";
        for (int i = 0; i < displayDataClass.shd.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.shd.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.clr)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Clarity";
        for (int i = 0; i < displayDataClass.clr.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.clr.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.cut)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Cut";
        for (int i = 0; i < displayDataClass.cut.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.cut.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.pol)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Polish";
        for (int i = 0; i < displayDataClass.pol.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.pol.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.sym)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Symmentry";
        for (int i = 0; i < displayDataClass.sym.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.sym.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.hA)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "H & A";
        for (int i = 0; i < displayDataClass.hA.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.hA.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.brlncy)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Brilliancy";
        for (int i = 0; i < displayDataClass.brlncy.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.brlncy.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

//      if (!isNullEmptyOrFalse(displayDataClass.wSts)) {
//        Map<String, String> displayDataKeyValue = {};
//        displayDataKeyValue["key"] = "Web Status";
//        for (int i = 0; i < displayDataClass.wSts.length; i++) {
//          displayDataKeyValue["value"] = displayDataClass.wSts.join(", ");
//        }
//
//        arrData.add(displayDataKeyValue);
//      }

      if (!isNullEmptyOrFalse(displayDataClass.isCm)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Canadamark";
        for (int i = 0; i < displayDataClass.isCm.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.isCm.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.isDor)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "DOR";
        for (int i = 0; i < displayDataClass.isDor.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.isDor.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.isFm)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "FM";
        for (int i = 0; i < displayDataClass.isFm.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.isFm.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.blkTbl)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Black Table";
        for (int i = 0; i < displayDataClass.blkTbl.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.blkTbl.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.blkSd)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Black Side";
        for (int i = 0; i < displayDataClass.blkSd.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.blkSd.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.wTbl)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "White Table";
        for (int i = 0; i < displayDataClass.wTbl.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.wTbl.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.cult)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Culet";
        for (int i = 0; i < displayDataClass.cult.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.cult.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.wSd)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "White Inclusion Side";
        for (int i = 0; i < displayDataClass.wSd.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.wSd.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.opTbl)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Open Table";
        for (int i = 0; i < displayDataClass.opTbl.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.opTbl.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.opPav)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Open Pavallion";
        for (int i = 0; i < displayDataClass.opPav.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.opPav.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.opCrwn)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Open Crown";
        for (int i = 0; i < displayDataClass.opCrwn.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.opCrwn.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.grdl)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Girdle";
        for (int i = 0; i < displayDataClass.grdl.length; i++) {
          displayDataKeyValue["value"] = displayDataClass.grdl.join(", ");
        }

        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.ctPr)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Carat Per Price";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.ctPr.back) &&
            !isNullEmptyOrFalse(displayDataClass.ctPr.empty)) {
          temp = displayDataClass.ctPr.back.toString() +
              " to " +
              displayDataClass.ctPr.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.ctPr.back)) {
          temp = displayDataClass.ctPr.back.toString();
        } else {
          temp = displayDataClass.ctPr.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.back)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "back";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.back.back) &&
            !isNullEmptyOrFalse(displayDataClass.back.empty)) {
          temp = displayDataClass.back.back.toString() +
              " to " +
              displayDataClass.back.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.back.back)) {
          temp = displayDataClass.back.back.toString();
        } else {
          temp = displayDataClass.back.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.tblPer)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Table Percentage";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.tblPer.back) &&
            !isNullEmptyOrFalse(displayDataClass.tblPer.empty)) {
          temp = displayDataClass.tblPer.back.toString() +
              " to " +
              displayDataClass.tblPer.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.tblPer.back)) {
          temp = displayDataClass.tblPer.back.toString();
        } else {
          temp = displayDataClass.tblPer.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.depPer)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Depth Percentage";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.depPer.back) &&
            !isNullEmptyOrFalse(displayDataClass.depPer.empty)) {
          temp = displayDataClass.depPer.back.toString() +
              " to " +
              displayDataClass.depPer.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.depPer.back)) {
          temp = displayDataClass.depPer.back.toString();
        } else {
          temp = displayDataClass.depPer.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.ratio)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Ratio";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.ratio.back) &&
            !isNullEmptyOrFalse(displayDataClass.ratio.empty)) {
          temp = displayDataClass.ratio.back.toString() +
              " to " +
              displayDataClass.ratio.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.ratio.back)) {
          temp = displayDataClass.ratio.back.toString();
        } else {
          temp = displayDataClass.ratio.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.length)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Length";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.length.back) &&
            !isNullEmptyOrFalse(displayDataClass.length.empty)) {
          temp = displayDataClass.length.back.toString() +
              " to " +
              displayDataClass.length.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.length.back)) {
          temp = displayDataClass.length.back.toString();
        } else {
          temp = displayDataClass.length.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.width)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Width";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.width.back) &&
            !isNullEmptyOrFalse(displayDataClass.width.empty)) {
          temp = displayDataClass.width.back.toString() +
              " to " +
              displayDataClass.width.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.width.back)) {
          temp = displayDataClass.width.back.toString();
        } else {
          temp = displayDataClass.width.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.height)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Height";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.height.back) &&
            !isNullEmptyOrFalse(displayDataClass.height.empty)) {
          temp = displayDataClass.height.back.toString() +
              " to " +
              displayDataClass.height.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.height.back)) {
          temp = displayDataClass.height.back.toString();
        } else {
          temp = displayDataClass.height.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.cAng)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Crown Angle";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.cAng.back) &&
            !isNullEmptyOrFalse(displayDataClass.cAng.empty)) {
          temp = displayDataClass.cAng.back.toString() +
              " to " +
              displayDataClass.cAng.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.cAng.back)) {
          temp = displayDataClass.cAng.back.toString();
        } else {
          temp = displayDataClass.cAng.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.cHgt)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Crown Height";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.cHgt.back) &&
            !isNullEmptyOrFalse(displayDataClass.cHgt.empty)) {
          temp = displayDataClass.cHgt.back.toString() +
              " to " +
              displayDataClass.cHgt.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.cHgt.back)) {
          temp = displayDataClass.cHgt.back.toString();
        } else {
          temp = displayDataClass.cHgt.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.grdlPer)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Girdle Per";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.grdlPer.back) &&
            !isNullEmptyOrFalse(displayDataClass.grdlPer.empty)) {
          temp = displayDataClass.grdlPer.back.toString() +
              " to " +
              displayDataClass.grdlPer.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.grdlPer.back)) {
          temp = displayDataClass.grdlPer.back.toString();
        } else {
          temp = displayDataClass.grdlPer.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.pAng)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Pavallion Angle";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.pAng.back) &&
            !isNullEmptyOrFalse(displayDataClass.pAng.empty)) {
          temp = displayDataClass.pAng.back.toString() +
              " to " +
              displayDataClass.pAng.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.pAng.back)) {
          temp = displayDataClass.pAng.back.toString();
        } else {
          temp = displayDataClass.pAng.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.pHgt)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Pavallion Height";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.pHgt.back) &&
            !isNullEmptyOrFalse(displayDataClass.pHgt.empty)) {
          temp = displayDataClass.pHgt.back.toString() +
              " to " +
              displayDataClass.pHgt.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.pHgt.back)) {
          temp = displayDataClass.pHgt.back.toString();
        } else {
          temp = displayDataClass.pHgt.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.lwr)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Lower Half";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.lwr.back) &&
            !isNullEmptyOrFalse(displayDataClass.lwr.empty)) {
          temp = displayDataClass.lwr.back.toString() +
              " to " +
              displayDataClass.lwr.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.lwr.back)) {
          temp = displayDataClass.lwr.back.toString();
        } else {
          temp = displayDataClass.lwr.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.strLn)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Star Length";

        String temp = "";
        if (!isNullEmptyOrFalse(displayDataClass.strLn.back) &&
            !isNullEmptyOrFalse(displayDataClass.strLn.empty)) {
          temp = displayDataClass.strLn.back.toString() +
              " to " +
              displayDataClass.strLn.empty.toString();
        } else if (!isNullEmptyOrFalse(displayDataClass.strLn.back)) {
          temp = displayDataClass.strLn.back.toString();
        } else {
          temp = displayDataClass.strLn.empty.toString();
        }
        displayDataKeyValue["value"] = temp;
        arrData.add(displayDataKeyValue);
      }

      if (!isNullEmptyOrFalse(displayDataClass.type2)) {
        if (!isNullEmptyOrFalse(displayDataClass.type2.empty)) {
          Map<String, String> displayDataKeyValue = {};
          displayDataKeyValue["key"] = "TYPE IIA";

          displayDataKeyValue["value"] = displayDataClass.type2.empty;
          arrData.add(displayDataKeyValue);
        }
      }

      if (!isNullEmptyOrFalse(displayDataClass.kToSArr)) {
        Map<String, String> displayDataKeyValue = {};
        displayDataKeyValue["key"] = "Key to Symbol";
        if (!isNullEmptyOrFalse(displayDataClass.kToSArr.kToSArrIn)) {
          String temp = displayDataClass.kToSArr.kToSArrIn.join(", ");
          displayDataKeyValue["value"] = temp;
        } else if (!isNullEmptyOrFalse(displayDataClass.kToSArr.kToSArrnIn)) {
          String temp = displayDataClass.kToSArr.kToSArrnIn.join(", ");
          displayDataKeyValue["value"] = temp;
        }
        arrData.add(displayDataKeyValue);
      }
    }
    if (isNullEmptyOrFalse(arrData)) {
      Map<String, String> displayDataKeyValue = {};
      displayDataKeyValue["key"] = "All All All All All";
      arrData.add(displayDataKeyValue);
    }

    return arrData;
  }

  @override
  bool get wantKeepAlive => true;
}
