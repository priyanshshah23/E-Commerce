import 'dart:collection';
import 'dart:io';

import 'package:diamnow/app/Helper/LocalNotification.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
import 'package:diamnow/components/Screens/Auth/Widget/MyAccountScreen.dart';
import 'package:diamnow/components/Screens/DashBoard/Widget/FeaturedStone.dart';
import 'package:diamnow/components/Screens/DashBoard/Widget/RecentSearch.dart';
import 'package:diamnow/components/Screens/DashBoard/Widget/StonesOfDay.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Notification/Notifications.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/components/Screens/Search/Search.dart';
import 'package:diamnow/components/Screens/VoiceSearch/VoiceSearch.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/AnalyticsModel/AnalyticsModel.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  bool isLoading = true;
  DiamondConfig diamondConfig;
  DashboardConfig dashboardConfig;
  String emailURL;
  AnalyticsReq req = new AnalyticsReq();

  final TextEditingController _searchController = TextEditingController();
  var _focusSearch = FocusNode();

  DashboardModel dashboardModel;
  AdminDashboardModel admindashboardModel;

  _DashboardState({this.moduleType, this.isFromDrawer});

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final searchKey = new GlobalKey();
  final savedSearchKey = new GlobalKey();
  final sellerKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems();

    dashboardConfig = DashboardConfig();
    dashboardConfig.initItems();
    this.dashboardModel = app.resolve<PrefUtils>().getDashboardDetails();

    callApiForDashboard(false);
    // setState(() {
    //   //
    // });
  }

  callApiForDashboard(bool isRefress, {bool isLoading = false}) {
    Map<String, dynamic> dict = {};

    dict["savedSearch"] = true;
    dict["recentSearch"] = true;
    dict["recentActivity"] = true;
    dict["track"] = true;
    dict["dashboardCount"] = true;
    dict["seller"] = true;
    dict["account"] = true;
    dict["featuredStone"] = true;
    dict["newArrival"] = true;
    dict["banners"] = true;
    print(dict);
    NetworkCall<DashboardResp>()
        .makeCall(
            () => app.resolve<ServiceModule>().networkService().dashboard(dict),
            context,
            isProgress: false)
        // !isRefress && !isLoading
        .then((resp) async {
      setState(() {
        this.dashboardModel = resp.data;

        if (!isNullEmptyOrFalse(this.dashboardModel.seller)) {
          emailURL = this.dashboardModel.seller.email;
        }
        setTopCountData();
      });
      await app
          .resolve<PrefUtils>()
          .saveDashboardDetails(resp.data)
          .then((value) => {});
    }).catchError((onError) {
      if (onError is ErrorResp) {
        app.resolve<CustomDialogs>().confirmDialog(
              context,
              desc: onError.message,
              positiveBtnTitle: R.string.commonString.btnTryAgain,
            );
      }
    });
  }

  setTopCountData() {
    for (var item in dashboardConfig.arrTopSection) {
      if (item.type == DiamondModuleConstant.MODULE_TYPE_MY_CART) {
        item.value =
            "${this.dashboardModel.tracks[DiamondTrackConstant.TRACK_TYPE_CART.toString()].pieces}";
      } else if (item.type == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST) {
        item.value =
            "${this.dashboardModel.tracks[DiamondTrackConstant.TRACK_TYPE_WATCH_LIST.toString()].pieces}";
      } else if (item.type == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL) {
        if (!isNullEmptyOrFalse(this.dashboardModel)) {
          if (!isNullEmptyOrFalse(this.dashboardModel.newArrival)) {
            item.value = this.dashboardModel.newArrival.length.toString();
          }
        }
      } else if (item.type ==
          DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY) {
        //TRACK_TYPE_BEST_BUY
        item.value =
            "${this.dashboardModel.tracks[DiamondTrackConstant.TRACK_TYPE_BEST_BUY.toString()].pieces}";
        // if (!isNullEmptyOrFalse(this.dashboardModel)) {
        //   if (!isNullEmptyOrFalse(this.dashboardModel.featuredStone)) {
        //     item.value = this.dashboardModel.featuredStone.length.toString();
        //   }
        // }
      }
    }
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    diamondConfig.toolbarList.forEach((element) {
      list.add(GestureDetector(
        onTap: () {
          manageToolbarClick(element);
        },
        child: (element.code == BottomCodeConstant.TBProfile)
            ? Padding(
                padding: EdgeInsets.only(
                    left: getSize(8.0), right: getSize(Spacing.rightPadding)),
                child: Container(
                  width: getSize(30),
                  height: getSize(30),
                  margin:
                      EdgeInsets.only(top: getSize(16), bottom: getSize(16)),
                  child: Center(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(getSize(15))),
                      child: getImageView(
                        app.resolve<PrefUtils>().getUserDetails().profileImage,
                        placeHolderImage: placeHolder,
                        height: getSize(30),
                        width: getSize(30),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              )
            : (element.code == BottomCodeConstant.TBNotification)
                ? InkWell(
                    onTap: () {
                      NavigationUtilities.pushRoute(
                        Notifications.route,
                      );
                      AnalyticsReport.shared.sendAnalyticsData(
                        buildContext: context,
                        action: ActionAnalytics.CLICK,
                        page: PageAnalytics.NOTIFICATION,
                        section: SectionAnalytics.VIEW,
                      );
                    },
                    child: Padding(
                        padding: EdgeInsets.all(getSize(8.0)),
                        child: Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                element.image,
                                height: getSize(24),
                                width: getSize(24),
                                color: appTheme.whiteColor,
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
                        )),
                  )
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
        openProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(this.dashboardModel.banners.length);
    //getHomeSliderImage(HOME_CENTRE);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: appTheme.whiteColor,
            appBar: getAppBar(
              context,
              diamondConfig.getScreenTitle(),
              bgColor: appTheme.colorPrimary,
              leadingButton: isFromDrawer
                  ? getDrawerButton(context, false)
                  : getBackButton(context),
              centerTitle: false,
              actionItems: getToolbarItem(),
              isWhite: true,
            ),
            // bottomNavigationBar: getBottomTab(),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  // left: getSize(20),
                  // right: getSize(20),
                  top: getSize(0),
                ),
                child: SmartRefresher(
                  header: MaterialClassicHeader(
                      backgroundColor: AppTheme.of(context).accentColor,
                      color: AppTheme.of(context).theme.primaryColorLight),
                  enablePullDown: true,
                  onRefresh: () {
                    callApiForDashboard(true);
                    refreshController.refreshCompleted();
                    refreshController.loadComplete();
                  },
                  controller: refreshController,
                  child: (this.dashboardModel != null)
                      ? ListView(
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            //if (dashboardConfig.arrTopSection.length > 0)
                            // getTopSection(),
                            getSarchTextField(),
                            //getFeaturedSection(),
                            //getStoneOfDaySection(),
                            buildTopSection(HOME_TOP_CENTRE),
                            getHomeSliderImage(HOME_CENTRE),
                            buildTopSection(HOME_BOTTOM_CENTRE),
                            getSavedSearchSection(),
                            //getRecentSection(),
                            getSalesSection(),
                            SizedBox(
                              height: getSize(20),
                            ),
                          ],
                        )
                      : Center(
                          child: SpinKitFadingCircle(
                            color: appTheme.colorPrimary,
                            size: getSize(30),
                          ),
                        ),
                ),
              ),
            ),
          ),
          showTour(),
        ],
      ),
    );
  }

  checkTourIsShown() {
    return (app.resolve<PrefUtils>().isDisplayedTour(PrefUtils().keyHomeTour) ==
            false &&
        isNullEmptyOrFalse(this.dashboardModel) == false);
  }

  showTour() {
    return (app.resolve<PrefUtils>().isDisplayedTour(PrefUtils().keyHomeTour) ==
                false &&
            isNullEmptyOrFalse(this.dashboardModel) == false)
        ? OverlayScreen(
            moduleType,
            finishTakeTour: () {
              setState(() {});
            },
            scrollIndex: (index) {
              if (index == 0 || index == 1) {
                Scrollable.ensureVisible(searchKey.currentContext);
              } else if (index == 2) {
                Scrollable.ensureVisible(savedSearchKey.currentContext);
              } else if (index == 3) {
                Scrollable.ensureVisible(sellerKey.currentContext);
              }
            },
          )
        : SizedBox();
  }

  getSarchTextField() {
    if (!(app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_searchDiamond)
        .view)) {
      return SizedBox();
    }
    return Container(
      color: appTheme.colorPrimary,
      child: Padding(
        padding: EdgeInsets.all(
          getSize(16),
        ),
        child: Row(
          key: checkTourIsShown() ? searchKey : null,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Hero(
                tag: 'searchTextField',
                child: Material(
                  color: appTheme.colorPrimary,
                  child: Container(
                    height: getSize(40),
                    decoration: BoxDecoration(
                      color: appTheme.colorPrimary,
                      borderRadius: BorderRadius.circular(getSize(5)),
                      border: Border.all(
                          color: appTheme.colorPrimary, width: getSize(1)),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical(y: 1.0),
                      textInputAction: TextInputAction.done,
                      focusNode: _focusSearch,
                      readOnly: true,
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(getSize(5))),
                          borderSide: BorderSide(
                              color: appTheme.dividerColor, width: getSize(1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(getSize(5))),
                          borderSide: BorderSide(
                              color: appTheme.dividerColor, width: getSize(1)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(getSize(5))),
                          borderSide: BorderSide(
                              color: appTheme.dividerColor, width: getSize(1)),
                        ),

                        hintStyle: appTheme.grey16HintTextStyle.copyWith(
                          color: appTheme.placeholderColor,
                        ),
                        hintText: "Round 1.0-1.19 D-H-VS",
                        labelStyle: TextStyle(
                          color: appTheme.textColor,
                          fontSize: getFontSize(16),
                        ),
                        // suffix: widget.textOption.postfixWidOnFocus,
                        suffixIcon: Padding(
                            padding: EdgeInsets.all(getSize(10)),
                            child: Image.asset(search,
                                color: appTheme.whiteColor)),
                      ),
                      onChanged: (String text) {
                        //
                      },
                      onEditingComplete: () {
                        //
                        _focusSearch.unfocus();
                      },
                      onTap: () {
                        Map<String, dynamic> dict = new HashMap();
                        dict["isFromSearch"] = false;
                        NavigationUtilities.pushRoute(SearchScreen.route,
                            args: dict);
                      },
                    ),
                  ),
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     NavigationUtilities.pushRoute(VoiceSearch.route);
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       left: getSize(Spacing.leftPadding),
            //     ),
            //     child: Image.asset(
            //       microphone,
            //       alignment: Alignment.centerRight,
            //       width: getSize(26),
            //       height: getSize(26),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  getTopSection() {
    return Padding(
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: Column(
        children: [
          getSarchTextField(),
          // Material(
          //   elevation: 10,
          //   shadowColor: appTheme.shadowColorWithoutOpacity.withOpacity(0.3),
          //   borderRadius: BorderRadius.circular(getSize(5)),
          //   child: Container(
          //     // height: getSize(200),
          //     decoration: BoxDecoration(
          //       color: appTheme.whiteColor,
          //       borderRadius: BorderRadius.circular(getSize(5)),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.all(
          //         getSize(10),
          //       ),
          //       child: GridView.count(
          //         physics: NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         crossAxisCount: 2,
          //         childAspectRatio: 2.0,
          //         mainAxisSpacing: 10,
          //         crossAxisSpacing: 10,
          //         children: List.generate(dashboardConfig.arrTopSection.length,
          //             (index) {
          //           return getTopSectionGridItem(
          //               dashboardConfig.arrTopSection[index]);
          //         }),
          //       ),
          //     ),
          //   ),
          // ),
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
        if (int.parse(model.value) > 0) {
          Map<String, dynamic> dict = new HashMap();
          dict[ArgumentConstant.ModuleType] = model.type;
          dict[ArgumentConstant.IsFromDrawer] = false;
          NavigationUtilities.pushRoute(
            DiamondListScreen.route,
            type: RouteType.fade,
            args: dict,
          );
        }
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
    if (app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_newGoods)
            .view &&
        !isNullEmptyOrFalse(this.dashboardModel)) {
      if (!isNullEmptyOrFalse(this.dashboardModel.newArrival)) {
        return FeaturedStoneWidget(
          diamondList: this.dashboardModel.newArrival,
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  getStoneOfDaySection() {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(
            ModulePermissionConstant.permission_stone_of_the_day)
        .view) {
      if (!isNullEmptyOrFalse(this.dashboardModel)) {
        if (!isNullEmptyOrFalse(this.dashboardModel.featuredStone)) {
          return StoneOfDayWidget(
            stoneList: this.dashboardModel.featuredStone,
          );
        } else {
          return SizedBox();
        }
      }

      return SizedBox();
    }

    return SizedBox();
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
                            finalUrl: true //model.img
                                ? DiamondUrls.image +
                                    model.mfgStnId +
                                    "/" +
                                    "still.jpg"
                                : "",
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
                          getStoneIdShape(model),
                          SizedBox(
                            height: getSize(6),
                          ),
                          getColorClarityLab(model),
                          SizedBox(
                            height: getSize(6),
                          ),
                          getCutPolSynData(model),
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

  getStoneOfDayItemWithPrice(DiamondModel model) {
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
                            finalUrl: DiamondUrls.image +
                                model.mfgStnId +
                                "/" +
                                "still.jpg",
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
                                "${model.crt} \n Carat ",
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
                      // mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: getSize(4),
                        ),
                        Row(
                          children: [
                            getText(model.stoneId ?? "-"),
                            Spacer(),
                            getAmountText(model.getPricePerCarat()),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: [
                            getText(
                              model.shpNm ?? "",
                              fontWeight: FontWeight.w500,
                            ),
                            Spacer(),
                            getAmountText(model.getAmount()),
                          ],
                        ),
                        SizedBox(
                          height: getSize(6),
                        ),
                        Row(
                          children: <Widget>[
                            getText(model.colNm ?? ""),
                            Spacer(),
                            getText(model.clrNm ?? ""),
                            Spacer(),
                            getText(model.cutNm ?? ""),
                            getDot(),
                            getText(model.polNm ?? ""),
                            getDot(),
                            getText(model.symNm ?? ""),
                            Spacer(),
                            getText(model.lbNm ?? ""),
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

  // getBannerSection() {
  //   if (isNullEmptyOrFalse(this.dashboardModel)) {
  //     return SizedBox();
  //   }
  //   if (isNullEmptyOrFalse(this.dashboardModel.banners)) {
  //     return SizedBox();
  //   }
  //   return Container(
  //     child: buildtopSection(this.dashboardModel.banners),
  //   );
  // }

  getSavedSearchSection() {
    if (isNullEmptyOrFalse(this.dashboardModel)) {
      return SizedBox();
    }

    if (isNullEmptyOrFalse(this.dashboardModel.savedSearch)) {
      return SizedBox();
    }
    if (!(app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_mySavedSearch)
        .view)) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(top: getSize(8)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getSize(Spacing.leftPadding),
              right: getSize(Spacing.rightPadding),
            ),
            child: Row(
              children: [
                Text(
                  R.string.screenTitle.savedSearch,
                  key: checkTourIsShown() ? savedSearchKey : null,
                  style: appTheme.blackNormal18TitleColorblack.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Map<String, dynamic> dict = new HashMap();
                    dict[ArgumentConstant.ModuleType] =
                        DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                    dict[ArgumentConstant.IsFromDrawer] = false;
                    NavigationUtilities.pushRoute(SavedSearchScreen.route,
                        args: dict);
                  },
                  child: getViewAll(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getSize(16),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: this.dashboardModel.savedSearch.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Map<String, dynamic> dict = new HashMap();
                    dict[ArgumentConstant.ModuleType] =
                        DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                    dict[ArgumentConstant.IsFromDrawer] = false;
                    dict["filterId"] = dashboardModel.savedSearch[index].id;
                    NavigationUtilities.pushRoute(DiamondListScreen.route,
                        args: dict);
                  },
                  child: getSavedSearchItem(
                      this.dashboardModel.savedSearch[index]),
                );
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
                      width: getSize(1), color: appTheme.borderColor),
                  // boxShadow: getBoxShadow(context),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      getSize(20), getSize(8), getSize(20), getSize(8)),
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
              app.resolve<CustomDialogs>().confirmDialog(context,
                  barrierDismissible: true,
                  title: "",
                  desc: R.string.commonString.deleteItem,
                  positiveBtnTitle: R.string.commonString.ok,
                  negativeBtnTitle: R.string.commonString.cancel,
                  onClickCallback: (buttonType) {
                if (buttonType == ButtonType.PositveButtonClick) {
                  SyncManager.instance.callApiForDeleteSavedSearch(
                      context, model.id, success: (resp) {
                    this
                        .dashboardModel
                        .savedSearch
                        .removeWhere((element) => element.id == model.id);
                    setState(() {});
                  });
                }
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
    if (isNullEmptyOrFalse(this.dashboardModel)) {
      return SizedBox();
    }

    if (isNullEmptyOrFalse(this.dashboardModel.recentSearch)) {
      return SizedBox();
    }
    if (!(app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_mySavedSearch)
        .view)) {
      return SizedBox();
    }
    return RecentSearchWidget(
      recentSearch: this.dashboardModel.recentSearch,
    );
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
          getTitleText(R.string.screenTitle.recentSearch),
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
                                  finalUrl: DiamondUrls.image +
                                      model.mfgStnId +
                                      "/" +
                                      "still.jpg",
                                  width: getSize(40),
                                  height: getSize(40),
                                  fit: BoxFit.fitWidth,
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
                        getStoneIdShape(model),
                        SizedBox(
                          height: getSize(6),
                        ),
                        getColorClarityLab(model),
                        SizedBox(
                          height: getSize(6),
                        ),
                        getCutPolSynData(model),
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
    if (isNullEmptyOrFalse(this.dashboardModel.seller.id)) {
      return SizedBox();
    }
    return Padding(
      // padding: EdgeInsets.only(top: getSize(20)),
      padding: EdgeInsets.only(
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
        top: getSize(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            R.string.screenTitle.salesPersonDetail,
            key: checkTourIsShown() ? sellerKey : null,
            style: appTheme.blackNormal18TitleColorblack.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: getSize(16),
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
                      width: getSize(1), color: appTheme.borderColor),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    getSize(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            this.dashboardModel.seller.firstName +
                                " " +
                                this.dashboardModel.seller.lastName,
                            style: appTheme.black18TextStyle.copyWith(
                              color: appTheme.colorPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    await whatsAppOpen(
                                        this.dashboardModel.seller.mobile);
                                  },
                                  child: Image.asset(
                                    whatsappIcon,
                                    height: getSize(20),
                                    width: getSize(20),
                                  )),
                              SizedBox(width: getSize(18)),
                              InkWell(
                                onTap: () {
                                  //change firstname to skypeId, when available on server.
                                  openSkype(
                                      this.dashboardModel.seller.firstName);
                                },
                                child: Image.asset(
                                  skypeIcon,
                                  height: getSize(20),
                                  width: getSize(20),
                                ),
                              ),
                            ],
                          )
                          // Spacer(),
                          // InkWell(onTap : (){

                          // }, child : Image.asset(CrossAxisAlignment.start))
                        ],
                      ),
                      SizedBox(
                        height: getSize(10),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!isNullEmptyOrFalse(
                              this.dashboardModel.seller.email)) {
                            openURLWithApp(
                                "mailto:?subject=PnShah&body=PnShah", context);
                          }
                        },
                        child: Row(
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
                              this.dashboardModel.seller?.email ?? "-",
                              style: appTheme.black16TextStyle,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getSize(10),
                      ),
                      InkWell(
                        onTap: () {
                          if (!isNullEmptyOrFalse(
                              this.dashboardModel.seller.mobile)) {
                            openURLWithApp(
                                "tel://${this.dashboardModel.seller.mobile}",
                                context);
                          }
                        },
                        child: Row(
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
                              this.dashboardModel.seller.mobile ?? "-",
                              style: appTheme.black16TextStyle,
                            ),
                          ],
                        ),
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

  void whatsAppOpen(String phoneNo, {String message = ""}) async {
    phoneNo = "91" + phoneNo;
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phoneNo/?text=${message}";
      } else {
        return "whatsapp://send?phone=$phoneNo&text=${message}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw showToast("whatspp is not installed in this device",
          context: context);
    }
  }

  void openSkype(String username) async {
    if (await canLaunch('skype:${username}')) {
      await launch('skype:${username}');
    } else {
      showToast("skype is not installed in this device", context: context);
    }
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
      R.string.screenTitle.viewAll,
      style: appTheme.black14TextStyle.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.colorPrimary,
      ),
    );
  }

  getText(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontsize = 12}) {
    return Text(
      text,
      style: appTheme.black12TextStyle.copyWith(
        fontSize: getFontSize(fontsize),
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

  getColorClarityLab(DiamondModel model) {
    return Row(
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
    );
  }

  getStoneIdShape(DiamondModel model) {
    return Row(
      children: [
        getText(model.stoneId ?? ""),
        Spacer(),
        getText(
          model.shpNm ?? "",
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  getCutPolSynData(DiamondModel model) {
    return Row(
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
    );
  }

  moveToDetail(DiamondModel model) {
    var dict = Map<String, dynamic>();
    dict[ArgumentConstant.DiamondDetail] = model;
    dict[ArgumentConstant.ModuleType] = DiamondModuleConstant.MODULE_TYPE_HOME;

    NavigationUtilities.pushRoute(DiamondDetailScreen.route, args: dict);
  }

  openProfile() {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(MyAccountScreen.route, args: dict)
        .then((value) {
      setState(() {});
    });
  }

  buildTopSection(String type) {
    bool isVideo = this.dashboardModel.getBannerDetails(type).isVideo;
    return Container(
      height: getSize(450),
      child: Stack(
        children: [
          Positioned(
            top: getSize(0),
            left: getSize(0),
            right: getSize(0),
            child: Card(
              margin: EdgeInsets.all(
                getSize(20),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  getSize(10),
                ),
              ),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  getSize(10),
                ),
                child: isVideo
                    ? openWebView(type)
                    : getImageView(getHomeCenterImage(type),
                        fit: BoxFit.cover,
                        placeHolderImage: diamond,
                        height: getSize(243),
                        width: MathUtilities.screenWidth(context)),
              ),
            ),
          ),
          Positioned(
            top: getSize(200),
            left: getSize(42),
            right: getSize(42),
            child: Card(
              elevation: 10,
              child: Container(
                padding: EdgeInsets.only(bottom: 13),
                width: getSize(311),
                //height: getSize(207),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    getSize(10),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        child: getText(
                          this
                              .dashboardModel
                              .getBannerDetails(type)
                              .description,
                          fontWeight: FontWeight.bold,
                          fontsize: 16,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getSideImages(type == HOME_TOP_CENTRE
                                  ? HOME_TOP_LEFT_1
                                  : HOME_BOTTOM_LEFT_1),
                              SizedBox(
                                height: getSize(13),
                              ),
                              getSideImages(type == HOME_TOP_CENTRE
                                  ? HOME_TOP_RIGHT_1
                                  : HOME_BOTTOM_RIGHT_1),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getSideImages(type == HOME_TOP_CENTRE
                                  ? HOME_TOP_LEFT_2
                                  : HOME_BOTTOM_LEFT_2),
                              SizedBox(
                                height: getSize(13),
                              ),
                              getSideImages(type == HOME_TOP_CENTRE
                                  ? HOME_TOP_RIGHT_2
                                  : HOME_BOTTOM_RIGHT_2),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getSideImages(type == HOME_TOP_CENTRE
                                  ? HOME_TOP_LEFT_3
                                  : HOME_BOTTOM_LEFT_3),
                              SizedBox(
                                height: getSize(13),
                              ),
                              getSideImages(type == HOME_TOP_CENTRE
                                  ? HOME_TOP_RIGHT_3
                                  : HOME_BOTTOM_RIGHT_3),
                            ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getHomeCenterImage(String type) {
//Removes everything after first '?'
    //List<String> result = s.split("?");
    //print(s);
    //print(this.dashboardModel.getBannerDetails(type).url);
    return this.dashboardModel.getBannerDetails(type).getDisplayImage();
    //for(int i=0;i<banners.length;i++)
  }

  getHomeSliderImage(String type) {
    List<String> images =
        this.dashboardModel.getBannerDetails(type).getSliderImage();
    return Container(
      height: getSize(200),
      child: CarouselSlider(
        options: CarouselOptions(
          height: getSize(180),
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        items: images
            .map((item) => Container(
                  margin: EdgeInsets.all(
                    getSize(6.0),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      getSize(8.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getSize(10),
                    ),
                    child: getImageView(item,
                        placeHolderImage: diamond,
                        fit: BoxFit.cover,
                        height: getSize(
                          getSize(243),
                        ),
                        width: MathUtilities.screenWidth(context)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  openDiamondList(String id) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_searchResult)
        .view) {
      Map<String, dynamic> dict = new HashMap();
      dict["filterId"] = id;
      dict[ArgumentConstant.ModuleType] =
          DiamondModuleConstant.MODULE_TYPE_SEARCH;
      NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
    }
  }

  getSideImages(String type) {
    Banners banner = this.dashboardModel.getBannerDetails(type);
    //banner.url;
    return InkWell(
      onTap: () {
        List<String> result = banner.url.split("?");
        //print(result[1]);
        if (result != null && result.length > 1) {
          print(result[1]);
          openDiamondList(result[1]);
        }
      },
      child: Container(
        height: getSize(72),
        width: getSize(90),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: getImageView(banner.getDisplayImage(),
              fit: BoxFit.cover,
              placeHolderImage: diamond,
              height: getSize(243),
              width: MathUtilities.screenWidth(context)),
        ),
      ),
    );
  }

  Future<WebView> openWebView(String type) async {
    return WebView(
        initialUrl:
            this.dashboardModel.getBannerDetails(type).getDisplayImage(),
        onPageStarted: (url) {
          // app.resolve<CustomDialogs>().showProgressDialog(context, "");
          setState(() {
            isLoading = true;
          });
        },
        onPageFinished: (finish) {
          // app.resolve<CustomDialogs>().hideProgressDialog();
          setState(() {
            isLoading = false;
          });
        },
        onWebResourceError: (error) {
          // print(error);
          setState(() {
            isLoading = true;
          });
        },
        javascriptMode: JavascriptMode.unrestricted);
  }
}
