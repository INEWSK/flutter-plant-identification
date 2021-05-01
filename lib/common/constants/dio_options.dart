import 'package:dio/dio.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';

final jsonOptions = BaseOptions(
  baseUrl: RestApi.localUrl,
  connectTimeout: 5000, //5s
  receiveTimeout: 10000, //10s
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

final stringOptions = BaseOptions(
  baseUrl: RestApi.localUrl,
  connectTimeout: 5000, //5s
  receiveTimeout: 10000, //10s
  contentType: Headers.textPlainContentType,
  responseType: ResponseType.plain,
);
