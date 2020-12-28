import 'package:diamnow/app/app.export.dart';
import 'package:flutter/material.dart';

class OverlayscreenModel {
  List<OverlayImagesModel> getHomeScreenOverlay() {
    List<OverlayImagesModel> arrImages = [];
    arrImages.add(OverlayImagesModel(
      imageName: homeOverlay1,
      isTop: true,
      align: Alignment.topCenter,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: homeOverlay2,
      isTop: true,
      align: Alignment.topCenter,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: homeOverlay3,
      isTop: true,
      topPadding: 0.0,
      align: Alignment.topCenter,
    ));
    arrImages.add(OverlayImagesModel(imageName: homeOverlay4, isBottom: true));
    arrImages.add(OverlayImagesModel(
      imageName: homeOverlay5,
      isTop: true,
      topPadding: 0.0,
      align: Alignment.topLeft,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: homeOverlay6,
      isTop: true,
      topPadding: 0.0,
      align: Alignment.topRight,
    ));
    return arrImages;
  }

  List<OverlayImagesModel> getAccountScreenOverlay() {
    List<OverlayImagesModel> arrImages = [];
    arrImages.add(OverlayImagesModel(
      imageName: myAccountOverlay1,
      isTop: true,
      align: Alignment.topCenter,
      topPadding: kBottomNavigationBarHeight + getSize(20.0),
    ));
    arrImages.add(OverlayImagesModel(
      imageName: myAccountOverlay2,
      isBottom: true,
    ));

    return arrImages;
  }

  List<OverlayImagesModel> getFilterOverlay() {
    List<OverlayImagesModel> arrImages = [];
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay1,
      isTop: true,
      align: Alignment.topCenter,
      topPadding: kBottomNavigationBarHeight - getSize(10),
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay2,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay3,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay4,
      isTop: true,
      align: Alignment.topRight,
      topPadding: 0.0,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay5,
      isTop: true,
      align: Alignment.topRight,
      topPadding: 0.0,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay6,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchOverlay7,
      isBottom: true,
    ));

    return arrImages;
  }

  List<OverlayImagesModel> getSearchResultOverlay() {
    List<OverlayImagesModel> arrImages = [];
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay1,
      isTop: true,
      align: Alignment.topRight,
      topPadding: kBottomNavigationBarHeight,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay2,
      isTop: true,
      align: Alignment.topRight,
      topPadding: kBottomNavigationBarHeight,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay3,
      isTop: true,
      align: Alignment.topRight,
      topPadding: kBottomNavigationBarHeight,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay4,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay5,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay6,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay7,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay8,
      isBottom: true,
    ));
    arrImages.add(OverlayImagesModel(
      imageName: searchResultOverlay9,
      isTop: true,
      align: Alignment.topCenter,
      topPadding: kBottomNavigationBarHeight - getSize(20),
    ));

    return arrImages;
  }
}

class OverlayImagesModel {
  String imageName;
  bool isCenter = false;
  bool isTop = false;
  bool isBottom = false;
  num topPadding;
  Alignment align;

  OverlayImagesModel({
    this.imageName,
    this.isBottom = false,
    this.isTop = false,
    this.isCenter = false,
    this.topPadding = kBottomNavigationBarHeight,
    this.align = Alignment.center,
  });
}
