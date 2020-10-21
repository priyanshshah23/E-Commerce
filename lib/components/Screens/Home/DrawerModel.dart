import 'dart:ui';

import 'package:diamnow/app/app.export.dart';
import 'package:flutter/material.dart';

class DrawerModel {
  String title;
  String image;
  bool isSelected = false;
  bool isExpand = false;
  bool isShowCount = false;
  Color countBackgroundColor = appTheme.colorPrimary;
  Color imageColor;
  int type;
  int count;

  DrawerModel({
    this.image,
    this.title,
    this.isSelected,
    this.type,
    this.isExpand = false,
    this.isShowCount = false,
    this.countBackgroundColor = Colors.red,
    this.imageColor,
    this.count = 0,
  });
}
