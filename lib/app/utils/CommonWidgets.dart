import 'dart:io';

import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rxbus/rxbus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app.export.dart';
import '../constant/ColorConstant.dart';
import '../theme/app_theme.dart';
import 'CustomDialog.dart';

getBackButton(BuildContext context,
    {bool isWhite = false, double height, double width, VoidCallback ontap}) {
  return IconButton(
    padding: EdgeInsets.all(3),
    onPressed: ontap ??
        () {
          Navigator.of(context).pop();
        },
    icon: Image.asset(
      back,
      color: isWhite ? appTheme.whiteColor : appTheme.textBlackColor,
      width: width ?? getSize(22),
      height: height ?? getSize(22),
    ),
  );
  /* return Container(
    child: InkWell(
      onTap: ontap ??
          () {
            Navigator.of(context).pop();
          },
      child: Padding(
        padding: EdgeInsets.all(getSize(8.0)),
        child: Image.asset(
          back,
          color: isWhite ? appTheme.whiteColor : appTheme.textBlackColor,
          width: width ?? getSize(16),
          height: height ?? getSize(16),
        ),
      ),
    ),
  );*/
}

getBarButton(
  BuildContext context,
  String imageName,
  VoidCallback onPressed, {
  bool isBlack = false,
  GlobalKey navigation_key,
}) {
  return IconButton(
    key: navigation_key,
    padding: EdgeInsets.all(3),
    onPressed: onPressed,
    icon: Image.asset(
      imageName,
      color: isBlack == true ? Colors.black : Colors.white,
      width: getSize(22),
      height: getSize(22),
    ),
  );
}

/*
getDrawerButton(BuildContext context, bool isBlack) {
  return IconButton(
    padding: EdgeInsets.all(3),
    onPressed: () {
      // RxBus.post(DrawerEvent(DrawerConstant.OPEN_DRAWER, false),
      //     tag: eventBusTag);
    },
    icon: Image.asset(
      "menu",
      color: isBlack == true ? Colors.black : Colors.white,
      width: getSize(26),
      height: getSize(26),
    ),
  );
}
*/

getDrawerButton(BuildContext context, bool isBlack) {
  return IconButton(
    padding: EdgeInsets.all(3),
    onPressed: () {
      RxBus.post(
          DrawerEvent(DiamondModuleConstant.MODULE_TYPE_OPEN_DRAWER, false),
          tag: eventBusTag);
    },
    icon: Image.asset(
      menu,
      color: isBlack == true ? Colors.black : Colors.white,
      width: getSize(26),
      height: getSize(26),
    ),
  );
}

getBarButtonWithColor(
    BuildContext context, String imageName, VoidCallback onPressed,
    {bool isBlack = false}) {
  return Padding(
    padding: EdgeInsets.only(
      top: getSize(15),
      right: getSize(20),
      bottom: getSize(10),
    ),
    child: Container(
      height: getSize(30),
      width: getSize(30),
      decoration: BoxDecoration(
        color: appTheme.colorPrimary,
        borderRadius: BorderRadius.all(Radius.circular(getSize(3))),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(getSize(6)),
          child: Image.asset(
            imageName,
            height: getSize(18),
            width: getSize(18),
            color: isBlack ? Colors.black : Colors.white,
          ),
        ),
      ),
    ),
  );
}

getNavigationTheme(BuildContext context) {
  return TextTheme(
    title: TextStyle(
        color: AppTheme.of(context).buttonTextColor,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w700,
        fontSize: getSize(20)),
  );
}

fieldFocusChange(BuildContext context, FocusNode nextFocus) {
  FocusScope.of(context).requestFocus(nextFocus);
}

pushToWebview(BuildContext context, String text, String url) {
  var dataMap = Map<String, dynamic>();
  dataMap["url"] = url;
  dataMap["displayUrl"] = text;
  // NavigationUtilities.pushRoute(WebviewScreen.route,
  //     type: RouteType.fade, args: dataMap);
}

List<BoxShadow> getBoxShadow(BuildContext context) {
  return [
    BoxShadow(
        color: appTheme.colorPrimary.withOpacity(0.2),
        blurRadius: getSize(10),
        spreadRadius: getSize(5),
        offset: Offset(0, 3)),
  ];
}

Widget getPreferdSizeTitle(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size(0.0, getSize(70)),
    child: Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.all(getSize(16)),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: AppTheme.of(context).theme.textTheme.subhead.copyWith(
            fontWeight: FontWeight.w600, color: appTheme.colorPrimary),
      ),
    ),
  );
}

Widget getPreferdSizeTitleForPayment(
    BuildContext context, String title, String titleAmount) {
  return PreferredSize(
    preferredSize: Size(0.0, getSize(80)),
    child: Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(
        getSize(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            // textAlign: TextAlign.left,
            style: AppTheme.of(context).theme.textTheme.subhead.copyWith(
                fontWeight: FontWeight.w600, color: appTheme.colorPrimary),
          ),
          Text(
            titleAmount,
            // textAlign: TextAlign.left,
            style: AppTheme.of(context).theme.textTheme.subhead.copyWith(
                fontWeight: FontWeight.w600, color: appTheme.colorPrimary),
          ),
        ],
      ),
    ),
  );
}

Widget getAppBar(BuildContext context, String title,
    {Widget leadingButton,
    Color bgColor,
    List<Widget> actionItems,
    bool isWhite = false,
    bool isTitleShow = true,
    TextAlign textalign,
    PreferredSize widget,
    bool centerTitle}) {
  //Status//(darken(AppTheme.of(context).accentColor,0.2));

  return AppBar(
    centerTitle: centerTitle ?? true,
    elevation: 0,
    title: isTitleShow
        ? Text(
            title,
            overflow: TextOverflow.fade,
            style: appTheme.blackMedium20TitleColorblack.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: textalign ?? TextAlign.center,
          )
        : Container(),
    leading: leadingButton ??= null,
    automaticallyImplyLeading: leadingButton != null,
    backgroundColor: bgColor,
    actions: actionItems == null ? null : actionItems,
    bottom: widget,
    titleSpacing: 0.0,
  );
}

addPrefixZero(int value) {
  return value < 10 ? '0' + value.toString() : value.toString();
}

getTitleText(
  BuildContext context,
  String text, {
  Color color,
  double fontSize,
  TextAlign alignment = TextAlign.left,
  FontWeight fontweight,
  Overflow overflow,
}) {
  return Text(
    text,
    style: AppTheme.of(context).theme.textTheme.display2.copyWith(
          color: color,
          fontFamily: 'CerebriSans',
          fontSize: fontSize == null ? getSize(16) : fontSize,
          fontWeight: fontweight == null ? FontWeight.w600 : fontweight,
        ),
    textAlign: alignment,
  );
}

getSubTitleText(
  BuildContext context,
  String text, {
  Color color,
  double fontSize,
  TextAlign alignment = TextAlign.left,
  FontWeight fontweight,
  Overflow overflow,
}) {
  return Text(
    text,
    style: AppTheme.of(context).theme.textTheme.display2.copyWith(
          color: color,
          fontSize: fontSize == null ? getSize(16) : fontSize,
          fontWeight: fontweight == null ? FontWeight.bold : fontweight,
        ),
    textAlign: alignment,
  );
}

Text getBodyText(BuildContext context, String text,
    {Color color,
    double fontSize,
    double letterSpacing,
    bool underline = false,
    alignment: TextAlign.center,
    FontWeight fontweight,
    TextOverflow textoverflow,
    int maxLines = 1}) {
  return Text(
    text,
    style: AppTheme.of(context).theme.textTheme.body2.copyWith(
        color: color,
        fontSize: fontSize == null ? getSize(14) : fontSize,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontWeight: fontweight == null ? FontWeight.normal : fontweight,
        letterSpacing: letterSpacing),
    overflow: textoverflow,
    maxLines: maxLines,
    //overflow: TextOverflow.fade,
    //maxLines: 1,
    textAlign: alignment,
  );
}

bool useWhiteForeground(Color backgroundColor) =>
    1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;

changeStatusColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: false);
    if (useWhiteForeground(color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}

changeNavigationColor(Color color) async {
  if (Platform.isAndroid) {
    try {
      await FlutterStatusbarcolor.setNavigationBarColor(color, animate: false);
      if (useWhiteForeground(color)) {
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
      } else {
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}

enum IconSizeType { small, medium, large }

getCommonIconWidget(
    {String imageName,
    IconSizeType imageType = IconSizeType.medium,
    Color color = Colors.black,
    VoidCallback onTap,
    GlobalKey search_key}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: getSize(46),
      height: getSize(46),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(getImageSize(imageType)),
          width: getSize(46),
          height: getSize(46),
          child: Image.asset(
            imageName,
            key: search_key,
            color: color,
          ),
        ),
      ),
    ),
  );
}

double getImageSize(IconSizeType imaegType) {
  if (imaegType == IconSizeType.small) {
    return getSize(12);
  } else if (imaegType == IconSizeType.medium) {
    return getSize(14);
  } else if (imaegType == IconSizeType.large) {
    return getSize(4);
  }
}

getBottomButton(BuildContext context, VoidCallback onTap, String title,
    {String firstButtonTitle, VoidCallback onCancel}) {
  return Padding(
    padding: EdgeInsets.only(
      top: getSize(24),
      left: getSize(16),
      right: getSize(16),
      bottom: getSize(24),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            if (onCancel != null) {
              onCancel();
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: MathUtilities.screenWidth(context) / 2 - 50,
            child: getBodyText(
                context, firstButtonTitle ?? R.string.commonString.cancel),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: appTheme.colorPrimary,
            ),
            height: getSize(54),
            child: FlatButton(
              padding: EdgeInsets.all(getSize(0)),
              onPressed: onTap,
              child: Text(title, style: appTheme.black16TextStyle),
            ),
          ),
        ),
      ],
    ),
  );
}

getFieldTitleText(String text) {
  return Padding(
    padding: EdgeInsets.only(
        left: getSize(16),
        right: getSize(16),
        bottom: getSize(6),
        top: getSize(10)),
    child: Text(
      text,
      style: appTheme.black16TextStyle,
    ),
  );
}

openURLWithApp(String uri, BuildContext context, {bool isPop = false}) async {
  if (await canLaunch(uri)) {
    await launch(uri);
    if (isPop) {
      Navigator.pop(context);
    }
  } else {
    app.resolve<CustomDialogs>().confirmDialog(
          context,
          title: R.string.commonString.error,
          desc: "Could not launch",
          positiveBtnTitle: R.string.commonString.ok,
        );
  }
}
