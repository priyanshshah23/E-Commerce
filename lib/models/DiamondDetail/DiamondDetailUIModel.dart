class DiamondDetailUIAPIKeys {
  static const String pricePerCarat = "ctPr";
  static const String amount = "amt";
}

class DiamondDetailUIModel {
  String title;
  int sequence;
  List<DiamondDetailUIComponentModel> parameters;
  bool isExpand = false;
  int columns;
  String orientation;

  DiamondDetailUIModel(
      {this.title,
      this.parameters,
      this.sequence,
      this.isExpand,
      this.columns,
      this.orientation});

  DiamondDetailUIModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    sequence = json['sequence'];
    if (json['parameters'] != null) {
      parameters = new List<DiamondDetailUIComponentModel>();
      json['parameters'].forEach((v) {
        parameters.add(new DiamondDetailUIComponentModel.fromJson(v));
      });
    }
    isExpand = json['isExpand'] ?? false;
    columns = json['columns'];
    orientation = json['orientation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sequence'] = this.sequence;
    if (this.parameters != null) {
      data['parameters'] = this.parameters.map((v) => v.toJson()).toList();
    }
    data['isExpand'] = this.isExpand;
    data['columns'] = this.columns;
    data['orientation'] = this.orientation;
    return data;
  }
}

class DiamondDetailUIComponentModel {
  String title;
  String apiKey;
  int sequence;
  bool isActive;
  bool isPercentage;

  String value;

  DiamondDetailUIComponentModel({
    this.title,
    this.apiKey,
    this.sequence,
    this.isActive,
    this.isPercentage,
  });

  DiamondDetailUIComponentModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    apiKey = json['apiKey'];
    sequence = json['sequence'];
    isActive = json["isActive"];
    isPercentage = json['isPercentage'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['apiKey'] = this.apiKey;
    data['sequence'] = this.sequence;
    data['isActive'] = this.isActive;
    data['isPercentage'] = this.isPercentage;

    return data;
  }
}
