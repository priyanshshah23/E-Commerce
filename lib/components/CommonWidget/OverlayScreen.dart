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
  OverlayScreen(this.moduleType, {this.finishTakeTour});

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
      print(arrOverlays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.blackColor.withOpacity(0.5),
      child: Padding(
        padding: EdgeInsets.only(top: kBottomNavigationBarHeight),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
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
      ),
    );
  }

  getCenteredColumn(int index) {
    return Center(child: getColumn(index));
  }

  getColumn(int index) {
    return Column(
      mainAxisSize:
          arrOverlays[index].isCenter ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: arrOverlays[index].isBottom
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(
              left: getSize(16),
              right: getSize(16),
            ),
            child: Image.asset(
              arrOverlays[index].imageName,
              fit: BoxFit.fitHeight,
            )),
      ],
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
              margin: EdgeInsets.only(top: getSize(10), left: getSize(0)),
              width: getSize(80),
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
                ? SmoothPageIndicator(
                    controller: controller,
                    count: arrOverlays.length,
                    effect:
                        JumpingDotEffect(activeDotColor: appTheme.colorPrimary),
                  )
                : SizedBox(),
            Container(
              width: getSize(80),
              margin: EdgeInsets.only(top: getSize(15), left: getSize(0)),
              decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
              child: AppButton.flat(
                onTap: () {
                  setState(() {
                    if (currentPage == (arrOverlays.length - 1)) {
                      setTakeaTourValueAsTrue();
                      widget.finishTakeTour();
                    } else {
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
    }
  }
}
