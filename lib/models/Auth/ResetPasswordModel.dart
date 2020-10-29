class ResetPasswordReq {
  String otpNumber;
  String value;
  String newPassword;

  ResetPasswordReq({this.otpNumber, this.value, this.newPassword});

  ResetPasswordReq.fromJson(Map<String, dynamic> json) {
    otpNumber = json['otpNumber'];
    value = json['value'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpNumber'] = this.otpNumber;
    data['value'] = this.value;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
