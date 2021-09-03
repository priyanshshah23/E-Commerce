import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/FinalCalculation.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/OfferPopup.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/PlaceOrderPopUp.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/components/widgets/shared/CommonDateTimePicker.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Slot/SlotModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rxbus/rxbus.dart';

import 'DiamondActionBottomSheet.dart';

class DiamondActionScreen extends StatefulScreenWidget {
  static const route = "DiamondActionScreen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  int actionType = DiamondTrackConstant.TRACK_TYPE_WATCH_LIST;
  List<DiamondModel> diamondList;
  bool isOfferUpdate;
  bool isFromOfferScreen;

  DiamondActionScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
        print('moduleType => $moduleType');
      }
      if (arguments[ArgumentConstant.ActionType] != null) {
        actionType = arguments[ArgumentConstant.ActionType];
        print('actionType => $actionType');
      }

      if ((this.moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) &&
          (this.actionType == DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER)) {
        isFromOfferScreen = true;
      }
      if (arguments[ArgumentConstant.DiamondList] != null) {
        diamondList = arguments[ArgumentConstant.DiamondList];
      }
      if (arguments["isOfferUpdate"] != null) {
        isOfferUpdate = arguments["isOfferUpdate"] ?? false;
      }
    }
  }

  @override
  _DiamondActionScreenState createState() => _DiamondActionScreenState(
      moduleType: moduleType,
      actionType: actionType,
      diamondList: diamondList,
      isOfferUpdate: isOfferUpdate,
      isFromOfferScreen: isFromOfferScreen);
}

class _DiamondActionScreenState extends StatefulScreenWidgetState {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool autovalid = false;
  int moduleType;
  int actionType;
  List<DiamondModel> diamondList;
  String selectedDate;
  bool isAllSelected = false;
  bool isCheckBoxChecked = false;
  bool isCMChargesApplied = false;
  List<SlotModel> arrSlots = [];
  bool isOfferUpdate;
  bool isFromOfferScreen;



  List<String> invoiceList = [
    InvoiceTypesString.today,
    InvoiceTypesString.tomorrow,
    InvoiceTypesString.later
  ];

  _DiamondActionScreenState({
    this.moduleType,
    this.actionType,
    this.diamondList,
    this.isOfferUpdate = false,
    this.isFromOfferScreen,
  });

  DiamondConfig diamondConfig;
  DiamondCalculation diamondCalculation = DiamondCalculation();
  DiamondCalculation diamondFinalCalculation = DiamondCalculation();

  @override
  void initState() {
    super.initState();
    if (this.actionType == DiamondTrackConstant.TRACK_TYPE_FINAL_CALCULATION) {
      diamondConfig =
          DiamondConfig(DiamondModuleConstant.MODULE_TYPE_FINAL_CALCULATION);
    } else {
      diamondConfig = DiamondConfig(moduleType);
    }
    manageDiamondCalculation();
    diamondConfig.initItems();

    if (this.actionType == DiamondTrackConstant.TRACK_TYPE_OFFICE) {
      callApiforTimeSlots();
    }
    if (this.actionType == DiamondTrackConstant.TRACK_TYPE_OFFER ||
        this.actionType == DiamondTrackConstant.TRACK_TYPE_BID) {
      RxBus.register<bool>(tag: eventBusRefreshList).listen((event) {
        print("action update");
        setState(() {

          manageDiamondCalculation();
        });
      });
    }
  }

  manageDiamondCalculation() {
    diamondFinalCalculation.setAverageCalculation(diamondList,
        isFinalCalculation: true);
    diamondCalculation.setAverageCalculation(diamondList);
  }

  whenCheckBoxIsChecked() {
    String remarkGlobal;
    if (!isCheckBoxChecked) {
      showNotesDialog(context, (manageClick) {
        if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
          remarkGlobal = manageClick.remark;
        }
      }).then((value) {
        if (remarkGlobal != null) {
          for (var i = 0; i < diamondList.length; i++) {
            diamondList[i].remarks = remarkGlobal;
          }

          RxBus.post(true, tag: eventBusRefreshItem);
        }
      });
    }
  }

  Widget getToolbarItem() {
    return GestureDetector(
      onTap: () {
        // manageToolbarClick(element);
      },
      child: Padding(
          padding: EdgeInsets.only(right: getSize(20.0)),
          child: Container(
            child: Row(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        //isCheckBoxChecked = !isCheckBoxChecked;
                        whenCheckBoxIsChecked();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(getSize(3))),
                        width: getSize(21),
                        height: getSize(21),
                        child: Image.asset(
                          isCheckBoxChecked
                              ? selectedCheckbox
                              : unSelectedCheckbox,
                          height: getSize(20),
                          width: getSize(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getSize(5),
                    ),
                    Text(
                      "Global comment",
                      style: appTheme.blackNormal14TitleColorblack,
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget getDiamondList() {
    return ListView.builder(
      // primary: false,
      shrinkWrap: true,
      itemCount: diamondList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return DiamondItemWidget(
            item: diamondList[index],
            isUpdateOffer: diamondList[index].isUpdateOffer,
            hourPop: true,
            actionClick: (manageClick) {
              setState(() {
                if (this.actionType ==
                    DiamondTrackConstant.TRACK_TYPE_FINAL_CALCULATION) {
                  diamondList[index].isSelected =
                      !diamondList[index].isSelected;
                  diamondCalculation.setAverageCalculation(diamondList);
                }
              });
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        resizeToAvoidBottomInset: true,
        appBar: getAppBar(
          context,
          diamondConfig.getActionScreenTitle(actionType),
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
          textalign: TextAlign.left,
          actionItems: [
            this.actionType == DiamondTrackConstant.TRACK_TYPE_FINAL_CALCULATION
                ? getActionItems()
                : SizedBox(),
            (this.actionType == DiamondTrackConstant.TRACK_TYPE_COMMENT ||
                    this.actionType ==
                        DiamondTrackConstant.TRACK_TYPE_UPDATE_COMMENT)
                ? getToolbarItem()
                : SizedBox()
          ],
        ),
        bottomNavigationBar:
            this.actionType == DiamondTrackConstant.TRACK_TYPE_FINAL_CALCULATION
                ? getBottomTabForFinalCalculation()
                : getBottomTab(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DiamondListHeader(
                  diamondCalculation: diamondCalculation,
                ),
                SizedBox(
                  height: getSize(20),
                ),
                Container(
                  child: getDiamondList(),
                ),
                SizedBox(
                  height: getSize(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Get Action Items for Final calculation
  Widget getActionItems() {
    return Row(children: [
      InkWell(
        onTap: () {
          setState(() {
            isAllSelected = !isAllSelected;

            diamondList.forEach((element) {
              element.isSelected = isAllSelected;
            });
            manageDiamondCalculation();
          });
        },
        child: Padding(
          padding: EdgeInsets.only(right: getSize(8), left: getSize(8.0)),
          child: Image.asset(
            !isAllSelected ? selectAll : selectList,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            isCMChargesApplied = !isCMChargesApplied;
          });
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: getSize(8), left: getSize(8.0)),
              child: Image.asset(
                isCMChargesApplied ? selectedCheckbox : unSelectedCheckbox,
                height: getSize(20),
                width: getSize(20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: getSize(20)),
              child: Text(
                "CM Charges",
                style: appTheme.black14TextStyle,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget getBottomTab() {
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: getSize(70),
          decoration: new BoxDecoration(
            color: appTheme.colorPrimary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5.0,
                spreadRadius: 1.0, //extend the shadow
                offset: Offset(
                  0, // Move to right 10  horizontally
                  1, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(getSize(8)),
                  width: getSize(172),
                  height: getSize(40),
                  child: AppButton.flat(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    textColor: appTheme.whiteColor,
                    backgroundColor: appTheme.colorPrimary,
                    text: R.string.commonString.cancel,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: getSize(172),
                  height: getSize(50),
                  child: AppButton.flat(
                    onTap: () {
                      switch (actionType) {
                        case DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER:
                          showDialog(
                              context: context,
                              builder: (BuildContext cnt) {
                                return Dialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal: getSize(20),
                                        vertical: getSize(20)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(getSize(25)),
                                    ),
                                    child: PlaceOrderPopUp(
                                      diamondConfig: diamondConfig,
                                      diamondList: diamondList,
                                      actionType: actionType,
                                      callBack: (selectedPopUpDate, remark) {
                                        diamondConfig.actionAll(
                                          context,
                                          diamondList,
                                          actionType,
                                          remark: remark,
                                          date: selectedPopUpDate,
                                          companyName:
                                              _nameController.text.trim(),
                                          isFromOffer: isFromOfferScreen,
                                        );
                                      },
                                    ));
                              });
                          break;
                        case DiamondTrackConstant.TRACK_TYPE_COMMENT:
                        case DiamondTrackConstant.TRACK_TYPE_UPDATE_COMMENT:
                          for (var item in diamondList) {
                            if (isNullEmptyOrFalse(item.remarks)) {
                              app.resolve<CustomDialogs>().confirmDialog(
                                    context,
                                    title: "Add note",
                                    desc: 'Please enter note.',
                                    positiveBtnTitle: "Try Again",
                                  );
                              return;
                            }
                          }
                          diamondConfig.actionAll(
                              context, diamondList, actionType);
                          break;
                        case DiamondTrackConstant.TRACK_TYPE_OFFICE:
                        case DiamondTrackConstant.TRACK_TYPE_OFFER:
                          showDialog(
                              context: context,
                              builder: (BuildContext cnt) {
                                return Dialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal: getSize(20),
                                        vertical: getSize(20)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(getSize(25)),
                                    ),
                                    child: OfferPopup(
                                      actionType: actionType,
                                      isFromOfferUpdate:
                                          this.isOfferUpdate ?? false,
                                      date: this.isOfferUpdate ?? false
                                          ? diamondList.first.offerValidDate
                                          : null,
                                      callBack: (selectedPopUpDate, remark) {
                                        if (actionType ==
                                            DiamondTrackConstant
                                                .TRACK_TYPE_OFFICE) {
                                          callApiForRequestForOffice(
                                              remark, selectedPopUpDate);
                                        } else {
                                          if (this.isOfferUpdate ?? false) {
                                            callApiForUpdateOffer(
                                                this.diamondList.first,
                                                remark,
                                                selectedPopUpDate);
                                          } else {
                                            diamondConfig.actionAll(context,
                                                diamondList, actionType,
                                                remark: remark,
                                                companyName: _nameController.text.trim());
                                          }
                                        }
                                      },
                                    ));
                              });
                          break;

                        default:
                          diamondConfig.actionAll(
                              context, diamondList, actionType,
                            companyName: _nameController.text.trim()
                          );
                          break;
                      }
                    },
                    textColor: appTheme.colorPrimary,
                    backgroundColor: appTheme.whiteColor,
                    text: R.string.commonString.confirm,
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  openDatePicker() {
    openDateTimeDialog(context, (manageClick) {
      setState(() {
        selectedDate = manageClick.date;
        _dateController.text = DateUtilities()
            .convertServerDateToFormatterString(selectedDate,
                formatter: DateUtilities.dd_mm_yyyy_);
      });
    }, isTime: false, title: R.string.commonString.selectDate);
  }

  getDateTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: CommonTextfield(
          readOnly: true,
          tapCallback: () {
            openDatePicker();
          },
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: company, imageType: IconSizeType.small),
              hintText: R.string.commonString.offerVelidTill,
              maxLine: 1,
              keyboardType: TextInputType.text,
              inputController: _dateController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          validation: (text) {
            if (text.isEmpty) {
              return R.string.errorString.pleaseSelectOfferTillDate;
            }
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getCommentTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: CommonTextfield(
        autoFocus: false,
        textOption: TextFieldOption(
          maxLine: 4,
          inputController: _commentController,
          hintText: R.string.screenTitle.comment,
          formatter: [
            WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
            BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
          ],
          //isSecureTextField: false
        ),
        textCallback: (text) {},
        inputAction: TextInputAction.done,
        onNextPress: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget getBottomTabForFinalCalculation() {
    bool isVisible = false;
    if (!isNullEmptyOrFalse(diamondList)) {
      isVisible =
          diamondList.where((element) => element.isSelected).toList().length >
              0;
    }
    return isNullEmptyOrFalse(this.diamondList) == false
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: isVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: FinalCalculationWidget(
                    diamondList, diamondFinalCalculation),
              ),
              BottomTabbarWidget(
                arrBottomTab: diamondConfig.arrBottomTab,
                onClickCallback: (obj) {
                  //Click handle
                  manageBottomMenuClick(obj);
                },
              ),
            ],
          )
        : SizedBox();
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        diamondList.where((element) => element.isSelected).toList();
    if (!isNullEmptyOrFalse(selectedList)) {
      if (bottomTabModel.type == ActionMenuConstant.ACTION_TYPE_CANCEL_STONE) {
        print(bottomTabModel.type);
      } else {
        diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel,
            () {
          print(bottomTabModel.type);
        });
      }
    } else {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: "",
            desc: R.string.errorString.diamondSelectionError,
            positiveBtnTitle: R.string.commonString.ok,
          );
    }
  }

  callApiforTimeSlots() {
    Map<String, dynamic> req = {};
    req["sort"] = [
      {"end": "ASC"}
    ];
    NetworkCall<SlotResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().getSlots(req),
            context,
            isProgress: true)
        .then((resp) async {
      arrSlots = resp.data.list;
      setState(() {});
    }).catchError((onError) {
      if (onError is ErrorResp) {
        // app.resolve<CustomDialogs>().confirmDialog(
        //       context,
        //       title: "",
        //       desc: onError.message,
        //       positiveBtnTitle: R.string.commonString.ok,
        //     );
      }
    });
  }

  callApiForRequestForOffice(String comment, String pickedDate) {
    Map<String, dynamic> req = {};
    req["purpose"] = comment;
    req["date"] = pickedDate;
    req["start"] = pickedDate;
    req["end"] = pickedDate;
    req["type"] = 2;
    req["meetingType"] = 2;
    req["cabinSlot"] = [
      {
        "id": arrSlots[0].id ?? "",
        "createdAt": arrSlots[0].createdAt ?? "",
        "updatedAt": arrSlots[0].updatedAt ?? "",
        "start": "1970-01-01T03:30:00.000Z",
        "end": "1970-01-01T04:00:00.000Z",
        "weekDay": 4,
        "type": 2,
        "slotDurationType": 4,
        "isActive": true,
        "appliedFrom": "2020-01-06T11:29:35Z",
        "cabinId": arrSlots[0].cabinId ?? "",
      }
    ];

    req["diamonds"] = diamondList.map((e) => e.id).toList();

    NetworkCall<BaseApiResp>()
        .makeCall(
            () => app
                .resolve<ServiceModule>()
                .networkService()
                .createOfficerequest(req),
            context,
            isProgress: true)
        .then((resp) async {
      app.resolve<CustomDialogs>().confirmDialog(context,
          title: "",
          desc: resp.message,
          positiveBtnTitle: R.string.commonString.ok, onClickCallback: (type) {
        Navigator.pop(context);
      });
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: "",
              desc: onError.message,
              positiveBtnTitle: R.string.commonString.ok,
            );
      }
    });
  }

  callApiForUpdateOffer(DiamondModel model, String remark, String offerDate) {
    Map<String, dynamic> req = {};

    req["trackType"] = DiamondTrackConstant.TRACK_TYPE_OFFER;
    req["remarks"] = remark;
    req["id"] = model.trackItemOffer.trackId;
    req["diamond"] = model.id;
    req["trackPricePerCarat"] = model.ctPr;
    req["trackAmount"] = model.amt;
    req["trackDiscount"] = model.back;
    req["vStnId"] = model.vStnId;
    req["newAmount"] = model.offeredAmount;
    req["newPricePerCarat"] = model.offeredPricePerCarat;
    req["newDiscount"] = model.offeredDiscount;
    req["offerValidDate"] = model.offerValidDate;

    app.resolve<CustomDialogs>().showProgressDialog(context, "");

    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      ApiConstants.updateOffer,
      MethodType.Post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: req,
      successCallback: (response, message) {
        app.resolve<CustomDialogs>().hideProgressDialog();
        app.resolve<CustomDialogs>().confirmDialog(
          context,
          title: "",
          desc: message,
          positiveBtnTitle: R.string.commonString.ok,
          onClickCallback: (type) {
            Navigator.pop(context, true);
          },
        );
      },
      failureCallback: (status, message) {
        app.resolve<CustomDialogs>().hideProgressDialog();
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: "",
            desc: message,
            positiveBtnTitle: R.string.commonString.ok,
            onClickCallback: (type) {
          Navigator.pop(context);
        });
      },
    );
  }
}
