import 'dart:collection';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';

import 'package:diamnow/components/Screens/Filter/Widget/CertNoWidget.dart';

import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ColorWhiteFancyWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ColorWidget.dart';

import 'package:diamnow/components/Screens/Filter/Widget/FromToWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SeperatorWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/FilterRequest.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rxbus/rxbus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterScreen extends StatefulScreenWidget {
  static const route = "FilterScreen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;
  DisplayDataClass dictSearchData;

  FilterScreen(Map<String, dynamic> arguments) {
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
    }
  }

  @override
  _FilterScreenState createState() =>
      _FilterScreenState(moduleType, isFromDrawer,
          dictSearchData: dictSearchData);
}

class _FilterScreenState extends StatefulScreenWidgetState {
  int moduleType;
  bool isFromDrawer;
  DisplayDataClass dictSearchData;

  _FilterScreenState(this.moduleType, this.isFromDrawer, {this.dictSearchData});

  int segmentedControlValue = 0;
  PageController controller = PageController();
  List<TabModel> arrTab = [];
  List<FormBaseModel> arrList = [];
  List<BottomTabModel> arrBottomTab;
  String filterId;
  List<FilterOptions> optionList = List<FilterOptions>();
  Config config = Config();

  final TextEditingController _diamondTitleTextField = TextEditingController();
  var _focusDiamondTitleTextField = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    registerRsBus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      config.getFilterJson().then((result) {
        setState(() {
          arrList = result;

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
    arrBottomTab = BottomTabBar.getFilterScreenBottomTabs();
    setState(() {
      //
    });
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
          element.isSelected = event.values.first;
        });
      });
      list2.forEach((element) {
        element.groupMaster.forEach((element) {
          element.isSelected = event.values.first;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppBackground(
        child: Scaffold(
            appBar: getAppBar(
              context,
              R.string().screenTitle.searchDiamond,
              bgColor: appTheme.whiteColor,
              leadingButton: isFromDrawer
                  ? getDrawerButton(context, true)
                  : getBackButton(context),
              centerTitle: false,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: getSize(16)),
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
                    margin: EdgeInsets.only(top: getSize(16)),
                    color: Colors.transparent,
                    child: isNullEmptyOrFalse(arrList)
                        ? SizedBox()
                        : getPageView(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: getBottomTab()),
      ),
    );
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
            title,
            style: segmentedControlValue == index
                ? appTheme.blackMedium16TitleColorblack
                : appTheme.grey16HintTextStyle,
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

  Future MyDemandDialog(BuildContext context,
      {String title,
      String desc,
      String positiveBtnTitle,
      String negativeBtnTitle,
      OnClickCallback onClickCallback,
      VoidCallback voidCallback,
      bool dismissPopup: true,
      bool barrierDismissible: true,
      RichText richText}) {
    Future<bool> _onBackPressed() {
      if (dismissPopup) {
        Navigator.pop(context);
      }
    }

    void selectionChanged(DateRangePickerSelectionChangedArgs args) {
      _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        setState(() {});
      });
    }

    Widget getDateRangePicker() {
      return Container(
          height: getSize(250),
          child: Card(
              child: SfDateRangePicker(
            initialDisplayDate: DateTime.now(),
            minDate: DateTime.now(),
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: selectionChanged,
          )));
    }

    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: StatefulBuilder(
            builder: (context, setState) {
              //SystemChrome.setEnabledSystemUIOverlays([]);

              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(getSize(15)))),
                child: SingleChildScrollView(
                  child: Container(
                    width: MathUtilities.screenWidth(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: getSize(20), vertical: getSize(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: getSize(10)),
                          child: Text(
                            "Add demand",
                            style: appTheme.blackSemiBold18TitleColorblack,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: getDiamondTitleTextField(),
                        ),
                        getDateRangePicker(),
                        Padding(
                          padding: EdgeInsets.only(top: getSize(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(getSize(5))),
                                width: getSize(130),
                                height: getSize(50),
                                child: AppButton.flat(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  text: "Cancel",
                                  textColor: ColorConstants.colorPrimary,
                                  backgroundColor: ColorConstants
                                      .backgroundColorForCancleButton,
                                ),
                              ),
                              Container(
                                width: getSize(130),
                                height: getSize(50),
                                child: AppButton.flat(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      diamondTitle =
                                          _diamondTitleTextField.text ?? "";

                                      print(_selectedDate);
                                      print(_diamondTitleTextField.text);
                                      callApiForAddDemand();
                                      _diamondTitleTextField.text = "";
                                      Navigator.pop(context);
                                    } else {
                                      _autoValidate = true;
                                    }
                                  },
                                  text: "Submit",
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  getDiamondTitleTextField() {
    return CommonTextfield(
      focusNode: _focusDiamondTitleTextField,
      textOption: TextFieldOption(
        prefixWid: getCommonIconWidget(
            imageName: saved_icon, imageType: IconSizeType.small),
        hintText: "Demand Title",
        maxLine: 1,
        formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
        keyboardType: TextInputType.text,
        inputController: _diamondTitleTextField,
      ),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return "Please enter Demand Title.";
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusDiamondTitleTextField.unfocus();
        FocusScope.of(context).requestFocus(_focusDiamondTitleTextField);
      },
    );
  }

  callApiForAddDemand() {
    Map<String, dynamic> dict = {};
    dict["filter"] = FilterRequest().createRequest(arrList);
    dict["name"] = diamondTitle;
    dict["searchType"] = DiamondSearchType.DEMAND;
    dict["expiryDate"] = _selectedDate;

    NetworkCall<BaseApiResp>()
        .makeCall(
      () => app.resolve<ServiceModule>().networkService().saveSearch(dict),
      context,
      isProgress: true,
    )
        .then((diamondListResp) async {
      showToast("Demand Added Successfully", context: context);
    }).catchError((onError) {
      print(onError.toString());
    });
  }
  //my demand popup end.

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: arrBottomTab,
      onClickCallback: (obj) {
        //
        if (obj.code == BottomCodeConstant.filterSavedSearch) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_mySavedSearch)
              .view) {
            // place code
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filterAddDemamd) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_myDemand)
              .insert) {
            if (!isNullEmptyOrFalse(FilterRequest().createRequest(arrList)))
              MyDemandDialog(context);
            else {
              showToast("Please, select at least one filter", context: context);
            }
            // place code
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filterSearch) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_searchResult)
              .view) {
            callApiForGetFilterId(DiamondModuleConstant.MODULE_TYPE_SEARCH,
                isSearch: true);
            // place code
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filterSaveAndSearch) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_mySavedSearch)
              .insert) {
            if (!isNullEmptyOrFalse(FilterRequest().createRequest(arrList)))
              callApiForGetFilterId(DiamondModuleConstant.MODULE_TYPE_SEARCH,
                  isSavedSearch: true);
            else
              showToast("Please, select at least one filter", context: context);
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        } else if (obj.code == BottomCodeConstant.filteMatchPair) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_matchPair)
              .view) {
            callApiForGetFilterId(DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR);
          } else {
            app.resolve<CustomDialogs>().accessDenideDialog(context);
          }
        }
      },
    );
  }

  callApiForGetFilterId(int moduleType,
      {bool isSavedSearch = false, bool isSearch = false}) {
    SyncManager.instance.callApiForDiamondList(
      context,
      FilterRequest().createRequest(arrList),
      (diamondListResp) {
        if (isSavedSearch) {
          openBottomSheetForSavedSearch(
              context,
              FilterRequest().createRequest(arrList),
              diamondListResp.data.filter.id);
        } else {
          if (isSearch) {
            if (diamondListResp.data.count == 0) {
              app.resolve<CustomDialogs>().confirmDialog(context,
                  desc: R.string().commonString.noDiamondFound,
                  positiveBtnTitle: R.string().commonString.ok);
            } else {
              Map<String, dynamic> dict = new HashMap();
              dict["filterId"] = diamondListResp.data.filter.id;
              dict["filters"] = FilterRequest().createRequest(arrList);
              dict[ArgumentConstant.ModuleType] = moduleType;
              NavigationUtilities.pushRoute(DiamondListScreen.route,
                  args: dict);
            }
          } else {
            Map<String, dynamic> dict = new HashMap();
            dict["filterId"] = diamondListResp.data.filter.id;
            dict["filters"] = FilterRequest().createRequest(arrList);
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
          return FilterItem(arrList);
        }
        return FilterItem(arrList
            .where((element) => element.tab == arrTab[position].tab)
            .toList());
      },
    );
  }
}

class FilterItem extends StatefulWidget {
  List<FormBaseModel> arrList = [];

  FilterItem(this.arrList);

  @override
  _FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
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
    if (model.viewType == ViewTypes.seperator) {
      return SeperatorWidget(model);
    } else if (model.viewType == ViewTypes.selection) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: SelectionWidget(model),
      );
    } else if (model.viewType == ViewTypes.fromTo) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: FromToWidget(model),
      );
    } else if (model.viewType == ViewTypes.certNo) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: CertNoWidget(model),
      );
    } else if (model.viewType == ViewTypes.keytosymbol) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: KeyToSymbolWidget(model),
      );
    } else if (model.viewType == ViewTypes.groupWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: (model as ColorModel).showGroup
            ? ColorWidget(model)
            : ColorWhiteFancyWidget(model),
      );
    } else if (model.viewType == ViewTypes.caratRange) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: CaratRangeWidget(model),
      );
    } else if (model.viewType == ViewTypes.shapeWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: ShapeWidget(model),
      );
    }
  }
}
