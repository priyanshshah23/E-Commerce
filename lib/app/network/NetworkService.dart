import 'package:diamnow/models/Master/Master.dart';
import 'package:retrofit/retrofit.dart';
import '../app.export.dart';

part 'NetworkService.g.dart';

@RestApi(baseUrl: baseURL)
abstract class NetworkService {
  factory NetworkService(Dio dio) = _NetworkService;

  @POST(ApiConstants.masterSync)
  Future<MasterResp> getMaster(@Body() MasterReq req);
}
