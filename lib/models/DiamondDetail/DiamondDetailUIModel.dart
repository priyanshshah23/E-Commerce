import 'package:diamnow/app/localization/app_locales.dart';

class DiamondDetailUIAPIKeys {
  static const String pricePerCarat = "ctPr";
  static const String amount = "amt";
  static const String stoneId = "stoneId";
  static const String shpNm = "shpNm";
  static const String crt = "crt";
  static const String shdNm = "shdNm";
  static const String cutNm = "cutNm";
  static const String polNm = "polNm";
  static const String symNm = "symNm";
  static const String fluNm = "fluNm";
  static const String lbNm = "lbNm";
  static const String rptNo = "rptNo";
  static const String back = "back";
  static const String mlkNm = "mlkNm";
  static const String eClnNm = "eClnNm";
  static const String length = "length";
  static const String width = "width";
  static const String height = "height";
  static const String ratio = "ratio";
  static const String depPer = "depPer";
  static const String tblPer = "tblPer";
  static const String cHgt = "cHgt";
  static const String cAng = "cAng";
  static const String pAng = "pAng";
  static const String girdleStr = "girdleStr";
  static const String grdlCondNm = "grdlCondNm";
  static const String cultNm = "cultNm";
  static const String cultCondNm = "cultCondNm";
  static const String hANm = "hANm";
  static const String comments = "comments";
  static const String kToSStr = "kToSStr";
  static const String clr = "clr";
  static const String col = "col";
}

class DiamondDetailUIModel {
  String title;
  int sequence;
  List<DiamondDetailUIComponentModel> parameters;
  bool isExpand;
  int columns;
  String orientation;

  DiamondDetailUIModel({
    this.title,
    this.parameters,
    this.sequence,
    this.isExpand = true,
    this.columns,
    this.orientation,
  });

  DiamondDetailUIModel.fromJson(Map<String, dynamic> json) {
    title = R.string?.dynamickeys?.byKey(
      json['title'],
    );
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
    title = R.string?.dynamickeys?.byKey(
      json['title'],
    );
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
