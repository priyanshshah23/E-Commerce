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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  DateTime now = DateTime.now();
  DateTime serverStart;
  List<DateModel> days;
  DateTime pickedDate = DateTime.now();
  String pd;
  int selectedDate = -1;
  int selectedSlot;
  int selectedVirtualType = -1;
  List<SlotModel> arrSlots = [];
  List<SlotModel> arrSlots1 = [];
  bool selectedList = false;
  List<String> virtualList = [
    VirtualTypesString.phoneCall,
    VirtualTypesString.webConference,
    VirtualTypesString.inPerson
  ];
  final TextEditingController _virtualTypeController = TextEditingController();
  final TextEditingController _commentTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    serverStart = DateTime(DateTime.now().day);
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
      arrSlots1 = resp.data.list;
      DateTime now = DateTime.now();
      arrSlots1.forEach((element) {
        if (element.isActive == true) {
          arrSlots.add(element);

          DateTime serverStart1 =
              DateUtilities().convertServerStringToFormatterDate(element.start);

          if (now.isAfter(DateTime(
              now.year,
              now.month,
              now.day,
              serverStart1.hour,
              serverStart1.minute,
              serverStart1.second,
              serverStart1.millisecond))) {
            element.disable = true;
          } else {
            element.disable = false;
          }
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
    String timeStart = arrSlots[selectedSlot].start;
    String timeEnd = arrSlots[selectedSlot].end;

    req["purpose"] = _commentTypeController.text ?? "";
    DateTime date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
            pickedDate.hour, pickedDate.minute)
        .toUtc();
    req["start"] = DateUtilities()
        .getSpecificTimeOfString(date, timeStart)
        .toUtc()
        .toIso8601String();
    req["date"] = date.toIso8601String();
    req["type"] = 2;
    req["end"] = DateUtilities()
        .getSpecificTimeOfString(date, timeEnd)
        .toUtc()
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
      appBar: getAppBar(
        context,
        R.string.screenTitle.appointment +
            " (" +
            app.resolve<PrefUtils>().getUserDetails().companyName +
            ")",
        leadingButton: getBackButton(context),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getSize(10),
            ),
            getTopRow(),
            SizedBox(
              height: getSize(10),
            ),
            //   getDateList(),
            getTimeSlot(),
            setVirtualDropDown(virtualList, (value) {
              _virtualTypeController.text = value;
            }),
            SizedBox(
              height: getSize(10),
            ),
            getCommentTextField(),
            SizedBox(
              height: getSize(10),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(
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
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: getSize(50),
                  color: appTheme.whiteColor,
                  padding: EdgeInsets.symmetric(
                    vertical: getSize(15),
                  ),
                  child: Text(
                    R.string.commonString.cancel,
                    textAlign: TextAlign.center,
                    style: appTheme.blue14TextStyle.copyWith(
                        fontSize: getFontSize(16), fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (serverStart == null) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string.errorString.selectAppointmentDate,
                          positiveBtnTitle: R.string.commonString.ok,
                        );
                    return;
                  } else if (selectedSlot < 0) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string.errorString.selectTimeSlot,
                          positiveBtnTitle: R.string.commonString.ok,
                        );
                    return;
                  } else if (isNullEmptyOrFalse(_virtualTypeController.text)) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string.errorString.selectVirtualType,
                          positiveBtnTitle: R.string.commonString.ok,
                        );
                    return;
                  } else if (isNullEmptyOrFalse(_commentTypeController.text)) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string.errorString.enterComments,
                          positiveBtnTitle: R.string.commonString.ok,
                        );
                    return;
                  }
                  callApiForRequestForOffice();
                },
                child: Container(
                  height: getSize(50),
                  color: appTheme.colorPrimary,
                  padding: EdgeInsets.symmetric(
                    vertical: getSize(15),
                  ),
                  child: Text(
                    R.string.screenTitle.reqOfficeView,
                    textAlign: TextAlign.center,
                    style: appTheme.white16TextStyle,
                  ),
                ),
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
              // Padding(
              //   padding: EdgeInsets.only(top: getSize(5)),
              //   child: Text(
              //     DateUtilities().convertServerDateToFormatterString(
              //         DateTime.now().toIso8601String(),
              //         formatter: DateUtilities.mmm_yyyy),
              //     style: appTheme.black16TextStyle,
              //   ),
              // ),
            ],
          ),
          InkWell(
            onTap: () async {
              DateTime pickedDates = await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                firstDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData(
                      primarySwatch: Colors.grey,
                      splashColor: Colors.black,
                      textTheme: TextTheme(
                        subtitle1: TextStyle(color: Colors.black),
                        button: TextStyle(color: Colors.black),
                      ),
                      accentColor: Colors.black,
                      colorScheme: ColorScheme.light(
                          primary: ColorConstants.colorPrimary,
                          primaryVariant: Colors.black,
                          secondaryVariant: Colors.black,
                          onSecondary: Colors.black,
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.black,
                          secondary: Colors.black),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: child,
                  );
                },
                lastDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
                selectableDayPredicate: (DateTime val) =>
                    val.weekday == 7 ? false : true,
              );
              if (pickedDates != null) {
                pd = DateUtilities().convertServerDateToFormatterString(
                    pickedDates.toUtc().toIso8601String(),
                    formatter: DateUtilities.dd_mm_yyyy_);
                serverStart = DateUtilities()
                    .convertServerStringToFormatterDate(
                        pickedDates.toUtc().toIso8601String());
                arrSlots.forEach((element) {
                  if (now.isAfter(DateTime(now.year, now.month, serverStart.day,
                      now.hour, now.minute, now.second, now.millisecond))) {
                    arrSlots.forEach((element) {
                      DateTime serverStart1 = DateUtilities()
                          .convertServerStringToFormatterDate(element.start);

                      if (now.isAfter(DateTime(
                          now.year,
                          now.month,
                          now.day,
                          serverStart1.hour,
                          serverStart1.minute,
                          serverStart1.second,
                          serverStart1.millisecond))) {
                        element.disable = true;
                      } else {
                        element.disable = false;
                      }
                    });
                  } else {
                    element.disable = false;
                  }
                });
                pickedDate = serverStart;
                // pd = DateUtilities().getDateFromString(selectedDate);

              }
              setState(() {});
              // showDialog(
              //   context: context,
              //   barrierDismissible: true,
              //   builder: (BuildContext context) {
              //     return Dialog(
              //       insetPadding: EdgeInsets.symmetric(
              //           horizontal: getSize(20), vertical: getSize(20)),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(getSize(25)),
              //       ),
              //       child: AddDemand(
              //           title: "OfferView",
              //           isShowTextField: false,
              //           applyCallBack: (
              //               {String selectedDate, String diamondTitle}) {
              //             pd = DateUtilities()
              //                 .convertServerDateToFormatterString(selectedDate,
              //                     formatter: DateUtilities.dd_mm_yyyy_);
              //             serverStart = DateUtilities()
              //                 .convertServerStringToFormatterDate(selectedDate);
              //             arrSlots.forEach((element) {
              //               if (now.isAfter(DateTime(
              //                   now.year,
              //                   now.month,
              //                   serverStart.day,
              //                   now.hour,
              //                   now.minute,
              //                   now.second,
              //                   now.millisecond))) {
              //                 arrSlots.forEach((element) {
              //                   DateTime serverStart1 = DateUtilities()
              //                       .convertServerStringToFormatterDate(
              //                           element.start);
              //
              //                   if (now.isAfter(DateTime(
              //                       now.year,
              //                       now.month,
              //                       now.day,
              //                       serverStart1.hour,
              //                       serverStart1.minute,
              //                       serverStart1.second,
              //                       serverStart1.millisecond))) {
              //                     element.disable = true;
              //                   } else {
              //                     element.disable = false;
              //                   }
              //                 });
              //               } else {
              //                 element.disable = false;
              //               }
              //             });
              //             pickedDate = serverStart;
              //             // pd = DateUtilities().getDateFromString(selectedDate);
              //             setState(() {});
              //           }),
              //     );
              //   },
              // );

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
              width: getSize(120),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: appTheme.dividerColor, width: getSize(2)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pd != null
                        ? pd
                        : DateUtilities().convertServerDateToFormatterString(
                            DateTime.now().toUtc().toIso8601String(),
                            formatter: DateUtilities.dd_mm_yyyy_),
                    style: appTheme.black16TextStyle,
                    textAlign: TextAlign.center,
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
                  days[index].isSelected = !days[index].isSelected;
                  if (days[index].isSelected) {
                    pickedDate = days[index].date;
                    serverStart = pickedDate;
                    pd = DateUtilities().convertServerDateToFormatterString(
                        serverStart.toUtc().toIso8601String(),
                        formatter: DateUtilities.dd_mm_yyyy_);
                    if (now.isAfter(DateTime(
                        now.year,
                        now.month,
                        serverStart.day,
                        now.hour,
                        now.minute,
                        now.second,
                        now.millisecond))) {
                      arrSlots.forEach((element) {
                        element.disable = true;
                      });
                    } else {
                      arrSlots.forEach((element) {
                        element.disable = false;
                      });
                    }
                  }
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
                            selectedList = true;
                            selectedSlot = index;
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
                            style: selectedSlot == index
                                ? appTheme.white16TextStyle
                                : appTheme.black16TextStyle,
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
        offset: Offset(25, 200),
      );

  getVirtualTypeDropDown() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: AbsorbPointer(
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
            inputAction: TextInputAction.next,
            onNextPress: () {
              FocusScope.of(context).unfocus();
            }),
      ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.leftPadding),
      child: CommonTextfield(
        autoFocus: false,
        textOption: TextFieldOption(
          maxLine: 4,
          inputController: _commentTypeController,
          hintText: "Notes",
          // formatter: [
          //   WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          //   BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
          // ],
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

  List<DateModel> setDateList() {
    return [
      DateModel(0, now, false),
      DateModel(1, getDate(1), false),
      DateModel(2, getDate(2), false),
      DateModel(3, getDate(3), false),
      DateModel(4, getDate(4), false),
      DateModel(5, getDate(5), false),
      DateModel(6, getDate(6), false),
    ];
  }
}

class DateModel {
  int id;
  DateTime date;
  bool isSelected;

  DateModel(this.id, this.date, this.isSelected);
}
