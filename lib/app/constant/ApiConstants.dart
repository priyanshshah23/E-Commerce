import 'dart:io';

import '../app.export.dart';

class ApiConstants {
  //  static const String PROXY_URL = "PROXY 192.168.2.124:8888";
  static String PROXY_URL =
      Platform.isIOS ? "PROXY localhost:8888" : "PROXY 192.168.0.116:8888";
//    static const String PROXY_URL = "PROXY 10.0.2.2:8888";

  static const String imageBaseURL = baseURL;
  static const String shareUrl = "http://pndevelop.democ.in/diamond-details/";

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
  static const String forgetPassword =
      apiUrl + "web/v1/auth/forgot-password"; //done
  static const String resetPassword = commonUrl + "user/reset-password";
  static const String changePassword =
      apiUrl + "web/v1/auth/reset-password-by-user"; //done
  static const String personalInformation = commonUrl + "user/update"; //done
  static const String sendOTP = commonUrl + "user/send-otp"; //done
  static const String verifyOTP = commonUrl + "user/verify-otp"; //done
  static const String companyInformation =
      commonUrl + "user/profile/update"; //done
  static const String quickSearch = commonUrl + "diamond/quick-search";
  static const String personalInformationView = commonUrl + "user/view";
  static const String companyInformationView = commonUrl + "user/profile";
  static const String savedSearch = apiUrl + "web/v1/diamond/search/upsert";
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

  static const String diamondTrackDelete = commonUrl + "diamond-track/delete";
  static const String diamondComentDelete =
      commonUrl + "diamond-comment/delete";
  static const String diamondBidDelete = commonUrl + "diamond-bid/delete";
  static const String shareThroughEmail = apiUrl + "web/v1/diamond/excel";
  static const String notificationList = apiUrl + "device/v1/notification/list";
}

class DiamondUrls {
  static const String commonUrl =
      "https://s3.ap-south-1.amazonaws.com/finestargroup/";
  static const String image = commonUrl + "RealImages/";
  static const String video = commonUrl + "viewer3/html/";
  static const String heartImage = commonUrl + "HeartImages/";
  static const String plotting = commonUrl + "PlottingImages/";
  static const String certificate = commonUrl + "CertiImages/";
  static const String arroImage = commonUrl + "ArrowImages/";
  static const String videomp4 = commonUrl + "Mov/";
  static const String roughVideo = commonUrl + "MFG/RoughVideo/";
  static const String polVideo = commonUrl + "viewer3/mp4_videos/";
  static const String assetImage = commonUrl + "AssetScopeImages/";
  static const String flouresenceImg = commonUrl + "FlsImages/";
  static const String idealScopeImg = commonUrl + "IDEAL_White_BG/";
  static const String darkFieldImg = commonUrl + "Dark_Field_White_BG/";
  static const String faceUpImg = commonUrl + "Office_Light_Black_BG/";
  static const String realImg2 = commonUrl + "viewer3/RealImages/";
  static const String type2A = commonUrl + "TYPE_IIA/";
  static const String roughScopeImg = commonUrl + "MFG/RoughImages/";
  static const String image3D = commonUrl + "MFG/PlanImages/";
}
// https://s3.ap-south-1.amazonaws.com/finestargroup/CertiImages/<report_no>.pdf
// https://s3.ap-south-1.amazonaws.com/finestargroup/MFG/RoughVideo/<packet_no>.html
// https://s3.ap-south-1.amazonaws.com/finestargroup/viewer3/mp4_videos/<packet_no>.mp4
// https://s3.ap-south-1.amazonaws.com/finestargroup/AssetScopeImages/<packet_no>.jpg
