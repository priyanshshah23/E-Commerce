import 'package:diamnow/app/app.export.dart';

class OverlayscreenModel {
  List<OverlayImagesModel> getHomeScreenOverlay() {
    List<OverlayImagesModel> arrImages = [];
    arrImages.add(OverlayImagesModel(imageName: homeOverlay1, isCenter: true));
    arrImages.add(OverlayImagesModel(imageName: homeOverlay1, isTop: true));
    arrImages.add(OverlayImagesModel(imageName: homeOverlay1, isBottom: true));
    return arrImages;
  }
}

class OverlayImagesModel {
  String imageName;
  bool isCenter = false;
  bool isTop = false;
  bool isBottom = false;

  OverlayImagesModel({
    this.imageName,
    this.isBottom = false,
    this.isTop = false,
    this.isCenter = false,
  });
}
