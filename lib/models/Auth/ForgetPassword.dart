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

class VerifyOTPReq {
  String email;
  String otpNumber;

  VerifyOTPReq({this.email, this.otpNumber});

  VerifyOTPReq.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otpNumber = json['otpNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otpNumber'] = this.otpNumber;
    return data;
  }
}

