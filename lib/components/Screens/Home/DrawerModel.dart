import 'dart:ui';

import 'package:diamnow/app/app.export.dart';

class DrawerModel {
  String title;
  String image;
  bool isSelected = false;
  bool isExpand = false;
  bool isShowCount = false;
  Color countBackgroundColor = appTheme.colorPrimary;
  int type;

  DrawerModel({
    this.image,
    this.title,
    this.isSelected,
    this.type,
    this.isExpand,
    this.isShowCount,
    this.countBackgroundColor,
  });
}
