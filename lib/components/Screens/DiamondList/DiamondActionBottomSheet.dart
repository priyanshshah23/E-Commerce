import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setSetter) {
          ActionClick actionClick = (manageClick) {
            setSetter(() {});
          };
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
                child: Text(
                  R.string().screenTitle.addToWatchList,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(8), right: getSize(8)),
                child: DiamondListHeader(
                  diamondCalculation: diamondCalculation,
                ),
              ),
              SizedBox(
                height: getSize(10),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(8), right: getSize(8)),
                child: diamondList.length < 4
                    ? ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: getSize(15),
                        ),
                        shrinkWrap: true,
                        itemCount: diamondList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return DiamondItemWidget(
                              item: diamondList[index],
                              actionClick: actionClick);
                        },
                      )
                    : Container(
                        height: getSize(100) * 4,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: getSize(15),
                          ),
                          itemCount: diamondList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DiamondItemWidget(
                                item: diamondList[index],
                                actionClick: actionClick);
                          },
                        ),
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
                        textColor: ColorConstants.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          R.string().commonString.cancel,
                          style: appTheme.black16TextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        textColor: ColorConstants.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          actionClick(ManageCLick(
                              type: clickConstant.CLICK_TYPE_CONFIRM));
                        },
                        child: Text(
                          R.string().screenTitle.addToWatchList,
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
                padding: EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
                child: Text(
                  R.string().screenTitle.offer,
                  style: appTheme.commonAlertDialogueTitleStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(8), right: getSize(8)),
                child: DiamondListHeader(
                  diamondCalculation: diamondCalculation,
                ),
              ),
              SizedBox(
                height: getSize(10),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(8), right: getSize(8)),
                child: diamondList.length < 4
                    ? ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: getSize(15),
                        ),
                        shrinkWrap: true,
                        itemCount: diamondList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return DiamondItemWidget(
                              item: diamondList[index],
                              actionClick: actionClick);
                        },
                      )
                    : Container(
                        height: getSize(100) * 4,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: getSize(15),
                          ),
                          itemCount: diamondList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DiamondItemWidget(
                                item: diamondList[index],
                                actionClick: actionClick);
                          },
                        ),
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
                        textColor: ColorConstants.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          R.string().commonString.cancel,
                          style: appTheme.black16TextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        textColor: ColorConstants.colorPrimary,
                        padding: EdgeInsets.all(getSize(0)),
                        onPressed: () {
                          showOfferCommentDialog(context, actionClick);
                        },
                        child: Text(
                          R.string().commonString.btnContinue,
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
                        R.string().screenTitle.offer,
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
                      R.string().authStrings.companyName,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: R.string().authStrings.companyName,
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
                          return R.string().errorString.pleaseEnterCompanyName;
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
                      R.string().screenTitle.comment,
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
                      R.string().screenTitle.comment,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(20),
                        right: getSize(20),
                        bottom: getSize(5)),
                    child: Text(
                      R.string().screenTitle.offerMsg,
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
                            textColor: ColorConstants.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              R.string().commonString.cancel,
                              style: appTheme.black16TextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            textColor: ColorConstants.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_CONFIRM,remark: _commentController.text,companyName: _nameController.text));
                              } else {
                                setsetter(() {
                                  autovalid = true;
                                });
                              }
                            },
                            child: Text(
                              R.string().screenTitle.addOffer,
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
                        R.string().screenTitle.comment,
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
                        hintText: R.string().screenTitle.comment,
                        inputController: _commentController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
                          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
                        ],
                        //isSecureTextField: false
                      ),
                      validation: (text) {
                        if (text.isEmpty) {
                          return R.string().errorString.pleaseEnterComment;
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
                        right: getSize(10),
                        left: getSize(26),
                        bottom: getSize(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            textColor: ColorConstants.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              R.string().commonString.cancel,
                              style: appTheme.black16TextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            textColor: ColorConstants.colorPrimary,
                            padding: EdgeInsets.all(getSize(0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_CONFIRM,
                                    remark: _commentController.text));
                              } else {
                                setsetter(() {
                                  autovalid = true;
                                });
                              }
                            },
                            child: Text(
                              R.string().screenTitle.addComment,
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

Future showBottomSheetForConfirmStoneDetail(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String selectedDate;
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
                        R.string().authStrings.confirmStoneDetail,
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
                      R.string().authStrings.companyName,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: R.string().authStrings.companyName,
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
                          return "Please enter company name.";
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
                      R.string().authStrings.invoiceDate,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        DateUtilities()
                            .pickDateDialog(context)
                            .then((pickDate) {
                          selectedDate = pickDate.toIso8601String();
                          _dateController.text = DateUtilities()
                              .convertServerDateToFormatterString(
                            pickDate.toIso8601String(),
                            formatter: DateUtilities.ddmmyyyy_,
                          );
//                      _dateController.text = selectedDate.toIso8601String();
                        });
                      },
                      child: AbsorbPointer(
                        child: CommonTextfield(
                          autoFocus: false,
                          textOption: TextFieldOption(
                            hintText: R.string().commonString.selected,
                            maxLine: 1,
                            inputController: _dateController,
                            formatter: [
                              WhitelistingTextInputFormatter(
                                  new RegExp(alphaRegEx)),
                              BlacklistingTextInputFormatter(
                                  RegExp(RegexForEmoji))
                            ],
                            //isSecureTextField: false
                          ),
                          textCallback: (text) {},
                          validation: (text) {
                            if (text.isEmpty) {
                              return "Please select date.";
                            }
                          },
                          inputAction: TextInputAction.next,
                          onNextPress: () {},
                        ),
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
                      R.string().screenTitle.comment,
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
                  getBottomButton(context, () {
                    if (_formKey.currentState.validate()) {
                      if (DateTime.parse(selectedDate).millisecondsSinceEpoch <
                          DateTime.now().millisecondsSinceEpoch) {
                        app.resolve<CustomDialogs>().errorDialog(
                            context,
                            R.string().commonString.toDate,
                            R.string().errorString.fromGreaterTo,
                            btntitle: R.string().commonString.ok);
                      }
                    } else {
                      setsetter(() {
                        autovalid = true;
                      });
                    }
                  }, R.string().commonString.confirmStone)
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

Future showBottomSheetforAddToOffice(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _salesmanController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  String selectedDate;
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
                        "ADD TO OFFICE",
                        style: appTheme.commonAlertDialogueTitleStyle,
                      ),
                    ),
                  ),
                  getFieldTitleText(R.string().authStrings.companyName + "*"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: R.string().commonString.selected,
                        maxLine: 1,
                        inputController: _timeController,
                        //isSecureTextField: false
                      ),
                      textCallback: (text) {},
                      validation: (text) {
                        if (text.isEmpty) {
                          return "Please select time.";
                        }
                      },
                      inputAction: TextInputAction.next,
                      onNextPress: () {},
                    ),
                  ),
                  getFieldTitleText("Appointment Date*"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        DateUtilities()
                            .pickDateDialog(context)
                            .then((pickDate) {
                          selectedDate = pickDate.toIso8601String();
                          _dateController.text = DateUtilities()
                              .convertServerDateToFormatterString(
                            pickDate.toIso8601String(),
                            formatter: DateUtilities.ddmmyyyy_,
                          );
//                      _dateController.text = selectedDate.toIso8601String();
                        });
                      },
                      child: AbsorbPointer(
                        child: CommonTextfield(
                          autoFocus: false,
                          textOption: TextFieldOption(
                            hintText: R.string().commonString.selected,
                            maxLine: 1,
                            inputController: _dateController,
                          ),
                          textCallback: (text) {},
                          validation: (text) {
                            if (text.isEmpty) {
                              return "Please select date.";
                            }
                          },
                          inputAction: TextInputAction.next,
                          onNextPress: () {},
                        ),
                      ),
                    ),
                  ),
                  getFieldTitleText("Appointment Time*"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: InkWell(
                      onTap: () {
//                        FocusScope.of(context).unfocus();
//                        DateUtilities()
//                            .pickTimeDialog(context)
//                            .then((pickTime) {
//                          selectedDate = pickTime.toString();
//                          _timeController.text = pickTime.toString();
////                      _dateController.text = selectedDate.toIso8601String();
//                        });
                        openTimeSlotDialog(context, _tagStateKey);
                      },
                      child: AbsorbPointer(
                        child: CommonTextfield(
                          autoFocus: false,
                          textOption: TextFieldOption(
                            hintText: R.string().commonString.selected,
                            maxLine: 1,
                            inputController: _timeController,
                            //isSecureTextField: false
                          ),
                          textCallback: (text) {},
                          validation: (text) {
                            if (text.isEmpty) {
                              return "Please select time.";
                            }
                          },
                          inputAction: TextInputAction.next,
                          onNextPress: () {},
                        ),
                      ),
                    ),
                  ),
                  getFieldTitleText("Room No"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: "Enter Room No.",
                        maxLine: 1,
                        inputController: _roomNoController,
                        formatter: [
                          WhitelistingTextInputFormatter(
                              new RegExp(alphaRegEx)),
                          BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
                        ],
                        //isSecureTextField: false
                      ),
                      textCallback: (text) {},
                      inputAction: TextInputAction.next,
                      onNextPress: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  getFieldTitleText("Salesman*"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        hintText: "Enter Salesman",
                        maxLine: 1,
                        inputController: _timeController,
                        //isSecureTextField: false
                      ),
                      textCallback: (text) {},
                      validation: (text) {
                        if (text.isEmpty) {
                          return "Please select time.";
                        }
                      },
                      inputAction: TextInputAction.next,
                      onNextPress: () {},
                    ),
                  ),
                  getFieldTitleText(R.string().screenTitle.comment),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: CommonTextfield(
                      autoFocus: false,
                      textOption: TextFieldOption(
                        inputController: _commentController,
                        hintText: "Enter Comments",
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
                    padding: EdgeInsets.symmetric(
                        horizontal: getSize(20), vertical: getSize(16)),
                    child: AppButton.flat(
                      onTap: () {
                        // NavigationUtilities.pushRoute(TabBarDemo.route);
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        } else {
                          setsetter(() {
                            autovalid = true;
                          });
                        }
                        // NavigationUtilities.push(ThemeSetting());
                      },
                      borderRadius: getSize(5),
                      fitWidth: true,
                      text: R.string().commonString.btnSubmit.toUpperCase(),
                      //isButtonEnabled: enableDisableSigninButton(),
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

openTimeSlotDialog(BuildContext context, Key key) {
  List<BottomTabModel> arrTimeSlot = BottomTabBar.getTimeSlotList();
  return showDialog(
    context: context,
    child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getSize(5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(getSize(15)),
        child: Tags(
          key: key,
          itemCount: arrTimeSlot.length,
          itemBuilder: (int index) {
            final item = arrTimeSlot[index];
            return ItemTags(
              index: index,
              title: item.title,
              borderRadius: BorderRadius.circular(getSize(10)),
              color: appTheme.colorPrimary.withOpacity(0.5),
              activeColor:  appTheme.colorPrimary.withOpacity(0.5),
              singleItem: true,
              onPressed: (item){
              },
            );
          },
        ),
      ),
    ),
  );
}