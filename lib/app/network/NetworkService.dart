import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Auth/ChangePasswordModel.dart';
import 'package:diamnow/models/Auth/CompanyInformationModel.dart';
import 'package:diamnow/models/Auth/ForgetPassword.dart';
import 'package:diamnow/models/Auth/PersonalInformationModel.dart';
import 'package:diamnow/models/Auth/ResetPasswordModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/QuickSearch/QuickSearchModel.dart';
import 'package:diamnow/models/StaticPage/StaticPageModel.dart';
import 'package:retrofit/retrofit.dart';
import '../app.export.dart';

part 'NetworkService.g.dart';

@RestApi(baseUrl: baseURL)
abstract class NetworkService {
  factory NetworkService(Dio dio) = _NetworkService;

  @POST(ApiConstants.masterSync)
  Future<MasterResp> getMaster(@Body() MasterReq req);

  @POST(ApiConstants.login)
  Future<LoginResp> login(@Body() LoginReq req);

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

  @POST(ApiConstants.forgetPassword)
  Future<BaseApiResp> forgetPassword(@Body() ForgotPasswordReq req);

  @POST(ApiConstants.resetPassword)
  Future<BaseApiResp> resetPassword(@Body() ResetPasswordReq req);

  @POST(ApiConstants.changePassword)
  Future<BaseApiResp> changePassword(@Body() ChangePasswordReq req);

  @POST(ApiConstants.personalInformation)
  Future<BaseApiResp> personalInformation(@Body() PersonalInformationReq req);

  @GET(ApiConstants.personalInformationView)
  Future<BaseApiResp> personalInformationView();

  @POST(ApiConstants.companyInformationView)
  Future<BaseApiResp> companyInformationView();

  @POST(ApiConstants.companyInformation)
  Future<CompanyInformationResp> companyInformation(
      @Body() CompanyInformationReq req);

  @POST(ApiConstants.placeOrder)
  Future<BaseApiResp> placeOrder(@Body() PlaceOrderReq req);

  @POST(ApiConstants.diamondList)
  Future<DiamondListResp> diamondListPaginate(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondBidList)
  Future<DiamondListResp> diamondBidList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondTrackList)
  Future<DiamondListResp> diamondTrackList(@Body() Map<String, dynamic> req);

  @POST(ApiConstants.diamondCommentList)
  Future<DiamondListResp> diamondCommentList(@Body() Map<String, dynamic> req);

  @GET(ApiConstants.staticPage)
  Future<StaticPageResp> staticPage(@Path("id") String id);

  @POST(ApiConstants.quickSearch)
  Future<QuickSearchResp> quickSearch(@Body() Map<String, dynamic> req);
}
