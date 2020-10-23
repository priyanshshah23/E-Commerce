class SignInAsGuestReq {
  String mobile;
  String email;
  String firstName;
  String lastName;
  String companyName;

  SignInAsGuestReq(
      {this.mobile,
        this.email,
        this.firstName,
        this.lastName,
        this.companyName});

  SignInAsGuestReq.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['companyName'] = this.companyName;
    return data;
  }
}