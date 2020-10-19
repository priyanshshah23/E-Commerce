import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
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
          ActionClick actionClick = (manageClick) {
            setSetter(() {});
          };
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
                      R.string().screenTitle.note,
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
                                    type: clickConstant.CLICK_TYPE_CONFIRM));
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
