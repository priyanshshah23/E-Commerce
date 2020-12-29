import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/pref_utils.dart';
import 'package:diamnow/components/CommonWidget/OverlayscreenModel.dart';
import 'package:diamnow/components/widgets/shared/buttons.dart';
import 'package:diamnow/main.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OverlayScreen extends StatefulWidget {
  int moduleType;
  Function finishTakeTour;
  Function(int index) scrollIndex;
  OverlayScreen(
    this.moduleType, {
    this.finishTakeTour,
    this.scrollIndex,
  });

  @override
  _OverlayScreenState createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  List<OverlayImagesModel> arrOverlays = [];
  final controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_HOME) {
      arrOverlays = OverlayscreenModel().getHomeScreenOverlay();
    } else if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_PROFILE) {
      arrOverlays = OverlayscreenModel().getAccountScreenOverlay();
    } else if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
      arrOverlays = OverlayscreenModel().getFilterOverlay();
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_DIAMOND_SEARCH_RESULT) {
      arrOverlays = OverlayscreenModel().getSearchResultOverlay();
    } else if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_COMPARE) {
      arrOverlays = OverlayscreenModel().getCompareStoneOverlay();
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_DIAMOND_DETAIL) {
      arrOverlays = OverlayscreenModel().getDiamondDetailOverlay();
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      arrOverlays = OverlayscreenModel().getOfferOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.blackColor.withOpacity(0.5),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                  widget.scrollIndex(page);
                });
              },
              controller: controller,
              itemBuilder: (context, index) {
                return arrOverlays[index].isCenter
                    ? getCenteredColumn(index)
                    : getColumn(index);
              },
              itemCount: arrOverlays.length,
            ),
          ),
          // Spacer(),
          getBottomTab(),
        ],
      ),
    );
  }

  getCenteredColumn(int index) {
    return Center(child: getColumn(index));
  }

  getColumn(int index) {
    return Align(
      alignment: arrOverlays[index].isCenter
          ? Alignment.center
          : arrOverlays[index].isTop
              ? arrOverlays[index].align
              : Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: num.parse(
            arrOverlays[index].topPadding.toString(),
          ),
        ),
        child: Image.asset(
          arrOverlays[index].imageName,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  getBottomTab() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: getSize(16), bottom: getSize(16), right: getSize(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: getSize(10)),
              width: getSize(60),
              height: getSize(40),
              child: AppButton.flat(
                onTap: () {
                  setTakeaTourValueAsTrue();
                  widget.finishTakeTour();
                },
                borderRadius: getSize(5),
                text: "Skip",
              ),
            ),
            arrOverlays.length > 1
                ? Padding(
                    padding: EdgeInsets.only(top: getSize(10)),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: arrOverlays.length,
                      effect: JumpingDotEffect(
                          activeDotColor: appTheme.colorPrimary),
                    ),
                  )
                : SizedBox(),
            Container(
              width: getSize(60),
              height: getSize(40),
              margin: EdgeInsets.only(top: getSize(15), left: getSize(0)),
              decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
              child: AppButton.flat(
                onTap: () {
                  setState(() {
                    if (currentPage == (arrOverlays.length - 1)) {
                      setTakeaTourValueAsTrue();
                      widget.finishTakeTour();
                    } else {
                      widget.scrollIndex(currentPage + 1);
                      controller.animateToPage(currentPage + 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }
                  });
                },
                borderRadius: getSize(5),
                text:
                    currentPage == (arrOverlays.length - 1) ? "Finish" : "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }

  setTakeaTourValueAsTrue() {
    if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_HOME) {
      app.resolve<PrefUtils>().saveBoolean(PrefUtils().keyHomeTour, true);
    } else if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_PROFILE) {
      app.resolve<PrefUtils>().saveBoolean(PrefUtils().keyMyAccountTour, true);
    } else if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
      app.resolve<PrefUtils>().saveBoolean(PrefUtils().keySearchTour, true);
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_DIAMOND_SEARCH_RESULT) {
      app
          .resolve<PrefUtils>()
          .saveBoolean(PrefUtils().keySearchResultTour, true);
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_DIAMOND_DETAIL) {
      app
          .resolve<PrefUtils>()
          .saveBoolean(PrefUtils().keyDiamondDetailTour, true);
    } else if (widget.moduleType == DiamondModuleConstant.MODULE_TYPE_COMPARE) {
      app
          .resolve<PrefUtils>()
          .saveBoolean(PrefUtils().keyCompareStoneTour, true);
    } else if (widget.moduleType ==
        DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      app.resolve<PrefUtils>().saveBoolean(PrefUtils().keyOfferTour, true);
    }
  }
}
