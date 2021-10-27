import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/AddDemand.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/Slot/SlotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class OfferViewScreen extends StatefulWidget {
  static const route = "OfferView";

  List<DiamondModel> list;

  OfferViewScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.DiamondList] != null) {
        list = arguments[ArgumentConstant.DiamondList];
      }
    }
  }

  @override
  _OfferViewScreenState createState() => _OfferViewScreenState();
}

class _OfferViewScreenState extends State<OfferViewScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  DateTime now = DateTime.now();
  List<DateModel> days;
  DateTime pickedDate = DateTime.now();
  String pd = DateTime.now().toIso8601String();
  int selectedDate = -1;
  int selectedSlot;
  int selectedVirtualType = -1;
  List<SlotModel> arrSlots = [];
  List<SlotModel> disableSlots = [];
  List<String> virtualList = [
    VirtualTypesString.phoneCall,
    VirtualTypesString.webConference,
    VirtualTypesString.inPerson
  ];
  final TextEditingController _virtualTypeController = TextEditingController();
  final TextEditingController _commentTypeController = TextEditingController();
  int selectedHourStart = 3;
  int selectedMinuteStart = 30;
  int selectedHourEnd = 4;
  int selectedMinuteEnd = 00;

  @override
  void initState() {
    super.initState();
    days = setDateList();
    callApiforTimeSlots();
  }

  getDate(int day) {
    return now.add(Duration(days: day));
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

      DateTime now = DateTime.now();

      arrSlots.forEach((element) {
        DateTime serverStart =
            DateUtilities().convertServerStringToFormatterDate(element.start);

        if (now.isAfter(DateTime(now.year, now.month, now.day, serverStart.hour,
            serverStart.minute, serverStart.second, serverStart.millisecond))) {
          element.disable = true;
        } else {
          element.disable = false;
        }
      });
      setState(() {});
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

  callApiForRequestForOffice() {
    Map<String, dynamic> req = {};
    List<String> diamondId = [];
    req["purpose"] = _commentTypeController.text;
    DateTime date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
            pickedDate.hour, pickedDate.minute)
        .toUtc();
    req["date"] = date.toUtc().toIso8601String();

    req["type"] = 2;
    req["start"] = DateUtilities()
        .getSpecificTimeOfDate(date, selectedHourStart, selectedMinuteStart, 00)
        .toIso8601String();
    req["end"] = DateUtilities()
        .getSpecificTimeOfDate(date, selectedHourEnd, selectedMinuteEnd, 00)
        .toIso8601String();

    req["meetingType"] =
        _virtualTypeController.text == VirtualTypesString.phoneCall
            ? VirtualTypes.phoneCall
            : _virtualTypeController.text == VirtualTypesString.webConference
                ? VirtualTypes.webConference
                : VirtualTypes.inPerson;
    req["cabinSlot"] = [arrSlots[selectedSlot]];
    widget.list.forEach((element) {
      diamondId.add(element.id);
    });
    req['diamonds'] = diamondId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        R.string.screenTitle.appointment,
        leadingButton: getBackButton(context),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTopRow(),
            getDateList(),
            getTimeSlot(),
//            setVirtualDropDown(virtualList, (value) {
//              _virtualTypeController.text = value;
//            }),
//            SizedBox(
//              height: getSize(10),
//            ),
//            getCommentTextField(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                      FocusScope.of(context).unfocus();

                      if (pickedDate == null) {
                        app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "",
                              desc: R.string.errorString.selectAppointmentDate,
                              positiveBtnTitle: R.string.commonString.ok,
                            );
                        return;
                      } else if (selectedSlot == null) {
                        app.resolve<CustomDialogs>().confirmDialog(
                              context,
                              title: "",
                              desc: R.string.errorString.selectTimeSlot,
                              positiveBtnTitle: R.string.commonString.ok,
                            );
                        return;
                      }
                      showAppoitmentDialog(context);
                    },
                    textColor: appTheme.colorPrimary,
                    backgroundColor: appTheme.whiteColor,
                    text: R.string.screenTitle.reqOfficeView),
              ),
            )
          ],
        ),
      ),
    );
  }

  getTopRow() {
    return Padding(
      padding: EdgeInsets.only(
        left: Spacing.leftPadding,
        right: Spacing.rightPadding,
        bottom: getSize(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                R.string.screenTitle.availableSlot,
                style: appTheme.black16TextStyle
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: EdgeInsets.only(top: getSize(5)),
                child: Text(
                  DateUtilities().convertServerDateToFormatterString(
                      DateTime.now().toIso8601String(),
                      formatter: DateUtilities.mmm_yyyy),
                  style: appTheme.black16TextStyle,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
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
                        title: "OfferView",
                        isShowTextField: false,
                        applyCallBack: (
                            {String selectedDate, String diamondTitle}) {
                          pd = selectedDate;
                          days.forEach((element) {
                            element.isSelected = false;
                            if (element.date.day ==
                                DateTime.parse(selectedDate).day) {
                              element.isSelected = true;
                            }

                            DateTime now = DateTime.now();
                            arrSlots.forEach((element) {
                              element.disable = false;
                            });
                            if (now.day == DateTime.parse(selectedDate).day &&
                                now.month ==
                                    DateTime.parse(selectedDate).month &&
                                now.year == DateTime.parse(selectedDate).year) {
                              selectedSlot = null;
                              arrSlots.forEach((element) {
                                DateTime serverStart = DateUtilities()
                                    .convertServerStringToFormatterDate(
                                        element.start);

                                if (now.isAfter(DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    serverStart.hour,
                                    serverStart.minute,
                                    serverStart.second,
                                    serverStart.millisecond))) {
                                  element.disable = true;
                                } else {
                                  element.disable = false;
                                }
                              });
                            }
                          });

                          setState(() {});
                        }),
                  );
                },
              );

              // DateUtilities().pickDateDialog(context).then((value) {
              //   pickedDate = value;
              //   days.forEach((element) {
              //     if (value.day == element.date.day) {
              //       element.isSelected = true;
              //     } else {
              //       element.isSelected = false;
              //     }
              //   });
              //   setState(() {});
              // });
            },
            child: Container(
//              width: getSize(175),
              padding: EdgeInsets.only(bottom: getSize(5)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: appTheme.dividerColor, width: getSize(2)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    pd != null
                        ? DateUtilities().convertServerDateToFormatterString(
                            pd,
                            formatter: DateUtilities.ddmmyyyy_,
                          )
                        : R.string.screenTitle.selectCustomDate,
                    style: appTheme.black16TextStyle,
                  ),
                  SizedBox(
                    width: getSize(10),
                  ),
                  Image.asset(
                    calender,
                    height: getSize(20),
                    width: getSize(20),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getDateList() {
    return Padding(
      padding: EdgeInsets.only(left: Spacing.leftPadding),
      child: Container(
        height: getSize(100),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  days.forEach((element) {
                    element.isSelected = false;
                  });
                  // arrSlots.forEach((element) {
                  //   element.isSelected = false;
                  // });
                  days[index].isSelected = !days[index].isSelected;
                  if (days[index].isSelected) {
                    pickedDate = days[index].date;
                    pd = pickedDate.toIso8601String();

                    DateTime now = DateTime.now();
                    if (now.day == pickedDate.day &&
                        now.month == pickedDate.month &&
                        now.year == pickedDate.year) {
                      arrSlots.forEach((element) {
                        DateTime serverStart = DateUtilities()
                            .convertServerStringToFormatterDate(element.start);

                        if (now.isAfter(DateTime(
                            now.year,
                            now.month,
                            now.day,
                            serverStart.hour,
                            serverStart.minute,
                            serverStart.second,
                            serverStart.millisecond))) {
                          element.disable = true;
                        } else {
                          element.disable = false;
                        }
                      });
                    } else {
                      arrSlots.forEach((element) {
                        DateTime serverStart = DateUtilities()
                            .convertServerStringToFormatterDate(element.start);

                        if (pickedDate.isAfter(DateTime(
                          now.year,
                          now.month,
                          now.day,
                        ))) {
                          element.disable = false;
                        } else {
                          element.disable = true;
                        }
                      });
                    }

                    setState(() {});
                  }
//                  print()
//                  if(pickedDate != pd){
//                    pd = null;
//                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: getSize(10)),
                margin: EdgeInsets.only(
                    left: getSize(10),
                    right: getSize(10),
                    top: getSize(15),
                    bottom: getSize(15)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(5)),
                  color: days[index].isSelected
                      ? appTheme.colorPrimary
                      : Colors.transparent,
                  boxShadow: days[index].isSelected
                      ? getBoxShadow(context)
                      : [BoxShadow(color: Colors.transparent)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateUtilities().convertServerDateToFormatterString(
                          days[index].date.toString(),
                          formatter: DateUtilities.dd),
                      textAlign: TextAlign.center,
                      style: days[index].isSelected
                          ? appTheme.white16TextStyle
                              .copyWith(fontWeight: FontWeight.w500)
                          : appTheme.black16TextStyle
                              .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateUtilities().convertServerDateToFormatterString(
                          days[index].date.toString(),
                          formatter: DateUtilities.ee),
                      textAlign: TextAlign.center,
                      style: days[index].isSelected
                          ? appTheme.white16TextStyle
                          : appTheme.black16TextStyle,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  getTimeSlot() {
    return Padding(
      padding: EdgeInsets.only(
        left: Spacing.leftPadding,
        right: Spacing.rightPadding,
        bottom: getSize(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            R.string.screenTitle.timeSlots,
            style:
                appTheme.black16TextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: getSize(15),
          ),
          isNullEmptyOrFalse(arrSlots)
              ? Text(R.string.commonString.noSlotFound,
                  style: appTheme.black14TextStyle)
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 4),
                  itemCount: arrSlots.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          arrSlots.forEach((element) {
                            // element.
                          });
                          if (arrSlots[index].disable) {
                          } else {
                            selectedSlot = index;
                            selectedHourStart = DateUtilities()
                                .getDateFromString(arrSlots[selectedSlot].start)
                                .hour;
                            selectedMinuteStart = DateUtilities()
                                .getDateFromString(arrSlots[selectedSlot].start)
                                .minute;
                            selectedHourEnd = DateUtilities()
                                .getDateFromString(arrSlots[selectedSlot].end)
                                .hour;
                            selectedMinuteEnd = DateUtilities()
                                .getDateFromString(arrSlots[selectedSlot].end)
                                .minute;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            right: getSize(5), bottom: getSize(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(getSize(5)),
                          border: Border.all(color: appTheme.borderColor),
                          color: arrSlots[index].disable
                              ? appTheme.colorPrimaryShadow
                              : selectedSlot == index
                                  ? appTheme.colorPrimary
                                  : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                              "${arrSlots[index].startTime} - ${arrSlots[index].endTime}",
                              style: appTheme.black16TextStyle
                              // ? appTheme.white16TextStyle
                              // : appTheme.black16TextStyle,
                              ),
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  Widget setVirtualDropDown(List<String> list, Function(String) selectedValue,
          {bool isPer = false}) =>
      PopupMenuButton<String>(
        shape: TooltipShapeBorder(arrowArc: 0.5),
        onSelected: (newValue) {
          // add this property
          selectedValue(newValue);
        },
        itemBuilder: (context) => [
          for (var item in list) getPopupItems(item),
          PopupMenuItem(
            height: getSize(30),
            value: "Start",
            child: SizedBox(),
          ),
        ],
        child: getVirtualTypeDropDown(),
        offset: Offset(25, 220),
      );

  getVirtualTypeDropDown() {
    return AbsorbPointer(
      child: CommonTextfield(
          enable: false,
          textOption: TextFieldOption(
              prefixWid: getCommonIconWidget(
                  imageName: company, imageType: IconSizeType.small),
              hintText: R.string.commonString.selectType,
              maxLine: 1,
              keyboardType: TextInputType.text,
              type: TextFieldType.DropDown,
              inputController: _virtualTypeController,
              isSecureTextField: false),
          textCallback: (text) {
//                  setState(() {
//                    checkValidation();
//                  });
          },
          validation: (text) {
            if (text.isEmpty) {
              return R.string.errorString.selectVirtualType;
            } else {
              return null;
            }
          },
          inputAction: TextInputAction.next,
          onNextPress: () {
            FocusScope.of(context).unfocus();
          }),
    );
  }

  getPopupItems(
    String per,
  ) {
    return PopupMenuItem(
      value: per,
      height: getSize(20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: getSize(10)),
        width: MathUtilities.screenWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              per,
              style: appTheme.black16TextStyle,
            )
          ],
        ),
      ),
    );
  }

  getCommentTextField() {
    return CommonTextfield(
      textOption: TextFieldOption(
        maxLine: 4,
        inputController: _commentTypeController,
        hintText: "Enter Comments",
        formatter: [
//          WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
        ],
        errorBorder: InputBorder.none,
        //isSecureTextField: false
      ),
      // validation: (text) {
      //   if (text.isEmpty) {
      //     return R.string.errorString.enterComments;
      //   } else {
      //     return null;
      //   }
      // },
      textCallback: (text) {},

      inputAction: TextInputAction.done,
      onNextPress: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  List<DateModel> setDateList() {
    return [
      DateModel(0, getDate(1), false),
      DateModel(1, getDate(2), false),
      DateModel(2, getDate(3), false),
      DateModel(3, getDate(4), false),
      DateModel(4, getDate(5), false),
      DateModel(5, getDate(6), false),
      DateModel(6, getDate(7), false),
    ];
  }

  showAppoitmentDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(getSize(15))),
            insetPadding: EdgeInsets.all(getSize(20)),
            child: Padding(
              padding: EdgeInsets.all(getSize(15)),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Book Appointment",
                      style: appTheme.black16MediumTextStyle,
                    ),
                    setVirtualDropDown(virtualList, (value) {
                      _virtualTypeController.text = value;
                    }),
                    SizedBox(
                      height: getSize(10),
                    ),
                    getCommentTextField(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: getSize(20), bottom: getSize(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: appTheme.colorPrimary, width: getSize(1)),
                                borderRadius: BorderRadius.circular(getSize(5)),
                              ),
                              child: AppButton.flat(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                // borderRadius: getSize(5),
                                text: R.string.commonString.cancel,
                                textColor: appTheme.colorPrimary,
                                backgroundColor: appTheme.whiteColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getSize(20),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  // color: appTheme.colorPrimary,
                                  // borderRadius: BorderRadius.circular(getSize(5)),
                                  boxShadow: getBoxShadow(context)),
                              child: AppButton.flat(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    callApiForRequestForOffice();
                                  } else {
                                    _autoValidate = true;
                                  }
                                },
                                // borderRadius: getSize(5),
                                text: R.string.commonString.btnSubmit,
                              ),
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
        }); /*.then((value) => Navigator.pop(context, true))*/
  }
}

class DateModel {
  int id;
  DateTime date;
  bool isSelected;

  DateModel(this.id, this.date, this.isSelected);
}
