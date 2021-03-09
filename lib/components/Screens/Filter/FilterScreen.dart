import 'dart:collection';

import 'package:diamnow/app/AppConfiguration/AppNavigation.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/Screens/Dialogue/SelectionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/Filter/Widget/AddDemand.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CertNoWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ColorWhiteFancyWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ColorWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/FromToWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SeperatorWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/components/Screens/MyDemand/MyDemandScreen.dart';
import 'package:diamnow/components/Screens/Notification/Notifications.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/components/Screens/Search/Search.dart';
import 'package:diamnow/components/Screens/VoiceSearch/VoiceSearch.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/FilterModel/SelectStatusModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/FilterRequest.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxbus/rxbus.dart';

class FilterScreen extends StatefulScreenWidget {
  static const route = "FilterScreen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;
  SavedSearchModel savedSearchModel;
  DisplayDataClass dictSearchData;

  FilterScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
      if (arguments["searchData"] != null) {
        dictSearchData = arguments["searchData"];
      }
      if (arguments["savedSearchModel"] != null) {
        savedSearchModel = arguments["savedSearchModel"];
      }
    }
  }

  @override
  _FilterScreenState createState() => _FilterScreenState(
        moduleType,
        isFromDrawer,
        dictSearchData: dictSearchData,
        savedSearchModel: savedSearchModel,
      );
}

class _FilterScreenState extends StatefulScreenWidgetState {
  int moduleType;
  bool isFromDrawer;
  DisplayDataClass dictSearchData;
  SavedSearchModel savedSearchModel;

  _FilterScreenState(this.moduleType, this.isFromDrawer,
      {this.dictSearchData, this.savedSearchModel});

  List<SelectionPopupModel> selectedOptions = List();

  int segmentedControlValue = 0;
  PageController controller = PageController();
  List<TabModel> arrTab = [];
  List<FormBaseModel> arrList = [];
  List<BottomTabModel> arrBottomTab;
  String filterId;
  List<FilterOptions> optionList = List<FilterOptions>();
  Config config = Config();
  List<SelectStatusModel> selectStatusModel = [];
  bool isCompanySelected = false;
  bool isStatusSelected = false;

  //PopUp data for savedsearch...
  List<SelectionPopupModel> saveSearchList = List<SelectionPopupModel>();

  @override
  void initState() {
    super.initState();
    registerRsBus();
    selectStatusModel = [];
    if (selectStatus != null && selectStatus.length > 0) {
      isStatusSelected = true;
    }
    selectStatusModel.addAll(SelectStatusModel.dynamicList);
    selectStatusModel.forEach((element) {
      element.isSelected = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      config.getFilterJson(isSearch: true).then((result) {
        setState(() {
          arrList = result.where((element) {
            if (element.viewType == ViewTypes.selection) {
              if (element is SelectionModel)
                return !isNullEmptyOrFalse(element.masters);
            }
            return true;
          }).toList();

          if (!isNullEmptyOrFalse(this.dictSearchData)) {
            arrList = FilterDataSource()
                .prepareFilterDataSource(arrList, this.dictSearchData);
          }
        });
      });
      config.getTabJson().then((result) {
        setState(() {
          arrTab = result;
        });
      });
    });
    arrBottomTab = BottomTabBar.getFilterScreenBottomTabs(
        isForEditSavedSearch: !isNullEmptyOrFalse(this.savedSearchModel));
    setState(() {
      //
    });
    app.resolve<PrefUtils>().saveCompany(null);
    if (app.resolve<PrefUtils>().getCompanyDetails() != null) {
      isCompanySelected = true;
    }
  }

  @override
  void dispose() {
    RxBus.destroy(tag: eventMasterSelection);
    RxBus.destroy(tag: eventMasterForDeSelectMake);
    RxBus.destroy(tag: eventMasterForDeSelectMake);
    RxBus.destroy(tag: eventMasterForGroupWidgetSelectAll);
    super.dispose();
  }

  registerRsBus() {
    RxBus.register<Map<MasterSelection, bool>>(tag: eventMasterSelection)
        .listen(
      (event) => setState(
        () {
          List<SelectionModel> list = arrList
              .where((element) => element.viewType == ViewTypes.selection)
              .toList()
              .cast<SelectionModel>();

          event.keys.first.masterToSelect.forEach((element) {
            SelectionModel temp = list.firstWhere((mainElement) {
              return mainElement.masterCode == element.code;
            });
            if (!isNullEmptyOrFalse(temp)) {
              temp.masters.forEach((elementSubMaster) {
                elementSubMaster.isSelected = false;

                if (element.subMasters.contains(elementSubMaster.code)) {
                  elementSubMaster.isSelected = event.values.first;
                }
              });
            }
          });
        },
      ),
    );

    RxBus.register<bool>(tag: eventMasterForDeSelectMake).listen(
      (event) => setState(
        () {
          List<SelectionModel> list = arrList
              .where((element) => element.viewType == ViewTypes.selection)
              .toList()
              .cast<SelectionModel>();

          list.forEach((element) {
            if (element.masterCode == MasterCode.make) {
              element.masters.forEach((element) {
                if (element.code != MasterCode.noBgm)
                  element.isSelected = false;
              });
            }
          });
        },
      ),
    );

    //Group selection for All
    RxBus.register<Map<String, bool>>(tag: eventMasterForGroupWidgetSelectAll)
        .listen((event) {
      List<ColorModel> list = arrList
          .where((element) => element.viewType == ViewTypes.groupWidget)
          .toList()
          .cast<ColorModel>();

      List<ColorModel> list2 = list
          .where((element) => element.masterCode == event.keys.first)
          .toList()
          .cast<ColorModel>();

      list2.forEach((element) {
        element.mainMasters.forEach((element) {
          if (element.sId != R.string.commonString.showMore) {
            element.isSelected = event.values.first;
          }
        });
      });
      list2.forEach((element) {
        element.groupMaster.forEach((element) {
          if (element.sId != R.string.commonString.showMore) {
            element.isSelected = event.values.first;
          }
        });
      });
    });

    RxBus.register<Map<String, dynamic>>(
            tag: eventMasterForSingleItemOfGroupSelection)
        .listen((event) {
      String masterCode = event["masterCode"];
      String selectedMasterCode = event["selectedMasterCode"];
      bool isSelected = event["isSelected"];
      List<MasterSelection> masterSelection = event["masterSelection"];
      bool isGroupSelected = event["isGroupSelected"];

      List<ColorModel> list = arrList
          .where((element) => element.viewType == ViewTypes.groupWidget)
          .toList()
          .cast<ColorModel>();

      List<ColorModel> list2 = list
          .where((element) => element.masterCode == masterCode)
          .toList()
          .cast<ColorModel>();

      if (!isNullEmptyOrFalse(list2)) {
        if (isGroupSelected) {
          for (var item in masterSelection) {
            if (item.code == selectedMasterCode) {
              if (isGroupSelected) {
                for (var subMaster in item.masterToSelect) {
                  subMaster.subMasters.forEach((strCode) {
                    list2.first.mainMasters.forEach((element) {
                      if (element.code == strCode) {
                        element.isSelected = isSelected;
                      }
                    });
                  });
                }
              }
            }
          }
        } else {
          list2.first.groupMaster.forEach((element) {
            element.isSelected = false;
          });

          List<Master> masters = list2.first.mainMasters
              .where((element) => element.isSelected == true)
              .toList();

          List<String> masterCodes = masters.map((e) => e.code).toList();

          for (var item in masterSelection) {
            item.masterToSelect.forEach((element) {
              if (element.subMasters
                      .where((f) => masterCodes.contains(f))
                      .toList()
                      .length ==
                  element.subMasters.length) {
                list2.first.groupMaster.forEach((element) {
                  if (element.code == item.code) {
                    element.isSelected = true;
                  }
                });
              }
            });
          }
        }
      }
    });
  }

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    if (selectStatus != null && selectStatus.length > 0) {
      isStatusSelected = true;
    }
//    app.resolve<PrefUtils>().saveCompany(null);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: appTheme.whiteColor,
            appBar: getAppBar(
                context,
                moduleType ==
                        DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH
                    ? R.string.screenTitle.searchOffline
                    : R.string.screenTitle.searchDiamond,
                bgColor: appTheme.whiteColor,
                leadingButton: isFromDrawer
                    ? getDrawerButton(context, true)
                    : getBackButton(context),
                centerTitle: false,
                actionItems: [
                  if (app.resolve<PrefUtils>().getUserDetails().type ==
                      UserConstant.SALES)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SelectionScreen(
                                title: R.string.screenTitle.selectCompany,
                                hintText: R.string.commonString.search,
                                positiveButtonTitle:
                                    R.string.commonString.apply,
                                negativeButtonTitle:
                                    R.string.commonString.cancel,
                                isSearchEnable: true,
                                type: CellType.Company,
                                isMultiSelectionEnable: false,
                                applyFilterCallBack: (
                                    {List<SelectionPopupModel>
                                        multiSelectedItem}) {
                                  isCompanySelected = true;
                                  app
                                      .resolve<PrefUtils>()
                                      .saveCompany(multiSelectedItem.first);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: getSize(Spacing.rightPadding),
                          left: getSize(8.0),
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Center(
                              child: Image.asset(
                                buildingIcon,
                                height: getSize(20),
                                width: getSize(20),
                              ),
                            ),
                            Visibility(
                              visible: isCompanySelected,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: getSize(10),
                                ),
                                height: getSize(8),
                                width: getSize(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appTheme.colorPrimary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (app.resolve<PrefUtils>().getUserDetails().type ==
                      UserConstant.SALES)
                    InkWell(
                      onTap: () {
                        openDialogueForSelectStatus(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: getSize(Spacing.rightPadding),
                          left: getSize(8.0),
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Center(
                              child: Image.asset(
                                descendantIcon,
                                height: getSize(20),
                                width: getSize(20),
                              ),
                            ),
                            Visibility(
                              visible: isStatusSelected,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: getSize(10),
                                ),
                                height: getSize(8),
                                width: getSize(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appTheme.colorPrimary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      NavigationUtilities.pushRoute(Notifications.route);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: getSize(Spacing.rightPadding),
                          left: getSize(8.0)),
                      child: Image.asset(
                        notification,
                        height: getSize(20),
                        width: getSize(20),
                      ),
                    ),
                  ),
                ]),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: getSize(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < arrTab.length; i++)
                        setTitleOfSegment(arrTab[i].title, i)
                    ],
                  ),
                ),
                // isNullEmptyOrFalse(arrTab)
                //     ? SizedBox()
                //     : SizedBox(height: getSize(16)),
                // isNullEmptyOrFalse(arrTab) ? SizedBox() : _segmentedControl(),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: isNullEmptyOrFalse(arrList)
                        ? SizedBox()
                        : getPageView(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: getBottomTab(),
          ),
          (app
                          .resolve<PrefUtils>()
                          .isDisplayedTour(PrefUtils().keySearchTour) ==
                      false &&
                  this.moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH)
              ? OverlayScreen(
                  moduleType,
                  finishTakeTour: () {
                    setState(() {});
                  },
                  scrollIndex: (index) {
                    // if (index == 0 || index == 1) {
                    //   Scrollable.ensureVisible(searchKey.currentContext);
                    // } else if (index == 2) {
                    //   Scrollable.ensureVisible(savedSearchKey.currentContext);
                    // } else if (index == 3) {
                    //   Scrollable.ensureVisible(sellerKey.currentContext);
                    // }
                  },
                )
              : SizedBox(),
        ],
      ),
    );
  }

  List<String> selectStatus = [];
  List<String> oldSelectStatus = [];

  openDialogueForSelectStatus(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext localContext) {
//        selectStatusModel.forEach((element) {
//          selectStatus.forEach((item) {
//                print(element.typeConstant);
//                print(item);
//                print(element.typeConstant == item);
//            if (element.typeConstant == item) {
//              element.isSelected = true;
////              selectStatus.add(element.typeConstant);
//            }
//          });
//        });
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: getSize(20),
            vertical: getSize(20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              getSize(25),
            ),
          ),
          child: StatefulBuilder(builder: (localContext, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: getSize(30),
                    bottom: getSize(14),
                  ),
                  child: Text(
                    "Select Status",
                    style: appTheme.black18TextStyle,
                  ),
                ),
                ListView.builder(
                  itemCount: selectStatusModel.length,
                  shrinkWrap: true,
                  itemBuilder: (localContext, int index) {
                    var mapData = selectStatusModel[index];
                    return CheckboxListTile(
                      title: Text(
                        mapData.title,
                        style: appTheme.black14TextStyle,
                      ),
                      value: mapData.isSelected,
                      activeColor: appTheme.colorPrimary,
                      onChanged: (newValue) {
                        setState(() {
                          mapData.isSelected = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getSize(20),
                    bottom: getSize(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: getSize(20),
                            right: getSize(20),
                          ),
                          child: AppButton.flat(
                            onTap: () {
                              selectStatus = oldSelectStatus;
                              selectStatusModel.forEach((element) {
                                element.isSelected = false;
                              });
                              selectStatusModel.forEach((element) {
                                selectStatus.forEach((item) {
                                  print(element.typeConstant);
                                  print(item);
                                  print(element.typeConstant == item);
                                  if (element.typeConstant == item) {
                                    element.isSelected = true;
                                  }
                                });
                              });
                              Navigator.pop(context, true);
                              setState(() {});
                            },
                            text: "cancel",
                            borderRadius: getSize(5),
                            textColor: appTheme.colorPrimary,
                            backgroundColor: appTheme.whiteColor,
                            fitWidth: true,
                            isBorder: true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: getSize(20),
                          ),
                          child: AppButton.flat(
                            onTap: () {
                              selectStatus.clear();
                              selectStatusModel.forEach((element) {
                                if (element.isSelected) {
                                  selectStatus.add(element.typeConstant);
                                }
                              });
                              selectStatus = selectStatus.toSet().toList();
                              oldSelectStatus = selectStatus;
                              if (selectStatus.length > 0) {
                                isStatusSelected = true;
                              } else {
                                isStatusSelected = false;
                              }
                              print(selectStatus);
                              Navigator.pop(context, true);
                            },
                            text: "Apply",
                            backgroundColor: appTheme.colorPrimary,
                            borderRadius: getSize(5),
                            fitWidth: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  setTitleOfSegment(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          segmentedControlValue = index;
          controller.animateToPage(segmentedControlValue,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        });
      },
      child: Column(
        children: [
          Text(
            title ?? "",
            style: segmentedControlValue == index
                ? appTheme.blackSemiBold18TitleColorblack
                : appTheme.greySemibold18TitleColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: getSize(8)),
            child: Container(
                height: getSize(3),
                width: getSize(50),
                color: segmentedControlValue == index
                    ? appTheme.colorPrimary
                    : Colors.transparent),
          ),
        ],
      ),
    );
  }

  //my demand popUP
  String _selectedDate;
  String diamondTitle;

  callApiForAddDemand(String selectedDate, String diamondTitle) {
    Map<String, dynamic> dict = {};
    dict["filter"] = FilterRequest().createRequest(arrList);
    dict["name"] = diamondTitle;
    dict["searchType"] = DiamondSearchType.DEMAND;
    dict["expiryDate"] = selectedDate;

    NetworkCall<AddDemandModel>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().addDemand(dict),
      context,
      isProgress: true,
    )
        .then((diamondListResp) async {
      app.resolve<CustomDialogs>().confirmDialog(
        context,
        title: R.string.commonString.demandadded,
        desc: R.string.commonString.demandAddedSuccessfully,
        negativeBtnTitle: R.string.commonString.myDemand,
        positiveBtnTitle: R.string.commonString.home,
        onClickCallback: (click) {
          if (click == ButtonType.PositveButtonClick) {
            AppNavigation.shared.movetoHome(isPopAndSwitch: true);
          } else {
            Map<String, dynamic> dict = {};
            dict[ArgumentConstant.ModuleType] =
                DiamondModuleConstant.MODULE_TYPE_MY_DEMAND;
            NavigationUtilities.pushRoute(MyDemandScreen.route, args: dict);
          }
        },
      );
      // showToast(R.string.commonString.demandAddedSuccessfully,
      //     context: context);
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  //my demand popup end.
  getAddDemand() {
    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.MY_DEMAND,
        section: SectionAnalytics.ADD,
        action: ActionAnalytics.OPEN);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: getSize(20), vertical: getSize(20)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getSize(25)),
          ),
          child: AddDemand(
              title: R.string.commonString.addDemand,
              arrList: arrList,
              applyCallBack: ({String selectedDate, String diamondTitle}) {
                callApiForAddDemand(selectedDate, diamondTitle);
              }),
        );
      },
    );
  }

  getSavedSearchPopUp() {
    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.MYSAVED_SEARCH,
        section: SectionAnalytics.LIST,
        action: ActionAnalytics.CLICK);

    if (!isNullEmptyOrFalse(saveSearchList)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: getSize(20), vertical: getSize(20)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getSize(25)),
            ),
            child: SelectionDialogue(
              title: R.string.commonString.savedSearch,
              hintText: R.string.commonString.searchSavedSearch,
              selectionOptions: saveSearchList,
              showViewAllButton: true,
              showViewAllButtonCallBack: () {
                NavigationUtilities.pushRoute(SavedSearchScreen.route);
              },
              applyFilterCallBack: (
                  {SelectionPopupModel selectedItem,
                  List<SelectionPopupModel> multiSelectedItem}) {
                Map<String, dynamic> dict = new HashMap();
                dict["filterId"] = selectedItem.id;
                dict[ArgumentConstant.ModuleType] =
                    DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                NavigationUtilities.pushRoute(
                  DiamondListScreen.route,
                  args: dict,
                );
              },
            ),
          );
        },
      );
    } else {
      SyncManager.instance.callAnalytics(context,
          page: PageAnalytics.MYSAVED_SEARCH,
          section: SectionAnalytics.ADD,
          action: ActionAnalytics.CLICK);

      Map<String, dynamic> dict = {};
      dict["type"] = SavedSearchType.savedSearch;
      dict["isAppendMasters"] = true;

      NetworkCall<SavedSearchResp>()
          .makeCall(
        () => app.resolve<ServiceModule>().networkService().mySavedSearch(dict),
        context,
      )
          .then((savedSearchResp) async {
        for (var item in savedSearchResp.data.list) {
          saveSearchList
              .add(SelectionPopupModel(item.id, item.name, isSelected: false));
        }
        ;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: getSize(20), vertical: getSize(20)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(getSize(25)),
              ),
              child: SelectionDialogue(
                hintText: R.string.commonString.searchSavedSearch,
                title: R.string.commonString.savedSearch,
                selectionOptions: saveSearchList,
                applyFilterCallBack: (
                    {SelectionPopupModel selectedItem,
                    List<SelectionPopupModel> multiSelectedItem}) {
                  Map<String, dynamic> dict = new HashMap();
                  dict["filterId"] = selectedItem.id;
                  dict[ArgumentConstant.ModuleType] =
                      DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                  NavigationUtilities.pushRoute(
                    DiamondListScreen.route,
                    args: dict,
                  );
                },
              ),
            );
          },
        );
      }).catchError((onError) {
        showToast(R.string.commonString.noSavedSearch, context: context);
      });
    }
  }

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: arrBottomTab,
      onClickCallback: (obj) async {
        //
        if (obj.code == BottomCodeConstant.filterSavedSearch) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_mySavedSearch)
              .view) {
            getSavedSearchPopUp();
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filterAddDemamd) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_myDemand)
              .insert) {
            if (!isNullEmptyOrFalse(FilterRequest().createRequest(arrList))) {
              Map<String, dynamic> map = FilterRequest()
                  .createRequest(arrList, selectedStatus: selectStatus);
//              if (app.resolve<PrefUtils>().getUserDetails().type ==
//                      UserConstant.CUSTOMER &&
//                  map.length < 3) {
//                app.resolve<CustomDialogs>().errorDialog(
//                      context,
//                      "",
//                      "Please select any 2 criteria.",
//                      btntitle: R.string.commonString.ok,
//                    );
//              } else
                getAddDemand();
            } else {
              showToast(R.string.commonString.selectAtleastOneFilter,
                  context: context);
            }
            // place code
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filterSearch) {
          //Check internet is online or not
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            //Save filter Param offline
            Map<String, dynamic> payload = {};
            payload["module"] =
                DiamondModuleConstant.MODULE_TYPE_FILTER_OFFLINE_NOTI_CLICK;

            payload["payload"] = FilterRequest().createRequest(arrList);

            app.resolve<PrefUtils>().saveFilterOffline(payload);

            showToast(
                "You are offline, Your search is saved. When you are connected with internet, You will be notified and you can continue your search.",
                context: context);
          } else {
            if (app
                    .resolve<PrefUtils>()
                    .getModulePermission(
                        ModulePermissionConstant.permission_offline_stock)
                    .view &&
                moduleType ==
                    DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
              //Query for sembast
              Map<String, dynamic> dict = new HashMap();
              dict["filterModel"] = arrList;
              dict[ArgumentConstant.ModuleType] = moduleType;
              NavigationUtilities.pushRoute(
                DiamondListScreen.route,
                args: dict,
              );
            } else if (segmentedControlValue == 2) {
              if (app
                  .resolve<PrefUtils>()
                  .getModulePermission(
                      ModulePermissionConstant.permission_matchPair)
                  .view) {
                Map<String, dynamic> map = FilterRequest()
                    .createRequest(arrList, selectedStatus: selectStatus);
//                if (/*app.resolve<PrefUtils>().getUserDetails().type ==
//                        UserConstant.CUSTOMER &&*/
//                    map.length < 3) {
//                  app.resolve<CustomDialogs>().errorDialog(
//                        context,
//                        "",
//                        "Please select any 2 criteria.",
//                        btntitle: R.string.commonString.ok,
//                      );
//                } else {
                  SyncManager.instance.callApiForMatchPair(context, map,
                      (diamondListResp) {
                    Map<String, dynamic> dict = new HashMap();
                    dict["filterId"] = diamondListResp.data.filter.id;
                    dict["filter"] = FilterRequest().createRequest(arrList);
                    dict[ArgumentConstant.ModuleType] =
                        DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR;
                    NavigationUtilities.pushRoute(DiamondListScreen.route,
                        args: dict);
                  }, (onError) {});
//                }
              }
              // place code
            } else if (app
                .resolve<PrefUtils>()
                .getModulePermission(
                    ModulePermissionConstant.permission_searchResult)
                .view) {
              callApiForGetFilterId(DiamondModuleConstant.MODULE_TYPE_SEARCH,
                  isSearch: true);
            } else {
              app.resolve<CustomDialogs>().accessDenideDialog(context);
            }
          }
        } else if (obj.code == BottomCodeConstant.filterSaveAndSearch) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_mySavedSearch)
              .insert) {
            if (!isNullEmptyOrFalse(FilterRequest().createRequest(arrList))) {
              callApiForGetFilterId(DiamondModuleConstant.MODULE_TYPE_SEARCH,
                  isSavedSearch: true, isSearch: true);
            } else {
              showToast(R.string.commonString.selectAtleastOneFilter,
                  context: context);
            }
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filterReset) {
          arrList.forEach((element) {
            if (element is SelectionModel) {
              element.masters.forEach((element) {
                element.isSelected = false;
              });
              element.isShowAllSelected = false;
              element.caratRangeChipsToShow = [];
            }
            if (element is KeyToSymbolModel) {
              element.masters.forEach((element) {
                element.isSelected = false;
              });
            }
            if (element is FromToModel) {
              element.valueFrom = "";
              element.valueTo = "";
            }
            if (element is ColorModel) {
              element.masters.forEach((element) {
                element.isSelected = false;
              });
              element.mainMasters.forEach((element) {
                element.isSelected = false;
              });
              element.groupMaster.forEach((element) {
                element.isSelected = false;
              });
              element.intensity.forEach((element) {
                element.isSelected = false;
              });
              element.overtone.forEach((element) {
                element.isSelected = false;
              });
            }
          });
          selectStatus.clear();
          selectStatusModel.forEach((element) {
            element.isSelected = false;
          });
          isStatusSelected = false;
          isCompanySelected = false;
          app.resolve<PrefUtils>().saveCompany(null);
          setState(() {});
        }
      },
    );
  }

  callApiForGetFilterId(int moduleType,
      {bool isSavedSearch = false, bool isSearch = false}) {
    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.DIAMOND_SEARCH,
        section: SectionAnalytics.SEARCH,
        action: ActionAnalytics.CLICK);
    Map<String, dynamic> map = FilterRequest().createRequest(arrList,
        selectedStatus: selectStatus,
        isFromLayout: segmentedControlValue == 3 ? true : false);
//    if (app.resolve<PrefUtils>().getUserDetails().type ==
//            UserConstant.CUSTOMER &&
//        map.length < 3) {
//      app.resolve<CustomDialogs>().errorDialog(
//            context,
//            "",
//            "Please select any 2 criteria.",
//            btntitle: R.string.commonString.ok,
//          );
//    } else {
    SyncManager.instance.callApiForDiamondList(
      context,
      map,
      (diamondListResp) {
        if (isSavedSearch) {
          openBottomSheetForSavedSearch(
              context,
              FilterRequest()
                  .createRequest(arrList, selectedStatus: selectStatus),
              isSearch: isSearch,
              savedSearchModel: this.savedSearchModel);
        } else {
          if (isSearch) {
            if (diamondListResp.data.count == 0) {
              app.resolve<CustomDialogs>().confirmDialog(context,
                  desc: R.string.commonString.noDiamondFound,
                  positiveBtnTitle: R.string.commonString.ok,
                  negativeBtnTitle: R.string.screenTitle.addDemand,
                  onClickCallback: (buttonType) {
                if (buttonType == ButtonType.NagativeButtonClick) {
                  if (app
                      .resolve<PrefUtils>()
                      .getModulePermission(
                          ModulePermissionConstant.permission_myDemand)
                      .insert) {
                    if (!isNullEmptyOrFalse(
                        FilterRequest().createRequest(arrList)))
                      getAddDemand();
                    else {
                      showToast(R.string.commonString.selectAtleastOneFilter,
                          context: context);
                    }
                    // place code
                  }
                }
              });
            } else {
              Map<String, dynamic> dict = new HashMap();
              dict["filterId"] = diamondListResp.data.filter.id;
              dict["filters"] = FilterRequest().createRequest(arrList);
              dict['isCompanySelected'] = isCompanySelected ?? false;
              dict[ArgumentConstant.ModuleType] = moduleType;
              NavigationUtilities.pushRoute(DiamondListScreen.route,
                  args: dict);
            }
          } else {
            Map<String, dynamic> dict = new HashMap();
            dict["filterId"] = diamondListResp.data.filter.id;
            dict["filters"] = FilterRequest().createRequest(arrList);
            dict['isCompanySelected'] = isCompanySelected ?? false;
            dict[ArgumentConstant.ModuleType] = moduleType;
            NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
          }
        }
      },
      (onError) {
        //print("Error");
      },
    );
//    }
  }

  callApiForGetFilterIdForSales(int moduleType,
      {bool isSavedSearch = false, bool isSearch = false}) {
    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.DIAMOND_SEARCH,
        section: SectionAnalytics.SEARCH,
        action: ActionAnalytics.CLICK);

    SyncManager.instance.callApiForDiamondList(
      context,
      FilterRequest().createRequest(arrList, selectedStatus: selectStatus),
      (diamondListResp) {
        if (isSavedSearch) {
          openBottomSheetForSavedSearch(
              context, FilterRequest().createRequest(arrList),
              isSearch: isSearch, savedSearchModel: this.savedSearchModel);
        } else {
          if (isSearch) {
            if (diamondListResp.data.count == 0) {
              app.resolve<CustomDialogs>().confirmDialog(context,
                  desc: R.string.commonString.noDiamondFound,
                  positiveBtnTitle: R.string.commonString.ok,
                  negativeBtnTitle: R.string.screenTitle.addDemand,
                  onClickCallback: (buttonType) {
                if (buttonType == ButtonType.NagativeButtonClick) {
                  if (app
                      .resolve<PrefUtils>()
                      .getModulePermission(
                          ModulePermissionConstant.permission_myDemand)
                      .insert) {
                    if (!isNullEmptyOrFalse(
                        FilterRequest().createRequest(arrList)))
                      getAddDemand();
                    else {
                      showToast(R.string.commonString.selectAtleastOneFilter,
                          context: context);
                    }
                    // place code
                  }
                }
              });
            } else {
              Map<String, dynamic> dict = new HashMap();
              dict["filterId"] = diamondListResp.data.filter.id;
              dict["filters"] = FilterRequest().createRequest(arrList);
              dict['isCompanySelected'] = isCompanySelected ?? false;
              dict[ArgumentConstant.ModuleType] = moduleType;
              NavigationUtilities.pushRoute(DiamondListScreen.route,
                  args: dict);
            }
          } else {
            Map<String, dynamic> dict = new HashMap();
            dict["filterId"] = diamondListResp.data.filter.id;
            dict["filters"] = FilterRequest().createRequest(arrList);
            dict['isCompanySelected'] = isCompanySelected ?? false;
            dict[ArgumentConstant.ModuleType] = moduleType;
            NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
          }
        }
      },
      (onError) {
        //print("Error");
      },
    );
  }

  Widget _segmentedControl() {
    return Container(
      width: MathUtilities.screenWidth(context),
      child: CupertinoSegmentedControl<int>(
        selectedColor: appTheme.colorPrimary,
        unselectedColor: Colors.white,
        pressedColor: Colors.transparent,
        borderColor: appTheme.colorPrimary,
        children: getSegmentChildren(),
        onValueChanged: (int val) {
          setState(() {
            segmentedControlValue = val;
            controller.animateToPage(segmentedControlValue,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          });
        },
        groupValue: segmentedControlValue,
      ),
    );
  }

  Map<int, Widget> getSegmentChildren() {
    Map<int, Widget> tab = Map<int, Widget>();
    for (int i = 0; i < arrTab.length; i++) {
      tab[i] = getTextWidget(arrTab[i].title, i);
    }

    return tab;
  }

  getTextWidget(String text, int index) {
    return Text(
      text,
      style: TextStyle(
        fontSize: getFontSize(14),
        fontWeight: FontWeight.w500,
        color: index != segmentedControlValue
            ? appTheme.colorPrimary
            : appTheme.whiteColor,
      ),
    );
  }

  getPageView() {
    return PageView.builder(
      controller: controller,
      itemCount: isNullEmptyOrFalse(arrTab) ? 1 : arrTab.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        if (isNullEmptyOrFalse(arrTab)) {
          return FilterItem(
            arrList,
            moduleType: moduleType,
          );
        }
        return FilterItem(
          arrList
              .where((element) => element.tab == arrTab[position].tab)
              .toList(),
          moduleType: moduleType,
        );
      },
    );
  }
}

class FilterItem extends StatefulWidget {
  List<FormBaseModel> arrList = [];
  int moduleType;
  bool isSearch;
  bool isMatchPair;
  bool isLayout;

  FilterItem(
    this.arrList, {
    this.moduleType,
    this.isSearch = false,
    this.isMatchPair = false,
    this.isLayout = false,
  });

  @override
  _FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  final TextEditingController _searchController = TextEditingController();
  var _focusSearch = FocusNode();
  final TextEditingController _searchStoneIdController =
      TextEditingController();
  var _focusSearchStoneId = FocusNode();
  bool isManualSearch = true;
  bool isAutoSearch = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.arrList.length,
      itemBuilder: (context, index) {
        return getWidgets(widget.arrList[index]);
      },
    );
  }

  getWidgets(FormBaseModel model) {
    if (model.viewType == "searchText") {
      return getSearchTextField();
    } else if (model.viewType == ViewTypes.seperator) {
      return SeperatorWidget(model, callBack: (model) {
        model.isExpand = !model.isExpand;
        for (int i = 0; i < widget.arrList.length; i++) {
          if (model.childrenApiKeys.contains(widget.arrList[i].apiKey)) {
            widget.arrList[i].isExpanded = model.isExpand;
          }
        }

        // model.childrenApiKeys;
        // widgetToggal(model.childrenViewType);
        setState(() {});
      });
    } else if (model.viewType == ViewTypes.selection) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: SelectionWidget(model),
            );
    } else if (model.viewType == ViewTypes.fromTo) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: FromToWidget(model),
            );
    } else if (model.viewType == ViewTypes.certNo) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: CertNoWidget(model),
            );
    } else if (model.viewType == ViewTypes.keytosymbol) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: KeyToSymbolWidget(model),
            );
    } else if (model.viewType == ViewTypes.groupWidget) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: (model as ColorModel).showGroup
                  ? ColorWidget(model)
                  : ColorWhiteFancyWidget(model),
            );
    } else if (model.viewType == ViewTypes.caratRange) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: CaratRangeWidget(model),
            );
    } else if (model.viewType == ViewTypes.shapeWidget) {
      return !model.isExpanded
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.rightPadding),
                  top: getSize(8),
                  bottom: getSize(8)),
              child: ShapeWidget(model),
            );
    }
  }

  Widget getSearchTextField() {
    if (!(app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_searchDiamond)
        .view)) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (app.resolve<PrefUtils>().getUserDetails().type ==
            UserConstant.SALES)
          Padding(
            padding: EdgeInsets.only(top: getSize(16.0), bottom: getSize(16.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'searchTextField',
                    child: Material(
                      color: appTheme.whiteColor,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getSize(Spacing.leftPadding),
                          right: getSize(Spacing.rightPadding),
                        ),
                        child: Container(
                          height: getSize(40),
                          decoration: BoxDecoration(
                            color: appTheme.whiteColor,
                            borderRadius: BorderRadius.circular(getSize(5)),
                            border: Border.all(
                              color: appTheme.colorPrimary,
                              width: getSize(1),
                            ),
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical(y: 1.0),
                            textInputAction: TextInputAction.done,
                            focusNode: _focusSearch,
                            readOnly: true,
                            autofocus: false,
                            controller: _searchController,
                            obscureText: false,
                            style: appTheme.black16TextStyle,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                            cursorColor: appTheme.colorPrimary,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(
                                  new RegExp(alphaRegEx)),
                              BlacklistingTextInputFormatter(
                                  RegExp(RegexForEmoji))
                            ],
                            decoration: InputDecoration(
                              fillColor: fromHex("#FFEFEF"),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    getSize(5),
                                  ),
                                ),
                                borderSide: BorderSide(
                                    color: appTheme.dividerColor,
                                    width: getSize(1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(getSize(5))),
                                borderSide: BorderSide(
                                  color: appTheme.dividerColor,
                                  width: getSize(1),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(getSize(5))),
                                borderSide: BorderSide(
                                    color: appTheme.dividerColor,
                                    width: getSize(1)),
                              ),

                              hintStyle: appTheme.grey16HintTextStyle,
                              hintText: R.string.commonString
                                  .searchStoneIdCertificateNo,
                              labelStyle: TextStyle(
                                color: appTheme.textColor,
                                fontSize: getFontSize(16),
                              ),
                              // suffix: widget.textOption.postfixWidOnFocus,
                              suffixIcon: Padding(
                                  padding: EdgeInsets.all(getSize(10)),
                                  child: Image.asset(search)),
                            ),
                            onChanged: (String text) {
                              //
                            },
                            onEditingComplete: () {
                              //
                              _focusSearch.unfocus();
                            },
                            onTap: () {
                              Map<String, dynamic> dict = new HashMap();
                              dict["isFromSearch"] = true;
                              dict["isFromManual"] = isManualSearch ?? true;
                              NavigationUtilities.pushRoute(
                                SearchScreen.route,
                                args: dict,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          isManualSearch = true;
                          isAutoSearch = false;
                          print(isManualSearch);
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: getSize(20)),
                          child: Text(
                            "M",
                            style: appTheme.blue20TextStyle.copyWith(
                              color: isManualSearch
                                  ? appTheme.blackColor
                                  : appTheme.textGray,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          isManualSearch = false;
                          isAutoSearch = true;
                          print(isAutoSearch);
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: getSize(20)),
                          child: Text(
                            "A",
                            style: appTheme.blue20TextStyle.copyWith(
                              color: isAutoSearch
                                  ? appTheme.blackColor
                                  : appTheme.textGray,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
//              if (widget.moduleType !=
//                  DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH)
//                Center(
//                  child: InkWell(
//                    onTap: () {
////                      NavigationUtilities.pushRoute(VoiceSearch.route);
//                    },
//                    child: Padding(
//                      padding: EdgeInsets.only(
//                        right: getSize(Spacing.leftPadding),
//                      ),
//                      child: Image.asset(
//                        microphone,
//                        alignment: Alignment.centerRight,
//                        width: getSize(26),
//                        height: getSize(26),
//                      ),
//                    ),
//                  ),
//                )
              ],
            ),
          ),
        if (app.resolve<PrefUtils>().getUserDetails().type ==
            UserConstant.CUSTOMER)
          Padding(
            padding: EdgeInsets.only(top: getSize(16.0), bottom: getSize(16.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'searchTextField',
                    child: Material(
                      color: appTheme.whiteColor,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getSize(Spacing.leftPadding),
                          right: getSize(Spacing.rightPadding),
                        ),
                        child: Container(
                          height: getSize(40),
                          decoration: BoxDecoration(
                            color: appTheme.whiteColor,
                            borderRadius: BorderRadius.circular(getSize(5)),
                            border: Border.all(
                              color: appTheme.colorPrimary,
                              width: getSize(1),
                            ),
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical(y: 1.0),
                            textInputAction: TextInputAction.done,
                            focusNode: _focusSearch,
                            readOnly: true,
                            autofocus: false,
                            controller: _searchController,
                            obscureText: false,
                            style: appTheme.black16TextStyle,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                            cursorColor: appTheme.colorPrimary,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(
                                  new RegExp(alphaRegEx)),
                              BlacklistingTextInputFormatter(
                                  RegExp(RegexForEmoji))
                            ],
                            decoration: InputDecoration(
                              fillColor: fromHex("#FFEFEF"),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    getSize(5),
                                  ),
                                ),
                                borderSide: BorderSide(
                                    color: appTheme.dividerColor,
                                    width: getSize(1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(getSize(5))),
                                borderSide: BorderSide(
                                  color: appTheme.dividerColor,
                                  width: getSize(1),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(getSize(5))),
                                borderSide: BorderSide(
                                    color: appTheme.dividerColor,
                                    width: getSize(1)),
                              ),

                              hintStyle: appTheme.grey16HintTextStyle,
                              hintText: R.string.commonString
                                  .searchStoneIdCertificateNo,
                              labelStyle: TextStyle(
                                color: appTheme.textColor,
                                fontSize: getFontSize(16),
                              ),
                              // suffix: widget.textOption.postfixWidOnFocus,
                              suffixIcon: Padding(
                                  padding: EdgeInsets.all(getSize(10)),
                                  child: Image.asset(search)),
                            ),
                            onChanged: (String text) {
                              //
                            },
                            onEditingComplete: () {
                              //
                              _focusSearch.unfocus();
                            },
                            onTap: () {
                              Map<String, dynamic> dict = new HashMap();
                              dict["isFromSearch"] = true;
                              dict["isFromManual"] = false;
                              NavigationUtilities.pushRoute(
                                SearchScreen.route,
                                args: dict,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.moduleType !=
                    DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH)
                  Center(
                    child: InkWell(
                      onTap: () {
                        NavigationUtilities.pushRoute(VoiceSearch.route);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: getSize(Spacing.leftPadding),
                        ),
                        child: Image.asset(
                          microphone,
                          alignment: Alignment.centerRight,
                          width: getSize(26),
                          height: getSize(26),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
      ],
    );
  }
}
