import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/OpenDatePickerWidget.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PlaceOrderPopUp extends StatefulWidget {
  DiamondConfig diamondConfig;
  int actionType;
  List<DiamondModel> diamondList;

  PlaceOrderPopUp({this.diamondConfig,this.actionType,this.diamondList});

  @override
  _PlaceOrderPopUpState createState() =>
      _PlaceOrderPopUpState(
          diamondConfig: diamondConfig,
        actionType: actionType,
        diamondList: diamondList
      );
}

class _PlaceOrderPopUpState extends State<PlaceOrderPopUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool autovalid = false;
  String selectedPopUpDate;
  DateTime selectedDate = DateTime.now();
  List<String> invoiceList = [
    InvoiceTypesString.today,
    InvoiceTypesString.tomorrow,
    InvoiceTypesString.later
  ];
  DiamondConfig diamondConfig;
  int actionType;
  List<DiamondModel> diamondList;


  _PlaceOrderPopUpState({this.diamondConfig,this.diamondList,this.actionType});


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: getSize(30)),
              child: Text(
                R.string().commonString.placeOrder,
                style: appTheme.blackSemiBold18TitleColorblack,
              ),
            ),
            SizedBox(
              height: getSize(20),
            ),
            Form(
              key: _formKey,
              autovalidate: autovalid,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        prefixWid: getCommonIconWidget(
                            imageName: company,
                            imageType: IconSizeType.small),
                        hintText: R.string().authStrings.companyName,
                        maxLine: 1,
                        inputController: _nameController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
                          BlacklistingTextInputFormatter(
                              RegExp(RegexForEmoji))
                        ],
                        //isSecureTextField: false
                      ),
                      validation: (text) {
                        if (text.isEmpty) {
                          return R.string().authStrings.enterCompanyName;
                        }
                      },
                      textCallback: (text) {},
                      inputAction: TextInputAction.next,
                      onNextPress: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Container(
                    height: getSize(8),
                  ),
                  setInvoiceDropDown(context, _dateController, invoiceList,
                          (value) {
                        selectedPopUpDate = value;
                        _dateController.text = value;
                      }),
                  Container(
                    height: getSize(8),
                  ),
//                  getInvoiceDateTextField(),
//                  Container(
//                    height: getSize(8),
//                  ),
                  getCommentTextField(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getSize(20),
                      right: getSize(20),
                      bottom: getSize(5),
                      top: getSize(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          R.string().screenTitle.note  + " : ",
                          style: appTheme.error14TextStyle,
                        ),
                        Expanded(
                          child: Text(
                             R.string().screenTitle.orderMsg,
                            style: appTheme.error14TextStyle,
                          ),
                        ),
                        // Expanded(
                        //   child: Text(
                        //     R.string().screenTitle.orderMsg,
                        //     style: appTheme.error12TextStyle,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getSize(Spacing.leftPadding),
                  vertical: getSize(16)),
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
                        if (_formKey.currentState.validate()) {
                          diamondConfig.actionAll(context, diamondList, actionType,
                              remark: _commentController.text,
                              date: selectedPopUpDate,
                              companyName: _nameController.text);
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
                            borderRadius:
                            BorderRadius.circular(getSize(5)),
                            boxShadow: getBoxShadow(context)),
                        child: Text(
                           R.string().commonString.btnSubmit,
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
          hintText: R.string().screenTitle.comment,
          formatter: [
            WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
            BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
          ],
          //isSecureTextField: false
        ),
        validation: (text) {
          if(text.isEmpty) {
            return R.string().commonString.enterComment;
          }
        },
        textCallback: (text) {},
        inputAction: TextInputAction.done,
        onNextPress: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }



  getInvoiceDateTextField() {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        showDialog(context: context,
            builder: (BuildContext context) {
              return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: getSize(20), vertical: getSize(20)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(25)),
                  ),
                  child: OpenDatePickerWidget(
                    onSubmit: (date) {
                      selectedDate = date;
                      _dateController.text = DateUtilities().getFormattedDateString(selectedDate,formatter: DateUtilities.dd_mm_yyyy);
                      Navigator.pop(context);
                    },
                    selectedDate: selectedDate,
                  ));
            }
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: getSize(Spacing.leftPadding),
          right: getSize(Spacing.rightPadding),
        ),
        child: CommonTextfield(
          enable: false,
            textOption: TextFieldOption(
                hintText: R.string().errorString.selectInvoiceDate,
                maxLine: 1,
                prefixWid: getCommonIconWidget(
                    imageName: calender, imageType: IconSizeType.small),
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
                return R.string().errorString.selectInvoiceDate;
              }
            },
            inputAction: TextInputAction.next,
            onNextPress: () {
              FocusScope.of(context).unfocus();
            }),
      ),
    );
  }


}