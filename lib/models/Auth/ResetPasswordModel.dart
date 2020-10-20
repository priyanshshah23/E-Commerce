class ResetPasswordReq {
  String newPassword;
  String currentPassword;

  ResetPasswordReq({this.newPassword, this.currentPassword});

  ResetPasswordReq.fromJson(Map<String, dynamic> json) {
    newPassword = json['newPassword'];
    currentPassword = json['currentPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newPassword'] = this.newPassword;
    data['currentPassword'] = this.currentPassword;
    return data;
  }
}
