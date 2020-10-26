import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/Dashboard/DashboardModel.dart';
import 'package:diamnow/models/Dashbord/DashBoardConfigModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulScreenWidget {
  static const route = "Dashboard";

  String filterId = "";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_HOME;
  bool isFromDrawer = false;

  Dashboard(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _DashboardState createState() => _DashboardState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _DashboardState extends StatefulScreenWidgetState {
  int moduleType;
  bool isFromDrawer;
  DiamondConfig diamondConfig;
  DashboardConfig dashboardConfig;

  final TextEditingController _searchController = TextEditingController();
  var _focusSearch = FocusNode();

  DashboardModel dashboardModel;
  _DashboardState({this.moduleType, this.isFromDrawer});

  @override
  void initState() {
    super.initState();

    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems();

    dashboardConfig = DashboardConfig();
    dashboardConfig.initItems();

    callApiForDashboard();
    setState(() {
      //
    });
  }

  callApiForDashboard() {
    Map<String, dynamic> dict = {};

    dict["savedSearch"] = true;
    dict["recentSearch"] = true;
    dict["recentActivity"] = true;
    dict["track"] = true;
    dict["dashboardCount"] = true;
    dict["seller"] = true;
    dict["account"] = true;
    dict["featuredStone"] = true;

    NetworkCall<DashboardResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().dashboard(dict),
            context,
            isProgress: true)
        .then((resp) async {
      print(resp);
      this.dashboardModel = resp.data;
      setState(() {});
    }).catchError((onError) {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: R.string().commonString.error,
            desc: onError.message,
            positiveBtnTitle: R.string().commonString.btnTryAgain,
          );
    });
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    diamondConfig.toolbarList.forEach((element) {
      list.add(GestureDetector(
        onTap: () {
          manageToolbarClick(element);
        },
        child: (element.code == BottomCodeConstant.TBProfile)
            ? Container(
                child: Padding(
                  padding: EdgeInsets.all(getSize(8.0)),
                  child: Center(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(getSize(15))),
                      child: getImageView(
                        "",
                        placeHolderImage: element.image,
                        height: getSize(30),
                        width: getSize(30),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            : (element.code == BottomCodeConstant.TBNotification)
                ? Padding(
                    padding: EdgeInsets.all(getSize(8.0)),
                    child: Center(
                      child: Stack(
                        children: [
                          Image.asset(
                            element.image,
                            height: getSize(24),
                            width: getSize(24),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: getSize(14.0), top: getSize(0.0)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(getSize(5)),
                                border: Border.all(
                                    color: appTheme.whiteColor,
                                    width: getSize(2)),
                              ),
                              height: getSize(10),
                              width: getSize(10),
                            ),
                          ),
                        ],
                      ),
                    ))
                : Padding(
                    padding: EdgeInsets.all(getSize(8.0)),
                    child: Image.asset(
                      element.image,
                      height: getSize(20),
                      width: getSize(20),
                    ),
                  ),
      ));
    });
    return list;
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBNotification:
// go to notification
        break;
      case BottomCodeConstant.TBProfile:
        // Go to Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: appTheme.whiteColor,
          appBar: getAppBar(
            context,
            diamondConfig.getScreenTitle(),
            bgColor: appTheme.whiteColor,
            leadingButton: isFromDrawer
                ? getDrawerButton(context, true)
                : getBackButton(context),
            centerTitle: false,
            actionItems: getToolbarItem(),
          ),
          // bottomNavigationBar: getBottomTab(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                // left: getSize(20),
                // right: getSize(20),
                top: getSize(20),
              ),
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  getSarchTextField(),
                  if (dashboardConfig.arrTopSection.length > 0) getTopSection(),
                  getFeaturedSection(),
                  getStoneOfDaySection(),
                  getSavedSearchSection(),
                  // getRecentSection(),
                  getSalesSection(),
                  SizedBox(
                    height: getSize(20),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  getSarchTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: Container(
        height: getSize(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(5)),
          border: Border.all(color: appTheme.colorPrimary, width: getSize(1)),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical(y: 1.0),
          textInputAction: TextInputAction.done,
          focusNode: _focusSearch,
          autofocus: false,
          controller: _searchController,
          obscureText: false,
          style: appTheme.black16TextStyle,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          cursorColor: appTheme.colorPrimary,
          inputFormatters: [
            WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
            BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
          ],
          decoration: InputDecoration(
            fillColor: fromHex("#FFEFEF"),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
              borderSide:
                  BorderSide(color: appTheme.dividerColor, width: getSize(1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
              borderSide:
                  BorderSide(color: appTheme.dividerColor, width: getSize(1)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
              borderSide:
                  BorderSide(color: appTheme.dividerColor, width: getSize(1)),
            ),

            hintStyle: appTheme.grey16HintTextStyle,
            hintText: "Search",
            labelStyle: TextStyle(
              color: appTheme.textColor,
              fontSize: getFontSize(16),
            ),
            // suffix: widget.textOption.postfixWidOnFocus,
            suffixIcon: Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: Image.asset(search)),
          ),
          // onFieldSubmitted: (String text) {
          //   //
          // },
          onChanged: (String text) {
            //
          },
          onEditingComplete: () {
            //
            _focusSearch.unfocus();
          },
        ),
      ),
    );
  }

  getTopSection() {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(30),
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: Column(
        children: [
          Material(
            elevation: 10,
            shadowColor: appTheme.shadowColorWithoutOpacity.withOpacity(0.3),
            borderRadius: BorderRadius.circular(getSize(5)),
            child: Container(
              // height: getSize(200),
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(getSize(5)),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  getSize(10),
                ),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.0,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(dashboardConfig.arrTopSection.length,
                      (index) {
                    // var item = arraDiamond[index];
                    return getTopSectionGridItem(
                        dashboardConfig.arrTopSection[index]);
                  }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: getSize(20),
          ),
        ],
      ),
    );
  }

  getTopSectionGridItem(DashbordTopSection model) {
    return InkWell(
      onTap: () {
        //
      },
      child: Container(
        decoration: BoxDecoration(
          color: model.bgColor,
          borderRadius: BorderRadius.circular(getSize(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Stack(
                children: [
                  Image.asset(model.bgImage, width: getSize(76)),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: getSize(14),
                        bottom: getSize(10),
                      ),
                      child: Image.asset(
                        model.image,
                        width: getSize(30),
                        height: getSize(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      model.value,
                      style: appTheme.blackNormal18TitleColorblack.copyWith(
                        color: model.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      model.title,
                      style: appTheme.blackNormal12TitleColorblack.copyWith(
                        color: model.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFeaturedSection() {
    List<DiamondModel> arrStones = [];
    if (!isNullEmptyOrFalse(this.dashboardModel)) {
      if (!isNullEmptyOrFalse(this.dashboardModel.featuredStone)) {
        List<FeaturedStone> filter = this
            .dashboardModel
            .featuredStone
            .where((element) => element.type == DashboardConstants.best)
            .toList();

        if (!isNullEmptyOrFalse(filter)) {
          arrStones = filter.first.featuredPair;
        }
      }
    }

    return isNullEmptyOrFalse(arrStones)
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(
              top: getSize(20),
              left: getSize(Spacing.leftPadding),
              right: getSize(Spacing.rightPadding),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    getTitleText(R.string().screenTitle.featuredStones),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        //
                      },
                      child: getViewAll(),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSize(20),
                ),
                Container(
                  height: getSize(200),
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 0.36, // without Price
                    // childAspectRatio: 0.327, // with Price
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(arrStones.length, (index) {
                      // var item = arraDiamond[index];
                      return getRecentItem(arrStones[index]);
                    }),
                  ),
                )
              ],
            ),
          );
  }

  getStoneOfDaySection() {
    List<DiamondModel> arrStones = [];
    if (!isNullEmptyOrFalse(this.dashboardModel)) {
      if (!isNullEmptyOrFalse(this.dashboardModel.featuredStone)) {
        List<FeaturedStone> filter = this
            .dashboardModel
            .featuredStone
            .where(
                (element) => element.type == DashboardConstants.stoneOfTheDay)
            .toList();

        if (!isNullEmptyOrFalse(filter)) {
          arrStones = filter.first.featuredPair;
        }
      }
    }

    return isNullEmptyOrFalse(arrStones)
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(
              top: getSize(20),
              left: getSize(Spacing.leftPadding),
              right: getSize(Spacing.rightPadding),
            ),
            child: Column(
              // mainAxisAlignment: mainaxisal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    getTitleText(R.string().screenTitle.stoneOfDay),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        //
                      },
                      child: getViewAll(),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSize(20),
                ),
                Container(
                  height: getSize(245),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return getStoneOfDayItem(arrStones[index]);
                    },
                    itemCount: arrStones.length,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
          );
  }

  getStoneOfDayItem(DiamondModel model) {
    return Container(
      height: getSize(225),
      padding: EdgeInsets.only(
        right: getSize(20),
      ),
      width: MathUtilities.screenWidth(context) / 2,
      child: Column(
        children: [
          Container(
            height: getSize(152),
            child: Stack(
              children: [
                //
                Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: getSize(51),
                    ),
                    Material(
                      elevation: 10,
                      shadowColor: appTheme.shadowColor,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(getSize(5)),
                          border: Border.all(color: appTheme.lightBGColor),
                        ),
                        // color: Colors.red,
                        height: getSize(101),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    elevation: 10,
                    shadowColor: appTheme.shadowColor,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(getSize(66)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: appTheme.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      // color: appTheme.colorPrimary,
                      height: getSize(132),
                      width: getSize(132),
                      child: Padding(
                        padding: EdgeInsets.all(getSize(10)),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(getSize(61))),
                          child: getImageView(
                            "",
                            width: getSize(122),
                            height: getSize(122),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Material(
            elevation: 10,
            shadowColor: appTheme.shadowColor,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(getSize(5)),
            child: Container(
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(color: appTheme.lightBGColor),
                // boxShadow: getBoxShadow(context),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: appTheme.lightBGColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)),
                      ),
                      width: getSize(62),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: getSize(8),
                          left: getSize(5),
                          right: getSize(5),
                          bottom: getSize(8),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${model.crt ?? ""}",
                                  style: appTheme.blue14TextStyle.copyWith(
                                    color: appTheme.colorPrimary,
                                    fontSize: getFontSize(12),
                                  ),
                                ),
                                Text(
                                  "Carat",
                                  style: appTheme.blue14TextStyle.copyWith(
                                    color: appTheme.colorPrimary,
                                    fontSize: getFontSize(10),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: getSize(5)),
                                  // width: getSize(55),
                                  // height: getSize(19),
                                  decoration: BoxDecoration(
                                      color: appTheme.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(getSize(5))),
                                  child: Padding(
                                    padding: EdgeInsets.all(getSize(2)),
                                    child: Text(
                                      PriceUtilities.getPercent(
                                          model.getFinalDiscount()),
                                      style: appTheme.green10TextStyle
                                          .copyWith(fontSize: getFontSize(9)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getSize(10),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: getSize(4),
                          ),
                          Row(
                            children: [
                              getText(model.stoneId ?? ""),
                              // Expanded(child: Container()),
                              Spacer(),
                              getText(
                                model.shpNm ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getSize(6),
                          ),
                          Row(
                            children: [
                              getText(
                                model.colNm ?? "",
                              ),
                              Spacer(),
                              getText(
                                model.clrNm ?? "",
                              ),
                              Spacer(),
                              getText(
                                model.lbNm ?? "",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getSize(6),
                          ),
                          Row(
                            children: <Widget>[
                              getText(
                                model.cutNm ?? "-",
                              ),
                              Spacer(),
                              getDot(),
                              Spacer(),
                              getText(
                                model.polNm ?? "-",
                              ),
                              Spacer(),
                              getDot(),
                              Spacer(),
                              getText(
                                model.symNm ?? "-",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getSize(8),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getSize(10),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getStoneOfDayItemWithPrice() {
    return Container(
      height: getSize(225),
      padding: EdgeInsets.only(
        right: getSize(20),
      ),
      width: MathUtilities.screenWidth(context) / 1.8,
      child: Column(
        children: [
          Container(
            height: getSize(152),
            child: Stack(
              children: [
                //
                Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: getSize(51),
                    ),
                    Material(
                      elevation: 10,
                      shadowColor: appTheme.shadowColor,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(getSize(5)),
                          border: Border.all(color: appTheme.lightBGColor),
                        ),
                        // color: Colors.red,
                        height: getSize(101),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    elevation: 10,
                    shadowColor: appTheme.shadowColor,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(getSize(66)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: appTheme.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      // color: appTheme.colorPrimary,
                      height: getSize(132),
                      width: getSize(132),
                      child: Padding(
                        padding: EdgeInsets.all(getSize(10)),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(getSize(61))),
                          child: getImageView(
                            "",
                            width: getSize(122),
                            height: getSize(122),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Material(
            elevation: 10,
            shadowColor: appTheme.shadowColor,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(getSize(5)),
            child: Container(
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(getSize(5)),
                border: Border.all(color: appTheme.lightBGColor),
                // boxShadow: getBoxShadow(context),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: appTheme.lightBGColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                    ),
                    width: getSize(62),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: getSize(8),
                        left: getSize(5),
                        right: getSize(5),
                        bottom: getSize(10),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            //
                          },
                          child: Column(
                            children: [
                              Text(
                                "12.50 \n Carat ",
                                style: appTheme.blue14TextStyle.copyWith(
                                  color: appTheme.colorPrimary,
                                  fontSize: getFontSize(12),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: getSize(5)),
                                // width: getSize(55),
                                // height: getSize(19),
                                decoration: BoxDecoration(
                                    color: appTheme.whiteColor,
                                    borderRadius:
                                        BorderRadius.circular(getSize(5))),
                                child: Padding(
                                  padding: EdgeInsets.all(getSize(2)),
                                  child: Text(
                                    "-44.33 %",
                                    style: appTheme.green10TextStyle
                                        .copyWith(fontSize: getFontSize(9)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(10),
                  ),
                  Expanded(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: getSize(4),
                        ),
                        Row(
                          children: [
                            getText("191071"),
                            Spacer(),
                            getAmountText("13,992.50/Cts"),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: [
                            getText(
                              "Round",
                              fontWeight: FontWeight.w500,
                            ),
                            Spacer(),
                            getAmountText("13,992.50/Amt"),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: <Widget>[
                            getText("D"),
                            Spacer(),
                            getText("IF"),
                            Spacer(),
                            getText("EX"),
                            getDot(),
                            getText("EX"),
                            getDot(),
                            getText("EX"),
                            Spacer(),
                            getText("GIA"),
                          ],
                        ),
                        SizedBox(
                          height: getSize(8),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getSize(10),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getSavedSearchSection() {
    if (isNullEmptyOrFalse(this.dashboardModel)) {
      return SizedBox();
    }

    if (isNullEmptyOrFalse(this.dashboardModel.savedSearch)) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(top: getSize(20)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getSize(Spacing.leftPadding),
              right: getSize(Spacing.rightPadding),
            ),
            child: Row(
              children: [
                getTitleText(R.string().screenTitle.savedSearch),
                Spacer(),
                InkWell(
                  onTap: () {
                    //
                  },
                  child: getViewAll(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getSize(20),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: this.dashboardModel.savedSearch.length,
              itemBuilder: (context, index) {
                return getSavedSearchItem(
                    this.dashboardModel.savedSearch[index]);
              }),
        ],
      ),
    );
  }

  getSavedSearchItem(SavedSearchModel model) {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        child: Column(
          children: [
            Material(
              elevation: 10,
              shadowColor: appTheme.shadowColor,
              borderRadius: BorderRadius.circular(getSize(5)),
              child: Container(
                decoration: BoxDecoration(
                  color: appTheme.whiteColor,
                  borderRadius: BorderRadius.circular(getSize(5)),
                  border: Border.all(
                    color: appTheme.lightBGColor,
                  ),
                  // boxShadow: getBoxShadow(context),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      getSize(20), getSize(16), getSize(20), getSize(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        home_clock,
                        width: getSize(30),
                        height: getSize(30),
                      ),
                      SizedBox(
                        width: getSize(16),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.name ?? "-",
                              style: appTheme.black16TextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: getSize(2),
                            ),
                            Text(
                              DateUtilities()
                                  .convertServerDateToFormatterString(
                                      model.createdAt,
                                      formatter:
                                          DateUtilities.dd_mmm_yy_h_mm_a),
                              style: appTheme.black14TextStyle.copyWith(
                                color: appTheme.textGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getSize(20),
            ),
          ],
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            onTap: () {
              SyncManager.instance.callApiForDeleteSavedSearch(
                  context, model.id, success: (resp) {
                this
                    .dashboardModel
                    .savedSearch
                    .removeWhere((element) => element.id == model.id);
                setState(() {});
              });
            },
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: fromHex("#FFE7E7"),
                      border: Border.all(color: fromHex("#FF4D4D")),
                      shape: BoxShape.circle,
                    ),
                    height: getSize(40),
                    width: getSize(40),
                    child: Padding(
                      padding: EdgeInsets.all(getSize(10)),
                      child: Image.asset(
                        home_delete,
                        // height: getSize(20),
                        // width: getSize(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getSize(20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getRecentSection() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
        top: getSize(20),
      ),
      child: Column(
        // mainAxisAlignment: mainaxisal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTitleText(R.string().screenTitle.recentSearch),
          SizedBox(
            height: getSize(20),
          ),
          Container(
            height: getSize(90),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // for (var i = 0; i < 5; i++) getRecentItem(),
              ],
            ),
          )
        ],
      ),
    );
  }

  getRecentItem(DiamondModel model) {
    return Padding(
      padding: EdgeInsets.only(
        // right: getSize(20),
        bottom: getSize(20),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: appTheme.shadowColor,
        // borderRadius: BorderRadius.circular(getSize(5)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getSize(5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  // width: getSize(122),
                  // width: MathUtilities.screenWidth(context) / 2,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            color: appTheme.lightBGColor,
                            // width: getSize(30),
                            child: SizedBox(
                              width: getSize(30),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 10,
                            shadowColor: appTheme.shadowColor,
                            child: Container(
                                // width: getSize(92),
                                width: MathUtilities.screenWidth(context) / 4.6,
                                decoration: BoxDecoration(
                                  color: appTheme.lightBGColor,
                                  borderRadius:
                                      BorderRadius.circular(getSize(5)),
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: getSize(10),
                                      right: getSize(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${model.crt} \n Carat",
                                          style: appTheme.black14TextStyle
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: appTheme.colorPrimary,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: getSize(5)),
                                          // width: getSize(55),
                                          // height: getSize(19),
                                          decoration: BoxDecoration(
                                              color: appTheme.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      getSize(5))),
                                          child: Padding(
                                            padding: EdgeInsets.all(getSize(2)),
                                            child: Text(
                                              PriceUtilities.getPercent(
                                                  model.getFinalDiscount()),
                                              style: appTheme.green10TextStyle
                                                  .copyWith(
                                                      fontSize: getFontSize(9)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          elevation: 10,
                          shadowColor: appTheme.shadowColor,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(getSize(30)),
                          child: Container(
                            width: getSize(60),
                            height: getSize(60),
                            decoration: BoxDecoration(
                              color: appTheme.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(getSize(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(getSize(20))),
                                child: getImageView(
                                  "",
                                  width: getSize(40),
                                  height: getSize(40),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                elevation: 10,
                shadowColor: appTheme.shadowColor,
                borderRadius: BorderRadius.circular(getSize(5)),
                child: Container(
                  // width: getSize(111),
                  width: MathUtilities.screenWidth(context) / 3,
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    borderRadius: BorderRadius.circular(getSize(5)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getSize(10),
                      right: getSize(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            getText(model.stoneId ?? ""),
                            Spacer(),
                            getText(
                              model.shpNm ?? "",
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: [
                            getText(model.colNm ?? "-"),
                            Spacer(),
                            getText(model.clrNm ?? "-"),
                            Spacer(),
                            getText(model.lbNm ?? "-"),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: [
                            getText(model.cutNm ?? "-"),
                            Spacer(),
                            getDot(),
                            Spacer(),
                            getText(model.polNm ?? "-"),
                            Spacer(),
                            getDot(),
                            Spacer(),
                            getText(model.symNm ?? "-"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getRecentItemWithPrice() {
    return Padding(
      padding: EdgeInsets.only(
        right: getSize(20),
        bottom: getSize(20),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: appTheme.shadowColor,
        // borderRadius: BorderRadius.circular(getSize(5)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getSize(5)),
          ),
          child: Row(
            children: [
              Container(
                width: getSize(122),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Container(
                          color: appTheme.lightBGColor,
                          width: getSize(30),
                          child: SizedBox(
                            width: getSize(30),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          elevation: 10,
                          shadowColor: appTheme.shadowColor,
                          child: Container(
                              width: getSize(92),
                              decoration: BoxDecoration(
                                color: appTheme.lightBGColor,
                                borderRadius: BorderRadius.circular(getSize(5)),
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: getSize(10),
                                    right: getSize(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "12.50 \n Carat",
                                        style:
                                            appTheme.black14TextStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: appTheme.colorPrimary,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: getSize(5)),
                                        // width: getSize(55),
                                        // height: getSize(19),
                                        decoration: BoxDecoration(
                                            color: appTheme.whiteColor,
                                            borderRadius: BorderRadius.circular(
                                                getSize(5))),
                                        child: Padding(
                                          padding: EdgeInsets.all(getSize(2)),
                                          child: Text(
                                            "-44.33 %",
                                            style: appTheme.green10TextStyle
                                                .copyWith(
                                                    fontSize: getFontSize(9)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        elevation: 10,
                        shadowColor: appTheme.shadowColor,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(getSize(30)),
                        child: Container(
                          width: getSize(60),
                          height: getSize(60),
                          decoration: BoxDecoration(
                            color: appTheme.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(getSize(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(getSize(20))),
                              child: getImageView(
                                "",
                                width: getSize(40),
                                height: getSize(40),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                elevation: 10,
                shadowColor: appTheme.shadowColor,
                borderRadius: BorderRadius.circular(getSize(5)),
                child: Container(
                  // width: getSize(111),
                  width: MathUtilities.screenWidth(context) / 2.8,
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    borderRadius: BorderRadius.circular(getSize(5)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getSize(10),
                      right: getSize(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            getText("191071"),
                            Spacer(),
                            getAmountText("13,992.50/Cts"),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: [
                            getText(
                              "Round",
                              fontWeight: FontWeight.w500,
                            ),
                            Spacer(),
                            getAmountText("13,992.50/Amt"),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: [
                            getText("D"),
                            Spacer(),
                            getText("IF"),
                            Spacer(),
                            getText("EX"),
                            getDot(),
                            getText("EX"),
                            getDot(),
                            getText("EX"),
                            Spacer(),
                            getText("GIA"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getSalesSection() {
    if (isNullEmptyOrFalse(this.dashboardModel)) {
      return SizedBox();
    }
    if (isNullEmptyOrFalse(this.dashboardModel.seller)) {
      return SizedBox();
    }

    return Padding(
      // padding: EdgeInsets.only(top: getSize(20)),
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
        top: getSize(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTitleText(R.string().screenTitle.salesPersonDetail),
          SizedBox(
            height: getSize(20),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: getSize(0),
              right: getSize(0),
            ),
            child: Material(
              elevation: 10,
              shadowColor: appTheme.shadowColor,
              borderRadius: BorderRadius.circular(getSize(5)),
              child: Container(
                decoration: BoxDecoration(
                  color: appTheme.whiteColor,
                  borderRadius: BorderRadius.circular(getSize(5)),
                  border: Border.all(
                    color: appTheme.lightBGColor,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    getSize(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this.dashboardModel.seller.firstName +
                            " " +
                            this.dashboardModel.seller.lastName,
                        style: appTheme.black16TextStyle.copyWith(
                          color: appTheme.colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: getSize(10),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            email,
                            width: getSize(16),
                            height: getSize(16),
                          ),
                          SizedBox(
                            width: getSize(10),
                          ),
                          Text(
                            this.dashboardModel.seller.email ?? "-",
                            style: appTheme.blackNormal14TitleColorblack,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getSize(10),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            phone,
                            width: getSize(16),
                            height: getSize(16),
                          ),
                          SizedBox(
                            width: getSize(10),
                          ),
                          Text(
                            this.dashboardModel.seller.whatsapp ?? "-",
                            style: appTheme.blackNormal14TitleColorblack,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getTitleText(String title) {
    return Text(
      title,
      style: appTheme.blackNormal18TitleColorblack.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  getViewAll() {
    return Text(
      R.string().screenTitle.viewAll,
      style: appTheme.black14TextStyle.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.colorPrimary,
      ),
    );
  }

  getText(String text, {FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: appTheme.black12TextStyle.copyWith(
        fontSize: getFontSize(12),
        fontWeight: fontWeight,
      ),
    );
  }

  getAmountText(String text) {
    return Text(
      text,
      style: appTheme.black12TextStyle.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.colorPrimary,
      ),
    );
  }

  getDot() {
    return Padding(
      padding: EdgeInsets.only(left: getSize(4), right: getSize(4)),
      child: Container(
        height: getSize(4),
        width: getSize(4),
        decoration:
            BoxDecoration(color: appTheme.dividerColor, shape: BoxShape.circle),
      ),
    );
  }
}
