import 'package:diamnow/app/app.export.dart';

class DiamondJourneyModel {
  bool isExpanded;
  String image;
  String title;
  int type;

  DiamondJourneyModel({
    this.title,
    this.image,
    this.isExpanded = false,
    this.type,
  });

  static List<DiamondJourneyModel> getDiamondJourneyData = [
    DiamondJourneyModel(
      title: "Rough Image",
      image: DiamondUrls.roughImage,
      type: DiamondDetailImageConstant.RoughImage,
    ),
    DiamondJourneyModel(
      title: "Rough Video",
      image: DiamondUrls.roughVideo,
      type: DiamondDetailImageConstant.RoughVideo,
    ),
    DiamondJourneyModel(
      title: "3D Image",
      image: DiamondUrls.threeDImage,
      type: DiamondDetailImageConstant.ThreeDImage,
    ),
    DiamondJourneyModel(
      title: "B2B Image",
      image: DiamondUrls.b2bImage,
      type: DiamondDetailImageConstant.B2BImage,

    ),
  ];
}
