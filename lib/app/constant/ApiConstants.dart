import 'dart:io';

import '../app.export.dart';

class ApiConstants {
//  static const String PROXY_URL = "PROXY 192.168.0.114:8888";
  //static String PROXY_URL = "PROXY 192.168.2.153:8888"; //HONEY
  static String PROXY_URL = "PROXY 192.168.0.170:8888"; //HIMANSHI
//  static String PROXY_URL = "PROXY 192.168.2.156:8888"; //SNEHAL
// static String PROXY_URL = "PROXY 192.168.0.118:8888"; //JECKY

//    static const String PROXY_URL = "PROXY 10.0.2.2:8888";

  static const String imageBaseURL = baseURL;
  static const String webPageUrl = "http://pndevelopapi.democ.in/";
  static const String shareUrl = "http://pndevelop.democ.in/diamond-details/";
  static const String googleDocUrl =
      "https://docs.google.com/viewer?embedded=true&url=";

  static const String apiUrl = baseURL;
  static const String commonUrl = apiUrl + "device/v1/";
  static const String authUrl = apiUrl + "web/v1/auth/";
  static const String shareAndEarn = "";

  static const String countryList = commonUrl + "country/paginate";
  static const String stateList = commonUrl + "state/paginate";
  static const String cityList = commonUrl + "city/paginate";

  static const String documentUpload = commonUrl + "upload-file";

  static const String masterSync = commonUrl + "masterSync";

  static const String login = commonUrl + "auth/login";
  static const String diamondListSales = commonUrl + "common/diamond/paginate";

  static const String diamondList = commonUrl + "diamond/paginate";
  static const String diamondMatchPair =
      commonUrl + "match-pair/diamond/filter";

  static const String stoneOfTheDay = commonUrl + "featuredStone/paginate";

  static const String mySaveSearch = commonUrl + "diamond/search/list";

  static const String diamondTrackList = commonUrl + "diamond-track/paginate";
  static const String diamondCommentList =
      commonUrl + "diamond-comment/by-user";
  static const String diamondBidList = commonUrl + "diamond-bid/paginate";
  static const String diamondOfficeList = commonUrl + "cabin-schedule/list";
  static const String diamondOrderList = commonUrl + "memo/paginate";
  static const String diamondBlockList = commonUrl + "diamond-block/paginate";

  static const String createDiamondTrack = commonUrl + "diamond-track/create";
  static const String upsetComment = commonUrl + "diamond-comment/upsert";
  static const String createDiamondBid = commonUrl + "diamond-bid/create";

  static const String placeOrder = commonUrl + "diamond-confirm/request";
  static const String staticPage = apiV1 + "static-page/{id}";
  static const String forgetPassword = commonUrl + "forgot-password"; //done
  static const String resetPassword = commonUrl + "user/reset-password";
  static const String changePassword =
      apiUrl + "web/v1/auth/reset-password-by-user"; //done
  static const String personalInformation = commonUrl + "user/update"; //done
  static const String sendOTP = commonUrl + "user/send-otp"; //done
  static const String forgotMpin = commonUrl + "forgot-mpin";
  static const String verifyOTP = commonUrl + "user/verify-otp"; //done
  static const String verifyOTPForMpin = commonUrl + "verify-mpin-otp"; //done
  static const String verifyMpin = commonUrl + "verify-mpin"; //done
  static const String companyInformation =
      commonUrl + "user/profile/update"; //done
  static const String quickSearch = commonUrl + "diamond/quick-search";
  static const String personalInformationView = commonUrl + "user/view";
  static const String companyInformationView = commonUrl + "user/profile";
  static const String savedSearch = commonUrl + "diamond/search/upsert";
  static const String signInAsGuest = commonUrl + "guest/auth/login";

  //Office
  static const String getSlots = commonUrl + "cabin-slot/paginate";
  static const String createOfficerequest = commonUrl + "cabin-schedule/create";

  //VERSION UPDATION
  static const getUpdation = commonUrl + "version";

  //Dashboard
  static const String dashboard = commonUrl + "user/dashboard";
  static const String deleteSavedSearch = commonUrl + "diamond/search/delete";
  static const String logout = commonUrl + "auth/logout";
  static const String sendAnalytics = commonUrl + "auth/logout";

  static const String diamondTrackDelete = commonUrl + "diamond-track/delete";
  static const String diamondComentDelete =
      commonUrl + "diamond-comment/delete";
  static const String diamondBidDelete = commonUrl + "diamond-bid/delete";

  static const String markAsReadNotification =
      commonUrl + "notification/markAsRead";

  static const String sendNotificationId = commonUrl + "user/player";
  static const String searchReportNo = "web/v1/diamond/reportno/paginate";

  //Excel
  static const String baseURLForExcel = "http://pndevelopapi.democ.in/data";

  static const String baseURL2 = "https://beta.arjivexports.com/device/";
  static const String termsCondition = baseURL2 + "terms-condition";
  static const String privacyPolicy = baseURL2 + "privacy-policy";
  static const String contactUs = baseURL2 + "contact-us";
  static const String shippingPolicy = baseURL2 + "shipping-policy";
  static const String aboutUs = baseURL2 + "about-us";

  //mpin
  static const String createMpin = commonUrl + "user/create-mpin";
  static const String resetMpin = commonUrl + "reset-mpin";
  static const String resetMpinByOtp = commonUrl + "reset-mpin-by-otp";

  //Networkclient api calls
  static const String dimaondTrackCreate = "device/v1/diamond-track/create";
  static const String placeOrderOffline = "device/v1/diamond-confirm/request";
  static const String uploadKyc = "device/v1/account/";

  static const String notificationList = apiUrl + "device/v1/notification/list";
  static const String updateOffer = "device/v1/diamond-track/update";
  static const String shareThroughEmail = apiUrl + "web/v1/diamond/excel";
  static const String analytics = "apis/analytics/create";
  static const String companyList = "device/v1/common/account/paginate";
  static const String buyerList = "device/v1/common/user/paginate";
  static const String salesmanList = "device/v1/common/seller/paginate";
  static const String deleteOffice =
      "device/v1/cabin-schedule/destroyDiamondAndSlot";

  static const String buyNow = "device/v1/common/diamond-confirm/request";
  static const String holdDiamond = "device/v1/common/diamond-block/create";
  static const String holdList = "device/v1/common/diamond-block/paginate";
  static const String byunowList = "device/v1/common/diamond-confirm/paginate";
}

class DiamondUrls {
  static const String commonUrl =
      // "https://s3.us-east-2.wasabisys.com/cdn.pndiamonds.com/";
      // "https://arjivexports.blob.core.windows.net/arjivfiles/Imaged/PLOTING/C895-46.png";
      "https://arjivexports.blob.core.windows.net/arjivfiles/";
  static const String commonUrlForImage =
      "https://arjivexports.blob.core.windows.net/arjivfiles/Imaged/";
  static const String image = commonUrlForImage + "IMAGE/";

  // commonUrlForImage + "stonevideos/StoneImage_04-01-2020/";
  static String video = commonUrl + "HDView/";
  static const String heartImage = commonUrlForImage + "HA/";

  // commonUrlForImage + "stonevideos/StoneImage_04-01-2020/";
  static const String plotting = commonUrlForImage + "PLOTING/";
  static const String proportion = commonUrlForImage + "PLOTING/MEASUREMENT/";
  static const String natural = commonUrlForImage + "NVIDEO/";
  static const String certificate = commonUrlForImage + "PDF/";
  static const String arroImage =
      commonUrlForImage + "stonevideos/StoneImage_04-01-2020/";
  static const String videomp4 = commonUrl + "Mov/";
  static const String roughVideo = commonUrl + "MFG/RoughVideo/";
  static const String polVideo = commonUrl + "viewer3/mp4_videos/";
  static const String assetImage =
      commonUrl + "stonevideos/StoneImage_04-01-2020/";
  static const String flouresenceImg = commonUrl + "FlsImages/";
  static const String idealScopeImg = commonUrl + "IDEAL_White_BG/";
  static const String darkFieldImg = commonUrl + "Dark_Field_White_BG/";
  static const String faceUpImg = commonUrl + "Office_Light_Black_BG/";
  static const String realImg2 = commonUrl + "viewer3/RealImages/";
  static const String type2A = commonUrl + "TYPE_IIA/";
  static const String roughScopeImg = commonUrl + "MFG/RoughImages/";
  static const String image3D = commonUrl + "MFG/PlanImages/";
  static const String roughImage = commonUrl + "MFG/RoughImages/";
  static const String threeDImage = commonUrl + "MFG/PlanImages/"; // 3D Image
  static const String b2bImage = commonUrl + "RealImages/"; // B2B Image
}

class DiamondDetailImageConstant {
  static const int RoughImage = 1;
  static const int RoughVideo = 2;
  static const int ThreeDImage = 3;
  static const int B2BImage = 4;
}
// https://s3.ap-south-1.amazonaws.com/finestargroup/CertiImages/<report_no>.pdf
// https://s3.ap-south-1.amazonaws.com/finestargroup/MFG/RoughVideo/<packet_no>.html
// https://s3.ap-south-1.amazonaws.com/finestargroup/viewer3/mp4_videos/<packet_no>.mp4
// https://s3.ap-south-1.amazonaws.com/finestargroup/AssetScopeImages/<packet_no>.jpg
