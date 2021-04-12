import 'package:dio/dio.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';

/*
 * 封裝 restful 請求
 *
 * GET、POST、DELETE、PATCH
 * - 統一處理請求前綴；
 * - 統一打印請求信息；
 * - 統一打印響應信息；
 * - 統一打印報錯信息；
 */
class DioUtils {
  /// global dio object
  static Dio dio;

  /// default options
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// 創建 dio 實例對象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局屬性：請求前綴、連接超時時間、響應超時時間
      var options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        responseType: ResponseType.plain,
        validateStatus: (status) {
          // 不使用http狀態碼判斷狀態，使用AdapterInterceptor來處理（適用於標準REST風格）
          return true;
        },
        baseUrl: RestApi.localUrl,
        // headers: httpHeaders,
      );

      dio = Dio(options);
    }

    return dio;
  }

  /// 清空 dio 對象
  static clear() {
    dio = null;
  }

  ///Get請求
  static void getHttp<T>(
    String url, {
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    // ///定義請求參數
    // parameters = parameters ?? {};
    // //參數處理
    // parameters.forEach((key, value) {
    //   if (url.indexOf(key) != -1) {
    //     url = url.replaceAll(':$key', value.toString());
    //   }
    // });

    try {
      Response response;
      Dio dio = createInstance();
      response = await dio.get(url);
      var responseData = response.data;
      if (onSuccess != null) {
        onSuccess(responseData);
      } else {
        throw Exception('erroMsg:${responseData['erroMsg']}');
      }
      print('響應數據：' + response.toString());
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      print('請求出錯：' + e.toString());
      onError(error.messge);
    }
  }

  ///Post請求
  static void postHttp<T>(
    String url, {
    // parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    // ///定義請求參數
    // parameters = parameters ?? {};
    // //參數處理
    // parameters.forEach((key, value) {
    //   if (url.indexOf(key) != -1) {
    //     url = url.replaceAll(':$key', value.toString());
    //   }
    // });

    try {
      Response response;
      Dio dio = createInstance();
      response = await dio.post(url);
      var responseData = response.data;
      if (onSuccess != null) {
        onSuccess(responseData['result']);
      } else {
        throw Exception('erroMsg:${responseData['erroMsg']}');
      }
      print('響應數據：' + response.toString());
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      print('請求出錯：' + e.toString());
      onError(error.messge);
    }
  }

  /// request Get、Post 請求
  //url 請求鏈接
  //parameters 請求參數
  //method 請求方式
  //onSuccess 成功回調
  //onError 失敗回調
  static void requestHttp<T>(
    String url, {
    parameters,
    method,
    Function(T t) onSuccess,
    Function(String error) onError,
  }) async {
    parameters = parameters ?? {};
    method = method ?? DioUtils.GET;

    if (method == DioUtils.GET) {
      getHttp(
        url,
        // parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    } else if (method == DioUtils.POST) {
      postHttp(
        url,
        // parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    }
  }
}

/// 自定義Header
Map<String, dynamic> httpHeaders = {
  Headers.acceptHeader: 'application/json,*/*',
  Headers.contentTypeHeader: 'application/json',
};
