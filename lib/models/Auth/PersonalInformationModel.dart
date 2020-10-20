class PersonalInformationReq {
  String id;
  String firstName;
  String lastName;
  String email;
//  String username;
//  String country;
//  String state;
//  String city;
//  String pinCode;
//  String fax;
//  String seller;
//  String vendorNo;
  String mobile;
//  String account;
//  String name;
  String address;
//  bool isActive;
  String profileImage;
//  String dob;
//  String gender;
//  String phone;
//  String photoId;
//  String reference;
  String whatsapp;
  String whatsappCounCode;
//  String skype;
//  String wechat;

  PersonalInformationReq(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
//        this.username,
//        this.country,
//        this.state,
//        this.city,
//        this.pinCode,
//        this.fax,
//        this.seller,
//        this.vendorNo,
        this.mobile,
//        this.account,
//        this.name,
        this.address,
//        this.isActive,
//        this.androidPlayerId,
//        this.iosPlayerId,
        this.profileImage,
//        this.dob,
//        this.gender,
//        this.phone,
//        this.photoId,
//        this.reference,
        this.whatsapp,
        this.whatsappCounCode,
//        this.skype,
//        this.wechat,
      });

  PersonalInformationReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
//    username = json['username'];
//    country = json['country'];
//    state = json['state'];
//    city = json['city'];
//    pinCode = json['pinCode'];
//    fax = json['fax'];
//    seller = json['seller'];
//    vendorNo = json['vendorNo'];
    mobile = json['mobile'];
//    account = json['account'];
//    name = json['name'];
    address = json['address'];
//    isActive = json['isActive'];
//    androidPlayerId = json['androidPlayerId'];
//    iosPlayerId = json['iosPlayerId'];
    profileImage = json['profileImage'];
//    dob = json['dob'];
//    gender = json['gender'];
//    phone = json['phone'];
//    photoId = json['photoId'];
//    reference = json['reference'];
    whatsapp = json['whatsapp'];
    whatsappCounCode = json['whatsappCounCode'];
//    skype = json['skype'];
//    wechat = json['wechat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
//    data['username'] = this.username;
//    data['country'] = this.country;
//    data['state'] = this.state;
//    data['city'] = this.city;
//    data['pinCode'] = this.pinCode;
//    data['fax'] = this.fax;
//    data['seller'] = this.seller;
//    data['vendorNo'] = this.vendorNo;
    data['mobile'] = this.mobile;
//    data['account'] = this.account;
//    data['name'] = this.name;
    data['address'] = this.address;
//    data['isActive'] = this.isActive;
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    data['profileImage'] = this.profileImage;
//    data['dob'] = this.dob;
//    data['gender'] = this.gender;
//    data['phone'] = this.phone;
//    data['photoId'] = this.photoId;
//    data['reference'] = this.reference;
    data['whatsapp'] = this.whatsapp;
    data['whatsappCounCode'] = this.whatsappCounCode;
//    data['skype'] = this.skype;
//    data['wechat'] = this.wechat;
    return data;
  }
}
