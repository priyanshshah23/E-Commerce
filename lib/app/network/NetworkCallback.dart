typedef ApiCall<T> = Future<T> Function();

abstract class NetworkCallback<T> {
  void onSuccessResponse(dynamic responce);

  void onErrorResponse(
      String strErrorMessage, String responseCode, bool isNetworkError);
}
