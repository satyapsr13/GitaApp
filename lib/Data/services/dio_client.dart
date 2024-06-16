// ignore_for_file: use_rethrow_when_possible

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Constants/constants.dart';
import 'secure_storage.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  late String baseUrl;
  String contentType;
  final SecureStorage _secureStorage = SecureStorage();

  // getToken() {
  //   String token = "";
  //   _secureStorage.getToken().then((value) {
  //     token = value.toString();
  //   });
  //   return token;
  // }

  late Dio _dio;

  final List<Interceptor>? interceptors;

  DioClient({
    this.interceptors,
    this.contentType = 'application/json; charset=UTF-8',
  }) {
    _dio = Dio();
    // baseUrl = "EnvironmentConfig.apiBase";
    baseUrl = "https://manage.connectup.in/api/";
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..httpClientAdapter;
    // ..options.headers = {'Authorization': getToken()};
    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: true,
          requestBody: true));
    }
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? customUrl,
    // String? authKey,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var token = await _secureStorage.getToken();
      var locale = await _secureStorage.getLocale();

      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "X-Language": locale
      };

      // Logger().i("Making API request:- GET $uri");
      var response = await _dio.get(
        customUrl ?? uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> getCustom(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? customUrl,
    String? authKey,
    String? accessKey,
    String? secretKey,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var token = await _secureStorage.getToken();
      var locale = await _secureStorage.getLocale();

      _dio.options.headers = authKey != null
          ? {}
          : {"Authorization": "Bearer $token", "X-Language": locale};

      // Logger().i("Making API request:- GET $uri");
      var response = await _dio.get(
        customUrl ?? uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? customUri,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var token = await _secureStorage.getToken();
      var locale = await _secureStorage.getLocale();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "X-Language": locale
      };

      // Logger().i("Making API request:- POST $uri");
      var response = await _dio.post(
        customUri ?? uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      // log("-------- Status Code ${response.statusCode} Response of DioClint Post dart file ${response.toString()}  -----------------");
      // log(response.data.toString());
      if (GlobalVariables.appVersion % 2 == 0) {
        logsMessages.add("${DateTime.now()} api_response $response");
      }
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (GlobalVariables.appVersion % 2 == 0) {
        logsMessages.add("${DateTime.now()} api_response $e");
      }
      throw e;
    }
  }

  Future<dynamic> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var token = await _secureStorage.getToken();
      var locale = await _secureStorage.getLocale();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "X-Language": locale
      };
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var token = await _secureStorage.getToken();
      var locale = await _secureStorage.getLocale();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "X-Language": locale
      };
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}

/*
*     (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
*
* */
