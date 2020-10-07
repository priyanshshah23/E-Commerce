class BaseApiResp {
  String message;
  num status;
  String code;

  BaseApiResp();

  BaseApiResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    status =  json.containsKey('status') ? json['status'] : 0;

    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    return data;
  }
}
