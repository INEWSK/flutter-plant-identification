import 'package:dio/dio.dart';

/// dio 請求返回提示處理封裝

class DioExceptions implements Exception {
  ///未知錯誤
  static const String UNKNOWN = "UNKNOWN";

  ///解析錯誤
  static const String PARSE_ERROR = "PARSE_ERROR";

  ///網絡錯誤
  static const String NETWORK_ERROR = "NETWORK_ERROR";

  ///協議錯誤
  static const String HTTP_ERROR = "HTTP_ERROR";

  ///證書錯誤
  static const String SSL_ERROR = "SSL_ERROR";

  ///連接超時
  static const String CONNECT_TIMEOUT = "CONNECT_TIMEOUT";

  ///回應超時
  static const String RECEIVE_TIMEOUT = "RECEIVE_TIMEOUT";

  ///發送超時
  static const String SEND_TIMEOUT = "SEND_TIMEOUT";

  ///網絡請求取消
  static const String CANCEL = "CANCEL";

  DioExceptions.fromDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        _code = CANCEL;
        _message = "Request to API server was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        _code = CONNECT_TIMEOUT;
        _message = "Connection timeout with API server";
        break;
      case DioErrorType.DEFAULT:
        _code = UNKNOWN;
        _message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        _code = RECEIVE_TIMEOUT;
        _message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.RESPONSE:
        _code = HTTP_ERROR;
        _message = _handleError(error.response.statusCode, error.response.data);
        break;
      case DioErrorType.SEND_TIMEOUT:
        _code = SEND_TIMEOUT;
        _message = "Send timeout in connection with API server";
        break;
      default:
        _message = "Something went wrong";
        break;
    }
  }

  String _message;
  String _code;

  String get messge => _message;
  String get code => _code;

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal Server Error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => 'DioError:\ncode: $_code\nmessage: $_message';
}
