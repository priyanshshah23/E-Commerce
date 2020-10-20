import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/Screens/More/DiamondBottomSheets.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';

class DiamondCompareScreen extends StatefulScreenWidget {
  static const route = "Diamond Compare Screen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  List<DiamondModel> arrayDiamond;

  DiamondCompareScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.DiamondList] != null) {
        arrayDiamond = arguments[ArgumentConstant.DiamondList];
      }
    }
  }

  @override
  _DiamondCompareScreenState createState() => _DiamondCompareScreenState(
      moduleType: moduleType, arrayDiamond: arrayDiamond);
}

class _DiamondCompareScreenState extends StatefulScreenWidgetState {
  int moduleType;
  List<DiamondModel> arrayDiamond;

  _DiamondCompareScreenState({this.moduleType, this.arrayDiamond});

  DiamondConfig diamondConfig;

  @override
  void initState() {
    super.initState();
    diamondConfig = DiamondConfig(moduleType);
    diamondConfig.initItems();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final DiamondModel item = arrayDiamond.removeAt(oldIndex);
        arrayDiamond.insert(newIndex, item);
      },
    );
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    diamondConfig.toolbarList.forEach((element) {
      list.add(GestureDetector(
        onTap: () {
          manageToolbarClick(element);
        },
        child: Padding(
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

  manageRowClick(int index, int type) {
    switch (type) {
      case clickConstant.CLICK_TYPE_SELECTION:
        setState(() {
          arrayDiamond[index].isSelected = !arrayDiamond[index].isSelected;
        });
        break;
    }
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBDownloadView:
        break;
    }
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
          actionItems: getToolbarItem(),
        ),
        bottomNavigationBar: getBottomTab(),
        body: ReorderableListView(
          onReorder: _onReorder,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          children: List.generate(
            arrayDiamond.length,
            (index) {
              return Image.asset(
                placeHolder,
                width: getSize(70),
                height: getSize(500),
                key: Key(index.toString()),
              );
            },
          ),
        ));
  }

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: diamondConfig.arrBottomTab,
      onClickCallback: (obj) {
        if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
          showBottomSheetForMenu(context, diamondConfig.arrMoreMenu,
              (manageClick) {
            manageBottomMenuClick(manageClick.bottomTabModel);
          }, R.string().commonString.more, isDisplaySelection: false);
        } else {
          manageBottomMenuClick(obj);
        }
      },
    );
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        arrayDiamond.where((element) => element.isSelected).toList();
    if (selectedList != null && selectedList.length > 0) {
      diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel);
    } else {
      app.resolve<CustomDialogs>().errorDialog(
          context, "Selection", "Please select at least one stone.",
          btntitle: R.string().commonString.ok);
    }
  }
}
