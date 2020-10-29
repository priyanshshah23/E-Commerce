import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
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
  bool autovalid = false;
  int moduleType;
  int actionType;
  List<DiamondModel> diamondList;

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
        child: Column(
          children: <Widget>[
            DiamondListHeader(
              diamondCalculation: diamondCalculation,
            ),
            SizedBox(
              height: getSize(20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: diamondList.length,
                itemBuilder: (BuildContext context, int index) {
                  return DiamondItemWidget(
                      item: diamondList[index], actionClick: (manageClick) {});
                },
              ),
            ),
            getOfferDetail()
          ],
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
                    if (_formKey.currentState.validate()) {
                      diamondConfig.actionAll(context, diamondList, actionType,
                          remark: _commentController.text);
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
                            BlacklistingTextInputFormatter(
                                RegExp(RegexForEmoji))
                          ],
                          //isSecureTextField: false
                        ),
                        validation: (text) {
                          if (text.isEmpty) {
                            return R
                                .string()
                                .errorString
                                .pleaseEnterCompanyName;
                          }
                        },
                        textCallback: (text) {},
                        inputAction: TextInputAction.next,
                        onNextPress: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    getCommentTextField(),
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
                  ],
                ),
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
