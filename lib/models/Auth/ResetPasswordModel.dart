class ResetPasswordReq {
  String otpNumber;
  String email;
  String newPassword;

  ResetPasswordReq({this.otpNumber, this.email, this.newPassword});

  ResetPasswordReq.fromJson(Map<String, dynamic> json) {
    otpNumber = json['otpNumber'];
    email = json['email'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpNumber'] = this.otpNumber;
    data['email'] = this.email;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
