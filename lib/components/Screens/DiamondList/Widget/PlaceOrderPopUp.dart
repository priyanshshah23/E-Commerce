import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/OpenDatePickerWidget.dart';
import 'package:diamnow/components/Screens/StaticPage/StaticPage.dart';
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

class PlaceOrderPopUp extends StatefulWidget {
  DiamondConfig diamondConfig;
  int actionType;
  List<DiamondModel> diamondList;
  Function(String selectedDate, String remark) callBack;

  PlaceOrderPopUp(
      {this.diamondConfig, this.actionType, this.diamondList, this.callBack});

  @override
  _PlaceOrderPopUpState createState() => _PlaceOrderPopUpState(
      diamondConfig: diamondConfig,
      actionType: actionType,
      diamondList: diamondList);
}

class _PlaceOrderPopUpState extends State<PlaceOrderPopUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
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
  bool isCheckBoxSelected = true;

  _PlaceOrderPopUpState(
      {this.diamondConfig, this.diamondList, this.actionType});

  @override
  void initState() {
    super.initState();

    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.MY_ORDER,
        section: SectionAnalytics.VIEW,
        action: ActionAnalytics.OPEN);
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
                R.string.commonString.confirmStone,
                style: TextStyle(fontSize: 18,decoration: TextDecoration.underline)
                //style: appTheme.blackSemiBold18TitleColorblack,

              ),
            ),
            SizedBox(
              height: getSize(15),
            ),
            Form(
              key: _formKey,
              autovalidate: autovalid,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // getCompanyNameTextfield(),
                  // Container(
                  //   height: getSize(8),
                  // ),
                  // setInvoiceDropDown(context, _dateController, invoiceList,
                  //     (value) {
                  //   selectedPopUpDate = value;
                  //   _dateController.text = value;
                  // }),
                  Container(
                    height: getSize(8),
                  ),
                  getCompanyNameTextfield(),
                  SizedBox(
                    height: getSize(16),
                  ),
                  //getInvoiceDateTextField(),
                  // setInvoiceDropDown(context, _dateController, invoiceList,
                  //     (value) {
                  //   selectedPopUpDate = value;
                  //   _dateController.text = value;
                  // }),
                  // SizedBox(
                  //   height: getSize(16),
                  // ),
                  getCommentTextField(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: getSize(16),
                      left: getSize(20),
                      right: getSize(20),
                      bottom: getSize(16),
                    ),
                    child: Container(
                      // width: getSize(311),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(R.string.screenTitle.note + " : "),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(R.string.screenTitle.orderMsg1),
                                Text(R.string.screenTitle.orderMsg2),
                                // Text(
                                //   "1) The Price Mentioned over here are fixed and nonce not negotiable.",
                                // ),
                                // Text(
                                //   "2) The grading, parameters mentioned on our website beyond GIA's Grading.",
                                //   maxLines: 2,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     isCheckBoxSelected = !isCheckBoxSelected;
                      //     setState(() {});
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         borderRadius:
                      //             BorderRadius.circular(getSize(3))),
                      //     width: getSize(21),
                      //     height: getSize(21),
                      //     child: Image.asset(
                      //       isCheckBoxSelected
                      //           ? selectedCheckbox
                      //           : unSelectedCheckbox,
                      //       height: getSize(20),
                      //       width: getSize(20),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: getSize(6),
                      // ),
                      // Text.rich(
                      //   TextSpan(
                      //     text: R.string.commonString.ihaveread,
                      //     style: appTheme.blackNormal14TitleColorblack,
                      //     children: <TextSpan>[
                      //       TextSpan(
                      //         recognizer: TapGestureRecognizer()
                      //           ..onTap = () {
                      //             print("Terms and condition clicked");
                      //             Navigator.pop(context);
                      //             Map<String, dynamic> dict = {};
                      //             dict["type"] =
                      //                 StaticPageConstant.TERMS_CONDITION;
                      //             dict["strUrl"] =
                      //                 ApiConstants.termsCondition;
                      //             dict[ArgumentConstant.IsFromDrawer] = false;
                      //             NavigationUtilities.pushRoute(
                      //                 StaticPageScreen.route,
                      //                 args: dict);
                      //           },
                      //         text: R.string.screenTitle.termsAndCondition,
                      //         style: appTheme.black16MediumTextStyle.copyWith(
                      //           decoration: TextDecoration.underline,
                      //           fontSize: getFontSize(14),
                      //           color: appTheme.colorPrimary,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     print("Shipping policy clicked");
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(
                  //         left: getSize(16),
                  //         right: getSize(16),
                  //         top: getSize(8),
                  //         bottom: getSize(8)),
                  //     child: Text(
                  //       R.string.commonString.shippingPolicy,
                  //       style: appTheme.blackNormal14TitleColorblack.copyWith(
                  //         decoration: TextDecoration.underline,
                  //         color: appTheme.colorPrimary,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
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
                          if (isCheckBoxSelected == false) {
                            showToast(
                                R.string.errorString.acceptTermsAndCondition,
                                context: context);
                            return;
                          }
                          Navigator.pop(context);
                          widget.callBack(selectedPopUpDate,
                              _commentController.text.trim());
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

  getCompanyNameTextfield() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
     // padding: EdgeInsets.symmetric(horizontal: getSize(20)),
      child: Center(child: Text(app.resolve<PrefUtils>().getUserDetails()?.account?.companyName ??"" )),
      // child: CommonTextfield(
      //   enable: true,
      //   autoFocus: false,
      //   textOption: TextFieldOption(
      //     prefixWid: getCommonIconWidget(
      //         imageName: company, imageType: IconSizeType.small),
      // //    hintText: R.string.authStrings.companyName,
      //     maxLine: 1,
      //     inputController: _nameController,
      //     // formatter: [
      //     //   WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
      //     //   BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
      //     // ],
      //     //isSecureTextField: false
      //   ),
      //   // validation: (text) {
      //   //   if (text.isEmpty) {
      //   //     return R.string.authStrings.enterCompanyName;
      //   //   }
      //   // },
      //   textCallback: (text) {},
      //   inputAction: TextInputAction.next,
      //   onNextPress: () {
      //     FocusScope.of(context).unfocus();
      //   },
      // ),
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

  getInvoiceDateTextField() {
    return InkWell(
      // highlightColor: Colors.transparent,
      onTap: () {
        showDialog(
            context: context,
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
                      _dateController.text = DateUtilities()
                          .getFormattedDateString(selectedDate,
                              formatter: DateUtilities.dd_mm_yyyy);
                      Navigator.pop(context);
                    },
                    selectedDate: selectedDate,
                  ));
            });
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: getSize(Spacing.leftPadding),
          right: getSize(Spacing.rightPadding),
        ),
        child: CommonTextfield(
            enable: false,
            readOnly: true,
            textOption: TextFieldOption(
                // isBorder: true,
                hintText: R.string.errorString.selectInvoiceDate,
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
            // validation: (text) {
            //   if (text.isEmpty) {
            //     return R.string.errorString.selectInvoiceDate;
            //   }
            // },
            inputAction: TextInputAction.next,
            onNextPress: () {
              FocusScope.of(context).unfocus();
            }),
      ),
    );
  }
}
