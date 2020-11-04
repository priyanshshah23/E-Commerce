class ShareThroughEmailReq {
  String subject;
  String cc;
  String email;
  String message;
  List<String> id;
  bool certFile;
  bool img;
  bool isPlt;
  bool videoFile;
  bool assetFile;
  bool arrowFile;
  bool mp4Video;
  bool type2;
  bool roughVideo;
  bool darkFieldImage;
  bool flsImage;
  bool idealWhiteImage;
  bool roughImage;
  bool planImg;
  bool faceUp;
  bool b2cRealImage;

  ShareThroughEmailReq(
      {this.subject,
        this.cc,
        this.email,
        this.message,
        this.id,
        this.certFile,
        this.img,
        this.isPlt,
        this.videoFile,
        this.assetFile,
        this.arrowFile,
        this.mp4Video,
        this.type2,
        this.roughVideo,
        this.darkFieldImage,
        this.flsImage,
        this.idealWhiteImage,
        this.roughImage,
        this.planImg,
        this.faceUp,
        this.b2cRealImage});

  ShareThroughEmailReq.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    cc = json['cc'];
    email = json['email'];
    message = json['message'];
    id = json['id'].cast<String>();
    certFile = json['certFile'];
    img = json['img'];
    isPlt = json['isPlt'];
    videoFile = json['videoFile'];
    assetFile = json['assetFile'];
    arrowFile = json['arrowFile'];
    mp4Video = json['mp4Video'];
    type2 = json['type2'];
    roughVideo = json['roughVideo'];
    darkFieldImage = json['darkFieldImage'];
    flsImage = json['flsImage'];
    idealWhiteImage = json['idealWhiteImage'];
    roughImage = json['roughImage'];
    planImg = json['planImg'];
    faceUp = json['faceUp'];
    b2cRealImage = json['b2cRealImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['cc'] = this.cc;
    data['email'] = this.email;
    data['message'] = this.message;
    data['id'] = this.id;
    data['certFile'] = this.certFile;
    data['img'] = this.img;
    data['isPlt'] = this.isPlt;
    data['videoFile'] = this.videoFile;
    data['assetFile'] = this.assetFile;
    data['arrowFile'] = this.arrowFile;
    data['mp4Video'] = this.mp4Video;
    data['type2'] = this.type2;
    data['roughVideo'] = this.roughVideo;
    data['darkFieldImage'] = this.darkFieldImage;
    data['flsImage'] = this.flsImage;
    data['idealWhiteImage'] = this.idealWhiteImage;
    data['roughImage'] = this.roughImage;
    data['planImg'] = this.planImg;
    data['faceUp'] = this.faceUp;
    data['b2cRealImage'] = this.b2cRealImage;
    return data;
  }
}