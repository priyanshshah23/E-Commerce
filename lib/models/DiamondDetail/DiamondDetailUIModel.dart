class DiamondDetailUIAPIKeys {
  // static const String shape = "SHAPE";
  //ctPr
  //amt
}

class DiamondDetailUIModel {
  String title;
  int sequence;
  List<DiamondDetailUIComponentModel> parameters;
  bool isExpand = false;

  DiamondDetailUIModel({
    this.title,
    this.parameters,
    this.sequence,
    this.isExpand,
  });

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sequence'] = this.sequence;
    if (this.parameters != null) {
      data['parameters'] = this.parameters.map((v) => v.toJson()).toList();
    }
    data['isExpand'] = this.isExpand;
    return data;
  }
}

class DiamondDetailUIComponentModel {
  String title;
  String apiKey;
  int sequence;
  bool isPercentage;

  String value;

  DiamondDetailUIComponentModel({
    this.title,
    this.apiKey,
    this.sequence,
    this.isPercentage,
  });

  DiamondDetailUIComponentModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    apiKey = json['apiKey'];
    sequence = json['sequence'];
    isPercentage = json['isPercentage'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['apiKey'] = this.apiKey;
    data['sequence'] = this.sequence;
    data['isPercentage'] = this.isPercentage;

    return data;
  }
}
