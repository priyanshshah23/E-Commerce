import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/OpenDatePickerWidget.dart';
import 'package:diamnow/components/widgets/shared/CommonDateTimePicker.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OfferPopup extends StatefulWidget {
  Function(String selectedDate, String comment) callBack;
  int actionType = DiamondTrackConstant.TRACK_TYPE_OFFER;
  String date;
  bool isFromOfferUpdate = false;
  OfferPopup(
      {this.callBack,
      this.actionType,
      this.date,
      this.isFromOfferUpdate = false});

  @override
  _OfferPopupState createState() => _OfferPopupState();
}

class _OfferPopupState extends State<OfferPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool autovalid = false;
  String selectedDate;
  List<String> invoiceList = [
    InvoiceTypesString.today,
    InvoiceTypesString.tomorrow,
    InvoiceTypesString.later
  ];
  DiamondConfig diamondConfig;
  int actionType;
  List<DiamondModel> diamondList;
  bool isCheckBoxSelected = false;

  @override
  void initState() {
    if (widget.isFromOfferUpdate) {
      selectedDate = widget.date;
      _dateController.text = DateUtilities().convertServerDateToFormatterString(
          selectedDate,
          formatter: DateUtilities.dd_mm_yyyy_);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: getSize(30)),
                child: Text(
                  widget.actionType == DiamondTrackConstant.TRACK_TYPE_OFFICE
                      ? R.string.screenTitle.bookOffice
                      : R.string.screenTitle.placeAnOffer,
                  style: appTheme.blackSemiBold18TitleColorblack,
                ),
              ),
            ),
            SizedBox(
              height: getSize(20),
            ),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Form(
                key: _formKey,
                autovalidate: autovalid,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: getSize(8),
                    ),
                    getDateTextField(),
                    Container(
                      height: getSize(8),
                    ),
                    getCommentTextField(),
                    Container(
                      height: getSize(8),
                    ),
                  ],
                ),
              ),
            ),
            // widget.actionType == DiamondTrackConstant.TRACK_TYPE_OFFICE
            //     ? Container()
            //     : InkWell(
            //         onTap: () {
            //           print("Shipping policy clicked");
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.only(
            //               left: getSize(16),
            //               right: getSize(16),
            //               top: getSize(8),
            //               bottom: getSize(8)),
            //           child: Text(
            //             R.string.commonString.shippingPolicy,
            //             style: appTheme.blackNormal14TitleColorblack.copyWith(
            //               decoration: TextDecoration.underline,
            //               color: appTheme.colorPrimary,
            //             ),
            //           ),
            //         ),
            //       ),
            Padding(
              padding: EdgeInsets.only(
                  left: getSize(Spacing.leftPadding),
                  right: getSize(Spacing.leftPadding),
                  top: getSize(16),
                  bottom: getSize(30)),
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
                          border: Border.all(
                              color: appTheme.colorPrimary, width: getSize(1)),
                          borderRadius: BorderRadius.circular(getSize(50)),
                        ),
                        child: Text(
                          R.string.commonString.cancel,
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
                        if (_formKey.currentState.validate()) {
                          print("---1----${_commentController.text}");
                          Navigator.pop(context);
                          widget.callBack(
                              selectedDate, _commentController.text);
                        } else {
                          setState(() {
                            autovalid = true;
                          });
                        }
                      },
                      child: Container(
                        //alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(
                          vertical: getSize(15),
                        ),
                        decoration: BoxDecoration(
                            color: appTheme.colorPrimary,
                            borderRadius: BorderRadius.circular(getSize(50)),
                            boxShadow: getBoxShadow(context)),
                        child: Text(
                          R.string.commonString.btnSubmit,
                          textAlign: TextAlign.center,
                          style: appTheme.white16TextStyle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
    },
        isTime: false,
        title: R.string.commonString.selectDate,
        actionType: DiamondTrackConstant.TRACK_TYPE_OFFICE);
  }

  getDateTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: CommonTextfield(
          // readOnly: true,
          tapCallback: () {},
          textOption: TextFieldOption(
            prefixWid: getCommonIconWidget(
                imageName: company, imageType: IconSizeType.small),
            hintText:
                widget.actionType == DiamondTrackConstant.TRACK_TYPE_OFFICE
                    ? R.string.commonString.officeVisitDate
                    : R.string.commonString.offerVelidTill,
            maxLine: 1,
            keyboardType: TextInputType.text,
            inputController: _dateController,
            // isSecureTextField: false,
          ),
//           textCallback: (text) {
// //                  setState(() {
// //                    checkValidation();
// //                  });
//           },
          // validation: (text) {
          //   if (text.isEmpty) {
          //     return widget.actionType == DiamondTrackConstant.TRACK_TYPE_OFFICE
          //         ? R.string.errorString.pleaseSelectOfficeVisitDate
          //         : R.string.errorString.pleaseSelectOfferTillDate;
          //   }
          // },
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
          // formatter: [
          //   WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
          //   BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
          // ],
          //isSecureTextField: false
        ),
        // validation: (text) {
        //   if (text.isEmpty) {
        //     return R.string.commonString.enterComment;
        //   }
        // },
        textCallback: (text) {},
        inputAction: TextInputAction.done,
        onNextPress: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
