import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/network/auth_service.dart';
import 'package:spotify_clone/core/network/dio_client.dart';
import 'package:spotify_clone/core/network/token_manager.dart';

class QueuedTokenInterceptor extends QueuedInterceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var token = await TokenManager().getToken();
    if (token != null) {
      debugPrint("---[Token is not null]---");
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != HttpStatus.unauthorized) {
      debugPrint("---[HttpStatus is not 401]---");
      return handler.next(err);
    }

    final newToken = await AuthService().refreshAccessToken();
    if (newToken == null) {
      debugPrint("---[newToken is null]---");
      return handler.reject(err);
    }
    await TokenManager().saveToken(newToken);
    debugPrint("---[Save token]---");
    final response = await _repeatRequest(err);

    return handler.resolve(response);
  }

  Future<Response> _repeatRequest(DioException error) async {
    final options = error.requestOptions;
    final dio = DioClient().dio;

    final newToken = await TokenManager().getToken();

    final updatedHeaders = Map<String, dynamic>.from(options.headers)
      ..remove('Authorization')
      ..addAll({'Authorization': 'Bearer $newToken'});
    debugPrint("---[Repeat Request]---");
    return dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(method: options.method, headers: updatedHeaders),
    );
  }
}
