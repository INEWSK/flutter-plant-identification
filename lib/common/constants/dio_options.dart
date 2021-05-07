import 'package:dio/dio.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';

/// 返回json type
final jsonOptions = BaseOptions(
  baseUrl: RestApi.localUrl,
  connectTimeout: 5000, //5s
  receiveTimeout: 10000, //10s
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

/// 返回 UTF8 string
final stringOptions = BaseOptions(
  baseUrl: RestApi.localUrl,
  connectTimeout: 5000, //5s
  receiveTimeout: 10000, //10s
  contentType: Headers.textPlainContentType,
  responseType: ResponseType.plain,
);
