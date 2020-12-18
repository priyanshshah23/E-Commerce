class OfflineSearchHistoryModel {
  int pcs;
  num carat;
  String date;
  String expiryDate;
  String filterParam;

  OfflineSearchHistoryModel(
      {this.pcs, this.carat, this.date, this.expiryDate, this.filterParam});

  OfflineSearchHistoryModel.fromJson(Map<String, dynamic> json) {
    pcs = json['pcs'];
    carat = json['carat'];
    date = json['date'];
    expiryDate = json['expiryDate'];
    filterParam = json['filterParam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pcs'] = this.pcs;
    data['carat'] = this.carat;
    data['date'] = this.date;
    data['expiryDate'] = this.expiryDate;
    data["filterParam"] = this.filterParam;
    return data;
  }
}
