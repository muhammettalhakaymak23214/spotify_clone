import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';

class BaseService {
  final Dio dio;

   BaseService()
      : dio = Dio(BaseOptions(baseUrl: 'https://api.spotify.com/v1/'));

  Options authHeader() => Options(
        headers: {"Authorization": AppStrings.token, "Content-Type": "application/json"},
      );

  void logError(dynamic error, String serviceName) {
    if (kDebugMode) {
      print("[$serviceName] Error: $error");
    }
  }
}