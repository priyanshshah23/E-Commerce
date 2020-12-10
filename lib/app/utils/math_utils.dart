import 'dart:math';

import 'package:flutter/material.dart';

import '../app.export.dart';

bool isPad() {
  var query =
      MediaQuery.of(NavigationUtilities.key.currentState.overlay.context);
  var size = query.size;
  var diagonal = sqrt((size.width * size.width) + (size.height * size.height));

  return (diagonal > 1100.0);
}

dynamic getSize(double px) {
  return isPad()
      ? px *
          ((MathUtilities.screenWidth(
                  NavigationUtilities.key.currentState.overlay.context)) /
              667)
      : px *
          ((MathUtilities.screenWidth(
                  NavigationUtilities.key.currentState.overlay.context)) /
              414);
}

dynamic getFontSize(double px) {
  return isPad()
      ? px *
          ((MathUtilities.screenWidth(
                  NavigationUtilities.key.currentState.overlay.context)) /
              667)
      : px *
          ((MathUtilities.screenWidth(
                  NavigationUtilities.key.currentState.overlay.context)) /
              414);
}

dynamic getPercentageWidth(double percentage) {
  return MathUtilities.screenWidth(
          NavigationUtilities.key.currentState.overlay.context) *
      percentage /
      100;
}

class MathUtilities {
  static screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static screenWidthDensity(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  static screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static safeAreaTopHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static safeAreaBottomHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
}
