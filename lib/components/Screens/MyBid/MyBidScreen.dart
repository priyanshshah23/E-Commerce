import 'package:diamnow/app/Helper/OfflineStockManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

import 'MyBidList.dart';

class MyBidScreen extends StatefulWidget {
  static const route = "My Bid Screen";
  @override
  _MyBidScreenState createState() => _MyBidScreenState();
}

class _MyBidScreenState extends State<MyBidScreen>
    with SingleTickerProviderStateMixin {
  DiamondConfig diamondConfig;
  int viewTypeCount = 0;
  List<FilterOptions> optionList = List<FilterOptions>();
  DiamondCalculation diamondCalculation = DiamondCalculation();

  TabController _controller;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> sortRequest;

  List<MyBidTab> tabs = [];

  List<Widget> tabbar;

  @override
  void initState() {
    super.initState();

    Config().getOptionsJson().then((result) {
      result.forEach((element) {
        if (element.isActive) {
          optionList.add(element);
        }
      });
      setState(() {});
    });
    tabs = configureTabs();
    tabbar = getTabs();
    updateToolbar();

    _controller = TabController(length: tabbar.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
        updateToolbar();
      });
      print("Selected Index: " + _controller.index.toString());
    });
  }

  updateToolbar() {
    diamondConfig = DiamondConfig(_selectedIndex == 0
        ? DiamondModuleConstant.MODULE_TYPE_MY_BID
        : DiamondModuleConstant.MODULE_TYPE_MY_BID_HISTORY);
    diamondConfig.initItems();
  }

  @override
  void dispose() {
    RxBus.destroy(tag: eventSelectAllGroupDiamonds);
    RxBus.destroy(tag: eventSelectAll);
    RxBus.destroy(tag: eventDiamondMoreClick);
    RxBus.destroy(tag: eventDiamondDownloadClick);
    RxBus.destroy(tag: eventManageBottomMenuClick);
    RxBus.destroy(tag: eventSortClick);

    super.dispose();
  }

  configureTabs() {
    return [
      MyBidTab(
        title: 'Live Bid',
        type: MyBidConstant.LiveBid,
      ),
      MyBidTab(
        title: 'Bid History',
        type: MyBidConstant.BidHistory,
      ),
    ];
  }

  getTabs() {
    List<Widget> list = [];

    for (var item in tabs) {
      list.add(
        Tab(
          text: item.title,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        diamondConfig.getScreenTitle(),
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
        textalign: TextAlign.left,
        actionItems: getToolbarItem(),
      ),
      bottomNavigationBar: getBottomTab(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DiamondListHeader(
              diamondCalculation: diamondCalculation,
              moduleType: DiamondModuleConstant.MODULE_TYPE_MY_BID,
            ),
            SizedBox(
              height: getSize(16),
            ),
            Container(
              height: getSize(46),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: appTheme.dividerColor,
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
                color: appTheme.whiteColor,
              ),
              child: TabBar(
                onTap: (index) {},
                labelStyle: appTheme.black16MediumTextStyle,
                unselectedLabelStyle: appTheme.black16MediumTextStyle,
                unselectedLabelColor: appTheme.textColor.withOpacity(0.6),
                labelColor: appTheme.textColor,
                // isScrollable: true,
                controller: _controller,
                tabs: tabbar,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                indicatorColor: appTheme.colorPrimary,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: getTabBarControllers(),
              ),
            ),
//            Expanded(
//              child: diamondList,
//            ),
            /*this.moduleType ==
                DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION
                ?*/
            /* AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: */ /*isVisible ? 1.0 :*/ /* 0.0,
                duration: Duration(milliseconds: 500),
                child: FinalCalculationWidget(
                    arraDiamond, this.diamondFinalCalculation)),*/
//                : SizedBox(),
          ],
        ),
      ),
    );
  }

  getTabBarControllers() {
    List<Widget> list = [];

    for (var item in tabs) {
      list.add(
        MyBidList(
          diamondCalculation: diamondCalculation,
          diamondConfig: diamondConfig,
          sortRequest: sortRequest,
          bidType: item.type,
          onDiamondCalculationUpdate: (newDiamondCalculation) {
            setState(() {
              diamondCalculation = newDiamondCalculation;
            });
          },
          onModelUpdate: (model) {
            setState(() {
              diamondConfig.toolbarList
                  .firstWhere((element) => (element.code == model.code),
                      orElse: () => null)
                  ?.isSelected = model.isSelected;
            });
          },
        ),
      );
    }
    return list;
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    for (int i = 0; i < diamondConfig.toolbarList.length; i++) {
      var element = diamondConfig.toolbarList[i];
      if (element.code == BottomCodeConstant.TBDownloadView &&
          OfflineStockManager.shared.isDownloading) {
        list.add(
          GestureDetector(
            onTap: () {
              app.resolve<CustomDialogs>().confirmDialog(context,
                  title: APPNAME,
                  desc:
                      "Are you sure you want to cancel offline stock download?",
                  positiveBtnTitle: R.string.commonString.yes,
                  negativeBtnTitle: R.string.commonString.no,
                  onClickCallback: (btnType) {
                if (btnType == ButtonType.PositveButtonClick) {
                  OfflineStockManager.shared.canelDownload();
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: i == diamondConfig.toolbarList.length - 1
                      ? getSize(Spacing.rightPadding)
                      : getSize(8),
                  left: getSize(8.0)),
              child: SizedBox(
                height: getSize(24),
                width: getSize(24),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: getSize(24),
                        width: getSize(24),
                        child: CircularProgressIndicator(
                          strokeWidth: getSize(3),
                          value: OfflineStockManager.shared.downloadProgress,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(appTheme.textColor),
                          backgroundColor: appTheme.textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        OfflineStockManager.shared.downloadProgressText(),
                        style: appTheme.primaryNormal12TitleColor.copyWith(
                          fontSize: getSize(8),
                          color: appTheme.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        list.add(GestureDetector(
          onTap: () {
            manageToolbarClick(element);
          },
          child: Padding(
            padding: EdgeInsets.only(
                right: i == diamondConfig.toolbarList.length - 1
                    ? getSize(Spacing.rightPadding)
                    : getSize(8),
                left: getSize(8.0)),
            child: Image.asset(
              element.isSelected
                  ? (element.selectedImage != null
                      ? element.selectedImage
                      : element.image)
                  : element.image,
              height: getSize(20),
              width: getSize(20),
            ),
          ),
        ));
      }

      ;
    }

    return list;
  }

  Widget getBottomTab() {
    return _selectedIndex == 0
        ? BottomTabbarWidget(
            arrBottomTab: diamondConfig.arrBottomTab,
            onClickCallback: (obj) {
              //
              if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
                RxBus.post(true, tag: eventDiamondMoreClick);
              } else if (obj.type ==
                  ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION) {
//          clearSelection();
              } else {
                RxBus.post(obj, tag: eventManageBottomMenuClick);
              }
            },
          )
        : null;
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBSelectAll:
        setState(() {
          model.isSelected = !model.isSelected;
          RxBus.post(model, tag: eventSelectAll);
        });

        break;

      case BottomCodeConstant.TBSortView:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          builder: (_) => FilterBy(
            optionList: optionList,
            callBack: (value) {
              //
              setState(() {
                sortRequest = value;
              });
              RxBus.post(value, tag: eventSortClick);
            },
          ),
        );
        break;
      case BottomCodeConstant.TBDownloadView:
        RxBus.post(true, tag: eventDiamondDownloadClick);
        break;
    }
  }
}
