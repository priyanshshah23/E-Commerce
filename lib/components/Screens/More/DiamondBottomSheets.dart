import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/modules/Filter/gridviewlist/selectable_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';

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
                        FocusScope.of(context).unfocus();
//                        DateUtilities()
//                            .pickTimeDialog(context)
//                            .then((pickTime) {
//                          selectedDate = pickTime.toString();
//                          _timeController.text = pickTime.toString();
////                      _dateController.text = selectedDate.toIso8601String();
//                        });
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
                  getFieldTitleText(R.string().authStrings.companyName + "*"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        DateUtilities()
                            .pickTimeDialog(context)
                            .then((pickTime) {
                          selectedDate = pickTime.toString();
                          _timeController.text = pickTime.toString();
//                      _dateController.text = selectedDate.toIso8601String();
                        });
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
                    padding: EdgeInsets.symmetric(horizontal: getSize(20),vertical: getSize(16)),
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

openTimeSlotDialog(){
  return Tags(
//    key: _tagStateKey,
  );
}
