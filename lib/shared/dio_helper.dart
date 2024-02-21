import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:socialty_with_firebase/constants/constants.dart';

class DioHelper {
  static Dio? dio;
  static Dio? dioGoogleMap;

  static init({bool isBaseUrl = true}) {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
    dio!.interceptors.add(ErrorInterceptor());
  }

  static Future<Response> postData({
    required String body,
    required String title,
    required String to,
    dynamic data,
  }) {
    return dio!.post(
      Constants.notifUrl,
      data: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': data,
          'to': to,
        },
      ),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=${Constants.serverToken}',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) {
    return dio!.get(endPoint, queryParameters: queryParameters, data: data);
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
  }) {
    return dio!.put(url, queryParameters: data);
  }

  static Future<Response> requestData({
    required String url,
    required Map<String, dynamic> data,
  }) {
    return dio!.request(url, queryParameters: data);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log("statusCode == 401");
    } else if (err.response?.statusCode == 403) {
      log("statusCode == 403");
    } else {
      log("statusCode == 500${err.response?.statusCode!}");
    }
    return super.onError(err, handler);
  }
}


/**
 *  jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': 'this is a body',
         'title': 'this is a title'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': await firebaseMessaging.getToken(),
     },
    )
 */