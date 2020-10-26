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

