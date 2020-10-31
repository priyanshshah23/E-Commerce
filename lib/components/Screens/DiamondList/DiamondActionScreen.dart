import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
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

  DiamondActionScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.ActionType] != null) {
        actionType = arguments[ArgumentConstant.ActionType];
      }
      if (arguments[ArgumentConstant.DiamondList] != null) {
        diamondList = arguments[ArgumentConstant.DiamondList];
      }
    }
  }

  @override
  _DiamondActionScreenState createState() => _DiamondActionScreenState(
        moduleType: moduleType,
        actionType: actionType,
        diamondList: diamondList,
      );
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
  List<String> invoiceList = [
    InvoiceTypesString.today,
    InvoiceTypesString.tomorrow,
    InvoiceTypesString.later
  ];

  _DiamondActionScreenState(
      {this.moduleType, this.actionType, this.diamondList});

  DiamondConfig diamondConfig;
  DiamondCalculation diamondCalculation = DiamondCalculation();

  @override
  void initState() {
    super.initState();
    diamondConfig = DiamondConfig(moduleType);
    diamondCalculation.setAverageCalculation(diamondList);
    diamondConfig.initItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(
        context,
        diamondConfig.getActionScreenTitle(actionType),
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
        textalign: TextAlign.left,
      ),
      bottomNavigationBar: getBottomTab(),
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
                child: ListView.builder(
                  // primary: false,
                  shrinkWrap: true,
                  itemCount: diamondList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return DiamondItemWidget(
                        item: diamondList[index],
                        actionClick: (manageClick) {});
                  },
                ),
              ),
              SizedBox(
                height: getSize(20),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getOfferDetail(),
                  getOrderDetail(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getBottomTab() {
    return Padding(
      padding: EdgeInsets.all(getSize(Spacing.leftPadding)),
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
                switch (actionType) {
                  case DiamondTrackConstant.TRACK_TYPE_OFFER:
                  case DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER:
                    if (_formKey.currentState.validate()) {
                      diamondConfig.actionAll(context, diamondList, actionType,
                          remark: _commentController.text,
                          date: selectedDate,
                          companyName: _nameController.text);
                    } else {
                      setState(() {
                        autovalid = true;
                      });
                    }
                    break;
                  default:
                    diamondConfig.actionAll(context, diamondList, actionType);
                    break;
                }
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
                  R.string().commonString.confirm,
                  textAlign: TextAlign.center,
                  style: appTheme.white16TextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getOfferDetail() {
    return actionType != DiamondTrackConstant.TRACK_TYPE_OFFER
        ? Container()
        : Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidate: autovalid,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getDateTextField(),
                    Container(
                      height: getSize(8),
                    ),
                    getCommentTextField(),
                  ],
                ),
              ),
            ),
          );
  }

  getOrderDetail() {
    return actionType != DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER
        ? Container()
        : Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Form(
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
                      selectedDate = value;
                      _dateController.text = value;
                    }),
                    Container(
                      height: getSize(8),
                    ),
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
                          Expanded(
                            child: Text(
                              R.string().screenTitle.note +
                                  " : " +
                                  R.string().screenTitle.orderMsg,
                              style: appTheme.error12TextStyle,
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
    }, isTime: false, title: R.string().commonString.selectDate);
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
              hintText: R.string().commonString.offerVelidTill,
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
              return R.string().errorString.pleaseSelectOfferTillDate;
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
          hintText: R.string().screenTitle.comment,
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
