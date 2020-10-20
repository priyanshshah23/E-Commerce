class ChangePasswordReq {
  String currentPassword;
  String newPassword;

  ChangePasswordReq({this.currentPassword, this.newPassword});

  ChangePasswordReq.fromJson(Map<String, dynamic> json) {
    currentPassword = json['currentPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPassword'] = this.currentPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
