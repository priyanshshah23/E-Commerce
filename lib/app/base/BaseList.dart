import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../app.export.dart';

class BaseList extends StatefulWidget {
  BaseListState state;

  @override
  BaseListState createState() => state;

  BaseList(this.state);
}

class BaseListState extends State<BaseList> {
  BaseListState(
      {this.noDataMsg,
      this.noDataDesc,
      this.refreshBtn,
      this.redirectDesc,
      this.imagePath,
      this.textColor,
      this.onRedirect,
      this.onPullToRefress,
      this.onLoadMore,
      this.onRefress,
      this.listCount = 0,
      this.totalCount = 0,
      this.isApiCalling = true,
      this.enablePullDown = false,
      this.enablePullUp = false});

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Widget listItems;

  int listCount, totalCount;
  String noDataMsg, noDataDesc, refreshBtn, imagePath, redirectDesc;
  bool enablePullDown;
  bool enablePullUp;
  bool isApiCalling;
  VoidCallback onRedirect;
  VoidCallback onPullToRefress;
  VoidCallback onLoadMore;
  VoidCallback onRefress;
  Color textColor;

  void hideProgress() {
    if (refreshController != null) {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
  }

  void setApiCalling(bool isApiCall) {
    if (!isApiCall) {
      hideProgress();
    }
    new Future.delayed(
        const Duration(microseconds: 100),
        () => setState(() {
              isApiCalling = isApiCall;
            }));
  }

  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        header: MaterialClassicHeader(
          backgroundColor: colorConstants.colorPrimary,
          color: colorConstants.colorPrimary,
        ),
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp && listCount > 0 && listCount < totalCount,
        controller: refreshController,
        onRefresh: onPullToRefress,
        onLoading: onLoadMore,
        child: isApiCalling && (listCount == null || listCount == 0)
            ? Container(
                width: MathUtilities.screenWidth(context),
                height: MathUtilities.screenHeight(context),
              )
            : (listCount != null && listCount > 0
                ? listItems
                : noDataWidget(context,
                    noDataMsg: noDataMsg,
                    noDataDesc: noDataDesc,
                    redirectDesc: redirectDesc,
                    imagePath: imagePath,
                    refreshBtn: refreshBtn,
                    textColor: textColor != null
                        ? textColor
                        : AppTheme.of(context).theme.textTheme.body1.color,
                    onRefress: onRefress)));
  }

  noDataWidget(
    context, {
    String noDataMsg,
    String noDataDesc,
    String imagePath,
    String refreshBtn,
    String redirectDesc,
    Color textColor,
    VoidCallback onRefress,
  }) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: MathUtilities.screenWidth(context),
          //height: MathUtilities.screenHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (noDataDesc != null)
                Expanded(
                  child: Container(),
                ),
//              if (imagePath != null)
//                Image.asset(
//                  imagePath,
//                  fit: BoxFit.fill,
//                  width: getSize(200),
//                  height: getSize(200),
//                ),
              if (imagePath != null)
                SizedBox(
                  height: getSize(16),
                ),
              if (noDataMsg != null)
                Text(noDataMsg,
                    style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold, color: textColor),
                    textAlign: TextAlign.center),
              if (noDataMsg != null)
                SizedBox(
                  height: getSize(16),
                ),
              if (noDataDesc != null)
                Text(noDataDesc,
                    style: AppTheme.of(context).theme.textTheme.body1.copyWith(
                        color: colorConstants.colorPrimary,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              if (noDataDesc != null)
                SizedBox(
                  height: getSize(16),
                ),
//              if (refreshBtn != null)
//                CustomButton(
//                  leftPadding: getSize(80),
//                  rightPadding: getSize(80),
//                  onPressed: () {
//                    if (onRefress != null) {
//                      onRefress();
//                    }
//                  },
//                  isButtonEnabled: true,
//                  text: refreshBtn,
//                ),
              if (noDataDesc != null)
                Expanded(
                  child: Container(),
                ),
              if (redirectDesc != null)
                Padding(
                  padding:
                      EdgeInsets.only(top: getSize(10), bottom: getSize(40)),
                  child: InkWell(
                    onTap: onRedirect,
                    child: Text(
                      redirectDesc,
                      style: AppTheme.of(context)
                          .theme
                          .textTheme
                          .body2
                          .copyWith(
                              color: colorConstants.colorPrimary,
                              decoration: TextDecoration.underline),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
