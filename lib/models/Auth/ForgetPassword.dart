class ForgotPasswordReq {
  String username;

  ForgotPasswordReq({this.username});

  ForgotPasswordReq.fromJson(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    return data;
  }
}
