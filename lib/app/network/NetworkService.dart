import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Auth/ChangePasswordModel.dart';
import 'package:diamnow/models/Auth/CompanyInformationModel.dart';
import 'package:diamnow/models/Auth/ForgetPassword.dart';
import 'package:diamnow/models/Auth/PersonalInformationModel.dart';
import 'package:diamnow/models/Auth/ResetPasswordModel.dart';
import 'package:diamnow/models/Dashboard/DashboardModel.dart';
import 'package:diamnow/models/Auth/SignInAsGuestModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/Notification/NotificationModel.dart';
import 'package:diamnow/models/Order/OrderListModel.dart';
import 'package:diamnow/models/QuickSearch/QuickSearchModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:diamnow/models/Share/ShareThroughEmail.dart';
import 'package:diamnow/models/Slot/SlotModel.dart';
import 'package:diamnow/models/StaticPage/StaticPageModel.dart';
import 'package:diamnow/models/Version/VersionUpdateResp.dart';
import 'package:diamnow/models/excel/ExcelApiResponse.dart';
import 'package:retrofit/retrofit.dart';
import '../app.export.dart';

part 'NetworkService.g.dart';

@RestApi(baseUrl: baseURL)
abstract class NetworkService {
  factory NetworkService(Dio dio) = _NetworkService;

  @POST(ApiConstants.masterSync)
  Future<MasterResp> getMaster(@Body() MasterReq req);

  @POST(ApiConstants.login)
  Future<LoginResp> login(@Body() Map<String,dynamic > req);

  @POST(ApiConstants.createMpin)
  Future<BaseApiResp> createMpin(@Body() CreateMpinReq req);

  @POST(ApiConstants.resetMpin)
  Future<BaseApiResp> resetMpin(@Body() Map<String,dynamic > req);

  @POST(ApiConstants.resetMpinByOtp)
  Future<BaseApiResp> resetMpinByOtp(@Body() Map<String,dynamic > req);

  @POST(ApiConstants.signInAsGuest)
  Future<LoginResp> signInAsGuest(@Body() SignInAsGuestReq req);

  @POST(ApiConstants.cityList)
  Future<CityListResp> cityList(@Body() CityListReq req);

  @POST(ApiConstants.countryList)
  Future<CountryListResp> countryList();

  @POST(ApiConstants.stateList)
  Future<StateListResp> stateList(@Body() StateListReq req);

  @POST(ApiConstants.diamondList)
  Future<DiamondListResp> diamondList(@Body() DiamondListReq req);

  @POST(ApiConstants.createDiamondTrack)
  Future<BaseApiResp> createDiamondTrack(@Body() CreateDiamondTrackReq req);

  @POST(ApiConstants.createDiamondBid)
  Future<BaseApiResp> createDiamondBid(@Body() CreateDiamondTrackReq req);

  @POST(ApiConstants.upsetComment)
  Future<BaseApiResp> upsetComment(@Body() CreateDiamondTrackReq req);

  @POST(ApiConstants.sendOTP)
  Future<BaseApiResp> forgetPassword(@Body() ForgotPasswordReq req);

  @POST(ApiConstants.forgotMpin)
  Future<BaseApiResp> forgetMpin(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.verifyOTP)
  Future<BaseApiResp> verifyOTP(@Body() VerifyOTPReq req);

  @POST(ApiConstants.verifyOTPForMpin)
  Future<BaseApiResp> verifyOTPForMpin(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.verifyMpin)
  Future<BaseApiResp> verifyMpin(@Body() Map<String, dynamic> req);


  @POST(ApiConstants.resetPassword)
  Future<BaseApiResp> resetPassword(@Body() ResetPasswordReq req);

  @POST(ApiConstants.changePassword)
  Future<BaseApiResp> changePassword(@Body() ChangePasswordReq req);

  @POST(ApiConstants.personalInformation)
  Future<PersonalInformationViewResp> personalInformation(
      @Body() PersonalInformationReq req);

  @GET(ApiConstants.personalInformationView)
  Future<PersonalInformationViewResp> personalInformationView();

  @POST(ApiConstants.companyInformationView)
  Future<CompanyInformationViewResp> companyInformationView();

  @POST(ApiConstants.companyInformation)
  Future<CompanyInformationViewResp> companyInformation(
      @Body() CompanyInformationReq req);

  @POST(ApiConstants.placeOrder)
  Future<BaseApiResp> placeOrder(@Body() PlaceOrderReq req);

  @POST(ApiConstants.diamondTrackDelete)
  Future<BaseApiResp> diamondTrackDelete(@Body() TrackDelReq req);

  @POST(ApiConstants.diamondComentDelete)
  Future<BaseApiResp> diamondComentDelete(@Body() TrackDelReq req);

  @POST(ApiConstants.diamondBidDelete)
  Future<BaseApiResp> diamondBidDelete(@Body() TrackDelReq req);

  @POST(ApiConstants.diamondList)
  Future<DiamondListResp> diamondListPaginate(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.shareThroughEmail)
  Future<BaseApiResp> shareThroughEmail(@Body() ShareThroughEmailReq req);

  @POST(ApiConstants.shareThroughEmail)
  Future<ExcelApiResponse> getExcel(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondMatchPair)
  Future<DiamondListResp> diamondMatchPairList(
      @Body() Map<String, dynamic> req);

  @POST(ApiConstants.stoneOfTheDay)
  Future<DiamondListResp> stoneOfTheDay(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.mySaveSearch)
  Future<SavedSearchResp> mySavedSearch(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondBidList)
  Future<DiamondListResp> diamondBidList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondOfficeList)
  Future<DiamondListResp> diamondOfficeList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondOrderList)
  Future<OrderListResp> diamondOrderList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondBlockList)
  Future<TrackBlockResp> diamondBlockList(@Body() TrackDataReq req);

  @POST(ApiConstants.diamondTrackList)
  Future<DiamondListResp> diamondTrackList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondCommentList)
  Future<DiamondListResp> diamondCommentList(@Body() Map<String, dynamic> req);

  @GET(ApiConstants.staticPage)
  Future<StaticPageResp> staticPage(@Path("id") String id);

  @POST(ApiConstants.quickSearch)
  Future<QuickSearchResp> quickSearch(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.savedSearch)
  Future<SavedSearchResp> saveSearch(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.savedSearch)
  Future<AddDemandModel> addDemand(@Body() Map<String, dynamic> req);

  //Office
  @POST(ApiConstants.getSlots)
  Future<SlotResp> getSlots(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.createOfficerequest)
  Future<BaseApiResp> createOfficerequest(@Body() Map<String, dynamic> req);

  //Dashboard
  @POST(ApiConstants.dashboard)
  Future<DashboardResp> dashboard(@Body() Map<String, dynamic> req);

  //Delete saved search
  @POST(ApiConstants.deleteSavedSearch)
  Future<BaseApiResp> deleteSavedSearch(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.logout)
  Future<BaseApiResp> logout();

  @GET(ApiConstants.getUpdation)
  Future<VersionUpdateResp> getVersionUpdate();

  @POST(ApiConstants.notificationList)
  Future<NotificationResp> getNotificationList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.markAsReadNotification)
  Future<NotificationResp> markAsReadNotification(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.sendNotificationId)
  Future<BaseApiResp> notificationId();
  
}
