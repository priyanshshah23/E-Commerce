import 'dart:collection';

import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SaveAndSearchBottomSheet.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/FilterRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Widget/CommonHeader.dart';
import 'Widget/DiamondListItemWidget.dart';

Future showWatchListDialog(BuildContext context, List<DiamondModel> diamondList,
    ActionClick actionClick) {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  diamondCalculation.setAverageCalculation(diamondList);
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appTheme.whiteColor,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setSetter) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getSize(28)),
                child: Text(
                  R.string.screenTitle.addToWatchList,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              DiamondListHeader(
                diamondCalculation: diamondCalculation,
              ),
              SizedBox(
                height: getSize(10),
              ),
              diamondList.length < 4
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: diamondList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return DiamondItemWidget(
                          item: diamondList[index],
                          actionClick: actionClick,
                        );
                      },
                    )
                  : Container(
                      height: getSize(100) * 4,
                      child: ListView.builder(
                        itemCount: diamondList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DiamondItemWidget(
                              item: diamondList[index],
                              actionClick: actionClick);
                        },
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(
                    right: getSize(10), left: getSize(26), bottom: getSize(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        textColor: appTheme.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          R.string.commonString.cancel,
                          style: appTheme.black16TextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        textColor: appTheme.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          actionClick(ManageCLick(
                              type: clickConstant.CLICK_TYPE_CONFIRM));
                        },
                        child: Text(
                          R.string.screenTitle.addToWatchList,
                          style: appTheme.primary16TextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      });
}

Future showOfferListDialog(BuildContext context, List<DiamondModel> diamondList,
    ActionClick actionClick) {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  diamondCalculation.setAverageCalculation(diamondList);
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setSetter) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getSize(28)),
                child: Text(
                  R.string.screenTitle.offer,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              DiamondListHeader(
                diamondCalculation: diamondCalculation,
              ),
              SizedBox(
                height: getSize(10),
              ),
              diamondList.length < 4
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: diamondList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return DiamondItemWidget(
                            item: diamondList[index], actionClick: actionClick);
                      },
                    )
                  : Container(
                      height: getSize(100) * 4,
                      child: ListView.builder(
                        itemCount: diamondList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DiamondItemWidget(
                              item: diamondList[index],
                              actionClick: actionClick);
                        },
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(
                    right: getSize(10), left: getSize(26), bottom: getSize(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        textColor: appTheme.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          R.string.commonString.cancel,
                          style: appTheme.black16TextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        textColor: appTheme.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          showOfferCommentDialog(context, actionClick);
                        },
                        child: Text(
                          R.string.commonString.btnContinue,
                          style: appTheme.primary16TextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      });
}

Future showBidListDialog(BuildContext context, List<DiamondModel> diamondList,
    ActionClick actionClick) {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  diamondCalculation.setAverageCalculation(diamondList);
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setSetter) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getSize(28)),
                child: Text(
                  R.string.screenTitle.bidStone,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              DiamondListHeader(
                diamondCalculation: diamondCalculation,
              ),
              SizedBox(
                height: getSize(10),
              ),
              diamondList.length < 4
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: diamondList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return DiamondItemWidget(
                            item: diamondList[index], actionClick: actionClick);
                      },
                    )
                  : Container(
                      height: getSize(100) * 4,
                      child: ListView.builder(
                        itemCount: diamondList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DiamondItemWidget(
                              item: diamondList[index],
                              actionClick: actionClick);
                        },
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(
                  right: getSize(10),
                  left: getSize(26),
                  bottom: getSize(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        textColor: appTheme.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          R.string.commonString.cancel,
                          style: appTheme.black16TextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        textColor: appTheme.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          actionClick(ManageCLick(
                              type: clickConstant.CLICK_TYPE_CONFIRM));
                        },
                        child: Text(
                          R.string.screenTitle.bidStone,
                          style: appTheme.primary16TextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      });
}

Future showOfferCommentDialog(BuildContext context, ActionClick actionClick) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool autovalid = false;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: appTheme.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, StateSetter setsetter) {
        return Padding(
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
                    padding:
                        EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        R.string.screenTitle.offer,
                        style: appTheme.commonAlertDialogueTitleStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.authStrings.companyName,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: R.string.authStrings.companyName,
                        maxLine: 1,
                        inputController: _nameController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
                          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
                        ],
                        //isSecureTextField: false
                      ),
                      validation: (text) {
                        if (text.isEmpty) {
                          return R.string.errorString.pleaseEnterCompanyName;
                        }
                      },
                      textCallback: (text) {},
                      inputAction: TextInputAction.next,
                      onNextPress: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.screenTitle.comment,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        maxLine: 3,
                        inputController: _commentController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.screenTitle.note,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5)),
                    child: Text(
                      R.string.screenTitle.offerMsg,
                      style: appTheme.black12TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: getSize(10),
                        left: getSize(26),
                        bottom: getSize(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            textColor: appTheme.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              R.string.commonString.cancel,
                              style: appTheme.black16TextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            textColor: appTheme.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_CONFIRM,
                                    remark: _commentController.text,
                                    companyName: _nameController.text));
                              } else {
                                setsetter(() {
                                  autovalid = true;
                                });
                              }
                            },
                            child: Text(
                              R.string.screenTitle.addOffer,
                              style: appTheme.primary16TextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

Future showNotesDialog(BuildContext context, ActionClick actionClick) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  bool autovalid = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: getSize(20), vertical: getSize(20)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(15)))),
            child: StatefulBuilder(builder: (context, StateSetter setsetter) {
              return Padding(
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
                          padding: EdgeInsets.only(
                              top: getSize(28), bottom: getSize(21)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              R.string.screenTitle.addComment,
                              style: appTheme.commonAlertDialogueTitleStyle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: getSize(20),
                              right: getSize(20),
                              bottom: getSize(20),
                              top: getSize(10)),
                          child: CommonTextfield(
                            autoFocus: false,
                            textOption: TextFieldOption(
                              maxLine: 3,
                              hintText: R.string.screenTitle.comment,
                              inputController: _commentController,
                              // formatter: [
                              //   WhitelistingTextInputFormatter(
                              //       new RegExp(alphaRegEx)),
                              //   BlacklistingTextInputFormatter(
                              //       RegExp(RegexForEmoji))
                              // ],
                              //isSecureTextField: false
                            ),
                            validation: (text) {
                              if (text.isEmpty) {
                                return R.string.errorString.pleaseEnterComment;
                              }
                            },
                            textCallback: (text) {},
                            inputAction: TextInputAction.done,
                            onNextPress: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: getSize(Spacing.leftPadding),
                              right: getSize(Spacing.leftPadding),
                              bottom: getSize(Spacing.leftPadding)),
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
                                      color: appTheme.whiteColor,
                                      border: Border.all(
                                          color: appTheme.colorPrimary),
                                      borderRadius:
                                          BorderRadius.circular(getSize(50)),
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
                                      actionClick(ManageCLick(
                                          type:
                                              clickConstant.CLICK_TYPE_CONFIRM,
                                          remark: _commentController.text));
                                    } else {
                                      setsetter(() {
                                        autovalid = true;
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    //alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.symmetric(
                                      vertical: getSize(15),
                                    ),
                                    decoration: BoxDecoration(
                                        color: appTheme.colorPrimary,
                                        borderRadius:
                                            BorderRadius.circular(getSize(50)),
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
                ),
              );
            }),
          );
        },
      );
    },
  );
}

Future showEnquiryDialog(BuildContext context, ActionClick actionClick) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  bool autovalid = false;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(getSize(15)))),
            child: StatefulBuilder(builder: (context, StateSetter setsetter) {
              return Padding(
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
                          padding: EdgeInsets.only(
                              top: getSize(28), bottom: getSize(21)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              R.string.screenTitle.addEnquiry,
                              style: appTheme.commonAlertDialogueTitleStyle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: getSize(20),
                              right: getSize(20),
                              bottom: getSize(20),
                              top: getSize(10)),
                          child: CommonTextfield(
                            autoFocus: false,
                            textOption: TextFieldOption(
                              maxLine: 3,
                              hintText: R.string.screenTitle.remarks,
                              inputController: _commentController,
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
                                return R.string.errorString.pleaseEnterRemarks;
                              }
                            },
                            textCallback: (text) {},
                            inputAction: TextInputAction.done,
                            onNextPress: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: getSize(Spacing.leftPadding),
                              right: getSize(Spacing.leftPadding),
                              bottom: getSize(Spacing.leftPadding)),
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
                                      color: appTheme.whiteColor,
                                      border: Border.all(
                                          color: appTheme.colorPrimary),
                                      borderRadius:
                                          BorderRadius.circular(getSize(50)),
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
                                      actionClick(ManageCLick(
                                          type:
                                              clickConstant.CLICK_TYPE_CONFIRM,
                                          remark: _commentController.text));
                                    } else {
                                      setsetter(() {
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
                                            BorderRadius.circular(getSize(50)),
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
                ),
              );
            }),
          );
        },
      );
    },
  );
}

Future showPlaceOrderDialog(BuildContext context, ActionClick actionClick) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String selectedDate;
  bool autovalid = false;
  List<String> invoiceList = [
    InvoiceTypesString.today,
    InvoiceTypesString.tomorrow,
    InvoiceTypesString.later
  ];

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: appTheme.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, StateSetter setsetter) {
        return Padding(
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
                    padding:
                        EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        R.string.authStrings.confirmStoneDetail,
                        style: appTheme.commonAlertDialogueTitleStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.authStrings.companyName,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: R.string.authStrings.companyName,
                        maxLine: 1,
                        inputController: _nameController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
                          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
                        ],
                        //isSecureTextField: false
                      ),
                      validation: (text) {
                        if (text.isEmpty) {
                          return R.string.authStrings.enterCompanyName;
                        }
                      },
                      textCallback: (text) {},
                      inputAction: TextInputAction.next,
                      onNextPress: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.authStrings.invoiceDate,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  setInvoiceDropDown(context, _dateController, invoiceList,
                      (value) {
                    _dateController.text = value;
                  }),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.screenTitle.comment,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        maxLine: 3,
                        inputController: _commentController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5),
                        top: getSize(10)),
                    child: Text(
                      R.string.screenTitle.note,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5)),
                    child: Text(
                      R.string.screenTitle.orderMsg,
                      style: appTheme.black12TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: getSize(10),
                        left: getSize(26),
                        bottom: getSize(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            textColor: appTheme.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              R.string.commonString.cancel,
                              style: appTheme.black16TextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            textColor: appTheme.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_CONFIRM,
                                    remark: _commentController.text,
                                    companyName: _nameController.text,
                                    date: _dateController.text));
                              } else {
                                setsetter(() {
                                  autovalid = true;
                                });
                              }
                            },
                            child: Text(
                              R.string.commonString.confirmStone,
                              style: appTheme.primary16TextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

Widget setInvoiceDropDown(
        BuildContext context,
        TextEditingController _dateController,
        List<String> list,
        Function(String) selectedValue,
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
      child: Padding(
        padding: EdgeInsets.only(
          left: getSize(Spacing.leftPadding),
          right: getSize(Spacing.rightPadding),
        ),
        child: AbsorbPointer(
          child: CommonTextfield(
              enable: false,
              textOption: TextFieldOption(
                  hintText: R.string.errorString.selectInvoiceDate,
                  maxLine: 1,
                  prefixWid: getCommonIconWidget(
                      imageName: calender, imageType: IconSizeType.small),
                  keyboardType: TextInputType.text,
                  type: TextFieldType.DropDown,
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
      ),
      offset: Offset(25, 110),
    );

Future openBottomSheetForSavedSearch(
  BuildContext context,
  Map<String, dynamic> req, {
  isSearch = false,
  SavedSearchModel savedSearchModel,
  List<FormBaseModel> filterList,
}) {
  return showDialog(
    barrierDismissible: true,
    context: context,

    // barrierDismissible: true,
    // useSafeArea: true,
    // useRootNavigator: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: getSize(20), vertical: getSize(20)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(25)),
        ),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(getSize(15)))),
        child: SaveAndSearchBottomSheet(
          savedSearchModel: savedSearchModel,
          callBack: (text, isNewSearch) {
            Map<String, dynamic> dict = {};
            dict["filter"] = req;
            dict["name"] = text;
            dict["id"] = isNewSearch ? "" : savedSearchModel?.id ?? "";
            dict["searchType"] = DiamondSearchType.SAVE;
            NetworkCall<SavedSearchResp>()
                .makeCall(
              () => app
                  .resolve<ServiceModule>()
                  .networkService()
                  .saveSearch(dict),
              context,
              isProgress: true,
            )
                .then((diamondListResp) async {
              Navigator.pop(context);
              if (isSearch) {
                Map<String, dynamic> dict = new HashMap();
                dict["filterId"] = diamondListResp.data.savedSearchModel.id;
                dict["filters"] = req;
                dict["filterModel"] = filterList;
                dict[ArgumentConstant.ModuleType] =
                    DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                NavigationUtilities.pushRoute(DiamondListScreen.route,
                    args: dict);
              }
              // Navigator.pop(context);
            }).catchError((onError) {
              app.resolve<CustomDialogs>().confirmDialog(
                    context,
                    desc: onError.message,
                    positiveBtnTitle: R.string.commonString.ok,
                  );
            });
          },
        ),
      );
    },
  );
  /*return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: appTheme.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return SaveAndSearchBottomSheet(
        savedSearchModel: savedSearchModel,
        callBack: (text, isNewSearch) {
          Map<String, dynamic> dict = {};
          dict["filter"] = req;
          dict["name"] = text;
          dict["id"] = isNewSearch ? "" : savedSearchModel?.id ?? "";
          dict["searchType"] = DiamondSearchType.SAVE;
          NetworkCall<SavedSearchResp>()
              .makeCall(
            () =>
                app.resolve<ServiceModule>().networkService().saveSearch(dict),
            context,
            isProgress: true,
          )
              .then((diamondListResp) async {
            Navigator.pop(context);
            if (isSearch) {
              Map<String, dynamic> dict = new HashMap();
              dict["filterId"] = diamondListResp.data.savedSearchModel.id;
              dict["filters"] = req;
              dict["filterModel"] = filterList;
              dict[ArgumentConstant.ModuleType] =
                  DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
              NavigationUtilities.pushRoute(DiamondListScreen.route,
                  args: dict);
            }
            // Navigator.pop(context);
          }).catchError((onError) {
            app.resolve<CustomDialogs>().confirmDialog(
                  context,
                  desc: onError.message,
                  positiveBtnTitle: R.string.commonString.ok,
                );
          });
        },
      );
    },
  );*/
}
