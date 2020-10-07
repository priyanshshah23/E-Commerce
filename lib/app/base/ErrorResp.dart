class ErrorResp {
  String _message, _code;
  bool _isNetwork;

  ErrorResp(this._message, this._code, this._isNetwork);

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  get code => _code;

  bool get isNetwork => _isNetwork;

  set isNetwork(bool value) {
    _isNetwork = value;
  }

  set code(value) {
    _code = value;
  }
}
