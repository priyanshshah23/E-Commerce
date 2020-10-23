import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedSearchScreen extends StatefulScreenWidget {
  static const route = "SavedSearchScreen";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;

  SavedSearchScreen(
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
  _SavedSearchScreenState createState() => _SavedSearchScreenState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _SavedSearchScreenState extends State<SavedSearchScreen> {
  int moduleType;
  bool isFromDrawer;
  BaseList savedSearchBaseList;

  _SavedSearchScreenState({this.moduleType, this.isFromDrawer});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    savedSearchBaseList = BaseList(BaseListState(
//      imagePath: noRideHistoryFound,
      noDataMsg: APPNAME,
      noDataDesc: R.string().noDataStrings.noDataFound,
      refreshBtn: R.string().commonString.refresh,
      enablePullDown: true,
      enablePullUp: true,
      onPullToRefress: () {
        callApi(true);
      },
      onRefress: () {
        callApi(true);
      },
      onLoadMore: () {
        callApi(false, isLoading: true);
      },
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi(false);
    });
    setState(() {
      //
    });
  }

  callApi(bool isRefress, {bool isLoading = false}) {
    // if (isRefress) {
    //   arraDiamond.clear();
    //   page = DEFAULT_PAGE;
    // }

    // Map<String, dynamic> dict = {};
    // dict["page"] = page;
    // dict["limit"] = DEFAULT_LIMIT;

    // NetworkCall<DiamondListResp>()
    //     .makeCall(
    //   () => diamondConfig.getApiCall(moduleType, dict),
    //   context,
    //   isProgress: !isRefress && !isLoading,
    // )
    //     .then((diamondListResp) async {
    //   savedSearchBaseList.state.listCount = arraDiamond.length;
    //   savedSearchBaseList.state.totalCount = diamondListResp.data.count;
    //   manageDiamondSelection();
    //   page = page + 1;
    //   savedSearchBaseList.state.setApiCalling(false);
    //   setState(() {});
    // }).catchError((onError) {
    //   if (isRefress) {
    //     arraDiamond.clear();
    //     savedSearchBaseList.state.listCount = arraDiamond.length;
    //     savedSearchBaseList.state.totalCount = arraDiamond.length;
    //   }
    //   savedSearchBaseList.state.setApiCalling(false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        R.string().screenTitle.savedSearch,
        bgColor: appTheme.whiteColor,
        leadingButton: isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
        centerTitle: false,
      ),
      body: savedSearchBaseList,
    );
  }
}
