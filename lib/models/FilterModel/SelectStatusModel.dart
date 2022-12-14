class SelectStatusModel {
  String title;
  String typeConstant;
  bool isSelected;

  SelectStatusModel({
    this.title,
    this.typeConstant,
    this.isSelected = false,
  });

  static List<SelectStatusModel> dynamicList = [
    SelectStatusModel(
      title: "Available",
      typeConstant: "S",
    ),
    SelectStatusModel(
      title: "Memo",
      typeConstant: "I",
    ),
    SelectStatusModel(
      title: "Hold",
      typeConstant: "W",
    ),
    SelectStatusModel(
      title: "Best Buy",
      typeConstant: "D",
    ),
    SelectStatusModel(
      title: "Reserved",
      typeConstant: "Y",
    ),
    SelectStatusModel(
      title: "Reserved Sold",
      typeConstant: "R",
    ),
    SelectStatusModel(
      title: "Available On Result",
      typeConstant: "C",
    ),
    SelectStatusModel(
      title: "Unreserved Sold",
      typeConstant: "U",
    ),
//    SelectStatusModel(
//      title: "Blocked",
//      typeConstant: "B",
//    ),
//    SelectStatusModel(
//      title: "Recut Issue",
//      typeConstant: "K",
//    ),
//
//    SelectStatusModel(
//      title: "Sold",
//      typeConstant: "O",
//    ),
  ];
}
