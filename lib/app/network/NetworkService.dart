import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/Master/Master.dart';
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

  @POST(ApiConstants.diamondList)
  Future<DiamondListResp> diamondListPaginate(@Body() Map<String, dynamic> req);

  @GET(ApiConstants.staticPage)
  Future<StaticPageResp> staticPage(@Path("id") String id);
}
