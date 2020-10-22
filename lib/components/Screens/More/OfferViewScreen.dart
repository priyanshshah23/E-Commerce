import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/models/Slot/SlotModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferViewScreen extends StatefulWidget {
  static const route = "OfferView";

  @override
  _OfferViewScreenState createState() => _OfferViewScreenState();
}

class _OfferViewScreenState extends State<OfferViewScreen> {
  DateTime now = DateTime.now();
  List days;
  var pickedDate;
  int selectedDate = -1;
  int selectedSlot = 0;
  int selectedVirtualType = -1;
  List<SlotModel> arrSlots = [];
  List<String> virtualList = ["Phone Call", "Web Conference", "In Person"];
  final TextEditingController _virtualTypeController = TextEditingController();
  final TextEditingController _commentTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    days = [
      now,
      getDate(1),
      getDate(2),
      getDate(3),
      getDate(4),
      getDate(5),
      getDate(6)
    ];

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
      setState(() {});
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: "",
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }

  callApiForRequestForOffice() {
    Map<String, dynamic> req = {};
    req["purpose"] = _commentTypeController.text;
    DateTime date = DateTime(
            now.add(Duration(days: selectedDate)).year,
            now.add(Duration(days: selectedDate)).month,
            now.add(Duration(days: selectedDate)).day,
            now.add(Duration(days: selectedDate)).hour,
            now.add(Duration(days: selectedDate)).minute)
        .toUtc();
    req["date"] = DateUtilities().getStartOfDay(date).toUtc().toIso8601String();
    req["type"] = 2;
    req["meetingType"] = 2;
    req["cabinSlot"] = [
      {"id": arrSlots[selectedSlot].id ?? ""}
    ];

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
          positiveBtnTitle: R.string().commonString.ok,
          onClickCallback: (type) {
        Navigator.pop(context);
      });
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              title: "",
              desc: onError.message,
              positiveBtnTitle: R.string().commonString.ok,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context,
        R.string().screenTitle.officeView,
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
            setVirtualDropDown(virtualList, (value) {
              _virtualTypeController.text = value;
            }),
            SizedBox(
              height: getSize(10),
            ),
            getCommentTextField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(Spacing.leftPadding), vertical: getSize(16)),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  // alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(
                    vertical: getSize(15),
                  ),
                  decoration: BoxDecoration(
                    color: appTheme.colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(getSize(5)),
                  ),
                  child: Text(
                    R.string().commonString.cancel,
                    textAlign: TextAlign.center,
                    style: appTheme.blue14TextStyle
                        .copyWith(fontSize: getFontSize(16)),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: getSize(20),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (selectedDate < 0) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string().errorString.selectAppointmentDate,
                          positiveBtnTitle: R.string().commonString.ok,
                        );
                    return;
                  } else if (selectedSlot < 0) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string().errorString.selectTimeSlot,
                          positiveBtnTitle: R.string().commonString.ok,
                        );
                    return;
                  } else if (isNullEmptyOrFalse(_virtualTypeController.text)) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string().errorString.selectVirtualType,
                          positiveBtnTitle: R.string().commonString.ok,
                        );
                    return;
                  } else if (isNullEmptyOrFalse(_commentTypeController.text)) {
                    app.resolve<CustomDialogs>().confirmDialog(
                          context,
                          title: "",
                          desc: R.string().errorString.enterComments,
                          positiveBtnTitle: R.string().commonString.ok,
                        );
                    return;
                  }
                  callApiForRequestForOffice();
                },
                child: Container(
                  //alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(
                    vertical: getSize(15),
                  ),
                  decoration: BoxDecoration(
                      color: appTheme.colorPrimary,
                      borderRadius: BorderRadius.circular(getSize(5)),
                      boxShadow: getBoxShadow(context)),
                  child: Text(
                    "Request Office View",
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
                "Available Slots",
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
              DateUtilities().pickDateDialog(context).then((value) {
                pickedDate = value;
                setState(() {});
              });
            },
            child: Container(
              width: getSize(200),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: appTheme.dividerColor, width: getSize(2)))),
              child: Row(
                children: [
                  Text(
                    pickedDate != null
                        ? DateUtilities().convertServerDateToFormatterString(
                            pickedDate.toString(),
                            formatter: DateUtilities.dd_mm_yyyy_)
                        : "Select Custom date",
                    style: appTheme.black16TextStyle,
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
                  selectedDate = index;
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
                  color: selectedDate == index
                      ? appTheme.colorPrimary
                      : Colors.transparent,
                  boxShadow: selectedDate == index
                      ? getBoxShadow(context)
                      : [BoxShadow(color: Colors.transparent)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateUtilities().convertServerDateToFormatterString(
                          days[index].toString(),
                          formatter: DateUtilities.dd),
                      textAlign: TextAlign.center,
                      style: selectedDate == index
                          ? appTheme.white16TextStyle
                              .copyWith(fontWeight: FontWeight.w500)
                          : appTheme.black16TextStyle
                              .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateUtilities().convertServerDateToFormatterString(
                          days[index].toString(),
                          formatter: DateUtilities.ee),
                      textAlign: TextAlign.center,
                      style: selectedDate == index
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
            "Time Slots",
            style:
                appTheme.black16TextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: getSize(15),
          ),
          isNullEmptyOrFalse(arrSlots)
              ? Text(R.string().commonString.noSlotFound,
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
                          selectedSlot = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            right: getSize(5), bottom: getSize(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(getSize(5)),
                          border: Border.all(color: appTheme.borderColor),
                          color: selectedSlot == index
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
        offset: Offset(25, 110),
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
                hintText: "Select Virtual Type",
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
          hintText: "Enter Comments",
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
}
