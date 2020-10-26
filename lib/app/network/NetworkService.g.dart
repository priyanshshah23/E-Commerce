// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NetworkService.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _NetworkService implements NetworkService {
  _NetworkService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://fndevelopapi.democ.in/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getMaster(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/masterSync',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = MasterResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  login(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/auth/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = LoginResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  signInAsGuest(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/guest/auth/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = LoginResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  cityList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/city/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CityListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  countryList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/country/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CountryListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  stateList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/state/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = StateListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  createDiamondTrack(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-track/create',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  createDiamondBid(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-bid/create',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  upsetComment(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-comment/upsert',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  forgetPassword(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/web/v1/auth/forgot-password',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  resetPassword(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/admin/v1/reset-password',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  changePassword(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/web/v1/auth/reset-password-by-user',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  personalInformation(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/user/update',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PersonalInformationViewResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  personalInformationView() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/user/view',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PersonalInformationViewResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  companyInformationView() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/user/profile',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CompanyInformationViewResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  companyInformation(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/user/profile/update',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CompanyInformationViewResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  placeOrder(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-confirm/request',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondListPaginate(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondMatchPairList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/match-pair/diamond/filter',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  stoneOfTheDay(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/featuredStone/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  mySavedSearch(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond/search/list',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = SavedSearchResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondBidList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-bid/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondOfficeList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/cabin-schedule/list',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondOrderList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/memo/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondTrackList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-track/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  diamondCommentList(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond-comment/by-user',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DiamondListResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  staticPage(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'api/v1/static-page/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = StaticPageResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  quickSearch(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond/quick-search',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = QuickSearchResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  saveSearch(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/web/v1/diamond/search/upsert',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getSlots(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/cabin-slot/paginate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = SlotResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  createOfficerequest(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/cabin-schedule/create',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  dashboard(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/user/dashboard',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DashboardResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  deleteSavedSearch(req) async {
    ArgumentError.checkNotNull(req, 'req');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(req ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/diamond/search/delete',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  logout() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'http://fndevelopapi.democ.in/device/v1/auth/logout',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseApiResp.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getVersionUpdate() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'api/v1/version',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VersionUpdateResp.fromJson(_result.data);
    return Future.value(value);
  }
}
