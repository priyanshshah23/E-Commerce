class ForgotPasswordReq {
  String value;

  ForgotPasswordReq({this.value});

  ForgotPasswordReq.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}

class ForgotPasswordEmailReq {
  String username;

  ForgotPasswordEmailReq({this.username});

  ForgotPasswordEmailReq.fromJson(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    return data;
  }
}

class VerifyOTPReq {
  String email;
  String otpNumber;

  VerifyOTPReq({this.email, this.otpNumber});

  VerifyOTPReq.fromJson(Map<String, dynamic> json) {
    email = json['value'];
    otpNumber = json['otpNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.email;
    data['otpNumber'] = this.otpNumber;
    return data;
  }
}
