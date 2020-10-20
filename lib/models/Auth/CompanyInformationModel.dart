class CompanyInformationReq {
  String id;
  String companyName;
  String dateOfJoin;
  String companyType;
  String businessType;
  bool isActive;

  CompanyInformationReq(
      {this.id,
        this.companyName,
        this.dateOfJoin,
        this.companyType,
        this.businessType,
        this.isActive});

  CompanyInformationReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    dateOfJoin = json['dateOfJoin'];
    companyType = json['companyType'];
    businessType = json['businessType'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['dateOfJoin'] = this.dateOfJoin;
    data['companyType'] = this.companyType;
    data['businessType'] = this.businessType;
    data['isActive'] = this.isActive;
    return data;
  }
}
